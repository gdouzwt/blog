---
typora-root-url: ../
layout:     post
title:      Java笔试题1
date:       '2020-05-10T20:02'
subtitle:   
keywords:   Java Interview, Test
author:     招文桃
catalog:    true
tags:
    - Java 笔试
---


### 真题1 某知名互联网下载服务提供商软件工程师笔试题  

**一、选择题**  
**1.** 访问修饰符作用范围由大到小是（ ）。
  > A.private-protected-default-public  
  > B.public-protected-default-private  
  > C.private-default-protected-public  
  > D.public-default-protected-private  

这题没什么好说，当然是选择 **B** 啦，初学的时候可能有点难记住，不过习惯了就记住了。后来越了解就更容易记住，根本不需要死记硬背。 `default` 关键字，表示访问权限的时候，其实新的规范（8以上？）改称为 'package private' 可以理解为包内私有访问权限，所以限制程度就是仅次于私有。接着protected和public容易，因为public肯定是范围最宽（大）的。  
关于类的访问修饰符的作用范围，Java语言规范的 8.1.1 节有：  
The access modifier `public` pertains only to top level classes and member classes, not to local classes or anonymous classes.  
The access modifier `protected` and `private` pertain only to member classes within a directly enclosing class declaration.<!--more-->  

**2.** 在Java 语言中，下面接口以键−值对的方式存储对象的是（ ）。
  > A.java.util.List  
  > B.java.util.Map  
  > C.java.util.Collection  
  > D.java.util.Set  

选 **B** 这题也很直接。

**3.** 以下不是Object 类的方法的是（ ）。
  > A.hashCode()  
  > B.finalize()  
  > C.notify()  
  > D.hasNext()  

选 **D**

**4.** 有如下代码：  

```java
public class Test {
    public void change(String str, char ch[]) {
        str = "test ok";
        ch[0] = 'g';
    }
    public static void main(String args[]) {
      String str = new String("good");
      char[] ch = { 'a', 'b', 'c' };
      Test ex = new Test();
      ex.change(str, ch);
      System.out.print(str + " and ");
      System.out.print(ch);
    }
}
```

上面程序的运行结果是（ ）。  
  > A.good and abc  
  > B.good and gbc  
  > C.test ok and abc  
  > D.test ok and gbc  

选 **B** 在 Java 语言中，除了8 种原始的数据类型（分别为 `byte`、`short`、`int`、`long`、`float`、`double`、`char` 和 `boolean`）外，其他的类型都是对象，在方法调用的时候，传递的都是引用。引用从本质上来讲也是按值传递，只不过传递的这个值是对象的引用而已，因此，在方法调用的时候，对形参引用所指对象属性值的修改对实参可见。但是对引用值本身的修改对实参是不可见的。  

**二、填空题**  
**1.** `Math.round(12.5)` 的返回值等于（ **13** ），`Math.round(-12.5)` 的返回值等于（ **-12** ）。  
  > `round` 是一个四舍五入的方法，12.5 的小数部分为 0.5，当对其执行 `Math.round()` 操作时，结果需要四舍五入，所以，结果为 13；−12.5 的小数部分也为 0.5，当对
其执行 `Math.round()` 操作时，结果也需要四舍五入，由于 −12 > −13，因此，结果为 −12。  

**2.** 有如下程序：  

```java
String str1 = "hello world";
String str2 = "hello" + new String("world");
System.out.println(str1 == str2);
```

那么程序的运行结果是（ **false** ）。  

**3.** 在Java 语言中，基本数据类型包括（ 浮点型 float、double ）、字符类型（ char ）、布尔类型 boolean 和 数值类型（byte、short、int、long ）。  
**4.** 字符串分为两大类：一类是字符串常量（ String ）；另一类是字符串变量（ StringBuffer ）。  

**三、简答题**  
**1.** 接口和抽象类有什么区别？  
**2.** 实现多线程的方法有哪几种？  
**3.** 利用递归方法求6!  
**4.** 用Java 语言实现一个观察者模式。  
**5.** 一个有10 亿条记录的文本文件，已按照关键字排好序存储，请设计一个算法，可以从文件中快速查找指定关键字的记录。  
