---
layout:     post
title:      查询 Linux 内存信息
date:       '2022-07-22T13:00'
subtitle:   Query Linux memory info
categories: Linux
author:     招文桃
catalog:    true
tags:
    - Linux
    - Hardware
---


### 使用 dmidecode 查看内存信息

首先看系统是否已经安装 dmidecode:

`dmidecode --help`

如果已经有安装，会见到类似以下输出：
```bash
Usage: dmidecode [OPTIONS]
Options are:
 -d, --dev-mem FILE     Read memory from device FILE (default: /dev/mem)
 -h, --help             Display this help text and exit
 -q, --quiet            Less verbose output
 -s, --string KEYWORD   Only display the value of the given DMI string
 -t, --type TYPE        Only display the entries of given type
 -H, --handle HANDLE    Only display the entry of given handle
 -u, --dump             Do not decode the entries
     --dump-bin FILE    Dump the DMI data to a binary file
     --from-dump FILE   Read the DMI data from a binary file
     --no-sysfs         Do not attempt to read DMI data from sysfs files
     --oem-string N     Only display the value of the given OEM string
 -V, --version          Display the version and exit
```

接下来是一些具体使用例子：

#### 查看内存插槽数量，已使用几个插槽，每条内存多大

```bash
$ sudo dmidecode | grep -A5 "Memory Device" | grep Size | grep -v Range
        Size: No Module Installed
        Size: 8192 MB
        Size: No Module Installed
        Size: No Module Installed
```
