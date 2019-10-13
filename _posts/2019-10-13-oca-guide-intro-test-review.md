---
typora-root-url: ../
layout:     post
title:      OCA 自测回顾
date:       '2019-10-13'
subtitle:   Assessment Test
author:     招文桃
catalog:    true
tags:
    - Java
    - OCA
---

## OCA 自测题回顾

3. What is the output of the following code? (Choose all that apply)

   ```java
   interface HasTail { int getTailLength(); }
   abstract class Puma implements HasTail {
       protected int getTailLength() {return 4;}
   }
   public class Cougar extends Puma {
       public static void main(String[] args) {
           Puma puma = new Puma();
           System.out.println(puma.getTailLength());
    }
       
       public int getTailLength(int length) {return 2;}
   }
   ```
   
   **A.** 2
   
   **B.** 4
   
   **C.** The code will not compile because of line 3.
   
   **D.** The code will not compile because of line 5.
   
   **E.** The code will not compile because of line 7.
   
   **F.** The output cannot be determined from the code provided.
   
   > 答案是： C, D, E. 
   
   **C**, **D**, **E**. First, the method `getTailLength()` in the interface `HasTail` is assumed to be
   `public`, since it is part of an interface. The implementation of the method on line 3 is
   therefore an invalid override, as `protected` is a more restrictive access modifier than
   `public`, so option **C** is correct. Next, the class `Cougar` implements an overloaded version
   of `getTailLength()`, but since the declaration in the parent class `Puma` is invalid,
   it needs to implement a `public` version of the method. Since it does not, the declaration
   of `Cougar` is invalid, so option **D** is correct. Option **E** is correct, since `Puma` is marked
   `abstract` and cannot be instantiated. The overloaded method on line 11 is declared
   correctly, so option **F** is not correct. Finally, as the code has multiple compiler errors,
   options **A**, **B**, and **G** can be eliminated. 

