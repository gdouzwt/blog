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
> 🔢`minimumIdle`<br>
> This property controls the minimum number of *idle connections* that HikariCP tries to maintain in the pool. If the idle connections dip below this value and total connections in the pool are less than `maximumPoolSize`, HikariCP will make a best effort to add additional connections quickly and efficiently. However, for maximum performance and responsiveness to spike demands, we recommend *not* setting this value and instead allowing HikariCP to act as a *fixed size* connection pool. *Default: same as maximumPoolSize*<br>
> 这个属性控制 HikariCP 在池中尝试维护的最小*空闲连接*数量。如果空闲连接数低于这个值，并且在池中的总连接数少于 `maximumPoolSize` 的值， HikariCP 会尽可能迅速和高效地添加另外的连接。然而，为了最大化性能和对于对突增请求的响应性，我们建议*不*设置这个值，而让 HikariCP 去作为一个*固定大小*连接池。*默认：同 maximumPoolSize* 。

所以没有必要设置 `minimumIdle` 的值。接下来看看 `maximum-pool-size` 的用途：

> 🔢`maximumPoolSize`<br>
> This property controls the maximum size that the pool is allowed to reach, including both idle and in-use connections. Basically this value will determine the maximum number of actual connections to the database backend. A reasonable value for this is best determined by your execution environment. When the pool reaches this size, and no idle connections are available, calls to getConnection() will block for up to `connectionTimeout` milliseconds before timing out. Please read [about pool sizing](https://github.com/brettwooldridge/HikariCP/wiki/About-Pool-Sizing). *Default: 10*<br>
> 这个属性控制连接池能达到的最大大小，包括空闲和正在使用的连接。基本上这个值会决定与数据库后端连接的实际最大数量。一个合理的值最好取决于你的程序执行环境。当连接池达到这个大小，并且没有空闲连接可用，调用 getConnection() 会阻塞直至 `connectionTimeout` 毫秒直到超时。请看[关于连接池大小](https://github.com/brettwooldridge/HikariCP/wiki/About-Pool-Sizing)。*默认：10*<br>


### Hikari CP 常用配置属性（GitHub README）

HikariCP comes with *sane* defaults that perform well in most deployments without additional tweaking. **Every property is optional, except for the "essentials" marked below.**

<sup>&#128206;</sup>&nbsp;*HikariCP uses milliseconds for all time values.*

&#128680;&nbsp;HikariCP relies on accurate timers for both performance and reliability. It is *imperative* that your server is synchronized with a time-source such as an NTP server. *Especially* if your server is running within a virtual machine.  Why? [Read more here](https://dba.stackexchange.com/a/171020). **Do not rely on hypervisor settings to "synchronize" the clock of the virtual machine. Configure time-source synchronization inside the virtual machine.**   If you come asking for support on an issue that turns out to be caused by lack time synchronization, you will be taunted publicly on Twitter.

#### Essentials

&#128292;``dataSourceClassName``<br/>
This is the name of the ``DataSource`` class provided by the JDBC driver.  Consult the
documentation for your specific JDBC driver to get this class name, or see the [table](https://github.com/brettwooldridge/HikariCP#popular-datasource-class-names) below.
Note XA data sources are not supported.  XA requires a real transaction manager like
[bitronix](https://github.com/bitronix/btm). Note that you do not need this property if you are using
``jdbcUrl`` for "old-school" DriverManager-based JDBC driver configuration.
*Default: none*

*- or -*

&#128292;``jdbcUrl``<br/>
This property directs HikariCP to use "DriverManager-based" configuration.  We feel that DataSource-based
configuration (above) is superior for a variety of reasons (see below), but for many deployments there is
little significant difference.  **When using this property with "old" drivers, you may also need to set
the  ``driverClassName`` property, but try it first without.**  Note that if this property is used, you may
still use *DataSource* properties to configure your driver and is in fact recommended over driver parameters
specified in the URL itself.
*Default: none*

***

&#128292;``username``<br/>
This property sets the default authentication username used when obtaining *Connections* from
the underlying driver.  Note that for DataSources this works in a very deterministic fashion by
calling ``DataSource.getConnection(*username*, password)`` on the underlying DataSource.  However,
for Driver-based configurations, every driver is different.  In the case of Driver-based, HikariCP
will use this ``username`` property to set a ``user`` property in the ``Properties`` passed to the
driver's ``DriverManager.getConnection(jdbcUrl, props)`` call.  If this is not what you need,
skip this method entirely and call ``addDataSourceProperty("username", ...)``, for example.
*Default: none*

&#128292;``password``<br/>
This property sets the default authentication password used when obtaining *Connections* from
the underlying driver. Note that for DataSources this works in a very deterministic fashion by
calling ``DataSource.getConnection(username, *password*)`` on the underlying DataSource.  However,
for Driver-based configurations, every driver is different.  In the case of Driver-based, HikariCP
will use this ``password`` property to set a ``password`` property in the ``Properties`` passed to the
driver's ``DriverManager.getConnection(jdbcUrl, props)`` call.  If this is not what you need,
skip this method entirely and call ``addDataSourceProperty("pass", ...)``, for example.
*Default: none*

#### Frequently used

&#9989;``autoCommit``<br/>
This property controls the default auto-commit behavior of connections returned from the pool.
It is a boolean value.
*Default: true*

&#9203;``connectionTimeout``<br/>
This property controls the maximum number of milliseconds that a client (that's you) will wait
for a connection from the pool.  If this time is exceeded without a connection becoming
available, a SQLException will be thrown.  Lowest acceptable connection timeout is 250 ms.
*Default: 30000 (30 seconds)*

&#9203;``idleTimeout``<br/>
This property controls the maximum amount of time that a connection is allowed to sit idle in the
pool.  **This setting only applies when ``minimumIdle`` is defined to be less than ``maximumPoolSize``.**
Idle connections will *not* be retired once the pool reaches ``minimumIdle`` connections.  Whether a
connection is retired as idle or not is subject to a maximum variation of +30 seconds, and average
variation of +15 seconds.  A connection will never be retired as idle *before* this timeout.  A value
of 0 means that idle connections are never removed from the pool.  The minimum allowed value is 10000ms
(10 seconds).
*Default: 600000 (10 minutes)*

&#9203;``keepaliveTime``<br/>
This property controls how frequently HikariCP will attempt to keep a connection alive, in order to prevent
it from being timed out by the database or network infrastructure. This value must be less than the
`maxLifetime` value. A "keepalive" will only occur on an idle connection. When the time arrives for a "keepalive"
against a given connection, that connection will be removed from the pool, "pinged", and then returned to the
pool. The 'ping' is one of either: invocation of the JDBC4 `isValid()` method, or execution of the
`connectionTestQuery`. Typically, the duration out-of-the-pool should be measured in single digit milliseconds
or even sub-millisecond, and therefore should have little or no noticible performance impact. The minimum
allowed value is 30000ms (30 seconds), but a value in the range of minutes is most desirable.
*Default: 0 (disabled)*

&#9203;``maxLifetime``<br/>
This property controls the maximum lifetime of a connection in the pool.  An in-use connection will
never be retired, only when it is closed will it then be removed.  On a connection-by-connection
basis, minor negative attenuation is applied to avoid mass-extinction in the pool.  **We strongly recommend
setting this value, and it should be several seconds shorter than any database or infrastructure imposed
connection time limit.**  A value of 0 indicates no maximum lifetime (infinite lifetime), subject of
course to the ``idleTimeout`` setting.  The minimum allowed value is 30000ms (30 seconds).
*Default: 1800000 (30 minutes)*

&#128292;``connectionTestQuery``<br/>
**If your driver supports JDBC4 we strongly recommend not setting this property.** This is for
"legacy" drivers that do not support the JDBC4 ``Connection.isValid() API``.  This is the query that
will be executed just before a connection is given to you from the pool to validate that the
connection to the database is still alive. *Again, try running the pool without this property,
HikariCP will log an error if your driver is not JDBC4 compliant to let you know.*
*Default: none*

&#128290;``minimumIdle``<br/>
This property controls the minimum number of *idle connections* that HikariCP tries to maintain
in the pool.  If the idle connections dip below this value and total connections in the pool are less than ``maximumPoolSize``,
HikariCP will make a best effort to add additional connections quickly and efficiently.
However, for maximum performance and responsiveness to spike demands,
we recommend *not* setting this value and instead allowing HikariCP to act as a *fixed size* connection pool.
*Default: same as maximumPoolSize*

&#128290;``maximumPoolSize``<br/>
This property controls the maximum size that the pool is allowed to reach, including both
idle and in-use connections.  Basically this value will determine the maximum number of
actual connections to the database backend.  A reasonable value for this is best determined
by your execution environment.  When the pool reaches this size, and no idle connections are
available, calls to getConnection() will block for up to ``connectionTimeout`` milliseconds
before timing out.  Please read [about pool sizing](https://github.com/brettwooldridge/HikariCP/wiki/About-Pool-Sizing).
*Default: 10*

&#128200;``metricRegistry``<br/>
This property is only available via programmatic configuration or IoC container.  This property
allows you to specify an instance of a *Codahale/Dropwizard* ``MetricRegistry`` to be used by the
pool to record various metrics.  See the [Metrics](https://github.com/brettwooldridge/HikariCP/wiki/Dropwizard-Metrics)
wiki page for details.
*Default: none*

&#128200;``healthCheckRegistry``<br/>
This property is only available via programmatic configuration or IoC container.  This property
allows you to specify an instance of a *Codahale/Dropwizard* ``HealthCheckRegistry`` to be used by the
pool to report current health information.  See the [Health Checks](https://github.com/brettwooldridge/HikariCP/wiki/Dropwizard-HealthChecks)
wiki page for details.
*Default: none*

&#128292;``poolName``<br/>
This property represents a user-defined name for the connection pool and appears mainly
in logging and JMX management consoles to identify pools and pool configurations.
*Default: auto-generated*

#### Infrequently used

&#9203;``initializationFailTimeout``<br/>
This property controls whether the pool will "fail fast" if the pool cannot be seeded with
an initial connection successfully.  Any positive number is taken to be the number of
milliseconds to attempt to acquire an initial connection; the application thread will be
blocked during this period.  If a connection cannot be acquired before this timeout occurs,
an exception will be thrown.  This timeout is applied *after* the ``connectionTimeout``
period.  If the value is zero (0), HikariCP will attempt to obtain and validate a connection.
If a connection is obtained, but fails validation, an exception will be thrown and the pool
not started.  However, if a connection cannot be obtained, the pool will start, but later
efforts to obtain a connection may fail.  A value less than zero will bypass any initial
connection attempt, and the pool will start immediately while trying to obtain connections
in the background.  Consequently, later efforts to obtain a connection may fail.
*Default: 1*

&#10062;``isolateInternalQueries``<br/>
This property determines whether HikariCP isolates internal pool queries, such as the
connection alive test, in their own transaction.  Since these are typically read-only
queries, it is rarely necessary to encapsulate them in their own transaction.  This
property only applies if ``autoCommit`` is disabled.
*Default: false*

&#10062;``allowPoolSuspension``<br/>
This property controls whether the pool can be suspended and resumed through JMX.  This is
useful for certain failover automation scenarios.  When the pool is suspended, calls to
``getConnection()`` will *not* timeout and will be held until the pool is resumed.
*Default: false*

&#10062;``readOnly``<br/>
This property controls whether *Connections* obtained from the pool are in read-only mode by
default.  Note some databases do not support the concept of read-only mode, while others provide
query optimizations when the *Connection* is set to read-only.  Whether you need this property
or not will depend largely on your application and database.
*Default: false*

&#10062;``registerMbeans``<br/>
This property controls whether or not JMX Management Beans ("MBeans") are registered or not.
*Default: false*

&#128292;``catalog``<br/>
This property sets the default *catalog* for databases that support the concept of catalogs.
If this property is not specified, the default catalog defined by the JDBC driver is used.
*Default: driver default*

&#128292;``connectionInitSql``<br/>
This property sets a SQL statement that will be executed after every new connection creation
before adding it to the pool. If this SQL is not valid or throws an exception, it will be
treated as a connection failure and the standard retry logic will be followed.
*Default: none*

&#128292;``driverClassName``<br/>
HikariCP will attempt to resolve a driver through the DriverManager based solely on the ``jdbcUrl``,
but for some older drivers the ``driverClassName`` must also be specified.  Omit this property unless
you get an obvious error message indicating that the driver was not found.
*Default: none*

&#128292;``transactionIsolation``<br/>
This property controls the default transaction isolation level of connections returned from
the pool.  If this property is not specified, the default transaction isolation level defined
by the JDBC driver is used.  Only use this property if you have specific isolation requirements that are
common for all queries.  The value of this property is the constant name from the ``Connection``
class such as ``TRANSACTION_READ_COMMITTED``, ``TRANSACTION_REPEATABLE_READ``, etc.
*Default: driver default*

&#9203;``validationTimeout``<br/>
This property controls the maximum amount of time that a connection will be tested for aliveness.
This value must be less than the ``connectionTimeout``.  Lowest acceptable validation timeout is 250 ms.
*Default: 5000*

&#9203;``leakDetectionThreshold``<br/>
This property controls the amount of time that a connection can be out of the pool before a
message is logged indicating a possible connection leak.  A value of 0 means leak detection
is disabled.  Lowest acceptable value for enabling leak detection is 2000 (2 seconds).
*Default: 0*

&#10145;``dataSource``<br/>
This property is only available via programmatic configuration or IoC container.  This property
allows you to directly set the instance of the ``DataSource`` to be wrapped by the pool, rather than
having HikariCP construct it via reflection.  This can be useful in some dependency injection
frameworks. When this property is specified, the ``dataSourceClassName`` property and all
DataSource-specific properties will be ignored.
*Default: none*

&#128292;``schema``<br/>
This property sets the default *schema* for databases that support the concept of schemas.
If this property is not specified, the default schema defined by the JDBC driver is used.
*Default: driver default*

&#10145;``threadFactory``<br/>
This property is only available via programmatic configuration or IoC container.  This property
allows you to set the instance of the ``java.util.concurrent.ThreadFactory`` that will be used
for creating all threads used by the pool. It is needed in some restricted execution environments
where threads can only be created through a ``ThreadFactory`` provided by the application container.
*Default: none*

&#10145;``scheduledExecutor``<br/>
This property is only available via programmatic configuration or IoC container.  This property
allows you to set the instance of the ``java.util.concurrent.ScheduledExecutorService`` that will
be used for various internally scheduled tasks.  If supplying HikariCP with a ``ScheduledThreadPoolExecutor``
instance, it is recommended that ``setRemoveOnCancelPolicy(true)`` is used.
*Default: none*

----------------------------------------------------

#### Missing Knobs

HikariCP has plenty of "knobs" to turn as you can see above, but comparatively less than some other pools.
This is a design philosophy.  The HikariCP design aesthetic is Minimalism.  In keeping with the
*simple is better* or *less is more* design philosophy, some configuration axis are intentionally left out.

#### Statement Cache

Many connection pools, including Apache DBCP, Vibur, c3p0 and others offer ``PreparedStatement`` caching.
HikariCP does not.  Why?

At the connection pool layer ``PreparedStatements`` can only be cached *per connection*.  If your application
has 250 commonly executed queries and a pool of 20 connections you are asking your database to hold on to
5000 query execution plans -- and similarly the pool must cache this many ``PreparedStatements`` and their
related graph of objects.

Most major database JDBC drivers already have a Statement cache that can be configured, including PostgreSQL,
Oracle, Derby, MySQL, DB2, and many others.  JDBC drivers are in a unique position to exploit database specific
features, and nearly all of the caching implementations are capable of sharing execution plans *across connections*.
This means that instead of 5000 statements in memory and associated execution plans, your 250 commonly executed
queries result in exactly 250 execution plans in the database.  Clever implementations do not even retain
``PreparedStatement`` objects in memory at the driver-level but instead merely attach new instances to existing plan IDs.

Using a statement cache at the pooling layer is an [anti-pattern](https://en.wikipedia.org/wiki/Anti-pattern),
and will negatively impact your application performance compared to driver-provided caches.

#### Log Statement Text / Slow Query Logging

Like Statement caching, most major database vendors support statement logging through
properties of their own driver.  This includes Oracle, MySQL, Derby, MSSQL, and others.  Some
even support slow query logging.  For those few databases that do not support it, several options are available.
We have received [a report that p6spy works well](https://github.com/brettwooldridge/HikariCP/issues/57#issuecomment-354647631),
and also note the availability of [log4jdbc](https://github.com/arthurblake/log4jdbc) and [jdbcdslog-exp](https://code.google.com/p/jdbcdslog-exp/).

#### Rapid Recovery
Please read the [Rapid Recovery Guide](https://github.com/brettwooldridge/HikariCP/wiki/Rapid-Recovery) for details on how to configure your driver and system for proper recovery from database restart and network partition events.
