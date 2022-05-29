---
typora-root-url: ../
layout:     post
title:      获取 Java thread dump
date:       '2022-01-06T15:54'
subtitle:   
keywords:   Java, JVM, Thread dump
author:     招文桃
catalog:    true
tags:
    - Java
    - JVM

---

当生产环境的Java应用程序出现问题时，我们可以借助JVM提供的一些工具去分析问题根源。近期在线上环境遇到Java应用导致服务器CPU占用过高的情况，当时使用到一些JVM工具去获取线程转存，
这里记录一下排查过程和用到的命令。
