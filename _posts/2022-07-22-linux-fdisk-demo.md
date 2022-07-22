---
layout:     post
title:      Linux fdisk 命令使用
date:       '2022-07-22T15:34'
subtitle:   Linux fdisk command
categories: Linux
author:     招文桃
catalog:    true
tags:
    - Linux
    - disk partition
---


### 使用 fdisk 命令查看磁盘分区

如下：

```bash
liuhuaqiang@shuiguotan:~$ sudo fdisk -l /dev/sdb
Disk /dev/sdb: 1.9 GiB, 2013265920 bytes, 3932160 sectors
Disk model: Flash Disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x339542e9

Device     Boot Start    End Sectors  Size Id Type
/dev/sdb1  *      512  33279   32768   16M 83 Linux
/dev/sdb2       33792 558079  524288  256M 83 Linux
```
