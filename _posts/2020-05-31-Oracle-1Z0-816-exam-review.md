---
typora-root-url: ../
layout:     post
title:      回顾OCP 1Z0-816认证考试
date:       '2020-05-31T06:32'
subtitle:   
keywords:   Java Certified, 1Z0-816
author:     招文桃
catalog:    true
tags:
    - Java
    - Certification
---

Today, I dedicate myself to write this review, hopefully get it done before I go to bed. I started with OCA Java SE 8 programmer I exam last year, it took me 12 days to prepared the OCA exam. It was relatively easy to pass the OCA exam, but it was much harder to pass the OCP 11 exam. It took me roughly 3 months to get fully prepared for the ultimate 1Z0-816, namely Java SE 11 Programmer II exam, for which response to the Oracle Certified Professional: Java SE 11 Developer certification.
This is by far the most difficult Java certification exam from Oracle/Sun, not just because it covers topics such as modules, functional programming, concurrent programming, IO. But also it includes some new objectives, like Java Secure Coding Guideline. For those who plan on to take the Oracle Java Certification exam, I strongly recommend you to take a look the
official exam objectives before you start your study plan. Buy a good book, I think Selikoff's book is great, I use that book for my exam preparation. Study the book chapter by chapter, or by topic, or whatever you want. Be sure to do the exercises, it will help you to consolidate your knowledge. It also helpful to use flashcard to aid the memorization process. Say some core APIs, or some syntax rules. Don't go directly into the quiz without studying the materials thoroughly, that will just a waste of time and energy.
Because that's very frustrated to see lots of errors.  Take your time, start slowly, and gradually level up the difficulty.  

---



### 考试复习大纲

**Java 基础**
创建并使用 final 类
创建并使用内部，嵌套，以及匿名类
创建并使用枚举
**Java 接口**
创建并使用带有默认方法的接口
创建并使用带有私有方法的接口
函数式接口与 Lambda 表达式
定义并编写函数式接口
创建并使用 Lambda 表达式，包括 Lambda 语句，局部变量作 lambda 参数
**内置函数式接口**
使用 java.util.function 包里的接口
使用核心函数式接口，包括 Predicate, Consumer, Function 和 Supplier
使用 java.util.function 包里基础接口的基本数据类型及二元变式
**迁移到模块化应用**
迁移使用Java SE 9 以前版本开发的应用到 SE 11，包括自上而下和自下而上迁移方式，将一个 Java SE
8 应用分模块作迁移
使用 jdeps 确定依赖关系，并识别解决循环依赖的方法。
**并发**
使用 Runnable，Callable 创建工作线程，并使用 ExecutorService 并发地执行任务
使用 java.util.concurrent 包里的容器和类，包括 CyclicBarrier 和 CopyOnWriteArrayList
编写线程安全的代码
识别线程问题，例如死锁和活锁
**I/O (基础以及 NIO2)**
使用 I/O 流从控制台和文件读写数据
使用 I/O 流读写文件
使用序列化读写对象
使用 Path 接口操作文件和目录路径
使用 Files 类去检查、删除、复制或移动一个文件或目录
结合 Files 类使用 Stream API
**JDBC 数据库应用**
使用 JDBC URLs 和 DriverManager 连接到数据库
使用 PreparedStatement 去执行 CRUD 操作
使用 PreparedStatement 和 CallableStatement APIs 去执行数据库操作
**注解**
表述注解的用途以及典型使用模式
应用注解到类和方法
描述 JDK 中常用的注解
声明自定义注解
异常处理与断言
使用 try-with-resources 结构
创建并使用自定义异常类
使用断言测试不变性
**泛型与容器**
使用包装类，自动装箱和自动拆箱
用钻石记号和通配符创建并使用泛型类、方法
描述容器框架并使用主要容器接口
使用 Comparator 和 Comparable 接口
创建并使用容器的便利方法
**Java Stream API**
描述 Stream 接口和管道
使用 lambda 表达式和方法引用
Streams 上的 Lambda 操作
使用 map, peek 和 flatMap 方法提取 stream 数据
使用 findFirst, findAny, anyMatch, allMatch 和 noneMatch 方法搜索 stream 数据
使用 Optional 类
使用 count, max, min, average 和 sum stream 操作执行计算
使用 lambda 表达式对容器排序
在 streams 使用 Collectors ，包括 groupingBy 和 partitioningBy 操作
**模块化应用中的服务**
描述服务的组件，包括指令
设计一个服务类型，使用 ServiceLoader 加载服务，检查服务的依赖，包括消费者和提供者模块
**并行 Streams**
编写使用并行 streams 的代码
用 streams 实现分解与归约操作
**Java SE 应用安全编码**
在 Java 应用中预防拒绝服务
在 Java 应用中保护机密信息
实现数据一致性准则——注入和包含以及输入校验
通过限制可访问性和可扩展性保护代码受外部攻击，妥善处理输入校验以及可变性
安全地构建敏感对象
保护序列化与反序列化
**本地化**
使用 Locale 类
使用资源包
使用 Java 格式化消息、日期和数字



### 其它有用的信息

- Oracle 的 Secure Coding Guidelines for Java SE 页面已经更新了，排版比较现代了，而且小标题改为Updated for Java SE 11 而不是 Java SE 13  
  [Secure Coding Guidelines for Java SE](https://www.oracle.com/java/technologies/javase/seccodeguide.html)  
  Updated for Java SE 11  
  Document version: 7.2  
  Published: 27 September 2018  
  Last updated: 7 May 2019  



- [Selikoff Java SE 11 experience](https://www.selikoff.net/2019/08/31/my-experience-taking-the-new-java-se-11-programmer-ii-1z0-816-exam/)

While questions within a topic were relatively straight-forward, the amount of topics you had to know for the 1Z0-816 exam dwarfs the 1Z0-809 exam. Annotations, Security, Local Type Inference, Private/Static Interface Methods, and Modules are completely new.

- Book
- Mock exam software
- docs
- jls

[Get Ready for your Online Proctored Exam - Oracle Certification(Video)](https://players.brightcove.net/2985902027001/r1ZNvX6Ux_default/index.html?videoId=6151284095001)  

[Oracle onvue](https://home.pearsonvue.com/oracle/onvue)  

[Online Proctoring FAQs](https://home.pearsonvue.com/oracle/op/faqs/)  

[pearsonvue online-proctored-policies](https://home.pearsonvue.com/Documents/Online-Proctored/online-proctored-policies.aspx)  

[甲骨文大学](https://education.oracle.com/home)  

关于认证考试本身的信息，我建议你去Oracle University官方网站看看，考试的信息和认证路径的信息。

[OCA 808](https://education.oracle.com/java-se-8-programmer-i/pexam_1Z0-808)  

[Oracle Learning Subscriptions Eight Quick Tips](https://blogs.oracle.com/certification/oracle-learning-subscription-eight-quick-tips)  

[OnVUE Testing Experience](https://youtu.be/Gm1PqdbwBP0)  

[Oracle Certification Exams Are More Accessible Than Ever Before](https://blogs.oracle.com/certification/oracle-certification-exams-are-more-accessible-than-ever-before)  

[Your Guide to Oracle Certification Testing Anywhere](https://blogs.oracle.com/certification/your-guide-to-oracle-certification-testing-anywhere)  

[Secure Coding Guidelines for Java SE](https://www.oracle.com/java/technologies/javase/seccodeguide.html)