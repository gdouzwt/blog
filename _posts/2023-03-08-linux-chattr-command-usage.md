---
layout:     post
title:      Linux 的 chattr 命令用途
date:       '2023-03-08T09:53'
subtitle:   using Linux chattr command
categories: Linux
author:     招文桃
catalog:    true
tags:
    - Linux
---

第一次使用 `chattr` 应该是在 [安装Spring Boot应用作为系统服务](https://blog.zwt.io/2021/04/06/install-spring-boot-as-linux-service/) 里：

> 如果被黑了，黑客可以将 jar 文件设为可写的并修改它的内容。其中一种防护方式是将它设置为不可修改的，通过使用 chattr 命令，命令如下：

```shell
$ sudo chattr +i your-app.jar
```

这会防止任何用户，包括 root 修改 jar 的内容。

所以本文就列举一下 `chttr` 的用途。

### 最常用的

一般会使用 `sudo chattr +i 文件名` 来将某个文件设为不可修改，连 root 也不能修改。 man page 说明如下：

> i      A file with the 'i' attribute cannot be modified: it cannot be deleted or renamed, no link can be created to this file, most of the file's metadata can not be  modified,
              and the file can not be opened in write mode.  Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE capability can set or clear this attribute.

移除这个 `i` 属性，可以使用 `sudo chattr -i 文件名` 操作。


### 查看文件属性

可以使用 `lsattr` 命令列出文件的属性。 例如：

```shell
ubuntu@zwt:~$ lsattr Hello.java
--------------e------- Hello.java
ubuntu@zwt:~$ sudo chattr +i Hello.java
ubuntu@zwt:~$ lsattr Hello.java
----i---------e------- Hello.java
ubuntu@zwt:~$ echo "class B {}" >> Hello.java
-bash: Hello.java: Operation not permitted
ubuntu@zwt:~$ sudo chattr -i Hello.java
ubuntu@zwt:~$ echo "class B {}" >> Hello.java
ubuntu@zwt:~$ java Hello.java
Hello World

ubuntu@zwt:~$
```

