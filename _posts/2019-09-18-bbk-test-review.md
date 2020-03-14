---
layout:     post
title:      一次笔试总结
subtitle:   多总结经验教训
date:       2019-09-18
author:     招文桃
header-img: img/post-bg-desk.jpg
catalog: true
tags:
    - 笔试面试
---

Java核心技术，说到底基础还不够硬。今天又没有睡觉，状态太差了，那个时候赶着去坐车不能静心做题，这是个教训了，不可以这样的状态下去做笔试题。

到目前为止，参加了4次在线笔试吧，第一次是TCL，很简单，第二次是步步高很多实战类型，第三次是亚信科技，中等上难度，内容全面，居然还考jsp，第四次是CVTE，这个选择题中等难，最后两道编程题，一道关于系统设计的题。<!--more-->

得要做个思维导图啊，而且应该是自己的总结，而不是那别人的总结。现在先回顾考过的题目，分类总结一下。

### 题型方面

- 单项选择
- 不定项选择
- 编程题
- 简单题/系统设计题

### Java Core 基础考点

- 访问控制符 - 基础中的基础， `public`, `protected`,`private`的作用范围。

- 操作符 - 位运算， 按位取反。

- 基本语法- 关键词声明的顺序，`package`,`import`,`class`。

- Java基本数据类型 - 8种，`int`,  `short`, `long`, `float`, `double`, `char`, `boolean`, `byte`。

- 异常处理 - `throw`, `throws`, `try`, `catch`基本用法，还有涉及控制流的变化，看代码选结果。

- 表达式，基本数据类型声明变量以及初始化赋值，注意`float` 和 `double`之类的。

- 面向对象特性，继承，以及带上`static`关键字的代码块怎样理解？看代码选运行结果。

- while循环和do-while循环的区别。

- 关于异常体系，运行时异常的类型，要记住。

- `final` 关键字的作用，用途说法。

- `String` 类的基本API， 字符串基本操作，应该要熟到烂。

- 关于继承和 `static` 关键字，静态代码块访问非静态方法之类的，这些也要很清楚，看题要很快就能够判断出来，选择题要快、准才可以。

- 关于类，`new` 关键字一些奇怪用法，还有字符串连接，String对于+操作符重载。

- 关于数组的基本语法，操作，有时候还考查一些奇葩的语法，读代码选择结果。例如以下一段代码：

  ``` java
  class Announce {
    public static void main(String[] args) {
        for (int __x = 0; __x < 3; __x++) ;
        int b$ = 7;
        long[] x;
        Boolean[] ba[];
    }
}
  ```
  
  其实编译没有问题，不过那个`Boolean[] ba[]`语句使用了混合C风格与Java风格的数组声明，其实相当于`Boolean[][] ba`， 然后重点是理解数组是一种引用类型，`Boolean`也是引用类型。如果初始化，初值是什么呢？ 引用类型初始化默认为`null` 引用， 而初始化如果指明数组长度为0，即像这样：`Boolean[][] ba = new Boolean[0][0];` 则是空数组，打印输出是`[]`，什么都没有，如果多维数组，第一维长度是0，那么后面的维数初始化填什么数字也没影响，根本没有内容在里面（一维都空了，自然不会有引用到其他层次的数组了。）
  
- 考察基础语法关于继承与类型转换的情况，主要有没有发生`ClassCastException`， 读代码选结果。主要考察`is-a` 关系，和`narrowing cast` & `widening cast` 的区别。

- 然后是`java.io` 里面的内容，文件操作， 文件输入输出流， `IOException` 等内容。下面一题考察到创建文件和往文件写入内容的模式。应该要非常熟悉文件操作API。

```java
import java.io.FileOutputStream;
import java.io.IOException;

public class Test {
    public static void main(String[] args) {
        try {
            String s = "ABCDE";
            byte b[] = s.getBytes();
            FileOutputStream file = new FileOutputStream("test.txt", true);
            file.write(b);
            file.close();
        } catch (IOException e) {
            System.out.println(e.toString());
        }
    }
}
```

> 问，假设程序当前目录下不存在文件test.txt，编译后，运行该程序3次，则文件test.txt的内容是（）
>
> A. 编译时将产生错误
>
> B. 运行时发生异常
>
> C. ABCDE
>
> D. ABCDEABCDEABCDE

答案是 D, 因为`FileOutputStream("test.txt", true)` 第一个参数是name: 文件名，第二个参数是append: 是否追加内容。所以上面程序第一次运行创建文件并写入字符串，接下来两次运行都是文件已存在，在末尾追加字符串，运行3次结果就是`ABCDEABCDEABCDE` 了。

- 考察长度为0的数组与`null` 的区别，以及不常见的new 对象语法，递归调用的时候参数压栈和出栈顺序。这些有时候可以通过IDE的调试功能加深对运行过程的理解，应该熟练掌握常用的调试方法。看以下代码：
```java
public class Test {
    public static void main(String[] args) {
        if (args == null || new Test() {
            {
                Test.main(null);
            }
        }.equals(null)) {
            System.out.println("A");
        } else {
            System.out.println("B");
        }
    }
}
```

> 输出：
>
> A
>
> B

在命令行不加参数运行上面的程序，那么`args` 字符串数组应该是`{}` ，而不是 `null` ，这就是要主要区分的长度为0的数组（或集合）与 `null` 的区别。 上面代码还涉及到 `||` 的短路求值， 第一个条件如果满足了， 就不再对第二个条件的表达式求值了。 刚开始`args == null` 不成立， 所以接着执行 `new Test() ...` 那部分，这部分代码创建一个 Test 对象， 并以 `null` 为参数调用main方法， 这时候应该创建子线程了…… 嗯，发觉关于线程的知识还掌握得不够，甚至说关于操作系统的也有点忘记了，也好，至少现在知道了，查漏补缺！ 第二次调用main方法的时候再到 `if` 语句判断那里，第一个条件就成立了，所以略过了第二个条件，打印 "A"，语句执行完之后返回到上一层 `if` 语句结果为 `false` 的情形， 所以打印 "B"。

- 关于集合框架(Collections framework)的常识性问题，例如：
哪个类不是继承自Collection接口的是（）
> A. ArrayList
> B. Set
> C. Vector
> D. Map

选D，这种题最好就看看集合框架继承关系图，平时多用就差不多了，一定要记清楚的。

![img](https://uploadfiles.nowcoder.com/images/20180227/3472441_1519736375385_5643D19A23970891816A811891CE6DE0)

- 关于 `String`,  `StringBuffer`,` StringBuilder` 基本是必考的内容，所以不能错。



竟然又有机会继续红牛加三明治的组合了。通宵啊，为了准备明天的笔试，总不能白白浪费了机会，时间也不能浪费！ 搞！搞到尽！

一个关于 `StringBuffer` 的题目，如下。

以下代码执行结果为（）

```java
public class TestRef {
    
    public static void main(String[] args) {
        StringBuffer a = new StringBuffer("a");
        StringBuffer b = new StringBuffer("b");
        append(a, b);
        System.out.println(a.toString()+","+b.toString());
        a = b;
        append(b, a);
        System.out.println(a.toString()+","+b.toString());
    }
    
    public static void append(StringBuffer a, StringBuffer b) {
        a.append(b);
        b = a;
    }
}
```

> A. a,b b,b
>
> B. a,b bb,b
>
> C. ab,b bb,b
>
> D. ab,b bb,bb

答案是C（上面选项没有换行，实际运行会换行）

解释：

### String Handling(字符串处理)

`String`, `StringBuffer`, `StringBuilder` 这3个都是`final` 修饰的，所以不能被继承。 而且它们都实现了 `CharSequence` 接口。 

`String` 的几个构造方法：

- `String s = new String();  // 会创建空的字符串，是没有字符，不是空格`

- `String(char chars[]) // 由字符数组构建字符串`

  ```java
  char chars[] = {'a', 'b', 'c'};
  String s = new String(chars);
  ```

- `String(char chars[], int startIndex, int numChars)`

- `String(String strObj)` 这里`strObj` 是一个 `String` 对象。

- `String(byte chrs[])`

- `String(byte chrs[], int startIndex, int numChars)` 字节数组转化为字符串，编码格式使用平台默认的。 Java 的`char`是16位的 Unicode， 但是网络上经常使用 8 位的 ASCII， 所以有时候需要转换一下。看下面一个例子：

```java
// Construct string from subset of char array.
class SubStringCons {
    public static void main(String[] args) {
            byte ascii[] = {65, 66, 67, 68, 69, 70};
        	
        	String s1 = new String(ascii);
        	System.out.println(s1);
        
        	String s2 = new String(ascii, 2, 3);
    		System.out.println(s2);
    }
}
```

> ABCDEF
>
> CDE

**注意** 由数组创建的字符串在创建时候复制了值，之后再修改数组的内容对创建的字符串没有影响。

- `String(StringBuffer strBufObj) // 由StringBuffer创建字符串`
- `String(StringBuilder strBuildObj) // 由StringBuilder创建字符串`

String Literals 是可以作`String` 对象直接调用方法的， 如 `"abc".length();`

- 关于对象成员占用内存的说法哪个正确？

  > A. 同一个类的对象共用一段内存
  >
  > B. 同一个类的对象是用不同的内存段，但静态成员共享相同的内存空间
  >
  > C. 对象的方法不占用内存
  >
  > D. 以上都不对

  这个题，我还未搞清楚。

- 简答题 有n盏灯，编号为1到N。第1个人把所有灯打开，第2个人按下所有编号为2的倍数的开关（按下开关打开的灯被关闭），第3个人按下所有编号为3的倍数的开关（按下开关开着的灯被关闭，关闭的灯被开启），以此类推。一共有k个人，问最后有哪些灯开着？

这个题目遇到过两次了，TCL，绿米联创！ 如果当时解决了，那就好办了。

TCL最后一道题，说是简答题，也有点点编程题的意味。考察冒泡排序算法的优化情形。

- 在数据结构与算法设计中冒泡算法是最简单也是经典算法之一，请你把冒泡算法思想写出来（可以用伪代码，图，例子等你认为最能表达清楚的方式。）下面有一串不重复整数date=[16,10,2,3,4,5,6,7,8,9,11,12,13,14,15,1], 请你针对这一串整数在冒泡算法整体思路不变情况下优化算法并实现。