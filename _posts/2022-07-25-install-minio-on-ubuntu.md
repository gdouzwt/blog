---
layout:     post
title:      在 Ubuntu 安装 MinIO
date:       '2022-07-25T20:56'
subtitle:   Install MinIO on Ubuntu
categories: MinIO
author:     招文桃
catalog:    true
tags:
    - MinIO
---

### 使用 Linux 二进制文件安装 MinIO

使用以下命令在 macOS 上下载并运行独立的 MinIO 服务器。 将/data 替换为您希望 MinIO 存储数据的驱动器或目录的路径。

```shell
wget http://dl.minio.org.cn/server/minio/release/darwin-amd64/minio
chmod +x minio
./minio server /data
```

不过现在一般都容器化安装了。
