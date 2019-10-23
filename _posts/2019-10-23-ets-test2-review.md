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