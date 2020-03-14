---
typora-root-url: ../
layout:     post
title:      网络爬虫学习笔记
date:       '2020-03-02T19:30'
subtitle:   scraping the web for fun and for profit
keywords:   web-scraping, crawler, java, jsoup
author:     招文桃
catalog:    true
tags:
    - Java
    - 爬虫
    - scraping
---

### 课程计划

- 入门

- HttpClient

- Jsoup

- 案例

  ```java
  dependencies {
      implementation('org.jsoup:jsoup:1.12.2')
      implementation('org.apache.httpcomponents:httpclient:4.5.2')
  
      testImplementation('org.slf4j:slf4j-log4j12:1.7.25')
      testImplementation('org.junit.jupiter:junit-jupiter:5.6.0')
  }
  ```

### 爬虫功能

从功能上来讲，爬虫一般分为数据采集，处理，存储三个部分。爬虫从一个或若干个初始页面的URL开始，获得初始页面上的URL，在抓取页面的过程中，不断从当前页面抽取新的URL放入队列，直到满足系统的一定停止条件。

- 数据采集
- 处理
- 存储

从初始页面开始，爬取这个页面里面的详细页面连接，接着是下一页，等等。<!--more-->

#### 为什么学习网络爬虫

1. 可以实现搜索引擎

   搜集，自己感兴趣的数据。做好玩的事情。

2. 大数据时代，获取更多数据源，人工智能

   - 数据分析
   - 数据挖掘

3. 搜索引擎优化，网站推广，研究规则

4. 就业，数据工程师，爬虫工程师， Microsoft Health,  Data mining

### 带参数的 GET 请求

- HttpGet

### POST 请求 

- HttpPost 不带参数
- 带参数

[To be continued!]

