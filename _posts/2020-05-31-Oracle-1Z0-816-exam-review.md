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

I started with OCA Java SE 8 Programmer I exam last year, it took me 12 days to prepare the OCA exam. It was relatively easy to pass the OCA exam, but it was much harder to pass the OCP 11 exam. It took me roughly 3 months to get fully prepared for the ultimate 1Z0-816, namely Java SE 11 Programmer II exam, for which response to the Oracle Certified Professional: Java SE 11 Developer certification. This is by far the most difficult Java certification exam from Oracle/Sun, not just because it covers topics such as modules, functional programming, concurrent programming, IO. But also it includes some new objectives, like Java Secure Coding Guideline. For those who plan on taking the Oracle Java Certification exam, I strongly recommend you take a look at the official exam objectives before you start your study plan. Buy a good book, I think Selikoff's book is great, I use that book for my exam preparation. Study the book chapter by chapter, or by topic, or whatever you want. Be sure to do the exercises, it will help you to consolidate your knowledge. It is also helpful to use flashcards to aid the memorization process, for example,  some core APIs or some syntax rules. Don't go directly into the quiz without studying the materials thoroughly, that will just a waste of time and energy. Because that's very frustrating to see lots of errors. Take your time, start slowly, and gradually level up the difficulty.  Below are some useful references.

 <!--more-->

---

### Books(参考书籍)

I recommend : [OCP Oracle Certified Professional Java SE 11 Programmer II Study Guide: Exam 1Z0-816 1st Edition](https://www.amazon.com/Oracle-Certified-Professional-Programmer-Study/dp/1119617626/ref=dp_ob_title_bk) by [Scott Selikoff](https://www.amazon.com/Scott-Selikoff/e/B00PFTZJ6G/ref=dp_byline_cont_book_1) (Author), [Jeanne Boyarsky](https://www.amazon.com/Jeanne-Boyarsky/e/B00PF6JTQK/ref=dp_byline_cont_book_2) (Author)（This title will be released on July 8, 2020.）

我建议使用这本书作为考试参考。

- [Selikoff Java SE 11 experience](https://www.selikoff.net/2019/08/31/my-experience-taking-the-new-java-se-11-programmer-ii-1z0-816-exam/) 书的作者的考试经验

> While questions within a topic were relatively straight-forward, the amount of topics you had to know for the 1Z0-816 exam dwarfs the 1Z0-809 exam. Annotations, Security, Local Type Inference, Private/Static Interface Methods, and Modules are completely new.
>
> 尽管考试相关的主题相对来说是很直接的，但你在 1Z0-816 考试所需要知道的主题内容使得 1Z0-809 相形见绌。注解、安全、局部类型推导，接口的私有/静态方法，以及模块的内容都是全新的。

If you have time... （有时间还推荐） Java Language Features, Java The Complete Reference, Effective Java

### Mock exam software(模拟软件)

I used (我使用的是) [OCP Java 11 - 1Z0-816 Mock Exams Practice Tests/Questions Part 2](http://www.enthuware.com/java-certification-mock-exams/oracle-certified-professional/ocp-java-11-exam-ii-1z0-816)

### Oracle website pages(官方页面)

#### Technical(技术相关)

- Secure Coding Guidelines for Java SE

   (页面已经更新了，排版比较现代了，而且小标题改为 Updated for Java SE 11 而不是 Java SE 13)  
  [Secure Coding Guidelines for Java SE](https://www.oracle.com/java/technologies/javase/seccodeguide.html)  
  Updated for Java SE 11  
  Document version: 7.2  
  Published: 27 September 2018  
  Last updated: 7 May 2019  

- Java SE 11 API docs : [Java® Platform, Standard Edition & Java Development Kit Version 11 API Specification](https://docs.oracle.com/en/java/javase/11/docs/api/index.html)
- jls :  [Java SE Specifications](https://docs.oracle.com/javase/specs/)
- [Annotations Trail](https://docs.oracle.com/javase/tutorial/java/annotations/) : Learn something new about annotations since Java 8(学习 Java 8 以来更新的注解)

About Online Proctored Exam(关于在线考试) [Get Ready for your Online Proctored Exam - Oracle Certification(Video)](https://players.brightcove.net/2985902027001/r1ZNvX6Ux_default/index.html?videoId=6151284095001)  

[Oracle onvue](https://home.pearsonvue.com/oracle/onvue) Where to schedule an exam(考试报名地址  )

[Online Proctoring FAQs](https://home.pearsonvue.com/oracle/op/faqs/)  常见问题

[pearsonvue online-proctored-policies](https://home.pearsonvue.com/Documents/Online-Proctored/online-proctored-policies.aspx)  在线考试政策

[甲骨文大学](https://education.oracle.com/home)  (Oracle University)主页

Checkout more info about certification exams(关于认证考试本身的信息，我建议你去Oracle University官方网站看看，考试的信息和认证路径的信息。)

[OCA 808](https://education.oracle.com/java-se-8-programmer-i/pexam_1Z0-808)  

[Oracle Learning Subscriptions Eight Quick Tips](https://blogs.oracle.com/certification/oracle-learning-subscription-eight-quick-tips)   官方贴士

[OnVUE Testing Experience](https://youtu.be/Gm1PqdbwBP0)  一个视频，在线考试的体验

[Oracle Certification Exams Are More Accessible Than Ever Before](https://blogs.oracle.com/certification/oracle-certification-exams-are-more-accessible-than-ever-before)  同样是一个关于在线考试的文章

[Your Guide to Oracle Certification Testing Anywhere](https://blogs.oracle.com/certification/your-guide-to-oracle-certification-testing-anywhere)  在线考试文章

---

### 考试复习大纲(1Z0-816 exam objects in Chinese)

**Java 基础**  
创建并使用 `final` 类  
创建并使用内部，嵌套，以及匿名类  
创建并使用枚举  
**Java 接口**  
创建并使用带有默认方法的接口  
创建并使用带有私有方法的接口  
函数式接口与 Lambda 表达式  
定义并编写函数式接口  
创建并使用 Lambda 表达式，包括 Lambda 语句，局部变量作 lambda 参数  
**内置函数式接口**  
使用 `java.util.function` 包里的接口  
使用核心函数式接口，包括 `Predicate`, `Consumer`, `Function` 和 `Supplier`  
使用 `java.util.function` 包里基础接口的基本数据类型及二元变式  
**迁移到模块化应用**  
迁移使用 Java SE 9 以前版本开发的应用到 SE 11，包括自上而下和自下而上迁移方式，将一个 Java SE 8 应用分模块作迁移  
使用 `jdeps` 确定依赖关系，并识别解决循环依赖的方法。  
**并发**  
使用 `Runnable`，`Callable` 创建工作线程，并使用 `ExecutorService` 并发地执行任务  
使用 `java.util.concurrent` 包里的容器和类，包括 `CyclicBarrier` 和 `CopyOnWriteArrayList`  
编写线程安全的代码  
识别线程问题，例如死锁和活锁  
**I/O (基础以及 NIO2)**  
使用 I/O 流从控制台和文件读写数据  
使用 I/O 流读写文件  
使用序列化读写对象  
使用 `Path` 接口操作文件和目录路径  
使用 `Files` 类去检查、删除、复制或移动一个文件或目录  
结合 `Files` 类使用 Stream API  
**JDBC 数据库应用**  
使用 JDBC URLs 和 `DriverManager` 连接到数据库  
使用 `PreparedStatement` 去执行 CRUD 操作  
使用 `PreparedStatement` 和 `CallableStatement` APIs 去执行数据库操作  
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
使用 `Comparator` 和 `Comparable` 接口  
创建并使用容器的便利方法  
**Java Stream API**  
描述 Stream 接口和管道  
使用 lambda 表达式和方法引用  
Streams 上的 Lambda 操作  
使用 `map`, `peek` 和 `flatMap` 方法提取 stream 数据  
使用 `findFirst`, `findAny`, `anyMatch`, `allMatch` 和 `noneMatch` 方法搜索 stream 数据  
使用 `Optional` 类  
使用 `count`, `max`, `min`, `average` 和 `sum` stream 操作执行计算  
使用 lambda 表达式对容器排序  
在 streams 使用 `Collectors` ，包括 `groupingBy` 和 `partitioningBy` 操作  
**模块化应用中的服务**  
描述服务的组件，包括指令  
设计一个服务类型，使用 `ServiceLoader` 加载服务，检查服务的依赖，包括消费者和提供者模块  
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
使用 `Locale` 类  
使用资源包  
使用 Java 格式化消息、日期和数字