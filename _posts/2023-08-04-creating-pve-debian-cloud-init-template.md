---
layout:     post
title:      创建 PVE debian cloud-init 模板
date:       '2023-08-04T11:22'
subtitle:   creating PVE debian cloud-init template
categories: Linux
author:     招文桃
catalog:    true
tags:
    - Linux
    - PVE
---

本文记录如何在 PVE 8.0.3 环境使用 debian 12 bookworm 的 cloud-init 镜像创建虚拟机模板，并进行一些定制化，例如预装一些常用软件包，修改 apt 源为国内镜像，和修改系统时区。

### 下载镜像

搜索 debian cloud init image 找到下载页面。
![debian cloud-init 镜像](/img/debian-cloud-init-image.png)

有好几种镜像种类，看到页面描述："generic: Should run in any environment using cloud-init, for e.g. OpenStack, DigitalOcean and also on bare metal." ，应该下载这种镜像，因为有包含了 cloud-init.

![debian generic 镜像](/img/debian-generic.png)

我们要下载 debian 12 bookworm，所以进入到 bookworm 的目录，再进入到 [latest](https://cloud.debian.org/images/cloud/bookworm/latest/)

![debian bookworm](/img/debian-bookworm.png)

然后选择下载适合 PVE 节点具体架构的镜像版本，这里我选的是 [debian-12-generic-amd64](https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2) 的镜像，`qcow2` 是 qemu 支持导入的磁盘镜像格式。下载时候可以直接在 PVE 节点的终端里面 `wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2` ，就不用下载完再传到 PVE，节省些时间。

![debian 12 generic amd64](/img/debian-12-generic-amd64.png)

### 创建虚拟机并导入镜像

这部分很多命令都是可以用等效的 Web UI 操作完成，不过为了简洁，就主要列出命令行方式。

#### 创建虚拟机

创建一个新的虚拟机

```shell
qm create 9000 --memory 2048 --core 2 --name debian-12-template --net0 virtio,bridge=vmbr0
```

这里是创建 id 为 9000 的虚拟机，内存大小为 2G ， CPU 核心数量 2，名称是 debian-12-template 并设置网卡 `net0` 桥接到 `vmbr0`。

然后将下载好的 debian 12 cloud init 镜像导入给刚创建的虚拟机，并且指定存储在 local-lvm

```shell
qm importdisk 9000 debian-12-generic-amd64.qcow2 local-lvm
```

将新导入的磁盘以 scsi 驱动器的方式装载到新建的虚拟机的 scsi 控制器

```shell
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
```

添加 cloud init CD ROM 驱动器，用于提供 Cloud-init 参数给虚拟机。

```shell
qm set 9000 --ide2 local-lvm:cloudinit
```

将导入了 debian-12 镜像的那个磁盘设置为可启动并限制 BIOS 仅从该磁盘启动

```shell
qm set 9000 --boot c --bootdisk scsi0
```

设置串口控制台，因为某些 Cloud init 镜像可能要求要有串口控制台，如果用不了，那么可以切换回默认显示设备。

```shell
qm set 9000 --serial0 socket --vga serial0
```

这时候，如果不启动虚拟机，那么就可以将这个配置好的虚拟机转成模板了。但是因为还想给虚拟机预安装一些常用的工具包和配置 apt 源镜像等操作，所以现在启动虚拟机进行配置，
但是虚拟机一旦启动，就会生成 `machine-id` ，以及留下其他的一些使用痕迹，但是主要有影响的是 `machine-id`，因为 DHCP 过程会根据这个 `machine-id` 分配 IP 的。
如果在将已经启动过的虚拟机，并且没有清除掉 `machine-id` 就转成模板的话。后面创建的虚拟机会有同样的 `machine-id`，DHCP 的时候就是分配到同样的 IP（但是只有一个虚拟机能正常使用被分配的 IP），这就好造成一些不必要的麻烦。所以我们启动虚拟机并做完更改之后，要记得使用命令 `sudo truncate -s /etc/machine-id /var/lib/dbus/machine-id` 移除 `machine-id`，不能直接删除 `machine-id` 文件，但是可以清空内容。因为如果删除了文件，重启是不会重新生成，也是一个问题。如果不小心删除了，可以使用命令 `sudo systemd-machine-id-setup` 生成回来。

### 预装软件和配置

#### 安装常用软件包

```shell
sudo apt install -y htop qemu-guest-agent dnsutils tree acpid
```

- htop              查看进程
- qemu-guest-agent  宿主机代理，搜集虚拟机信息(IP，主机名等)
- nslookup          DNS 调试
- dig               DNS 调试
- tree              方便浏览目录

#### 配置时区

修改 `/etc/cloud/cloud.cfg` ，在底下添加

```yml
ntp:
  enabled: true

timezone: Asia/Shanghai

```

在 `system_info` 的 `package_mirrors` 那里还可以修改使用的源 mirrors

```yaml
system_info:
  package_mirrors:
    - arches: [default]
      failsafe:
        primary: https://deb.debian.org/debian
        security: https://deb.debian.org/debian-security
```

不过目前是在 `/etc/apt/mirrors/` 里面的文件修改，直接替换成阿里云的镜像地址：

```ini
# debian.list
https://mirrors.aliyun.com/debian
```

```ini
# debian-security.list
https://mirrors.aliyun.com/debian-security
```

还有一个地方需要改，就是 `/etc/cloud/cloud.cfg.d/01_debian_cloud.cfg`

```yaml
apt:
  generate_mirrorlists: false
```

改成 false，修改就不会被覆盖掉，前面两个地方的改动是有关的，如果改了生成镜像列表的地址，应该就不用将这个改成 `false` 不过手动修改，并改成 `false` 也可以。

这样虚拟机就配置好了，清除 `machine-id` 关机就可以。

### 转成虚拟机模板

```shell
qm template 9000
```

之后就可以由这个模板创建出新的虚拟机了。
