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

1. What is the output of the following code? (Choose all that apply) 
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
   > **A.** 2 
   >
   > **B.** 4 
   >
   > **C.** The code will not compile because of line 3. 
   >
   > **D.** The code will not compile because of line 5. 
   >
   > **E.** The code will not compile because of line 7. 
   >
   > **F.** The output cannot be determined from the code provided. 
   
   **答案是：** **C**, **D**, **E**. First, the method `getTailLength()` in the interface `HasTail` is assumed to be `public`, since it is part of an interface. The implementation of the method on line 3 is therefore an invalid override, as `protected` is a more restrictive access modifier than `public`, so option **C** is correct. Next, the class `Cougar` implements an overloaded version
   of `getTailLength()`, but since the declaration in the parent class `Puma` is invalid, it needs to implement a `public` version of the method. Since it does not, the declaration of `Cougar` is invalid, so option **D** is correct. Option **E** is correct, since `Puma` is marked `abstract` and cannot be instantiated. The overloaded method on line 11 is declared correctly, so option **F** is not correct. Finally, as the code has multiple compiler errors, options **A**, **B**, and **G** can be eliminated. 
   
2. What is the result of the following program? 
    ```java
   public class MathFunctions { 
       public static void addToInt(int x, int amountToAdd) { 
           x = x + amountToAdd; 
       } 
       public static void main(String[] args) { 
           int a = 15; 
           int b = 10; 
           MathFunctions.addToInt(a, b); 
           System.out.println(a); } } 
   ```

   > **A.** 10 
   >
   > **B.** 15 
   >
   > **C.** 25 
   >
> **D.** Compiler error on line 3. 
   >
> **E.** Compiler error on line 8. 
   >
> **F.** None of the above. 
    
    **答案是：** **B.** The code compiles successfully, so options **D** and **E** are incorrect. The value of a cannot be changed by the `addToInt` method, no matter what the method does, because only a copy of the variable is passed into the parameter `x`. Therefore, a does not change and the output on line 9 is 15. 
    
3. What is the result of the following code? 

   ```java
   int[] array = {6,9,8}; 
   List<Integer> list = new ArrayList<>(); 
   list.add(array[0]); 
   list.add(array[2]); 
   list.set(1, array[1]); 
   list.remove(0); 
   System.out.println(list); 
   ```

   > **A.** [8] 
   >
   > **B.** [9] 
   >
   > **C.** Something like [Ljava.lang.String;@160bc7c0 
   >
   > **D.** An exception is thrown. 
   >
   > **E.** The code does not compile.

   **答案是： B.** The array is allowed to use an anonymous initializer because it is in the same line as the declaration. The `ArrayList` uses the diamond operator allowed since Java 7. This specifies the type matches the one on the left without having to re-type it. After adding the two elements, list contains [6, 8]. We then replace the element at index 1 with 9, resulting in [6, 9]. Finally, we remove the element at index 0, leaving [9]. Option **C** is incorrect because arrays output something like that rather than an `ArrayList`. 

4. What is the output of the following code? 

   ```java
   public class Deer { 
       public Deer() { System.out.print("Deer"); } 
       public Deer(int age) { System.out.print("DeerAge"); } 
       private boolean hasHorns() { return false; } 
       public static void main(String[] args) { 
           Deer deer = new Reindeer(5); 
           System.out.println(","+deer.hasHorns()); 
       } 
   } 
   class Reindeer extends Deer { 
       public Reindeer(int age) { System.out.print("Reindeer"); } 
       public boolean hasHorns() { return true; } 
   } 
   ```

   > **A.** DeerReindeer,false 
   >
   > **B.** DeerReindeer,true 
   >
   > **C.** ReindeerDeer,false 
   >
   > **D.** ReindeerDeer,true 
   >
   > **E.** DeerAgeReindeer,false 
   >
   > **F.** DeerAgeReindeer,true 
   >
   > **G.** The code will not compile because of line 7.
   >
   > **H.** The code will not compile because of line 12. 

   **答案是：A.** The code compiles and runs without issue, so options **G** and **H** are incorrect. First, the `Reindeer` object is instantiated using the constructor that takes an `int` value. Since there is no explicit call to the parent constructor, the default no-argument `super()` is inserted as the first line of the constructor. The output is then `Deer`, followed by `Reindeer` in the child constructor, so only options **A** and **B** can be correct. Next, the method `hasHorns()` looks like an overridden method, but it is actually a *hidden method* since it is declared `private` in the parent class. Because the hidden method is referenced in the parent class, the parent version is used, so the code outputs `false`, and option **A** is the correct answer. 

5. Which of the following statements are true? (Choose all that apply) 

   > **A.** Checked exceptions are intended to be thrown by the JVM (and not the programmer). 
   >
   > **B.** Checked exceptions are required to be caught or declared. 
   >
   > **C.** Errors are intended to be thrown by the JVM (and not the programmer). 
   >
   > **D.** Errors are required to be caught or declared. 
   >
   > **E.** Runtime exceptions are intended to be thrown by the JVM (and not the programmer). 
   >
   > **F.** Runtime exceptions are required to be caught or declared. 

   **答案是：B, C.** Only checked exceptions are required to be handled (caught) or declared. Runtime exceptions are commonly thrown by both the JVM and programmer code. Checked exceptions are usually thrown by programmer code. Errors are intended to be thrown by the JVM. While a programmer could throw one, this would be a **horrible** practice. 

6. Which are true of the following code? (Choose all that apply) 

   ```java
   import java.util.*; 
   public class Grasshopper { 
       public Grasshopper(String n) { 
       name = n; 
   } 
   public static void main(String[] args) { 
       Grasshopper one = new Grasshopper("g1"); 
       Grasshopper two = new Grasshopper("g2"); 
       one = two; 
       two = null; 
       one = null; 
   } 
   private String name; } 
   ```

   > **A.** Immediately after line 9, no grasshopper objects are eligible for garbage collection. 
   >
   > **B.** Immediately after line 10, no grasshopper objects are eligible for garbage collection. 
   >
   > **C.** Immediately after line 9, only one grasshopper object is eligible for garbage collection. 
   >
   > **D.** Immediately after line 10, only one grasshopper object is eligible for garbage collection. 
   >
   > **E.** Immediately after line 11, only one grasshopper object is eligible for garbage collection. 
   >
   > **F.** The code compiles. 
   >
   > **G.** The code does not compile. 

   **答案是：C, D, F.** Immediately after line 9, only `Grasshopper` `g1` is eligible for garbage collection since both `one` and `two` point to `Grasshopper` `g2`. Immediately after line 10, we still only have `Grasshopper` `g1` eligible for garbage collection. Reference `two` points to `g2` and reference `two` is `null`. Immediately after line 11, both `Grasshopper` objects are eligible for garbage collection since both `one` and `two` point to `null`. The code does compile. Although it is traditional to declare instance variables early in the class, you don’t have to. 

7. What is the output of the following program? 

   ```java
   public class FeedingSchedule { 
   public static void main(String[] args) { 
   	int x = 5, j = 0; 
   	OUTER: for(int i=0; i<3; ) 
   		INNER: do { 
               i++; x++; 
               if(x > 10) break INNER; 
               x += 4; 
               j++; 
            } while(j <= 2); 
    		System.out.println(x); 
   } } 
   ```

   > **A.** 10 
   >
   > **B.** 12 
   >
   > **C.** 13 
   >
   > **D.** 17 
   >
   > **E.** The code will not compile because of line 4. 
   >
   > **F.** The code will not compile because of line 6. 

   **答案是：B.** The code compiles and runs without issue; therefore, options **E** and **F** are incorrect. This type of problem is best examined one loop iteration at a time: 

   - On the first iteration of the outer loop `i` is 0, so the loop continues. 
   - On the first iteration of the inner loop, `i` is updated to 1 and `x` to 6. The `if-then` statement branch is not executed, and `x` is increased to 10 and `j` to 1. 
   -  On the second iteration of the inner loop (since `j = 1` and `1 <= 2`), `i` is updated to 2 and `x` to 11. At this point, the `if-then` branch will evaluate to `true` for the remainder of the program run, which causes the flow to break out of the inner loop each time it is reached. 
   -  On the second iteration of the outer loop (since `i = 2`), `i` is updated to 3 and `x` to 12. As before, the inner loop is broken since `x` is still greater than 10. 
   -  On the third iteration of the outer loop, the outer loop is broken, as `i` is already not less than 3. The most recent value of `x`, 12, is output, so the answer is option **B**. 

8. Assuming we have a valid, non-null HenHouse object whose value is initialized by the blank line shown here, which of the following are possible outputs of this application?(Choose all that apply) 

   ```java
   class Chicken {} 
   interface HenHouse { public java.util.List<Chicken> getChickens(); } 
   public class ChickenSong { 
   public static void main(String[] args) { 
   HenHouse house = ______________ 
       Chicken chicken = house.getChickens().get(0); 
       for(int i=0; i<house.getChickens().size(); 
           chicken = house.getChickens().get(i++)) { 
           System.out.println("Cluck"); 
   } } } 
   ```

   > **A.** The code will not compile because of line 6. 
   >
   > **B.** The code will not compile because of lines 7–8. 
   >
   > **C.** The application will compile but not produce any output. 
   >
   > **D.** The application will output Cluck exactly once. 
   >
   > **E.** The application will output Cluck more than once. 
   >
   > **F.** The application will compile but produce an exception at runtime. 

   **答案是：D, E, F.** The code compiles without issue, so options **A** and **B** are incorrect. If `house.getChickens()` returns an array of one element, the code will output Cluck once, so option **D** is correct. If `house.getChickens()` returns an array of multiple elements, the code will output Cluck once for each element in the array, so option **E** is correct. Alternatively, if `house.getChickens()` returns an array of zero elements, then the code will throw an `IndexOutOfBoundsException` on the call to `house.getChickens().get(0);` therefore, option **C** is not possible and option **F** is correct. The code will also throw an exception if the array returned by `house.getChickens()` is `null`, so option **F** is possible under multiple circumstances. 

9. 
