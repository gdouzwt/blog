---
typora-root-url: ../
layout:     post
title:      Java笔试题1
date:       '2020-05-16T12:30'
subtitle:   
keywords:   Java Interview, Test
author:     招文桃
catalog:    true
tags:
    - Java 笔试
---

最大汉明距离
给出 n 个数，求这 n 个数中两两最大的汉明距离
两个数的汉明距离定义为两个数的二进制表示中不同的位数。
例如 11 和 6 的汉明距离为 3， 因为 11 转换成为二进制后为 1011， 6 转换为二进制后为 0110， 他们的二进制第 1，3，4 位（从低位开始数）不同。

输入
第一行一个数 n， 代表有 n 个数
接下来 n 个数，描述这 n 个数 a1，a2, ... , an
1 <= n <= 100     1 <= ai <= 10000

输出
一个数，最大的汉明距离

样例输入
3
1 2 3
样例输出
2
