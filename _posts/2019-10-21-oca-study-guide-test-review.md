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

> 这文章讲OCA准备过程，读过的书籍。 这本书叫 OCA Oracle Certified Associate Java SE 8 Programmer I Study Guide 以下按章节整理错题：  

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
3:  boolean keepGoing = true;
4:  int result = 15, i = 10;
5:  do {
6:  i--;
7:  if(i==8) keepGoing = false;
8:  result -= 2;
9:  } while(keepGoing);
10: System.out.println(result);
```

> **A.** 7  
> **B.** 9  
> **C.** 10  
> **D.** 11  
> **E.** 15  
> **F.** The code will not compile because of line 8.  

#### Chapter 3 Core Java APIs (13/33😂)

**4.**What is the result of the following code?  

```java
7: StringBuilder sb = new StringBuilder();
8: sb.append("aaa").insert(1, "bb").insert(4, "ccc");
9: System.out.println(sb);
```

> **A.** abbaaccc  
> **B.** abbaccca  
> **C.** bbaaaccc  
> **D.** bbaaccca  
> **E.** An exception is thrown.  
> **F.** The code does not compile.  

**5.**What is the result of the following code?  

```java
2: String s1 = "java";
3: StringBuilder s2 = new StringBuilder("java");
4: if (s1 == s2)
5: System.out.print("1");
6: if (s1.equals(s2))
7: System.out.print("2");
```

> **A.** 1  
> **B.** 2  
> **C.** 12  
> **D.** No output is printed.  
> **E.** An exception is thrown.  
> **F.** The code does not compile.  

**15.**Which of these array declarations is not legal? (Choose all that apply)  

> **A.** `int[][] scores = new int[5][];`  
> **B.** `Object[][][] cubbies = new Object[3][0][5];`  
> **C.** `String beans[] = new beans[6];`  
> **D.** `java.util.Date[] dates[] = new java.util.Date[2][];`  
> **E.** `int[][] types = new int[];`  
> **F.** `int[][] java = new int[][];`  

**16.**Which of these compile when replacing line 8? (Choose all that apply)  

```java
7: char[]c = new char[2];
8: // INSERT CODE HERE
```

> **A.** `int length = c.capacity;`  
> **B.** `int length = c.capacity();`  
> **C.** `int length = c.length;`  
> **D.** `int length = c.length();`  
> **E.** `int length = c.size;`  
> **F.** `int length = c.size();`  
> **G.** None of the above.  

**17.**Which of these compile when replacing line 8? (Choose all that apply)  

```java
7: ArrayList l = new ArrayList();
8: // INSERT CODE HERE
```

> **A.** `int length = l.capacity;`  
> **B.** `int length = l.capacity();`  
> **C.** `int length = l.length;`  
> **D.** `int length = l.length();`  
> **E.** `int length = l.size;`  
> **F.** `int length = l.size();`  
> **G.** None of the above.  

**18.**Which of the following are true? (Choose all that apply)  

> **A.** An array has a fixed size.  
> **B.** An `ArrayList` has a fixed size.  
> **C.** An array allows multiple dimensions.  
> **D.** An array is ordered.  
> **E.** An `ArrayList` is ordered.  
> **F.** An array is immutable.  
> **G.** An `ArrayList` is immutable.  

**19.**Which of the following are true? (Choose all that apply)  

> **A.** Two arrays with the same content are equal.  
> **B.** Two ArrayLists with the same content are equal.  
> **C.** If you call `remove(0)` using an empty `ArrayList` object, it will compile successfully.  
> **D.** If you call `remove(0)` using an empty `ArrayList` object, it will run successfully.  
> **E.** None of the above.  

**20.**What is the result of the following statements?  

```java
6:  List<String> list = new ArrayList<String>();
7:  list.add("one");
8:  list.add("two");
9:  list.add(7);
10: for(String s : list) System.out.print(s);
```

> **A.** onetwo  
> **B.** onetwo7  
> **C.** onetwo followed by an exception  
> **D.** Compiler error on line 9.  
> **E.** Compiler error on line 10.  

**24.**What is the result of the following?  

```java
6: String [] names = {"Tom", "Dick", "Harry"};
7: List<String> list = names.asList();
8: list.set(0, "Sue");
9: System.out.println(names[0]);
```

> **A.** Sue  
> **B.** Tom  
> **C.** Compiler error on line 7.  
> **D.** Compiler error on line 8.  
> **E.** An exception is thrown.  

**25.**What is the result of the following?  
```java
List<String> hex = Arrays.asList("30", "8", "3A", "FF");
Collections.sort(hex);
int x = Collections.binarySearch(hex, "8");
int y = Collections.binarySearch(hex, "3A");
int z = Collections.binarySearch(hex, "4F");
System.out.println(x + " " + y + " " + z);
```

> **A.** 0 1 –2  
> **B.** 0 1 –3  
> **C.** 2 1 –2  
> **D.** 2 1 –3  
> **E.** None of the above.  
> **F.** The code doesn’t compile.  

**26.**Which of the following are true statements about the following code? (Choose all that apply)  

```java
4: List<Integer> ages = new ArrayList<>();
5: ages.add(Integer.parseInt("5"));
6: ages.add(Integer.valueOf("6"));
7: ages.add(7);
8: ages.add(null);
9: for (int age : ages) System.out.print(age);
```

> **A.** The code compiles.  
> **B.** The code throws a runtime exception.  
> **C.** Exactly one of the add statements uses autoboxing.  
> **D.** Exactly two of the add statements use autoboxing.  
> **E.** Exactly three of the add statements use autoboxing.  

**29.**Which of the following can be inserted into the blank to create a date of June 21, 2014? (Choose all that apply)  

```java
import java.time.*;
public class StartOfSummer {
    public static void main(String[] args) {
    LocalDate date = _________
    }
}
```

> **A.** `new LocalDate(2014, 5, 21);`  
> **B.** `new LocalDate(2014, 6, 21);`  
> **C.** `LocalDate.of(2014, 5, 21);`  
> **D.** `LocalDate.of(2014, 6, 21);`  
> **E.** `LocalDate.of(2014, Calendar.JUNE, 21);`  
> **F.** `LocalDate.of(2014, Month.JUNE, 21);`  

**30.**What is the output of the following code?  

```java
LocalDate date = LocalDate.of(2018, Month.APRIL, 40);
System.out.println(date.getYear() + " " + date.getMonth() + " "
+ date.getDayOfMonth());
```

> **A.** 2018 APRIL 4  
> **B.** 2018 APRIL 30  
> **C.** 2018 MAY 10  
> **D.** Another date.  
> **E.** The code does not compile.  
> **F.** A runtime exception is thrown.  

#### Chapter 4 Methods and Encapsulation (14/29😂)

**2.**
**5.**
**6.**
**9.**
**11.**
**12.**
**15.**
**17.**
**18.**
**20.**
**22.**
**26.**
**27.**
**29.**


#### Chapter 5 Class Design (12/20😭)

**1.**
**2.**
**3.**
**4.**
**5.**
**8.**
**10.**
**11.**
**16.**
**18.**
**19.**
**20.**

#### Chapter 6 Exceptions (12/20😭)

**1.**
**2.**
**5.**
**7.**
**13.**
**14.**
**15.**
**16.**
**17.**
**18.**
**19.**
**20.**

