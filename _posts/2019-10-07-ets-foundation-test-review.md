---
layout:     post
title:      EST 基础测试回顾
date:       '2019-10-07 11:26:02'
subtitle:   整理错题，查漏补缺
author:     招文桃
catalog:    true
tags:
    - Java
    - OCA
---

###  基础测试的情况

当时第一次测试结果报告如下：

![foundation-test](/img/foundation-test.png)

按照考试的主题（或者说考点）来看的话，Java Basics 正确率 6/7。然后，OO Concepts 过关的，Java Data Types 部分就只对了 3 题，有点危险。基础测试没有涉及到垃圾回收的内容，但是真正考试应该会有的，而且现在工作要求也肯定会问，需要了解的。关于操作符和条件判断结构居然也只有对了 6 个题，看起来真的有点 tricky。接下来的数组、循环结构和构造方法这些考点感觉还过得去的样子。 关于方法的使用居然有点不稳，要搞清楚了，可能需要翻译 coderanch 的文章加深一下理解。这次没有设计方法重载的题目，然而关于继承的理解，可能还不够深，要看看编程思想了。instanceof 没有考到，异常处理需要加强。最基本的 String， 以及相关的类要烂熟了，至少 API 文档过一遍。最后 Java 8 新的时间日期 API 还没有了解，这一次就新的旧的都看一遍吧，所以今天是要看完错题，找出对应的知识点，考点，然后读 API 文档。

### 接下来做什么

#### 整理错题

1. Compared to public, protected, and private accessibilities, default accessibility is ... **(Working with Methods)**

   - [ ] Less restrictive than public  肯定错啦，public 最宽了。
   - [ ] More restrictive than public, but less restrictive than protected. 想到 "by default is protect"，默认情况下，就相当于保护了，但是更深一层限制在同一个包里。所以就 `default` < `protected` 所以下一个选项是正确的。
   - [x] More restrictive than protected, but less restrictive than private.
   - [ ] More restrictive than private. 肯定错， private 最窄了。
   - [ ] Less restrictive than protected from within a package, and more restrictive than protected from outside a package. 当时选择了这个选项，因为看起来好像很有道理，而且描述全面。但现在仔细看看，说的是，在同一个包内，访问权限比 `protected` 更受限，这已经错了，同一个包内两个一样的。后面部分就不用看了，当时就没多想，这次知道了，下次就不会错了。

2. What can be the type of a `catch` argument? (Select the best option.) **(Handling Exceptions)**

   - [ ] Any class that extends `java.lang.Exception`
   - [ ] Any class that extends `java.lang.Exception` except any class that extends `java.lang.RuntimeException`
   - [x] Any class that is-a `Throwable`. 这个是正确答案，解释如下

   > The catch argument type declares the type of exception that the handler can handle and must be the name of a class that extends `Throwable` or `Throwable` itself.

   - [ ] Any Object
   - [ ] Any class that extends `Error`

3. 记录一个关于重写的： An overriding method must have a same parameter list and the same return type as that of the overridden method. 翻译成中文就是，重写方法必须与被重写方法具有相同的参数列表和返回类型。

   - [ ] True
   - [x] False 我答对了，不过好像没有理解正确。 解释是这样说的：

   > This would have been true prior to Java 1.5. But from Java 1.5, an overriding method is allowed to change the return type to any subclass of the original return type, also known as covariant return type. This does not apply to primitives, in which case, the return type of the overriding method must match exactly to the return type of the overridden method.
   >
   > 所以主要看返回值类型，重写必须参数列表相同才算重写，不然就是重载了。而在 Java 1.5 之前，重写方法的返回值必须与被重写方法返回值一致。不过从 Java 1.5 开始，重写方法的返回值类型可以是被重写方法返回值的任意子类，也称为 covariant return type（好像中文译为“协变返回类型”）

#### 读 API 文档

##### String

##### StringBuilder

##### StringBuffer

