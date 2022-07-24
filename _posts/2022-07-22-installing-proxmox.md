---
layout:     post
title:      安装 Proxmox VE
date:       '2022-07-22T23:26'
subtitle:   Installing Proxmox VE
categories: Virtualization
author:     招文桃
catalog:    true
tags:
    - Virtualization
---

> 记录安装 Proxmox VE 过程

### 从 ISO 镜像制作启动 U 盘

```bash
liuhuaqiang@shuiguotan:~$ sudo dd bs=1M conv=fdatasync if=./proxmox-ve_7.2-1.iso of=/dev/sdb
994+1 records in
994+1 records out
1042497536 bytes (1.0 GB, 994 MiB) copied, 80.7667 s, 12.9 MB/s
```
