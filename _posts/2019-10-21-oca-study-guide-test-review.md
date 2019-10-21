---
typora-root-url: ../
layout:     post
title:      OCA Study Guide 练习回顾
date:       '2019-10-21'
subtitle:   包括全部章节的习题
author:     招文桃
catalog:    true
tags:
    - Java
    - oca
---

这文章讲OCA准备过程，读过的书籍。 这本书叫 OCA Oracle Certified Associate Java SE 8 Programmer I Study 

以下按章节整理错题：

#### Chapter 1 Java Building Blocks (2/23😊)

**18.**Which represent the order in which the following statements can be assembled into a program that will compile successfully? (Choose all that apply)
`A: class Rabbit {}`  
`B: import java.util.*;`  
`C: package animals;`  

> **A.** A, B, C  
> **B.** B, C, A  
> **C.** C, B, A  
> **D.** B, A  
> **E.** C, A  
> **F.** A, C  
> **G.** A, B  

**22.**Which of the following are true statements? (Choose all that apply)

> **A.** Java allows operator overloading.  
> **B.** Java code compiled on Windows can run on Linux.  
> **C.** Java has pointers to specific locations in memory.  
> **D.** Java is a procedural language.  
> **E.** Java is an object-oriented language.  
> **F.** Java is a functional programming language.  

#### Chapter 2 Operators and Statements (3/20😄)

**9.**How many times will the following code print "Hello World"?

```java
3: for(int i=0; i<10 ; ) {
4: i = i++;
5: System.out.println("Hello World");
6: }
```

> **A.** 9  
> **B.** 10  
> **C.** 11  
> **D.** The code will not compile because of line 3.  
> **E.** The code will not compile because of line 5.  
> **F.** The code contains an infinite loop and does not terminate.  

**16.**What is the output of the following code snippet?

```java
3: do {
4: int y = 1;
5: System.out.print(y++ + " ");
6: } while(y <= 10);
```

> **A.** 1 2 3 4 5 6 7 8 9  
> **B.** 1 2 3 4 5 6 7 8 9 10  
> **C.** 1 2 3 4 5 6 7 8 9 10 11  
> **D.** The code will not compile because of line 6.  
> **E.** The code contains an infinite loop and does not terminate.  

**17.**What is the output of the following code snippet?

```java
3: boolean keepGoing = true;
4: int result = 15, i = 10;
5: do {
6: i--;
7: if(i==8) keepGoing = false;
8: result -= 2;
9: } while(keepGoing);
10: System.out.println(result);
```

> **A.** 7  
> **B.** 9  
> **C.** 10  
> **D.** 11  
> **E.** 15  
> **F.** The code will not compile because of line 8.  

#### Chapter 3 Core Java APIs (14/33😂)



#### Chapter 4 Methods and Encapsulation (14/29😂)

#### Chapter 5 Class Design (12/20😭)

#### Chapter 6 Exceptions (10/20😭)












