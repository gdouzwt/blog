---
layout:     post
title:      MySQL Max connect timeout reached 错误排查
date:       '2022-07-22T17:40'
subtitle:   MySQL Max connect timeout reached trouble shooting
categories: MySQL
author:     招文桃
catalog:    true
tags:
    - MySQL
---

> 线上环境遇到过 'java.sql.SQLException: Max connect timeout reached while reaching hostgroup 0 after 10000ms' 这样的错误，记录一下事故排查过程。

### 事故情况描述及紧急处理

当天下午 5 点左右，收到投诉说用户登入不了网站，管理后台有发现 `Max connect timeout reached while reaching hostgroup 0 after 10000ms` 错误，大概可以判断是因为数据库连接问题导致所有用到数据库查询的 API 都出现了这个错误，所以网站、管理后台、Apps都登录不上。

![MySQL-max-connect-timeout-error](/img/mysql-max-connect-timeout-2022-07-22_17-38-55.png)
<p align="center">MySQL 达到最大连接超时错误</p>

紧急处理就是将新服务先停掉，以免影响到原先正常的服务。

### Hikari CP 数据库连接池配置检查

初步怀疑是新上线的一个服务的 Hikari CP 配置项不恰当导致出现这样的问题。
