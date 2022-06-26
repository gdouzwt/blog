---
layout:     post
title:      MySQL 优化策略
date:       '2022-06-10T17:13'
subtitle:   MySQL optimization strategies
categories: MySQL
author:     招文桃
catalog:    true
tags:
    - MySQL
    - Optimization
    - 优化
---

> 本文讨论 MySQL 一般优化策略

## 数据库层面优化

先问一下问题：

- 数据表结构是否合理，列是否使用的正确的数据类型，以及每张表的列数量是否合理？例如，经常做更新操作的应用通常是多表少列，而用于分析大量数据的应用一般是少表多列。
- 索引设置是否合理以便优化查询？
- 表是否采用了合适的存储引擎？事务型用 InnoDB，非事务型用 MyISAM

