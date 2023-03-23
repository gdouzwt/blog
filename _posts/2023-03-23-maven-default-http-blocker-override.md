---
layout:     post
title:      允许高版本 maven 使用 http 私有仓库
date:       '2023-03-23T17:58'
subtitle:   overriding maven default http blocker
categories: Java
author:     招文桃
catalog:    true
tags:
    - Java
    - Maven
---

高版本的 maven 默认会阻止使用 http 协议，仅支持 https 协议。但是如果本地网络私有仓库有 maven 的包，需要用到 http 的 repository

例如在工程的 `pom.xml` 文件里面，假设是这样的：

```text-xml
<repositories>
    <repository>
        <snapshots>
            <enabled>false</enabled>
        </snapshots>
        <id>central</id>
        <name>libs-release</name>
        <url>http://my-url/libs-release</url>
    </repository>
    <repository>
        <id>snapshots</id>
        <name>libs-snapshot</name>
        <url>http://my-url/libs-snapshot</url>
    </repository>
</repositories>
```

那么，需要在本地的 `~/.m2/settings.xml` 或者 `.mvn/local-settings.xml` 里面设置一下内容，以允许使用 http 协议的私有仓库：

```text-xml
<settings>
    <mirrors>
        <mirror>
            <id>release-http-unblocker</id>
            <mirrorOf>central</mirrorOf>
            <name></name>
            <url>http://my-url/libs-release</url>
        </mirror>
        <mirror>
            <id>snapshot-http-unblocker</id>
            <mirrorOf>snapshots</mirrorOf>
            <name></name>
            <url>http://my-url/libs-snapshot</url>
        </mirror>
    </mirrors>
</settings>
```

其中，`<mirrorOf>` 标签填，`pom.xml` 里面定义的私有仓库的 `id` ，然后 `<url` 填原来被镜像的 url （即默认被 block 的那个 http url）

这样设置完，就可以跳过高版本强制使用 https 协议导致的报错。
