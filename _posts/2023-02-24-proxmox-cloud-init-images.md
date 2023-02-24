---
layout:     post
title:      在 pve 使用 cloud-init 镜像
date:       '2023-02-24T14:20'
subtitle:   using cloud-init images in Proxmox VE
categories: Virtualization
author:     招文桃
catalog:    true
tags:
    - Virtualization
    - Cloud-init
---

使用 cloud images 和 cloud-init 可以很方便地在 pve 创建一个快捷高效的虚拟机克隆模板。首先选择自己偏好的 cloud image，例如 Ubuntu 的可以在 [Ubuntu cloud init 镜像](https://cloud-images.ubuntu.com/) 下载， CentOS 的可以在 [Centos cloud images](https://cloud.centos.org/) 下载。

提供下载的镜像有好几种格式， ubuntu 的一般用 img 就可以，centos 下载 qcow2c 就可以，后面导入的时候都会转换成 raw 格式。

下载好所需的镜像之后（假设下载的是 jammy-server-cloudimg-amd64.img ），就开始按以下步骤制作虚拟机模板：

### 创建一个新的虚拟机

```Shell
qm create 8000 --memory 2048 --core 2 --name ubuntu-cloud --net0 virtio,bridge=vmbr0
```

这里是创建 id 为 8000 的虚拟机，内存大小为 2G ， CPU 核心数量 2，名称是 ubuntu-cloud 并设置网卡桥接到 vmbr0

### 导入下载好的云镜像到 local-lvm 存储

```Shell
qm importdisk 8000 jammy-server-cloudimg-amd64.img local-lvm
```

### 将新导入的磁盘以 scsi 驱动器的方式装载到新建的虚拟机的 scsi 控制器

```Shell
qm set 8000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-8000-disk-0
```

### 添加 cloud init 驱动器

```Shell
qm set 8000 --ide2 local-lvm:cloudinit
```

### 将 cloud init 驱动器设置为可启动并限制 BIOS 仅从磁盘启动

```Shell
qm set 8000 --boot c --bootdisk scsi0
```

### 添加串口控制台

```Shell
qm set 8000 --serial0 socket --vga serial0
```

## 现在先不要启动虚拟机

现在可以配置新虚拟机的硬件和 cloud init 选项，配置好之后转换成模板。磁盘大小的调整可以在转换成模板前调整，或者从模板克隆出新的虚拟机时候再调整。

### 创建模板（也可以在 Web UI 操作）

```Shell
qm template 8000
```

### 克隆模板（也可以在 Web UI 操作）

```Shell
qm clone 8000 135 --name huihui --full
```

## 排障

如果需要重置机器 id

```Shell
sudo rm -f /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
```

然后关机，下次启动会生成新的机器 id，如果没有生成，可以运行以下命令：

```Shell
sudo systemd-machine-id-setup
```
