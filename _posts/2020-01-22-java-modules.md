---
typora-root-url: ../
layout:     post
title:      Java模块化
date:       '2020-01-22T00:14'
subtitle:   学习Java 11模块化特性
author:     招文桃
catalog:    true
tags:
    - Java 11
---

为了准备 1Z0-816，所以要学习一下 Java 11 的基础部分。

<!--more-->

![image-20200122001604874](/img/image-20200122001604874.png)

module-info.java 是模块的信息。

一个新的关键词 `module` ，最简单的一个模块如下：

```java
module io.zwt.common {

}
```
