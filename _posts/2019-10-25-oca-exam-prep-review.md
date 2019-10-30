---
typora-root-url: ../
layout:     post
title:      OCA 回顾与评价
date:       '2019-10-25'
subtitle:   备考参考书籍、软件，还有考试体验
author:     招文桃
catalog:    true
tags:
    - Java
    - OCA
---

## 背景

背景，大学学的是软件工程专业。语言学习路径，大一专业课先学C语言，接着是C语言的数据结构。大二分方向，C++ 和 Java两个方向。C++ 作为我入门面向对象编程的语言，学完大学的C++ 课程，主要实践就是用Qt 写了个简单的数据库课程设计，之后就没有怎么用了，荒废掉了。 C 语言还因为学习微机原理（51 单片机）重新拾起来了一段时间。之后因为那段时间喜欢折腾一些硬件所以也开始玩树莓派，树莓派用 Python 比较多，所以又稍微接触了一下 Python 的基础。到后来因为组队参加比赛，开始接触Android 编程，那时候 Android 还未开始用 Kotlin, 就开始学习，边学边开发。后来学校的课程也有 Java Web，和 Android 。在做课程设计的过程就开始使用Spring Boot + AngularJS(那时候用的是 1.x)，写一下后端 REST API，之后觉得 Java Web 后端开发是我想做的方向。可以因为之前学得比较杂，还因为 C/C++ 硬件背景，让我在情感上有点不重视 Java，所以学习投入程度不够。后果就是有时候看代码，写代码的时候觉得很吃力，一种似懂非懂的状态，模糊不清晰，好像大概知道这是做什么功能，但是要清晰地表达出来就有困难了。 要摆脱这种状况，所以多看书，多写代码。参加 Oracle Java 认证考试的作用就是可以驱动学习，有了这个目标，就会认真深入学习。这才是考试的意义。

## 备考

### 选择哪个考试？

#### 历史

Java 1995年5月23日 首次发布，到现在过去了24年，Java 版本经历了很多变化，Java 考试也经历了很多变化。  从最初的 Sun 公司的 SCJP(Sun Certified Java Programmer) 和 SCJA(Sun Certified Java Associate)。 后来 Oracle 收购了 Sun 公司，相应的考试名称更改了，变成OCJP 和 OCJA。 后来从Java 7 版本开始，Oracle 决定不再更新 OCJA考试。 并将更多内容移入到程序员考试，更名为 Oracle Certified Associate Java Programmer (OCAJP)，也称为 Java Programmer I，或者叫 OCA。 考完 OCA 接着就应该参加 Oracle Certified Professional Java Programmer（OCPJP）考试，或称 OCP，又名 Java Programmer II。

![Oracle-java-exam](/img/image-20191029053541378.png)

#### 现在只需要关注的考试：

1Z0-808（Java SE 8 助理程序员），1Z0-809（Java SE 8 专业程序员），1Z0-817（Java SE 6,7,8 专业程序员升级到 Java SE 11 开发者），1Z0-815（Java SE 11 程序员第一部分），1Z0-816（Java SE 11 程序员第二部分，考过即为 Java SE 11开发者）

#### 报考

##### 创建帐户

在 [Oracle 大学网站](https://education.oracle.com/home)创建帐户，然后购买考试券。

在[这个页面]( https://education.oracle.com/java-se-8-programmer-i/pexam_1Z0-808 )可以看到关于 OCA 考试的介绍，关于认证路径的更详细内容在[另一个页面]( https://education.oracle.com/oracle-certified-associate-java-se-8-programmer/trackp_333 )。 这两个页面都包含了可以购买用于 Pearson VUE 考试的考试券。在 Oracle 大学购买考试券可以支持国内银行卡汇款的支付方式，直接在Pearson VUE 注册并付款就只支持国外信用卡和考试券的方式。 我没有Visa / Master 之类的信用卡，所以就用国内银行汇款的方式了，考试券1077元。实际上加上增值税一共花费1142元，发票数据是 1107.36 + 63.64 税。当然没有国外信用卡的也可以找人代付，据网友分享，淘宝代付1131元。 我倾向于银行汇款的方式。

![image-20191029225254769](/img/image-20191029225254769.png)

##### 报名

在 [Pearson VUE](  https://home.pearsonvue.com/  ) 的网站找到 Oracle 的这个 1Z0-808 考试按提示一步步报名就可以了。

##### 考试

我在广州嘉为考试中心考的试，不同考试中心肯定是不同的。在嘉为考试中心，只提供了A4 纸长一点的 Pearson VUE 可擦除手写板，和一支白板笔。那其实就是是一张白纸过塑了，就像集体照那种，不过它正面是白色给写画，背面是一些考生规则介绍。连个擦除白板字迹的白板擦或者一块布或纸巾都没有提供，当时我做题的时候在版上思考写画，直接用手擦除了，不太好擦，因为版本笔质量比较好，笔迹清晰。按规定中途可以要求在更换白板的，不过我嫌浪费时间就用手擦算了。考试的系统，看起来像是基于浏览器系统，考试过程那个屏幕分辨率低，看起来文字显示粗糙，不过这也不意外。有点像考驾照的文明驾驶科目的那种。但是有时候还要反应慢，估计是直连海外Pearson的服务器传输的题目数据，而不是缓存到本地机器的。中间差点以为链接断开了，点下一题的按钮挺久无响应的。有时候突然想起前一题可能做错了，想快速回头检查一下，也会有点卡顿，估计网络延迟比较严重。那个考试系统提供了标记题目的功能，还有鼠标右键划线排除某个选项的功能，最后还可以回顾，检查，这些功能在模拟测试软件都有的。这些功能如果有刷过牛客网，或者做过其他在线笔试的话，可能也不陌生标记题目等功能。觉得还是做题速度和节奏比较重要，如果做得够快，就会有比较多的时间回头检查，double check，但是题目比较多，基本上比较难做得到double check，mark 就很重要了，标记出有疑问的，到最后剩得二三十分钟可以再检查一遍有标记的题目，然后基本就这样的过程了。

##### 获得认证

考试结束后，考试结果会在两小时内收到邮件，就可以查看到成绩报告了，报告包括题目正确率和结果是否通过。然后在48小时后会发放电子证书和数字徽章，电子证书就是一个pdf文件，就是证书的模样，因为推崇环保就默认不方法纸质证书了。 然后电子徽章是基于 open badge标准的，发布于 Pearson 旗下的 Acclaim，数字徽章可以发布到区块链供查询认证，也支持分享到一些社交网络，嵌入到 web 页面。我的数字徽章在[这里](https://www.youracclaim.com/badges/dee74bd5-6ec6-455a-b28b-c125291b7232)

### OCA考试大纲

#### Java Basics 基础

- Define the scope of variables 定义变量的作用范围
- Define the structure of a Java class 定义一个 Java 类的结构
- Create executable Java applications with a main method; run a Java program from the command line; produce console output 创建包含一个 main 方法的可执行 Java 应用程序；从命令行运行一个 Java 程序；产生控制台输出
- Import other Java packages to make them accessible in your code 导入其他 Java 包使其可在你的代码中使用
- Compare and contrast the features and components of Java such as: platform independence, object orientation, encapsulation, etc. 比较和对比 Java 的特性和组件，例如：平台独立性，面向对象，封装等

#### Using Operators and Decision Constructs 使用操作符和条件判断结构

- Use Java operators; use parentheses to override operator precedence 使用操作符；使用括号覆盖操作符优先级
- Test equality between Strings and other objects using `==` and `equals ()` 使用 `==` 和 `equals()` 检查字符串和其他对象之间的相等性
- Create if and if/else and ternary constructs 创建 if 和 if/else 已经三元（条件）结构
- Use a switch statement 使用 switch 语句

#### Using Loop Constructs 使用循环结构

- Create and use `while` loops 创建并使用 while 循环
- Create and use `for` loops including the enhanced for loop 创建并使用 for 循环，包括增强版 for 循环
- Create and use do/while loops 创建并使用do/while 循环
- Compare loop constructs 比较循环结构
- Use `break` and `continue` 使用 break 和 continue

#### Working with Inheritance 使用继承

- Describe inheritance and its benefits 描述继承及其好处
- Develop code that makes use of polymorphism; develop code that overrides methods;  differentiate between the type of a reference and the type of an object 开发应用到了多态的代码；开发重写方法的代码；区分引用的类型和对象的类型
- Determine when casting is necessary 确定何时类型转换时必要的
- Use `super` and `this` to access objects and constructors 使用 super 和 this 访问对象和构造方法
- Use abstract classes and interfaces 使用抽象类和接口

#### Working with Selected classes from the Java API 使用从 Java API 中选择的类

- Manipulate data using the `StringBuilder` class and its methods 使用 StringBuilder 类及其方法去操作数据
- Create and manipulate Strings 创建并操作字符串
- Create and manipulate calendar data using classes from `java.time.LocalDateTime`,  `java.time.LocalDate`, `java.time.LocalTime`,`java.time.format.DateTimeFormatter`, `java.time.Period` 创建并操纵日历数据，使用这些类：`java.time.LocalDateTime`, `java.time.LocalDate`, `java.time.LocalTime`,`java.time.format.DateTimeFormatter`, `java.time.Period`
- Declare and use an `ArrayList` of a given type 声明并使用某个类型的 `ArrayList`
- Write a simple Lambda expression that consumes a Lambda Predicate expression 编写一个简单的 Lambda 表达式，要求一个 Lambda Predicate 表达式

#### Working With Java Data Types 使用 Java 数据类型

- Declare and initialize variables (including casting of primitive data types) 声明并初始化变量（包括原始数据类型的转换）
- Differentiate between object reference variables and primitive variables 区分对象引用变量和原始变量
- Know how to read or write to object fields 知道如何读或写对象字段
- Explain an Object's Lifecycle (creation, "dereference by reassignment" and garbage collection) 解释一个对象的生命周期（创建，“重新赋值解引用” 和垃圾回收）
- Develop code that uses wrapper classes such as `Boolean`, `Double`, and `Integer` 开发使用封装类的代码，例如 Boolean, Double 和 Integer

#### Creating and Using Arrays 创建并使用数组

- Declare, instantiate, initialize and use a one-dimensional array 声明，实例化，初始化以及使用一维数组
- Declare, instantiate, initialize and use multi-dimensional arrays 声明，实例化，初始化以及使用多维数组

#### Working with Methods and Encapsulation 使用方法和封装

- Create methods with arguments and return values; including overloaded methods 创建带参数和返回值的方法
- Apply the `static` keyword to methods and fields 在方法和字段应用 static 关键字
- Create and overload constructors; differentiate between default and user defined constructors 创建并重载构造方法；区分默认和用户定义构造方法
- Apply access modifiers 应用访问修饰符
- Apply encapsulation principles to a class 对类应用封装原则
- Determine the effect upon object references and primitive values when they are passed  into methods that change the values 确定对象引用和原始变量传递到会改变值的方法时的效果 （考察引用传递还是值传递）

#### Handling Exceptions 处理异常

- Differentiate among checked exceptions, unchecked exceptions, and Errors 区分检查异常，非检查异常以及错误
- Create a try-catch block and determine how exceptions alter normal program flow 创建一个 try-catch 语句块并确定异常时如何改变正常的程序控制流的
- Describe the advantages of Exception handling 描述异常处理的优点
- Create and invoke a method that throws an exception 创建并调用一个会抛出异常的方法
- Recognize common exception classes (such as `NullPointerException`, `ArithmeticException`, `ArrayIndexOutOfBoundsException`, `ClassCastException`) 识别常见的异常类（例如 空指针异常，算术异常，数组越界异常，类型转换异常）

#### Assume the following: 默认以下情况：

- **Missing package and import statements:** If sample code do not include package or import statements, and the question does not explicitly refer to these missing statements, then assume that all sample code is in the same package, or import statements exist to support them. 
**缺失的包和导入语句：**如果示例代码没有包含包或导入语句，并且问题没有明示这些缺失的语句，那么认为所有的示例代码是在同一个包，或者存在导入它们的导入语句。

- No file or directory path names for classes:
  类没有文件名或者目录路径名：
   If a question does not state the file names or directory locations of classes, then assume one of the following, whichever will enable the code to compile and run:
   如果问题没有提及到类的文件名或者目录位置，那么假设以下几点，能让代码编译并运行即可：

  - All classes are in one file 所有类是在同一个文件
  - Each class is contained in a separate file, and all files are in one directory
    每个类分别存在与不同的文件，并且所有文件都在同一个目录

- **Unintended line breaks:** Sample code might have unintended line breaks. If you see a line of code that looks like it has wrapped, and this creates a situation where the wrapping is significant (for example, a quoted String literal has wrapped), assume that the wrapping is an extension of the same line, and the line does not contain a hard carriage return that would cause a compilation failure.

  **意外的换行：**示例代码可能由非预期的换行。如果你看到一行代码看起来软换行了，并且它造成了一个情形，换行的影响是重要的（例如，一个双引号括起来的字符串常量换行了），假设那个换行是同一行的延申，且该行不包含导致编译失败的硬回车换行。

- **Code fragments:** A code fragment is a small section of source code that is presented without its context. Assume that all necessary supporting code exists and that the supporting environment fully supports the correct compilation and execution of the code shown and its omitted environment.

  **代码片段：**一个代码片段是不带有上下文出现的一小节代码片段。假设所有必要的支持代码存在并且支持的环境能保证呈现的代码片段及其省略的部分能够正确执行。

- **Descriptive comments:** Take descriptive comments, such as "setter and getters go here," at face value. Assume that correct code exists, compiles, and runs successfully to create the described effect.

  **描述性注释：**将描述性注释，例如“setter 和 getters 在这里” 按字面意思理解。假设正确的代码存在，编译、运行成功产生所描述的效果。
  
  

### 书籍信息

这文章讲OCA准备过程，读过的书籍。 这本书叫 :

> OCA Oracle Certified Associate Java SE 8 Programmer I Study Guide

是针对 Exam 1Z0-808 ，考的内容是 Java 8 版本，属于长期支持版。 还有一个专业级别的 OCP考试： Oracle Certified Professional Java SE 8 Programmer II，那个难度大一点。

**书的目录内容：**

Chapter 1 Java Building Blocks

Chapter 2 Operators and Statements

Chapter 3 Core Java API

Chapter 4 Methods and Encapsulation

Chapter 5 Class Design

Chapter 6 Exceptions

Infoq 有人翻译了一篇介绍这本书的[文章]( https://www.infoq.cn/article/OCP-Java-SE-8-Programmer-Study-Guide-Book-Review )



### 模拟考试软件 (Enthuware)

一个Java写的软件，界面没什么用户体验的，不过这样好，因为实际考试也差不多的体验。

![image-20191029055503022](/img/image-20191029055503022.png)

在软件的欢迎界面看到介绍包含了超过 600 个问题，7个模拟考试，还有关于官方考试的一些细节介绍。其实这就足够应付考试了，实际上这并不是所谓的题库。根本不存在题库，然后买个题库相当于背题考试就完了。这些只是模拟题目，OCA 考试的题目是会不断变化的。

![image-20191029055925453](/img/image-20191029055925453.png)

## 后续

计划今年考完

![image-20191029060400482](/img/image-20191029060400482.png)

接着考 Java SE 8 Programmer 升级到 Java SE 11 Developer

![image-20191029060558042](/img/image-20191029060558042.png)



Java 11 之后，也不分什么OCA OCP了，只有 Java SE 11 Programmer Part 1 & Part 2.



## 附录：出现的生僻英语单词（对我而言）

1. perpetually 常常；永远；没完没了地
2. inquire 询问；打听；调查；〈古〉质问
3. cougar 【动】美洲狮
4. puma 美洲狮
5. gibberish 无稽之谈
6. cram 把…塞进；挤满；塞满；（为应考）临时死记硬背
7. meekly 温顺地
8. portion 把…分成若干份（或部分）
9. dividend 被除数，股息；利息；(破产时清算的)分配金  
10. divisor 除数；除子
11. solely 只；仅；唯；单独地
12. nontrivial 非平凡；不容易的；〔数〕非零的；非无效的
13. endeavor 努力
14. trip 绊倒；将…绊倒；使跌倒；脚步轻快地走（或跑、跳舞） 
15. 还有 trick 为欺骗的；使人产生错觉的；虚弱有毛病的 
16. 还有 cheat 骗子；欺诈行为；欺骗手段；作弊软件
17. stray 走失的宠物（或家畜）；无主的宠物（或家畜）；离群者；零星的；孤立的
18. astray 出正轨的 ；迷路；堕落
19. pathways 同“path”
20. glaring 显眼的；明显的；易见的；刺眼的 “glare”的现在分词
21. methodical 有条理的；有条不紊的；办事有条不紊的 Being methodical pays off.
22. bulge 凸出；鼓胀；充满；塞满  鼓起；凸起；（身体的）肥胖部位；暂时的激增
23. koala 树袋熊；考拉熊；无尾熊
24. hamster 仓鼠（有颊囊可存放食物，常作宠物）
25. floppy 松散下垂的；耷拉的；松软的
26. lenient 仁慈的 宽恕; 宽容; 宽厚,宽仁的; 宽大为怀
27. covariant 【物】协变式的；【统】协变的  【统】协变式；协度
28. fraught 充满（不愉快事物）的；焦虑的；忧虑的；担心的  货物 
29. pitfalls  陷阱；诱惑；圈套；隐藏的危险
30. prepend  add (something) to the beginning of something else. 
31. lemur 狐猴（栖居于马达加斯加岛）
32. primate 灵长类；灵长目动物；大主教；总主教
33. capybara  A mammal native to South America.
34. toddler 学步的儿童；刚学会走路的孩子
35. contrived 预谋的；不自然的；人为的；矫揉造作的
36. porcupine 豪猪；箭猪
37. thwart 阻止；阻挠；对…构成阻力  穿过的；不利的 (横贯小艇的)坐板
38. momentum 动量；势头；动力；推进力
39. self-imposed  (of a task or circumstance) imposed on oneself, not by an external force. 自我加强
40. imposed 使…负担；强派(工)；把(次品等)硬卖给
41. assimilate 吸收；消化；透彻理解；（使）同化
42. jotting   noun. a brief note. "a few jottings on an envelope" 简短的笔记， 随笔
43. allot v. 分配；分派（任务等）give or apportion (something) to someone.
44. sparingly adverb. in a restricted or infrequent manner; in small quantities.












