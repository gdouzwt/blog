---
layout:     post
title:      一次刺激的面试和笔试
subtitle:   继续总结经验教训
date:       2019-09-21
author:     招文桃
header-img: img/post-bg-desk.jpg
catalog: true
tags:
    - 笔试面试
---





先记录一些错题回顾。不过这些不是在线笔试的错题，是日常练习的。

- 一个以".java"为后缀的源文件：

> 只能有一个与文件名相同的public类，可以包含其他非public类（不考虑内部类）

基础概念要清晰。

- 关于`equals()` 和 `hashcode()` 的，对象属性之类的东西。

下面论述正确的是（）？

> A. 如果两个对象的hashcode相同，那么它们作为同一个HashMap的key时，必然返回同样的值
> B. 如果a,b的hashcode相同，那么a.equals(b)必须返回true
> C. 对于一个类，其所有对象的hashcode必须不同
> D. 如果a.equals(b)返回true，那么a,b两个对象的hashcode必须相同

答案是 D

解释如下：

如果两个对象的hashcode相同，那么它们作为同一个HashMap的key时，必然返回同样的值。如果a,b的hashcode相同，那么a.equals(b)必须返回true，对于一个类，其所有对象的hashcode必须不同，
如果a.equals(b)返回true，那么a,b两个对象的hashcode必须相同。



- 关于计算机网络

如果在一个建立了TCP连接的socket上调用recv函数，返回值为0，则表示（）

> A. 对端发送了一段长度为0的数据
> B. 对端关闭了连接
> C. 还没有收到对端数据
> D. 连接发生错误

基础，对于TCP协议的认识，解阻塞与非阻塞recv返回值没有区分，都是

>  < 0 出错， 
>
> =0 连接关闭 
>
> 0 接收到数据太小



- 关于JavaBean的，还有一些JSP，旧的技术还没有完全淘汰，有时候有必要了解一下。

