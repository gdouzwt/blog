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

初步怀疑是新上线的一个服务的 Hikari CP 配置项不恰当导致出现这样的问题。先看看当时正式环境的 Spring Boot 配置文件里面关于 Hikari CP 的配置参数：

```yml
spring:
  datasource:
    hikari:
      poolName: Hikari
      auto-commit: false
      minimum-idle: 100
      maximum-pool-size: 200
      data-source-properties:
        cachePrepStmts: true
        prepStmtCacheSize: 250
        prepStmtCacheSqlLimit: 2048
        useServerPrepStmts: true
```
这个跟以往使用的配置，或者说跟 *JHipster* 默认的配置有点点区别。主要是显式指定了 `minimum-idle` 和 `maximum-pool-size` 的值。 下面说说这两个参数的作用，根据 [HikariCP GitHub](https://github.com/brettwooldridge/HikariCP#configuration-knobs-baby):
> `minimumIdle`
> This property controls the minimum number of *idle connections* that HikariCP tries to maintain in the pool. If the idle connections dip below this value and total connections in the pool are less than `maximumPoolSize`, HikariCP will make a best effort to add additional connections quickly and efficiently. However, for maximum performance and responsiveness to spike demands, we recommend *not* setting this value and instead allowing HikariCP to act as a *fixed size* connection pool. *Default: same as maximumPoolSize*
> 这个属性控制 HikariCP 在池中尝试维护的最小*空闲连接*数量。如果空闲连接数低于这个值，并且在池中的总连接数少于 `maximumPoolSize` 的值， HikariCP 会尽可能迅速和高效地添加另外的连接。然而，为了最大化性能和对于对突增请求的响应性，我们建议*不*设置这个值，而让 HikariCP 去作为一个*固定大小*连接池。*默认：同 maximumPoolSize* 。
