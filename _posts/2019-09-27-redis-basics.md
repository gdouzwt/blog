---
layout:     post
title:      学习Redis基础知识
date:       '2019-09-27 23:25:02'
subtitle:   肯定会用到Redis的，至少要理解最基础的命令
author:     招文桃
catalog:    true
tags:
    - Redis
---

### 基础命令

启动 Redis

`redis-server`

查看 Redis 是否启动

`redis-cli`

`redis-cli --raw` 中文不会乱码

默认情况下相当于 `redis-cli -h 127.0.0.1 -p 6379`

设置键值对：

`set myKey abc`

取出键值对：

`get myKey`

### Redis 数据类型

String

Hash

- HMSET
- HGET

List

- LPUSH
- LRANGE

SET

集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是 $O(1)$。

- SADD
- SMEMBERS
- zset(sorted set:)
- ZADD

### Redis 发布订阅

### Redis 事务

### Redis 脚本

