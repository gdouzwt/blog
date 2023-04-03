---
layout:     post
title:      在 ESXi 使用 Cloud-init 安装系统的例子
date:       '2023-03-20T22:16'
subtitle:   using cloud-init in ESXi
categories: Linux
author:     招文桃
catalog:    true
tags:
    - Linux
---

[在 pve 使用 cloud-init 镜像](https://blog.zwt.io/virtualization/2023/02/24/proxmox-cloud-init-images/) 相对来说简单一些，要在 ESXi 中使用 cloud-init 镜像，步骤就繁琐一点。本文记录一下在 ESXi-7.0U3f-20036589-standard 中使用 cloud-init 镜像安装并配置 Ubuntu Server Jammy 的步骤。

## 下载 VMDK 文件

首先去 Ubuntu 的 [cloud-images](https://cloud-images.ubuntu.com/jammy/current/) 网站下载对应版本的 VMDK 文件，用于 ESXi 新创建的虚拟机磁盘。

## 创建虚拟机

将 VMDK 上传到 ESXi 的存储目录，一路按默认步骤创建虚拟机，去到自定义设置的时候，删掉默认设置的硬盘。虚拟机创建好之后，在存储浏览器那里可以看到有个以虚拟机名称命名的目录。将 VMDK 文件复制一份到这个目录里面作为这个新建的虚拟机的硬盘。用复制而不是直接移动过去，是为了可以之后可以继续复用这个 VMDK.
![上传 vmdk 到 ESXi](/img/upload-cloud-init-to-esxi-storage.png)

## 添加 Cloud-init 磁盘到新建的虚拟机

在 ESXi 虚拟机的配置添加 cloud-init 的磁盘镜像作为虚拟机硬盘即可。 留意，一般保存配置之后，回头在编辑才可以修改磁盘空间大小。

## 修改虚拟机设置，添加 Cloud-init userdata

编辑新创建的虚拟机的选项，在【高级】-【配置参数】那里编辑配置，添加两个参数：
`guestinfo.userdata.encoding` 和 `guestinfo.userdata`。其值分别是 'base64'，表示数据的类型是 base64 格式，和 userdata cloud-init 配置的 yaml 内容的 base64 后字符串。

例如，一个最小配置的 userdata yaml 像这样：

```yml
#cloud-config
users:
  - name: tao
    # passwd: $6$rounds=4096$4Jh2rwf9h2jM9TbQ$.CTSPJPIoIOUwKVo4A2Er19Deu945m/oD.JXVEGNH9g/piK.motblke/kpyPQ0npNKF.jZjzi61ZSBPGNbJyK/
    plain_text_passwd: youPassword
    groups: sudo
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    lock_passwd: false
```

注意 userdata 的 yml 文件开头的 `#cloud-config` 是必须的。以上最小配置，会创建一个用户。这样至少可以登录到系统。 默认 Cloud images 五百多个 MB，扩展磁盘 Cloud-init 初始化时候一般会扩展到最大可用空间。

其实 Cloud-init 启动过程有一些 modules 可以在 `/etc/cloud/cloud.cfg` 配置的。 而且可以自定义一些配置操作，让 Cloud-init 去运行，例如，配置时区。

可以在文件最后添加：

```yml
timezone: Asia/Shanghai
```

然后我们需要清理一下 Cloud-init, 使用以下命令：

```shell
sudo cloud-init clean --logs
```

先查看一下当前时区设置（默认应该是 UTC），用命令 `timedatectl` 查看。

之后运行以下命令，应用 cloud-init 的改动：

```shell
sudo cloud-init single --name cc_timezone
```

效果如下图：

![自定义 cloud-init 时区参数](/img/esxi-cloud-init-image.png)


## 配置需要安装的包

要通过 cloud-init 配置系统初次启动后额外安装的一些包，例如常用的 docker，可以使用以下配置：

```yml

#cloud-config

# hostname
hostname: Ox
manage_etc_hosts: true
chpasswd:
  expire: False

# enable ntp
ntp:
  enabled: true

# timezone
timezone: Asia/Shanghai

# disable root login via ssh
disable_root: true

# optional, additional groups
groups:
  # because we gonna install docker
  - docker

users:
  - name: tao
    # allows password authnetication when set to false, true by default
    lock_passwd: False
    # password hash, created by `mkpasswd --method=SHA-512 --rounds=4096`, read the docs before complaining security against plain
    # passwd: $6$rounds=4096$4Jh2rwf9h2jM9TbQ$.CTSPJPIoIOUwKVo4A2Er19Deu945m/oD.JXVEGNH9g/piK.motblke/kpyPQ0npNKF.jZjzi61ZSBPGNbJyK/
    # alternative approach with plain text password
    plain_text_passwd: youPassword
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOTan+yolWwBH4HKkVd6Y2OKzGGeJLijGGSd1NzuMSp Grace
    groups:
      - adm
      - cdrom
      - sudo
      - dip
      - plugdev
      - lxd
      # add user to docker group
      - docker
    sudo:
      # allow sudo
      - ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash

# optional, additional apt sources, docker
apt:
  sources:
    docker.list:
      source: deb [arch=amd64] https://download.docker.com/linux/ubuntu $RELEASE stable
      keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88

# apt update && apt upgrade, reboot if needed
package_update: true
package_upgrade: true
package_reboot_if_required: true

# install packages
packages:
  - docker-ce
  - docker-ce-cli
  - containerd.io
```

## 添加 metadata 部分，控制虚拟机网络初始化

最常用的 Cloud-init 场景就是给虚拟机设置固定 ip，关于网络的设置，在 cloud-init 属于metadata 部分。所以需要在虚拟机配置那里另外添加两组 key-value:
`guestinfo.metadata.encoding` 和 `guestinfo.metadata`。其值分别是 'base64'，表示数据的类型是 base64 格式，和 metadata cloud-init 配置的 yaml 内容的 base64 后字符串。

例子如下：

```yml
network:
  version: 1
  config:
      - type: physical
        name: ens160
        subnets:
        - type: static
          address: '192.168.3.222'
          netmask: '255.255.255.0'
          gateway: '192.168.3.1'
      - type: nameserver
        address:
        - '172.17.11.80'
        search:
        - 'linuxfield.com'
```

这部分不强制要求文件开头要有 `#cloud-config`，上面内容是使用 `version 1` 网络配置，没那么灵活，但是也适合没有使用 netplan 的 Linux 发行版。在 pve 的虚拟机 cloud-init 配置里面，可以通过命令 `qm cloudinit dump [虚拟机 id] [配置类型]` 查看。例如查看虚拟机 100 的 网络配置：
![虚拟机 100 网络配置 dump](/img/cloud-init-network-dump.png)

这样就可以参考 pve 的 cloud-init 配置，在 ESXi 上也使用类似的配置。最后是 ESXi cloud-init 配置固定 IP 的效果图：
![ESXi cloud-init 固定 IP](/img/esxi-cloud-init-static-ip.png)

完。
