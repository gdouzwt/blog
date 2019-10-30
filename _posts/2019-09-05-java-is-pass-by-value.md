---
layout:     post
title:      Java是值传递
subtitle:   搞清楚Java是值传递还是引用传递
date:       2019-09-05
author:     招文桃
header-img: img/java-pass-by-value-not-reference.jpg
catalog: true
tags:
    - Java
---

# Java是值传递

在一本Java面试参考书里面看到一个题目，有如下代码：
```java
public class Test {

    private void change(String str, char[] ch) {
        str = "test ok";
        ch[0] = 'g';
    }
    public static void main(String[] args) {
        String str = new String("good");
        char[] ch = {'a', 'b', 'c'};
        Test ex = new Test();
        ex.change(str, ch);
        System.out.print(str + " and ");
        System.out.print(ch);
    }
}
```
问上面程序运行的结果是（）  
A. good and abc  
B. good and gbc  
C. test ok and abc  
D. test ok and gbc  
> 答案是 **B**

这个题目主要考察Java语言中传参方式以及不可变类的知识。  
基本上对于`String`类是不可变的(Immutable)没有什么疑问，但关于Java的传参方式究竟是值传递还是引用传递的认识还不够清晰，所以在下文就要搞清楚这个知识点。
其实Java都是值传递的，没有什么好说了，引用类型，只不过是传递了引用变量(reference variable)的值而已，说到底还是值传递，不存在引用传递的说法。这文章到这里可以结束了。
