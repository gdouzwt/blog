---
layout:     post
title:      MySQL 文档型数据存储
date:       '2022-05-30T08:20'
subtitle:   Using MySQL as NoSQL engine
categories: MySQL
author:     招文桃
catalog:    true
tags:
    - MySQL
    - NoSQL
    - JSON
---

> 本文记录使用 MySQL 作为 NoSQL 存储，主要是阅读 MySQL 8.0 Reference Manual 的 Chapter 20 Using MySQL as a Document Store 内容和练习时候的笔记。

## 文档型数据存储

文档型数据存储相对于传统的关系型数据存储，比较明显的区别就是文档型数据存储是不需要预先定义模式（schema）的，而关系型数据存储需要定义模式才能做数据存储的动作。

## MySQL 文档型数据存储模式

当将 MySQL 作为文档存储使用时，主要会用到以下功能：

- X Plugin
- X Protocol
- X DevAPI

### 安装 MySQL Shell 以便练习

在 Ubuntu 中可以用以下命令安装 MySQL Shell：

```console
sudo apt install mysql-shell
```

如果用 `apt` 安装有出现依赖库相关的问题，那么可以尝试通过 `snap` 安装：

```console
sudo snap install mysql-shell
```

顺利安装完会提示：
> mysql-shell 8.0.23 from Canonical✓ installed

MySQL 支持两种语言运行环境，一种是 JavaScript，另一种是 Python。 在 Windows 打开 MySQL shell 貌似默认是用 JavaScript，而在 Ubuntu 默认使用 Python。在终端输入 `mysqlsh` 就可以打开 MySQL shell，不过默认情况下可能没有连接到数据库。使用以下命令连接到数据库，注意 `X Protocol` 使用的端口号是 `33060`。

```console
mysqlsh root@192.168.3.33:33060/world_x
```

其中 `root` 是用户，`192.168.3.33` 是主机 IP，`33060` 是端口号，最后部分是默认的 schema。 `world_x` 是 MySQL 官方提供的一个 example database，是世界上大部分国家/地区、城市等信息的数据库，带 "_x" 是 X Protocol 的版本，用 JSON document 存储数据的。所以这个数据库可以用来练习通过 X Protocol 或者 X DevAPI 使用 MySQL 的文档存储特性。

一般在 Windows 安装 MySQL 8.x 时候会默认自带这个 world_x 示例数据库，且 8.x 版本默认开启 X Plugin（即支持 document store）。 不过如果发现你的 MySQL 实例没有 world_x 这个数据库，那么可以到 MySQL 的网站[下载][world_x-download]这些数据，只是一个 zip 压缩包，里面包含个 SQL 文件，导入即可。学习 MySQL 参考手册这个主题相关内容时候，录了个[短视频][bilibili-video]记录。

### MySQL shell 的基本使用

```console
db
```

> <Schema:world_x>

会输出 schema 相关信息，可以看到存在哪些 schema 和哪个正在使用。

```console
\use world_x

```

> Default schema `world_x` accessible through db.

表示使用 `world_x` 作为数据库默认 schema。


[world_x-download]: https://downloads.mysql.com/docs/world_x-db.zip
[bilibili-video]: https://www.bilibili.com/video/BV1RB4y1X7PY
