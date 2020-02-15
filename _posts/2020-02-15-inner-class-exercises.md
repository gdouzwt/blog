---
typora-root-url: ../
layout:     post
title:      Exercises for Inner class
date:       '2020-02-15T16:55'
subtitle:   内部类章节的练习
author:     招文桃
catalog:    true
tags:
    - Java
---

### QUESTIONS AND EXERCISES

1. What is an inner class? Differentiate between member, local, and anonymous inner classes.

   An inner class declares inside a top-level class without a static modifier. Inner classes that declared at member level are called member inner classes, local to the method, or instance initialization block are local inner class. And local inner classes that have no name are anonymous inner classes.

   > An inner class is a class declared inside the  body of another class. A member inner class is declared inside a class. It can be declared as public, private, protected, or package-level. A local inner class is declared inside a block. Its scope is limited to the block in which it is declared. An anonymous inner class is the same as  local inner class, but has no name. It is declared and an object of the class is created at the same time.

2. What is the fully qualified name of the inner class B, which is declared as follows?

   ```java
   // A.java
   package io.zwt.innerclasses.exercises;
   
   public class A {
   	public class B {
   	}
   }
   ```

   That will be :  io.zwt.innerclasses.exercises.A.B

3. Consider the following declaration for top-level class named Cup and a member inner class named Handle:

   ```java
   // Cup.java
   package io.zwt.innerclasses.exercises;
   
   public class Cup {
   	public class Handle {
   		public Handle() {
   			System.out.println("Created a handle for the cup");
   		}
   	}
   	
   	public Cup() {
   		System.out.println("Created a cup");
   	}
   }
   ```

   Compile the in the main() method for the following CupTest class that will create an instance of the Cup.Handle inner class:

   ```java
   // CupTest.java
   package io.zwt.innerclasses.exercises;
   public class CupTest {
       public static void main(String[] args) {
           // Create a Cup
           Cup c = new Cup();
           
           // Create a Handle
           // Cup.Handle h = / * You code goes here */;
           Cup.Handle h = c.new Handle();
       }
   }
   ```

4. What will be the output when the following Outer class is run?

   ```java
   // Outer.java
   package io.zwt.innerclasses.exercises;
   
   public class Outer {
       private final int value = 19680112;
       
       public class Inner {
           private final int value = 19690919;
           public void print() {
               System.out.println("Inner: value = " + value);
               System.out.println("Inner: this.value = " + this.value);
               System.out.println("Inner: Inner.this.value = " + 
                                 Inner.this.value);
               System.out.println("Inner: Outer.this.value = " + 
                                 Outer.this.vlaue);
           }
       }
       
       public void print() {
           System.out.println("Outer: value = " + value);
           System.out.println("Outer: this.value = " + this.value);
           System.out.println("Outer: Outer.this.value = " + 
                             Outer.this.value);
       }
       
       public static void main(String[] args) {
           Outer out = new Outer();
           Inner in = out.new Inner();
           out.print();
           in.print();
       }
   }
   ```

5. The following declaration of an AnonymousTest class does not compile. Describe the reasons and steps you might take to fix the error.

   ```java
   // AnonymousTest
   package io.zwt.innerclasses.exercises;
   
   public class AnonymousTest {
       public static void main(String[] args) {
           int x = 100;
           
           Object obj = new Object() {
               {
                   System.out.println("Inside.x = " + x);
               }
           };
           x = 300;
           System.out.println("Outside.x = " + x);
       }
   }
   ```

6. Consider the following declaration for a top-level class A and a member inner class B:

   ```java
   package io.zwt.innerclasses.exercises;
   
   public class A {
       public class B {
           public B() {
               System.out.println("B is created.");
           }
       }
       public A() {
           System.out.println("A is created.");
       }
   }
   ```

   Consider the following incomplete declaration of class C, which inherits from the inner class A.B:

   ```java
   // C.java
   package io.zwt.innerclasses.exercises;
   
   public class C extends A.B {
       /* Define a constructor for class C here */
       
       public static void main(String[] args) {
           C c = /* Your code goes here */;
       }
   }
   ```

   Add an appropriate constructor for class C and complete the statement in the main() method. When class C is run, it should print the following to the standard output:

   ```
   A is created.
   B is created.
   C is created.
   ```

7. Which of the following is true about an anonymous inner class?

   a. It can inherit from one class and implement one interface.

   b. It can inherit from one class and implement multiple interfaces.

   c. It can inherit from one class or implement one interface.

   d. It can implement multiple interfaces, but inherits from only one class.

8. How many class files will be generated when the following declaration of the Computer class is compiled? List the names of all generated class files.

   ```java
   // Computer.java
   package io.zwt.innerclasses.exercises;
   
   public class Computer {
       public class Mouse {
           public class Button {
           }
       }
       
       public static void main(String[] args) {
           Object obj = new Object() {
           };
           
           System.out.println(obj.hasCode());
       }
   }
   ```

9. The following declaration of class H does not compile. Point out the problem and suggest a solution.

   ```java
   // H.java
   package io.zwt.innerclasses.exercises;
   
   public class H {
       private int x = 100;
       
       public static class J {
           private int y = x * 2;
       }
   }
   ```

10. Consider the following declaration of a top-level class P and a nested static class Q:

    ```java
    // P.java
    package io.zwt.innerclasses.exercises;
    
    public class P {
        public static class Q {
            System.out.println("Hello from Q.");
        }
    }
    ```

    Complete the main() method of the following PTest class that will create an object of the nested static class Q. When class PTest is run, it should print a message "Hello from Q." to the standard output.

    ```java
    // PTest.java
    package io.zwt.innerclasses.exercises;
    
    public class PTest {
        public static void main(String[] args) {
            P.Q q = /* Your code goes here */ ;
        }
    }
    ```

    

