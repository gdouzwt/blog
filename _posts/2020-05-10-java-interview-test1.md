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

答案：接口（interface）和抽象类（abstract class）是支持抽象类定义的两种机制（注意，该句中前后两个抽象类的意义不一样，前者表示的是一个实体，后者表示的是一个概念）。  
两者具有很大的相似性，甚至有时候是可以互换的。但同时，两者也存在很大的区别。具体而言，接口是公开的，里面不能有私有的方法或变量，是用于让别人使用的，而抽象类是可以有私有方法或私有变量的，如果一个类中包含抽象方法，那么这个类就是抽象类。在Java 语言中，可以通过把类或者类中的某些方法声明为abstract（abstract 只能用来修饰类或者方法，不能用来修饰属性）来表示一个类是抽象类。接口就是指一个方法的集合，接口中的所有方法都没有方法体，在Java 语言中，接口是通过关键字interface 来实现的。包含一个或多个抽象方法的类就必须被声明为抽象类，抽象类可以声明方法的存在而不去实现它，被声明为抽象的方法不能包含方法体。在抽象类的子类中，实现方法必须含有相同的或者更低的访问级别（public->protected->private）。抽象类在使用的过程中不能被实例化，但是可以创建一个对象使其指向具体子类的一个实例。抽象类的子类为父类中所有的抽象方法提供具体的实现，否则，它们也是抽象类。接口可以被看作是抽象类的变体，接口中所有的方法都是抽象的，可以通过接口来间接地实现多重继承。接口中的成员变量都是static final
类型，由于抽象类可以包含部分方法的实现，所以，在一些场合下抽象类比接口存在更多的优势。接口与抽象类的相同点如下：  
1）都不能被实例化。  
2）接口的实现类或抽象类的子类都只有实现了接口或抽象类中的方法后才能被实例化。  
接口与抽象类的不同点如下：  
1）接口只有定义，不能有方法的实现，而抽象类可以有定义与实现，即其方法可以在抽象类中被实现。  
2）实现接口的关键字为implements，继承抽象类的关键字为extends。一个类可以实现多个接口，但一个类只能继承一个抽象类，因此，使用接口可以间接地达到多重继承的目的。  
3）接口强调特定功能的实现，其设计理念是“has-a”关系，而抽象类强调所属关系，其设计理念为“is-a”关系。  
4）接口中定义的成员变量默认为public static final，只能够有静态的不能被修改的数据成员，而且，必须给其赋初值，其所有的成员方法都是public、abstract 的，而且只能被这两个关键字修饰。而抽象类可以有自己的数据成员变量，也可以有非抽象的成员方法，而且，抽象类中的成员变量默认为default，当然也可以被定义为private、protected 和public，这些成员变量可以在子类中被重新定义，也可以被重新赋值，抽象类中的抽象方法（其前有abstract修饰）不能用private、static、synchronized 和native 等访问修饰符修饰，同时方法必须以分号结尾，并且不带花括号{}。所以，当功能需要累积时，使用抽象类；不需要累积时，使用接口。  
5）接口被运用于实现比较常用的功能，便于日后维护或者添加删除方法，而抽象类更倾向于充当公共类的角色，不适用于日后重新对里面的代码进行修改。  

**2.** 实现多线程的方法有哪几种？  

答案：Java 虚拟机（Java Virtual Machine，JVM，是运行所有Java 程序的抽象计算机，是Java 语言的运行环境）允许应用程序并发地运行多个线程。在Java 语言中，多线程的实现一般有以下三种方法：  
1）实现Runnable 接口，并实现该接口的run()方法。  
以下是主要步骤：
① 自定义类并实现Runnable 接口，实现run()方法。  
② 创建Thread 对象，用实现Runnable 接口的对象作为参数实例化该Thread 对象。  
③ 调用Thread 的start()方法。  

**3.** 利用递归方法求6!  
**4.** 用Java 语言实现一个观察者模式。  
答案：观察者模式（也被称为发布/订阅模式）提供了避免组件之间紧密耦合的另一种方法，它将观察者和被观察的对象分离开。在该模式中，一个对象通过添加一个方法（该方法允许另一个对象，即观察者注册自己）使本身变得可观察。当可观察的对象更改时，它会将消息发送到已注册的观察者。这些观察者收到消息后所执行的操作与可观察的对象无关，这种模式使得对象可以相互对话，而不必了解原因。Java 语言与C#语言的事件处理机制就是采用的此种设计模式。例如，用户界面（同一个数据可以有多种不同的显示方式）可以作为观察者，业务数据是被观察者，当数据有变化后会通知界面，界面收到通知后，会根据自己的显示方式修改界面的显示。面向对象设计的一个原则是：系统中的每个类将重点放在某一个功能上，而不是其他方面。一个对象只做一件事情，并且将它做好。观察者模式在模块之间划定了清晰的界限，提高了应用程序的可维护性和重用性。设计类图如图1 所示。【准备放图】下面给出一个观察者模式的示例代码，代码的主要功能是实现天气预报，同样的温度信息可以有多种不同的展示方式：  

**5.** 一个有10 亿条记录的文本文件，已按照关键字排好序存储，请设计一个算法，可以从文件中快速查找指定关键字的记录。  
