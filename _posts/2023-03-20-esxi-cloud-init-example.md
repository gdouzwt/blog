---
layout:     post
title:      在 ESxi 使用 Cloud-init 安装系统的例子
date:       '2023-03-20T22:16'
subtitle:   using cloud-init in esxi
categories: Linux
author:     招文桃
catalog:    true
tags:
    - Linux
---

[在 pve 使用 cloud-init 镜像](https://blog.zwt.io/virtualization/2023/02/24/proxmox-cloud-init-images/) 相对来说简单一些，要在 esxi 中使用 cloud-init 镜像，步骤就繁琐一点。本文记录一下在 ESXi-7.0U3f-20036589-standard 中使用 cloud-init 镜像安装并配置 Ubuntu Server Jammy 的步骤。

### 下载 VMDK 文件

首先去 Ubuntu 的 cloud-images 网站下载对应版本的 VMDK 文件，用于 ESxi 新创建的虚拟机磁盘。

### 上传到 ESxi 的存储


### 创建虚拟机

其他步骤默认即可，去到自定义设置的时候，删掉默认设置的硬盘。虚拟机创建好之后，在存储浏览器那里可以看到有个以虚拟机名称命名的目录。
将 VMDK 文件复制一份到这个目录里面作为这个新建的虚拟机的硬盘。用复制而不是直接移动过去，是为了可以之后可以继续复用这个 VMDK

### 修改虚拟机设置

编辑新创建的虚拟机的选项，在【高级】-【配置参数】那里编辑配置，添加两个参数：
`guestinfo.userdata.encoding` 和 `guestinfo.userdata`。其值分别是 'base64'，表示数据的类型是 base64 格式，和 cloud-init 配置的 yaml 内容的 base64 后字符串。

例如，一个最小配置的 yaml 像这样：

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

注意 yml 文件开头的 `#cloud-config` 是必须的。以上最小配置，会创建一个用户。这样至少可以登录到系统。 默认 Cloud images 五百多个 M，扩展磁盘 Cloud-init 初始化时候一般会扩展到最大可用空间。

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

![自定义 cloud-init 时区参数](https://notes.zwt.io/share/api/images/7r5OENfEpjYa/image.png)

### 添加 Cloud-init 磁盘到新建的虚拟机
