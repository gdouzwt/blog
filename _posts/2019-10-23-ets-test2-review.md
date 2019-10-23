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

> Enthuware Test Studio Test 2 错题回顾，题目编号为测试系统的编号。  

**2.**Given:  
```java
package loops;
public class JustLooping {
    private int j;
    void showJ(){
        while(j<=5){
            for(int j=1; j <= 5;){
                System.out.print(j+" ");
                j++;
            }
            j++;
        }
    }
    public static void main(String[] args) {
        new JustLooping().showJ();
    }
}
```
What is the result?  
**You had to select 1 option**  
- [ ] It will not compile.  
- [ ] It will print 1 2 3 4 5 five times.  
- [ ] It will print 1 3 5 five times.  
- [ ] It will print 1 2 3 4 5 once.  
- [x] It will print 1 2 3 4 5 six times.  

##### ✨**Explanation**  2

The point to note here is that the `j` in for loop is different from the instance member `j`. Therefore, `j++` occuring in the `for` loop doesn't affect the while loop. The `for` loop prints 1 2 3 4 5.  
The while loop runs `for` the values 0 to 5 i.e. 6 iterations. Thus, 1 2 3 4 5 is printed 6 times. Note that after the end of the while loop the value of `j` is 6.  

---

**6.**Given:  
```java
//in file Movable.java
package p1;
public interface Movable {
  int location = 0;
  void move(int by);
  public void moveBack(int by);
}

//in file Donkey.java
package p2;
import p1.Movable;
public class Donkey implements Movable{
    int location = 200;
    public void move(int by) {
        location = location+by;
    }
    public void moveBack(int by) {
        location = location-by;
    }
}

//in file TestClass.java
package px;
import p1.Movable;
import p2.Donkey;
public class TestClass {
    public static void main(String[] args) {
        Movable m = new Donkey();
        m.move(10);
        m.moveBack(20);
        System.out.println(m.location);
    }
}
```
Identify the correct statement(s).  
**You had to select 1 option**  
- [ ] Donkey.java will not compile.  
- [ ] TestClass.java will not compile.  
- [ ] Movable.java will not compile.  
- [ ] It will print 190 when TestClass is run.  
- [x] It will print 0 when TestClass is run.  

##### ✨**Explanation**  6

There is no problem with the code. All variables in an interface are implicitly `public`, `static`, and `final`. All methods in an interface are `public`.  
There is no need to define them so explicitly. Therefore, the `location` variable in `Movable` is `public` and `static` and the `move()` method is `public`.  
Now, when you call `m.move(10)` and `m.moveBack(20)`, the instance member `location` of `Donkey` is updated to 190 because  the reference `m` refers to a `Donkey` at run time and so `move` and `moveBack` methods of `Donkey` are invoked at runtime. However, when you print `m.location`, it is the Movable's `location` (which is never updated) that is printed.  

---

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
**You had to select 1 options**  
- [ ] It will throw `ArrayIndexOutOfBoundsException` at Runtime  
- [ ] Compile time Error.  
- [ ] It will print 10 20 30  
- [x] It will print 30 20 30  

##### ✨**Explanation**  8

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
**You had to select 1 options**  
- [ ] It will throw `ArrayIndexOutOfBoundsException` at runtime.  
- [x] It will end without exceptions and will print nothing.  
- [ ] It will print `Go away`  
- [ ] It will print `Go away` and then will throw `ArrayIndexOutOfBoundsException`.  
- [ ] None of the above.  

##### ✨**Explanation**  11

As in C and C++, the Java `if` statement suffers from the so-called "dangling `else` problem," The problem is that both the outer `if` statement and the inner `if` statement might conceivably own the `else` clause. In this example, one might be tempted to assume that the programmer intended the `else` clause to belong to the outer `if` statement.  

The Java language, like C and C++ and many languages before them, arbitrarily decree that an `else` clause belongs to the innermost `if` so as the first `if()` condition fails (`args[0]` not being "open") there is no `else` associated to execute. So, the program does nothing. The else actually is associated with the second `if`.  
So had the command line been :  
`java Test open`, it would have executed the second `if` and thrown `ArrayIndexOutOfBoundsException`.  
If the command line had been:  
`java Test open xyz`, it would execute the else part(which is associated with the second `if`) and would have printed "Go away xyz".

---

**14.**Which of the following code snippets will compile without any errors?  
(Assume that the statement `int x = 0;` exists prior to the statements below.)  
**You had to select 3 options**  

- [ ] `while (false) { x=3; }`  
- [x] `if (false) { x=3; }`  
- [x] `do{ x = 3; } while(false);`  
- [x] `for( int i = 0; i< 0; i++) x = 3;`  

##### ✨**Explanation**  14

`while (false) { x=3; }` is a compile-time error because the statement `x=3;` is not reachable;  
Similarly, `for( int i = 0; false; i++) x = 3;` is also a compile time error because `x = 3;` is unreachable.  

In `if(false){ x=3; }`, although the body of the condition is unreachable, this is not an error because the JLS explicitly defines this as an exception to the rule. It allows this construct to support optimizations through the conditional compilation. For example,  
`if(DEBUG){ System.out.println("beginning task 1"); }`  
Here, the `DEBUG` variable can be set to false in the code while generating the production version of the class file, which will allow the compiler to optimize the code by removing the whole if statement entirely from the class file.  

---

**20.**Given the following code, which of these statements are true?  
```java
class TestClass{
   public static void main(String args[]){
      int k = 0;
      int m = 0;
      for ( int i = 0; i <= 3; i++){
         k++;
         if ( i == 2){
            // line 1
         }
         m++;
      }
      System.out.println( k + ", " + m );
   }
}
```
**You had to select 3 options**  
- [x] It will print 3, 2 when line 1 is replaced by `break;`  
- [ ] It will print 3, 2 when line 1 is replaced by `continue`.  
- [x] It will print 4, 3 when line 1 is replaced by `continue`.  
- [ ] It will print 4, 4 when line 1 is replaced by `i = m++;`  
- [x] It will print 3, 3 when line 1 is replaced by `i = 4;`  

##### ✨**Explanation**  20

This is a simple loop. All you need to do is execute each statement in your head. For example, if line 1 is replaced by `break`:  

> ① k=0, m=0  
> ② iteration 1: i=0  
>    ⇨ k = 1  
>    ⇨ i == 2 is false  
>    ⇨ m = 1  
> ③ iteration 2: i = 1  
>    ⇨ k=2  
>    ⇨ i==2 is false  
>    ⇨ m = 2  
> ④ iteration 3: i = 2  
>    ⇨ k=3  
>    ⇨ i==2 is true  
>    ⇨ break  
> ⑤ print 3, 2  

---

**25.**Which of these statements are true?  
**You had to select 2 options**  
- [ ] A static method can call other non-static methods in the same class by using the 'this' keyword.  
- [x] A calss may contain both static and non-static variables and both static and non-static methods.  
- [x] Each object of a class has its own copy of each non-static member variable.  
- [ ] Instance methods of a class has it own copy of each non-static member variable.  
- [ ] Instance methods may access local variables of static methods.  
- [ ] All methods in a class are implicitly passed a 'this' parameter when called.  

##### ✨**Explanation**  25

'this' is assigned a reference to the current object automatically by the JVM. Thus, within an instance method `foo`, calling `this.foo();` is same as calling `foo();`  
Since there is no current object available for a static method, 'this' reference is not available in static methods and therefore it can only be used within instance methods. For the same reason, static methods cannot access non static fields or methods of that class directly i.e. without a reference to an instance of that class.  
Note : you can't reassign 'this' like this: `this = new Object();`  

---

**28.**Which of the following comparisons will yield false?  
**You had to select 3 options**  
- [ ] `Boolean.parseBoolean("true") == true`  
- [x] `Boolean.parseBoolean("TrUe") == new Boolean(null);`  
- [x] `new Boolean("TrUe") == new Boolean(true);`  
- [ ] `new Boolean() == false;`  
- [ ] `new Boolean("true") == Boolean.TRUE`  
- [x] `new Boolean("no") == false;`  

##### ✨**Explanation**  28

You need to remember the following points about `Boolean`:  
**1.** `Boolean` class has two constructors - `Boolean(String)` and `Boolean(boolean)` The `String` constructor allocates a `Boolean` object representing the value `true` if the string argument is not `null` and is equal, ignoring case, to the string "true". Otherwise, allocate a `Boolean` object representing the value `false`. Examples: `new Boolean("True")` produces a `Boolean` object that represents `true`. `new Boolean("yes")` produces a `Boolean` object that represents `false`.
The `boolean` constructor is self explanatory.  
**2.** `Boolean` class has two static helper methods for creating booleans - `parseBoolean` and `valueOf`. `Boolean.parseBoolean(String )` method returns a primitive `boolean` and not a `Boolean` object (Note - Same is with the case with other parseXXX methods such as `Integer.parseInt` - they return primitives and not objects). The `boolean` returned represents the value `true` if the string argument is not null and is equal, ignoring case, to the string "true".  
`Boolean.valueOf(String )` and its overloaded `Boolean.valueOf(boolean )` version, on the other hand, work similarly but return a reference to either `Boolean.TRUE` or `Boolean.FALSE` wrapper objects. Observe that they dont create a new `Boolean` object but just return the static constants `TRUE` or `FALSE` defined in `Boolean` class.  
**3.** When you use the equality operator ( `==` ) with booleans, if exactly one of the operands is a `Boolean` wrapper, it is first unboxed into a `boolean` primitive and then the two are compared (JLS 15.21.2). If both are `Boolean` wrappers, then their references are compared just like in the case of other objects. Thus, `new Boolean("true") == new Boolean("true")` is `false`, but `new Boolean("true") == Boolean.parseBoolean("true")` is true.  

---

**29.**

##### ✨**Explanation**  29

---
**33.**

##### ✨**Explanation**  33

---
**44.**

##### ✨**Explanation**  44

---
**48.**

##### ✨**Explanation**  48

---
**56.**

##### ✨**Explanation**  56

---
**58.**

##### ✨**Explanation**  58

---
**65.**

##### ✨**Explanation**  65

---
**69.**

##### ✨**Explanation**  69

---

