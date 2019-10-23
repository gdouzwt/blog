---
typora-root-url: ../
layout:     post
title:      ETS Test 2 回顾
date:       '2019-10-23'
subtitle:   Test 2 76% (53/70) 正确率通过
author:     招文桃
catalog:    true
tags:
    - Java
    - oca
---

> Enthuware Test Studio Test 2 错题回顾：  
> 题目编号为测试系统的编号。  


**8.**What will be the result of trying to compile and execute the following program?
```java
public class TestClass{
   public static void main(String args[] ){
      int i = 0 ;
      int[] iA = {10, 20} ;
      iA[i] = i = 30 ;
      System.out.println(""+ iA[ 0 ] + " " + iA[ 1 ] + "  "+i) ;
    }
}
```  
> - [ ] It will throw `ArrayIndexOutOfBoundsException` at Runtime  
> - [ ] Compile time Error.  
> - [ ] It will print 10 20 30  
> - [x] It will print 30 20 30  

💭**Explanation**  
The statement `iA[i] = i = 30;` will be processed as follows:  
`iA[i] = i = 30;` 👉 `iA[0] = i = 30;`  👉  `i = 30; iA[0] = i ;` 👉  `iA[0] = 30;`  

Here is what JLS says on this:  
**1** Evaluate Left-Hand Operand First  
**2** Evaluate Operands before Operation  
**3** Evaluation Respects Parentheses and Precedence  
**4** Argument Lists are Evaluated Left-to-Right  

For Arrays: First, the dimension expressions are evaluated, left-to-right. If any of the expression evaluations completes abruptly, the expressions to the right of it are not evaluated.  

---  

**11.**Consider the following class :  
```java
public class Test{
   public static void main(String[] args){
      if (args[0].equals("open"))
         if (args[1].equals("someone"))
            System.out.println("Hello!");
      else System.out.println("Go away "+ args[1]);
    }
}
```  
Which of the following statements are true if the above program is run with the command line :  
`java Test closed`  
> - [ ] It will throw `ArrayIndexOutOfBoundsException` at runtime.  
> - [x] It will end without exceptions and will print nothing.  
> - [ ] It will print `Go away`  
> - [ ] It will print `Go away` and then will throw `ArrayIndexOutOfBoundsException`.  
> - [ ] None of the above.  

💭**Explanation**  
As in C and C++, the Java `if` statement suffers from the so-called "dangling `else` problem," The problem is that both the outer `if` statement and the inner `if` statement might conceivably own the `else` clause. In this example, one might be tempted to assume that the programmer intended the `else` clause to belong to the outer `if` statement.  

The Java language, like C and C++ and many languages before them, arbitrarily decree that an `else` clause belongs to the innermost `if` so as the first `if()` condition fails (`args[0]` not being "open") there is no `else` associated to execute. So, the program does nothing. The else actually is associated with the second `if`. So had the command line been :  
java Test open, it would have executed the second `if` and thrown `ArrayIndexOutOfBoundsException`.  
If the command line had been: java Test open xyz, it would execute the else part(which is associated with the second `if`) and would have printed "Go away xyz".

---  

