---
layout:     post
title:      MySQL 文档型数据存储
date:       '2022-05-30T08:20'
subtitle:   Using MySQL as NoSQL engine
keywords:   MySQL, NoSQL, JSON
author:     招文桃
catalog:    true
tags:
    - MySQL
    - NoSQL
    - JSON

---

> 本文记录使用 MySQL 作为 NoSQL 存储，主要是阅读 MySQL 8.0 Reference Manual 的 Chapter 20 Using MySQL as a Document Store 内容和练习时候的笔记。

### 文档型数据存储

文档型数据存储相对于传统的关系型数据存储，比较明显的区别就是文档型数据存储是不需要预先定义模式（schema）的，而关系型数据存储需要定义模式才能做数据存储的动作。

### MySQL 文档型数据存储模式

当将 MySQL 作为文档存储使用时，主要会用到以下功能：

- X Plugin
- X Protocol
- X DevAPI
