---
typora-root-url: ../
layout:     post
title:      EST 基础测试回顾
date:       '2019-10-07'
subtitle:   整理错题，查漏补缺
author:     招文桃
catalog:    true
tags:
    - Java
    - OCA
---

###  基础测试的情况 

#### 测试报告 

当时第一次测试结果报告如下： 

![foundation-test](/img/foundation-test.png)

按照考试的主题（或者说考点）来看的话，Java Basics 正确率 6/7。然后，OO Concepts 过关的，Java Data Types 部分就只对了 3 题，有点危险。基础测试没有涉及到垃圾回收的内容，但是真正考试应该会有的，而且现在工作要求也肯定会问，需要了解的。关于操作符和条件判断结构居然也只有对了 6 个题，看起来真的有点 tricky。接下来的数组、循环结构和构造方法这些考点感觉还过得去的样子。 关于方法的使用居然有点不稳，要搞清楚了，可能需要翻译 Coderanch 的文章加深一下理解。这次没有涉及方法重载的题目，然而关于继承的理解，可能还不够深，要看看编程思想了。`instanceof`在继承相关主题没有考到，但在操作符题目里出现了，异常处理方面需要加强。最基本的 `String`， 以及相关的类要烂熟了，至少 API 文档过一遍。最后 Java 8 新的时间日期 API 还没有了解，这一次就新的旧的都看一遍吧，所以今天是要看完错题，找出对应的知识点，考点，然后读 API 文档。 <!--more-->

### 接下来做什么 

#### 整理错题 

1. Compared to public, protected, and private accessibilities, default accessibility is ... **(Working with Methods)** 

   - [ ] Less restrictive than `public` 

     > 肯定错啦，`public` 最宽了。 

   - [ ] More restrictive than `public`, but less restrictive than `protected`. 

     > 想到 "by default is protect"，默认情况下，就相当于保护了，但是更深一层限制在同一个包里。所以就 `default` < `protected` 所以下一个选项是正确的。 

   - [x] More restrictive than `protected`, but less restrictive than `private`. 

   - [ ] More restrictive than `private`. 

     > 肯定错， `private` 最窄了。 

   - [ ] Less restrictive than `protected` from within a package, and more restrictive than `protected` from outside a package. 

     > 当时选择了这个选项，因为看起来好像很有道理，而且描述全面。但现在仔细看看，说的是，在同一个包内，访问权限比 `protected` 更受限，这已经错了，同一个包内两个一样的。后面部分就不用看了，当时就没多想，这次知道了，下次就不会错了。 

   ---

2. What can be the type of a `catch` argument? (Select the best option.) **(Handling Exceptions)**

   - [ ] Any class that extends `java.lang.Exception` 

   - [ ] Any class that extends `java.lang.Exception` except any class that extends `java.lang.RuntimeException` 

   - [x] Any class that is-a `Throwable`. 

     > The catch argument type declares the type of exception that the handler can handle and must be the name of a class that extends `Throwable` or `Throwable` itself. 

   - [ ] Any Object 

   - [ ] Any class that extends `Error` 

   ---

3. 记录一个关于重写的： An overriding method must have the same parameter list and the same return type as that of the overridden method. 翻译成中文就是，重写方法必须与被重写方法具有相同的参数列表和返回类型。 

   - [ ] True 

   - [x] False 

     > 我答对了，不过好像没有理解正确。 解释是这样说的： 
     >
     > This would have been true prior to Java 1.5. But from Java 1.5, an overriding method is allowed to change the return type to any subclass of the original return type, also known as **covariant return type**. This does not apply to primitives, in which case, the return type of the overriding method must match exactly to the return type of the overridden method. 
     >
     > 所以主要看返回值类型，重写必须参数列表相同才算重写，不然就是重载了。而在 Java 1.5 之前，重写方法的返回值必须与被重写方法返回值一致。不过从 Java 1.5 开始，重写方法的返回值类型可以是被重写方法返回值的任意子类，也称为 covariant return type（好像中文译为“**协变返回类型**”） 

   ---

4. Which of the following statements are true?**(Working with Inheritance)** 选择两个正确的，当时选错了。 

   - [x] Private methods cannot be overridden in subclasses. 

      > Only methods that are inherited can be overridden and private methods are not inherited. 
      >
      > 只有被继承的方法才能被重写，**私有方法不会被继承**。 

   - [ ] A subclass can override any method in a non-final superclass. 

     > Only the methods that are not declared to be final can be overridden. Further, private methods are not inherited so they cannot be overridden either. 

   - [ ] An overriding method can declare that it throws a wider spectrum of checked exceptions than the method it is overriding. 

     > 这个没有在选项给出解释，看底下更长的解释。 

   - [ ] The parameter list of an overriding method must be a subset of the parameter list of the method that it is overriding. 

     > An overriding method (the method that is trying to override the base class's method) must have the same parameters. 

   - [x] The overriding method may opt not to declare any throws clause even if the original method has a throws clause. 

     > No exception(i.e. an empty set of exceptions) is a valid subset of the set of exceptions thrown by the original method so an overriding method can choose to not have any throws clause. 

   A method can be overridden by defining a method with the same signature(i.e. name and parameter list) and return type as the method in a superclass. The return type can also be a subclass of the original method's return type. 

   Only methods that are accessible can be overridden. A private method cannot, therefore, be overridden in subclasses, but the subclasses are allowed to define a new method with exactly the same signature. 

   A final method cannot be overridden. 

   An overriding method cannot exhibit behavior that contradicts the declaration of the original method. An overriding method, therefore, cannot return a different type (except a subtype) or throw a wider spectrum of exceptions than the original method in the superclass. This, of course, applies only to checked exceptions because unchecked exceptions are not required to be declared at all. 

   A subclass may have a static method with the same signature as a static method in the base class but it is not called overriding. It is called hiding because **the concept of polymorphism doesn't apply to static members.** 

   这部分这有点意思，之前没有了解到。关于方法重写和重载，还有静态成员的知识。对于静态方法，子类中具有与父类相同方法签名的静态方法，不叫重写，叫隐藏，因为多态的概念不适用于静态成员。 

   ---

5. Given: **(Working with Methods)** 

   ```java
   //In file AccessTest.java 
   package a; 
   public class AccessTest { 
       int a; 
       private int b; 
       protected void c() {} 
       public int d() { return 0; } 
   } 
   
   //In file AccessTester.java 
   package b; 
   import a.AccessTest; 
   
   public class AccessTester extends AccessTest { 
       public static void main(String[] args) { 
           AccessTest ref = new AccessTest(); 
       } 
   } 
   ```

   Identify the correct statements - 

   - [ ] Only `c()` and `b()` can be accessed by `ref`. 
   - [ ] `b`, `c()` as well as `d()`, can be accessed by `ref`. 
   - [x] Only `d()` can be accessed by `ref`. 
   - [ ] Only a and `d()` can be accessed by `ref`. 

   The wording of this question is a bit vague because it is not clear what is meant by "can be accessed by". Expect such wording in the real exam as well. Our guess is that it means what variables of class `AceesssTest` can be accessed using the reference named `ref`. 

   Since a public member is always accessible to everyone, `ref.d()` is definitely correct. private is only accessible within that class, therefore, b cannot be accessed from anywhere outside of class `AccessTest`. A default (aka package protected) member is accessible only from members of the same package. Since `AccessTester` is in a different package `a` cannot be accessed from `AccessTester` either. 

   Now, the question is only about the method `c()`. A protected member is inherited by a subclass and it is therefore accessible in the subclass. However, in the words of Java Language Specification, protected members of a class are accessible outside the package only in subclasses of that class, and only when they are fields of objects that are being implemented by the code that is accessing them. 

   Basically, it implies that a protected member is accessible in the subclass only using a reference whose declared type is of the same subclass (or its subclass.). 

   In this case, the declared type of `ref` is `AccessTest`, which is not of the same type as the class from which you are trying to access `c()`. Therefore, you cannot do `ref.c()` in `AccessTester`. If you had `AccessTester ref = new AccessTester();` you could do `ref.c()` because now the declared type of `ref`(i.e. `AccessTester`) is the same subclass from which you are trying to access `c()`. It will work even if the declared type of the reference is a child of the subclass. For example, the following would be valid as well. 

   ```java
   SubAccessTester ref = new SubAccessTester(); 
   ref.c();   // this is valid 
   ```

   Where `SubAccessTester` is a subclass of `AccessTester` - 
   `class SubAccessTester extends AccessTester {}` 

   ---

6. Which of these statements concerning the use of modifiers are true? **(Java Basics)** 

   - [ ] By default (i.e. no modifier) the member is only accessible to classes in the same package and subclasses of the class. 

     > No. the member will be accessible only within the package. 

   - [x] You cannot specify visibility of local variables. 

     > They are always only accessible within the block in which they are declared. 

   - [ ] Local variable always have default accessibility. 

     > A local variable (aka automatic variable) means a variable declared in a method. They don't have any accessibility. They are accessible only from the block they are declared in. 
     >
     > **Remember**, they are not initialized automatically. You have to initialize them explicitly. 

   - [ ] Local variables can be declared as private. 

   - [ ] Local variables can only be declared as public. 

   You cannot apply any modifier except `final` to a local variable. i.e. you cannot make them `transient`, `volatile`, `static`, `public`, and `private`. 

   But you can apply access modifier (`public` `private` and `protected`) and `final`, `transient`, `volatile`, `static` to instance variables. 

   You cannot apply `native` and `synchronized` to any kind of variable. 

   这些很经典的基础，关键词的运用，必须熟记。 

   ---

7. An abstract method cannot be overridden. **(Working with inheritance)** 

   - [ ] True 
   - [x] False 

   Abstract methods are meant to be overridden in the subclass. Abstract methods describe behavior but do not implement it. So the subclasses have to override it to actually implement the behavior. A subclass may choose to override it, in which case, the subclass will **have to be abstract too**. 

   ---

8. What is the correct declaration for an abstract method 'add' in a class that is accessible to any class, takes no arguments and returns nothing? (You had to select 1 option) 

   - [ ] `public void add();` 

     > An abstract method must have the `abstract` keyword and must not have a method body i.e. `{}`. 

   - [ ] `abstract add();` 

     > A method that is not supposed to return anything must specify `void` as its return type. 

   - [ ] `abstract null add();` 

     > A method that is not supposed to return anything must specify `void` as its return type. `null` is not a type, though it is a valid return value for any reference type. 

   - [ ] `abstract public void add();` 

     > It is invalid because has a method body i.e. `{}`.  **有方法体都不可以**。 

   - [x] `abstract public void add() throws Exception;` 

   ---

9. Which of the following are correct about `java.util.function.Predicate`? 

   - [ ] It is an interface that has only one abstract method (among other non-abstract methods) with the signature - `public void test(T t);` 
   - [x] It is an interface class that has only one abstract method (among other non-abstract methods) with the signature - `public boolean test(T t);` 
   - [ ] It is an abstract class that has only abstract method (among other non-abstract methods) with the signature - `public abstract void test(T t);` 
   - [ ] It is an abstract class that has only on abstract method (among other non-abstract methods) with the signature - `public abstract boolean test(T t);` 

   `java.util.function.Predicate` is one of the several functional interfaces that have been added to Java 8. This interface has exactly one abstract method named `test`, which takes any object as input and returns a `boolean`. This comes in very handy when you have a collection of objects and you want to go through each object of that collection and see if that object satisfies some criteria. For example, you may have a collection of `Employee` objects and, in one place of your application, you want to remove all such employees whose age is below 50, while in other place, you want to remove all such employees whose salary is above 100,000. In both the cases, you want to go through your collection of employees and check each `Employee` object to determine if it fits the criteria. This can be implemented by writing an interface named `CheckEmployee` and having a method `check(Employee)` which would return `true` if the passed object satisfies the criteria. The following code fragments illustrate how it can be done - 

   ```java
   //define the interface for creating criteria 
   interface CheckEmployee { 
    boolean check(Employee e); 
   } 
    ...
   //write a method that filters Employees based on given criteria. 
   public void filterEmployees(ArrayList<Employee> dataList, CheckEmployee p) { 
       Iterator<Employee> i = dataList.iterator(); 
       while(i.hasNext()) { 
           if(p.check(i.next())) { 
               i.remove(); 
           } 
       } 
   } 
   ... 
   //create a specific criteria by defining a class that implements CheckEmployee 
   class MyCheckEmployee implements CheckEmployee { 
       public boolean check(Employee e) { 
           return e.getSalary()>100000; 
       } 
   } 
   ... 
   //use the filter method with the specific criteria to filter the collection. 
   filterEmployees(employeeList, new MyCheckEmployee()); 
   ```

   This is a very common requirement across applications. The purpose of `Predicate` interface (and other standard functional interfaces) is to eliminate the need for every application to write a customized interface. For example, you can do the same thing with the `Predicate` interface as follows 

   ```java
   public void filterEmployees(ArrayList<Employee dataList, Predicate<Employee> p) { 
       Iterator<Employee> i = dataList.iterator(); 
       while(i.hasNext()) { 
           if(p.test(i.next())) { 
               i.remove(); 
           } 
       } 
   } 
   ... 
   // Instead of defining a MyPredicate class (like we did with MyCheckEmployee), we could also define and instantiate an anonymous inner class to reduce code clutter 
   Predicate<Employee> p = new Predicate<Employee>() { 
       public boolean test(Employee e) { 
           return e.getSalary()>1000000; 
       } 
   } 
   ... 
   filterEmployees(employeeList, p); 
   ```

   Note that both the interfaces (`CheckEmployee` and `Predicate`) can be used with lambda expressions in exactly the same way. Instead of creating an anonymous inner class that implements the `CheckEmployee` or `Predicate` interface, you could just do - 

   `filterEmployees(employeeList, e -> e.getSalary()>1000000);` 

   The benefit with `Predicate` is that you don't have to write it, It is already there in the standard java library. 

   ---

10. Which of the following are valid declarations in a class? (You had to select 1 option) **(Working with Inheritance)** 

    - [x] `abstract int absMethod(int param) throws Exception;` 

    - [ ] `abstract native int absMethod(int param) throws Exception;` 

      > `native` method cannot be `abstract` 

    - [ ] `float native getVariance() throws Exception;` 

      > return type should always be on the immediate left of the method name. 

    - [ ] `abstract private int absMethod(int param) throws Exception;` 

      > `private` method cannot be `abstract`. A `private` method is not inherited so how can a subclass implement it? 

    ---

11. Which of the following statements is/are true? (You had to select 1 option) 

    - [ ] Subclasses must define all the abstract methods that the superclass defines. 

      > Not if the subclass is also defined abstract! 

    - [ ] A class implementing an interface must define all the methods of that interface. 

      > Not if the class is defined abstract. Further, Java 8 allows interface to have and static methods, which need not be implemented by a non-abstract class that says it implements that interface. 

    - [x] A class cannot override the super class's constructor. 

      > Because constructors are not inherited. 

    - [ ] It is possible for two classes to be the superclass of each other. 

    - [ ] An interface can implement multiple interfaces. 

      > Interface cannot "implement" other interfaces. It can extend multiple interfaces. The following is a valid declaration `interface I1 extends I2, I3, I4 {}`。 **记得了，接口是不可以实现其它接口的，但是可以实现多个接口。** 

    ---

12. Which of the following statements regarding 'break' and 'continue' are true? (You had to select 1 option) **(Using Loop Constructs)** 这题选错了，注意。 

    - [x] `break` without a label, can occur only in a `switch`, `while`, `do`, or `for` statement. 

    - [ ] `continue` without a label, can occur only in a `switch`, `while`, `do`, or `for` statement. 

      > It cannot occur in a switch. 

    - [ ] `break` can never occur without a label. 

    - [ ] `continue` can never occur WITH a label. 

    - [ ] None of the above. 

    A `break` statement with no label attempts to transfer control to the innermost enclosing `switch`, `while`, `do`, or `for` statement; this statement, which is called the break target, then immediately completes normally. If no `switch`, `while`, `do`, or `for` statement encloses the `break` statement, a compile-time error occurs. 

    A `break` statement with label Identifier attempts to transfer control to the enclosing labeled statement that has the same identifier as its label; this statement, which is called the break target, then immediately completes normally. In this case, the break target need not be a `while`, `do`, `for`, or `switch` statement. 

    A `continue` statement with no label attempts to transfer control to the innermost enclosing `while`, `do`, or `for` statement; this statement, which is called the continue target, then immediately ends the current iteration and begins a new one. If no `while`, `do`, or `for` statement encloses the `continue` statement, a compile-time error occurs. 

    A `continue` statement with label identifier attempts to transfer control to the enclosing labeled statement that has the same identifier as its label; that statement, which is called the continue target, then immediately ends the current iteration and begins a new one. The continue target must be a `while`, `do`, or `for` statement or a compile-time error occurs. If no labeled statement with identifier as its label contains the `continue` statement, a compile-time error occurs. 

    ---

13. What class of objects can be declared by the throws clause? **(Handling Exceptions)** 

    - [x] `Exception` 
    - [x] `Error` 
    - [ ] `Event` 
    - [ ] `Object` 
    - [x] `RuntimeException` 

    You can declare anything that is a `Throwable` or a subclass of `Throwable`, in the `throws` clause. 

    ---

14. Identify the valid members of `Boolean` class. 

    - [x] `parseBoolean(String)` 
    - [x] `valueOf(boolean)` 
    - [ ] `parseBoolean(boolean)` 
    - [x] `FALSE`       
      
      > `TRUE` and `FALSE` are valid static members of `Boolean` class. 
    - [ ] `Boolean(Boolean)`       
      
      > There is no constructor that takes a `Boolean`. 

    **You need to remember the following points about Boolean:** 

    1. `Boolean` class has two constructors - `Boolean(String)` and `Boolean(boolean)` 

       The `String` constructor allocates a `Boolean` object representing the value `true` if string argument is not null and is equal, ignoring case, to the string "true". Otherwise, allocate a Boolean object representing the value `false`. Examples: `new Boolean("True")` produces a `Boolean` object that represents `true`. `new Boolean("yes")` produces a `Boolean` object that represents `false`. 

       The `boolean` constructor is self-explanatory. 

    2. `Boolean` class has two static helper methods for creating booleans - `parseBoolean` and `valueOf`. 

       `Boolean.parseBoolean(String )` method returns a primitive boolean and not a `Boolean` object (Note - Same as with the case with other `parseXXX` methods such as `Integer.parseInt` - they return primitives and not objects). The boolean returned represents the value `true` if the string argument is not null and is equal, ignoring case, to the string "true". 

       `Boolean.valueOf(String )` and its overloaded `Boolean.valueOf(boolean )` version, on the other hand, work similarly but returns a reference to either `Boolean.TRUE` or `Boolean.FALSE` wrapper objects. Observe that they don't create a new Boolean object but just return the static constants `TRUE` or `FALSE` defined in `Boolean` class. 

    3. When you use the equality operator ( `==` ) with booleans, if exactly one of the operands is a `Boolean` wrapper, it is first unboxed into a `boolean` primitive and then the two are compared (JLS 15.21.2). If both are `Boolean` wrappers, then their references are compared just like in the case of other objects. Thus, `new Boolean("true") == new Boolean("true")` is `false`, but `new Boolean("true") == Boolean.parseBoolean("true")` is `true`. 

    ---

15. **(Working with Inheritance)** A method with no access modifier defined in a class can be overridden by a method marked protected (assuming that it is not final) in the subclass. (You had to select 1 option) 

    - [x] True 
    - [ ] False 

    An overriding method is allowed to make the overridden method more accessible, and since protected is more accessible than default (package), this is allowed. Note that protected access will allow access to the subclass even if the subclass is in a different package but package access will not. 

    ---

16. Which of the following are **NOT** valid operators in Java? **(Using Operators and Decision Constructs)** 

    - [x] `sizeof` 
      
      > It is a valid operator in C++ but not in java because the size of everything is known at compile time and is not machine dependent. 
    - [x] `<<<` 
      
      > For left shifts there is no difference between shifting signed and unsigned values so there is only one leftshift `'<<'` in java. 
    - [ ] `instanceof` 
      
      > 这个居然也算是运算符，记混了，以为只是关键字！ 
    - [x] `mod` 
      
      > No such thing. 
    - [x] `equals` 
      
      > `boolean equals(Object o)` is a method in `java.lang.Object.` It is not an operator. 

    ---

17. Which of these statements are true? 

    - [ ] All classes must explicitly define a constructor. 

      > A default no args one will be provided if not defined any. 

    - [x] A constructor can be declared private. 

      > **This feature is used for implementing Singleton Classes.** 单例模式，要可以手写。 

    - [ ] A constructor can declare a return value. 

    - [ ] A constructor must initialize all the member variables of a class. 

      > All non-final instance variables get default values if not explicitly initialized. 

    - [x] A constructor can access the non-static members of a class. 

      > A constructor is non-static, and so it can access directly both the static and non-static members of the class. 

    Constructors need not initialize **all** the member variables of the class. A non-final member(i.e. an instance) variable will be assigned a default value if not explicitly initialized. 

    ---

18. Which of these statements are true? (You had to select 2 option(s)) **(Working with Inheritance)** 

    - [ ] A `super(<appropriate list of arguments>)` or `this(<appropriate list of arguments>)` call must always be provided explicitly as the first statement in the body of the constructor. 

      > `super();` is automatically added if the subclass constructor doesn't call any of the super class's constructors. 

    - [x] If a subclass does not have any declared constructors, the implicit default constructor of the subclass will have a call to `super()`. 

    - [ ] If neither `super()` or `this()` id declared as the first statement of the body of a constructor, then `this()` will implicitly be inserted as the first statement. 

      > `super()` is added and not `this()` 

    - [ ] `super(<appropriate list of arguments>)` can only be called in the first line of the constructor but `this(<appropriate list of arguments>)` can be called from anywhere. 

    - [x] You can either call `super(<appropriate list of arguments>)` or `this(<appropriate list of arguments>)` but not both from a constructor. 

    Note that calling `super();` will not always work because if the superclass has defined a constructor with arguments and has not defined a no args constructor then no args constructor will not be provided by the compiler. It is provided only to the class that does not define ANY constructor explicitly. 

    ---

19. Which of these combinations of switch expression types and case label value types are legal within a switch statement? (You had to select 1 option(s)) **(Using Operators and Decision Constructs)** 

    - [x] switch expression of type int and case label value of type `char`. 

      > Note that the following is invalid though because a `char` cannot be assigned to an `Integer`. 
      >
      > ```java
      > Integer x = 1;   // int x = 1; is valid. 
      > switch(x) { 
      > case 'a' : System.out.println("a"); 
      > } 
      > ```

    - [ ] switch expression of type `float` and case label value of type `int`. 

    - [ ] switch expression of type `byte` and case label value of type `float`. 

    - [ ] switch expression of type `char` and case label value of type `byte`. 

      > This will not work in all cases because a `byte` may have negative values which cannot be assigned to a char. For example, `char ch = -1;` does not compile. Therefore, the following does not compile either: 
      >
      > ```java
      > char ch = 'x';
      > switch (ch) { 
      >   case -1 : System.out.println("-1"); break; // This will not compile: possible loss of precision 
      >   default:  System.out.println("default"); 
      > } 
      > ```

    - [ ] switch expression of type boolean and case label value of type boolean. 

    You should remember the following rules for a switch statement: 

    1. Only `String`, `byte`, `char`, `short`, `int`, and `enum` values can be used as types of a switch variable. (`String` is allowed since Java 7.) Wrapper classes `Byte`, `Character`, `Short`, and `Integer` are allowed as well. 

    2. The case constants must be assignable to the switch variable. For example, if your switch variable is of class `String`, your case labels must use Strings as well. 

    3. The switch variable must be big enough to hold all the case constants. For example, if the switch variable is of type `char`, then none of the case constants can be greater than 65535 because a char's range is from 0 to 65535. Similarly, the following will not compile because 300 cannot be assigned to 'by', which can only hold values from -128 to 127. 

          ```java
          byte by = 10; 
          switch(by){ 
              case 200 :  //some code; 
              case 300 :  //some code; 
          } 
          ```

    4. All case labels should be **COMPILE TIME CONSTANTS**. 

    5. No two of the case constant expressions associated with a switch statement may have the same value. 

    6. At most one default label may be associated with the same switch statement. 

    ---

20. Consider the following code: 

    ```java
    public class Conversion { 
      public static void main(String[] args) { 
        int i = 1234567890; 
        float f = i; 
        System.out.println( i - (int)f); 
      } 
    } 
    ```

    What will it print when run? 

    - [ ] It will print 0. 
    - [x] It will not print 0. 
    - [ ] It will not compile. 
    - [ ] It will throw an exception at runtime. 
    - [ ] None of the above. 

    Actually, it prints -46. This is because the information was lost during the conversion from type int to type `float` as values of type `float` are not precise to nine significant digits. 
    Note: **You are not required to know the number of significant digits that can be stored by a float for the exam. However, it is good to know about the loss of precision while using float and double.** 

    ---

21. Which of the following statements are true? (You had to select 2 option(s)) 

    - [ ] `private` keyword can never be applied to a class. 

      > `private`, `protected` and `public` can be applied to nested class. 
      >
      > Although not too important for the exam, you should still know the following terminology: A top level class is a class that is not a nested class. A nested class is any class whose declaration occurs within the body of another class or interface. 

    - [x] `synchronized` keyword can never be applied to a class. 

    - [ ] `synchronized` keyword may be applied to a non-primitive variable. 

      > It can only be applied to a method or a block. 

    - [ ] `final` keyword can never be applied to a class. 

      > It can be applied to class, variable and methods. 

    - [x] A `final` variable can be hidden in a subclass. 

    If the class declares a field with a certain name, then the declaration of that field is said to hide any and all accessible declarations of fields with the same name in superclasses and superinterfaces of the class. 
    For example, 

    ```java
    class Base{ 
    int i=10; 
    } 
    class Sub extends Base{ 
    int i=20; //This i hides Base's i. 
    } 
    ... 
    Sub s = new Sub(); 
    int k = s.i; //assigns 20 to k. 
    
    k = ((Base)s).i;//assigns 10 to k. The cast is used to show the Base's i. 
    
    Base b = new Sub(); 
    ```

    `k = b.i;//assigns 10 to k` because which field is accessed depends on the class of the variable and not on the class of the actual object. The same rule applies to static methods but the opposite is true for instance methods. 

    `final` keyword when applied to a class means the class cannot be subclassed, when applied to a method means the method cannot be overridden (it can be overloaded though) and when applied to a variable means that the variable is a constant. 

    ---

22. **(Working with Java API - Time and Date)** Identify the correct statements. 

    - [ ] `LocalDate`, `LocalTime`, and `LocalDateTime` extend `Date`. 
    - [x] `LocalDate`, `LocalTime`, and `LocalDateTime` implement `TemporalAccessor`. 
    - [ ] Both - `LocalDate` and `LocalTime` extend `LocalDateTime`, which extends `java.util.Date`. 
    - [ ] `LocalDate`, `LocalTime`, and `LocalDateTime` implement `TemporalAccessor` and extend `java.util.Date`. 

    Here are some points that you should keep in mind about the new Date/Time classes introduced in Java 8 - 

    1. They are in package `java.time` and they have no relation at all to the old `java.util.Date` and `java.sql.Date`. 

    2. `java.time.temporal.TemporalAccessor` is the base interface that is implemented by `LocalDate`, `LocalTime`, and `LocalDateTime` concrete classes. This interface defines read-only access to temporal objects, such as a date, time, offset or some combination of these, which are represented by the interface `TemporalField`. 

    3. `LocalDate`, `LocalTime`, and `LocalDateTime` classes do not have any parent/child relationship among themselves. As their names imply, `LocalDate` contains just the date information and no time information, `LocalTime` contains only time and no date, while `LocalDateTime` contains date as well as time. None of them contains zone information. For that, you can use `ZonedDateTime`. 

       These classes are immutable and have no public constructors. You create objects of these classes using their static factory methods such as of(...) and from(`TemporalAccessor` ).  For example, 

       ```java
       LocalDate ld = LocalDate.of(2015, Month.JANUARY, 1); 
       ```
        or 
       ```java
       LocalDate ld = LocalDate.from(anotherDate); 
       ```
       or 
       ```java 
       LocalDateTime ldt = LocalDateTime.of(2015, Month.JANUARY, 1, 21, 10); //9.10 PM 
       ```
       Since you can't modify them once created, if you want to create new object with some changes to the original, you can use the instance method named with(...). For example, 

       ```java
       LocalDate sunday = ld.with(java.time.temporal.TemporalAdjusters.next(DayOfWeek.SUNDAY)); 
       ```

    4. Formatting of date objects into String and parsing of Strings into date objects is done by `java.time.format.DateTimeFormatter` class. This class provides public static references to readymade `DateTimeFormatter` objects through the fields named `ISO_DATE`, `ISO_LOCAL_DATE`, `ISO_LOCAL_DATE_TIME`, etc.  For example 

       ```java
       LocalDate d1 = LocalDate.parse("2015-01-01", DateTimeFormatter.ISO_LOCAL_DATE); 
       ```

       The parameter type and return type of the methods of `DateTimeFormatter` class is the base interface `TemporalAccessor` instead of concrete classes such as `LocalDate` or `LocalDateTime`. So you shouldn't directly cast the returned values to concrete classes like this - 

       ```java
       LocalDate d2 = (LocalDate) DateTimeFormatter.ISO_LOCAL_DATE.parse("2015-01-01"); 
       //will compile but may or may not throw a ClassCastException at runtime. 
       ```

       You should do like this - 

       ```java
       LocalDate d2 = 
           LocalDate.from(DateTimeFormatter.ISO_LOCAL_DATE.parse("2015-01-01")); 
       ```

    5. Besides dates, `java.time` package also provides `Period` and `Duration` classes. `Period` is used for quantity or amount of time in terms of years, months and days, while `Duration` is used for quantity or amount of time in terms of hour, minute, and seconds. 

       Durations and periods differ in their treatment of daylight savings time when added to `ZonedDateTime`. A `Duration` will add an exact number of seconds, thus a duration of one day is always exactly 24 hours. By contrast, a `Period` will add a conceptual day, trying to maintain the local time. 

       For example, consider adding a period of one day and a duration of one day to 18:00 on the evening before a daylight savings gap. The Period will add the conceptual day and result in a `ZonedDateTime` at 18:00 the following day. By contrast, the `Duration` will add exactly 24 hours, resulting in a `ZonedDateTime` at 19:00 the following day (assuming a one hour DST gap). 

    ---

23. **(Q 40 of 69 Working with Java API - Time and Date)** Which of the following are true regarding the new Date-Time API of Java 8? (You had to select 2 option(s)) 

    - [x] It uses the calendar system defined in ISO-8601 as the default calendar. 
      > This calendar is based on the Gregorian calendar system and is used globally as the defacto standard for representing date and time. The core classes in the Date-Time API have names such as `LocalDateTime`, `ZonedDateTime`, and `OffsetDateTime`. All of these use the ISO calendar system. 
      > 
      > If you want to use an alternative calendar system, such as Hijrah or Thai Buddhist, the `java.time.chrono` package allows you to use one of the predefined calendar systems. Or you can create your own. 

    - [x] Most of the actual date related classes in the Date-Time API such as `LocalDate`, `LocalTime`, and `LocalDateTime` are immutable. 
      
    > These classes do not have any setters. Once created you cannot change their contents. Even their constructors are **private**. 
    
    - [ ] `LocalDateTime` includes time zone information but `LocalDate` does not. 
      > None of `LocalDate`, `LocalDateTime`, or `LocalTime` store zone information. 
      > 
      > `java.time.ZonedDateTime` does. `ZonedDateTime` is an immutable representation of a date-time with a time-zone. This class stores all date and time fields, to a precision of nanoseconds, and a time-zone, with a zone offset used to handle ambiguous local date-times. For example, the value "2nd October 2007 at 13:45:30.123456789 +02:20 in the Europe/Paris time-zone" can be stored in a `ZonedDateTime`. 
      > 
      > `ZonedDateTime` is not listed in official exam objectives. 

    - [ ] To create a `LocalDate` or a `LocalDateTime` object, you can use one of their several constructors. 
      > These classes do not have any public constructors. You need to use their static factory methods to get their instances. 
      > 
      > For example: 
      > 
      > ```java
      > java.time.LocalDate d1 = java.time.LocalDate.of(2015, Month.JANUARY, 31); 
      > 
      > java.time.LocalDateTime d2 = java.time.LocalDateTime.of(2015, Month.JANUARY, 31, 10, 56); 
      > 
      > java.time.LocalDateTime d3 = java.time.LocalDateTime.parse("2015-01-02T17:13:50"); 
      > //Note that this will throw a java.time.format.DateTimeParseException if the input string lacks the time component i.e. T17:13:50 
      > 
      > java.time.LocalDate d4 = java.time.LocalDate.parse("2015-01-02"); 
      > //Note that this will throw a java.time.format.DateTimeParseException if the input string contains the time component 
      > 
      > java.time.LocalTime d5 = java.time.LocalTime.parse("02:13:59.985"); 
      > //Note that this will throw a java.time.format.DateTimeParseException if the input string contains the Date component. 
      > ```

    ---

24. Which of the following statements concerning the switch construct are true? (You had to select 3 option(s)) 

    - [x] A character literal can be used as a value for a case label. 
      
    > `boolean`, `long`, `float` and `double` cannot be used. 
    
    - [x] A 'long' cannot be used as a switch variable. 
      
    > `boolean`, `long`, `float` and `double` cannot be used. 
    
    - [x] An empty switch block is a valid construct. 

    - [ ] A switch block must have a `default` label. 

    - [ ] If present, the default label must be the last of all the labels. 
      
      > Any order is valid. 

    Here are the rules for a switch statement: 
    1. Only `String`, `byte`, `char`, `short`, `int`, (and their wrapper classes `Byte`, `Character`, `Short`, and `Integer`), and enums can be used as types of a switch variable. (`String` is allowed only since Java 7). 
    2. The case constants must be assignable to switch variable. For example, if your switch variable is of class `String`, your case labels must use `String` as well. 
    3. The switch variable must be big enough to hold all the case constants. For example, if the switch variable is of type `char`, then none of the case constants can be greater than 65535 because a char's range is from 0 to 65535. 
    4. All case labels should be **COMPILE TIME CONSTANTS**. 
    5. No two of the case constant expressions associated with a switch statement may have the same value. 
    6. At most one `default` label may be associated with the same switch statement. 

    ---

25. How can you declare a method `someMethod()` such that an instance of the class is not needed to access it and all the members of the same package have access to it? 

    - [x] `public static void someMethod()` 

    - [x] `static void someMethod()` 

    - [x] `protected static void someMethod()` 

    - [ ] `void someMethod()` 

    - [ ] `protected void someMethod()` 

    - [ ] `public abstract static void someMethod()` 
      
      > static methods can't be abstract. 

    Since the question says, "...an instance of the class is not needed...", the method has to be static. 
    Also, as the question does not say that other packages should not have access to the method so public or protected is also correct. 

    ---

26. Objects of which of the following classes can be thrown using a throw statement? **(Handling Exceptions)** 

    - [ ] `Event` 

    - [ ] `Object` 

    - [x] `Throwable` 

    - [x] `Exception` 

    - [x] `RuntimeException` 

    You can only throw a `Throwable` using a `throws` clause. Exception and Error are two main subclasses of `Throwable`. 

    ---

27. In which of these variable declarations, will the variable remain uninitialized unless explicitly initialized? (You had to select 1 option(s)) 

    - [ ] Declaration of an instance variable of type int. 

    - [ ] Declaration of a static class variable of type float. 

    - [x] Declaration of a local variable of type float. 

    - [ ] Declaration of a static class variable of class Object. 

    - [ ] Declaration of an instance variable of class Object. 

    We have to explicitly initialize local variables otherwise they remain uninitialized and it will be a compile time error if such variables are accessed without getting initialized first. 
    Instance variables and static variables receive a default value if not explicitly initialized. All primitive types get a default value equivalent to 0, that is, int to 0 and float to 0.0f and so on and boolean to false. 
    The type/class of a variable does not affect whether a variable is initialized or not. 

    ---

28. A try statement must always have a ... associated with it. 

    - [ ] `catch` 

    - [ ] `throws` 

    - [ ] `finally` 

    - [x] `catch`, `finally` or both 

    - [ ] `throw` 

    A try without resources must have either a `catch` or a `finally`. It may have both as well. 
    Thus, the following constructs are valid: 

    1. 
    ```java
    try{ 
    } 
    catch(Exception e){  }  // no finally 
    ```

    2. 
    ```java
    try{ 
    } 
    finally{  }  // no catch 
    ```

    3. 
    ```java
    try{ 
    } 
    catch(Exception e) {  } 
    finally{  } 
    ```

    4. A catch can catch multiple exceptions: 
    ```java
    try{ 
    } 
    catch(Exception1 | Exception2 | Exception3 e) {  } 
    ```

    Note: try with resources (which is not on this exam) may omit catch as well as finally blocks. 

    ---

29. Which of the following classes should you use to represent just a date without any time or zone information? **(Working with Java API - Time and Date)** 

    - [ ] `java.util.Date` 

    - [ ] `java.sql.Date` 

    - [ ] `java.time.Date` 

    - [x] `java.time.LocalDate` 

    Java 8 introduces a new package `java.time` to deal with dates. The old classes such as `java.util.Date` are not recommended anymore. 

    Briefly: 
    `java.time` Package: This is the base package of new Java Date Time API. All the commonly used classes such as `LocalDate`, `LocalTime`, `LocalDateTime`, `Instant`, `Period`, `Duration` are part of this package. All of these classes are immutable and thread safe. 

    `java.time.format` Package: This package contains classes used for formatting and parsing date time objects such as `java.time.format.DateTimeFormatter`. 

    (The following two are not important for the exam.) 

    `java.time.zone` Package: This package contains classes for supporting different time zones and their rules. 

    `java.time.chrono` Package: This package defines generic APIs for non ISO calendar systems. We can extend `AbstractChronology` class to create our own calendar system. 

    `java.time.temporal` Package: This package contains temporal objects and we can use it for find out specific date or time related to date/time object. For example, we can use these to find out the first or last day of the month. You can identify these methods easily because they always have format “withXXX”. 

    ---

30. Consider the following variable declaration within the definition of an interface: 
    `int i = 10;` 
Which of the following declarations defined in a non-abstract class, is equivalent to the above? (You had to select 1 option(s)) 

    - [ ] `public static int i = 10;` 

    - [ ] `public final int i = 10;` 

    - [x] `public static final int i = 10;` 

    - [ ] `public int i = 10;` 

    - [ ] `final int i = 10;` 

    Fields in an interface are implicitly `public`, `static` and `final`. Although you can put these words in the interface definition but it is not a good practice to do so. 

    ---

31. Which of the following statements are true? (You had to select 2 option(s)) 

    - [ ] The modulus operator `%` can only be used with integer operands. 
      
    > It can be used on floating points operands also. For example, `5.5 % 3 = 2.5` 
    
    - [x] `&` can have integral as well as boolean operands. 

    - [x] The arithmetic operators `*`, `/` and `%` have the same level of precedence. 

    - [ ] `&&` can have integer as well as boolean operands. 
      
    > `!`, `&&` and `||` operate only on booleans. 
    
    - [ ] `~` can have integer as well as boolean operands. 
      
      > `~` Operates only on integral types. 

    **Note :** 
    integral types means `byte`, `short`, `int`, `long`, and, `char` 

    As per Section 4.1 of JLS 8 - 

    The integral types are `byte`, `short`, `int`, and `long`, whose values are 8-bit, 16-bit, 32-bit, and 64-bit signed two's-complement integers, respectively, and `char`, whose values are 16-bit unsigned integers representing UTF-16 code units. 

    ---

32. Which of the following statements are correct? (You had to select 3 option(s)) 

    - [x] An abstract class can be extended by an abstract or a concrete class. 

    - [x] A concrete class can be extended by an abstract class or a concrete class. 

    - [x] An interface can be extended by another interface. 

    - [ ] An interface can be extended by an abstract class. 
      
    > A class "implements" an interface. It does not "extend" an interface. 
    
    - [ ] An interface can be extended by a concrete class. 

    - [ ] An abstract class cannot implement an interface. 
      
      > Any class, whether abstract or concrete, can implement any interface. 

    ---

33. Which statements concerning conversion are true? (You had to select 4 option(s)) 

    - [x] Conversion from `char` to `long` does not need a cast. 

    - [x] Conversion from `byte` to short does not need a case. 

    - [x] Conversion from short to `char` needs a cast. 

    - [ ] Conversion from `int` to `float` needs a cast. 
      
    > It does not need a cast because a `float` can hold any value of `int`. Note that the opposite is not true because of the loss of precision. 
    
    - [x] Conversion from `byte`, `char`, or `short` to `int`, `long` or `float` does not need a case. 
      
      > Because `int`, `long`, or `float` are bigger than `byte` `char` or `short`. 

    Think of it as transferring the contents of one bucket into another. You can always transfer the contents of a smaller bucket to a bigger one. But the opposite is not always possible. You can transfer the contents of the bigger bucket into the smaller bucket only if the actual content in the bigger bucket can fit into the smaller one. Otherwise, it will spill. 

    It is the same with integral types as well. `byte` is smaller than `short` or int. So you can assign a `byte` to an `int` (or an `int` to a `float`, or a `float` to a `double`) without any cast. But for the reverse, you need to assure the compiler that the actual contents in my `int` will be smaller than a `byte` so let me assign this `int` to a `byte`. This is achieved by the cast. 

    ```java
    int i = 10; 
    byte b = 20; 
    b = i;//will not compile because byte is smaller than int 
    b = (byte) i; //OK 
    ```

    Further, if you have a final variable and its value fits into a smaller type, then you can assign it without a cast because the compiler already knows its value and realizes that it can fit into the smaller type. This is called implicit narrowing and is allowed between `byte`, `int`, `char`, and, `short` but not for `long`, `float`, and `double`. 

    ```java
    final int k = 10; 
    b = k; //Okay because k is final and 10 fits into a byte 
    final float f = 10.0;//will not compile because 10.0 is a double even though the value 10.0 fits into a float 
    i = f;//will not compile. 
    ```

    ---

34. Which of the following statements are correct regarding a functional interface? **(Lambda Expressions)** 

    - [ ] It has exactly one method and it must be abstract. 

    - [ ] It has exactly one method and it may or may not be abstract. 

    - [x] It must have exactly one abstract method and may have other default or static methods. 

    - [ ] It must have exactly one static method and may have other default or abstract methods. 

    A functional interface is an interface that contains exactly one abstract method. It may contain zero or more default methods and/or static methods. Because a functional interface contains exactly one abstract method, you can omit the name of that method when you implement it using a lambda expression. For example, consider the following interface - 

    ```java
    interface Predicate<T> { 
      boolean test(T t); 
    } 
    ```

    The purpose of this interface is to provide a method that operates on an object of class `T` and returns a boolean. 

    You could have a method that takes an instance of class that implements this interface defined like this - 
    ```java
    public void printImportantData(ArrayList<Data> dataList, Predicate<Data> p){ 
      for(Data d: dataList) { 
        if(p.test(d)) System.out.println(d); 
      } 
    } 
    ```

    where Data class could be as simple as `public class Data { public int value;}` 

    Now, you can call the above method as follows: 

    `printImportantData(al, (Data d)->{ return d.value>1;});` 

    Notice the lack of method name here. This is possible because the interface has only one abstract method so the compiler can figure out the name. This can be shortened to: 

    `printImportantData(al, (Data d)->d.value>1);` 

    Notice the lack of curly brackets, the `return` keyword, and the semicolon. This is possible because the method returns a boolean and the expression `d.value>1` also returns a boolean. The compiler is, therefore, able to figure out that the value of this expression is to be returned from the method. This can be shortened even more to: 

    `printImportantData(al, d->d.value>1);` 

    Notice that there is no declaration of d! The compiler can figure out all the information it needs because the interface has only one abstract method and that method has only one parameter. So you don't need to write all those things in your code. 

    Compare the above approach to the old style using an inner class that does the same thing - 

    ```java
    printImportantData(al, new Predicate<Data>() { 
      public boolean test(Data d) { 
        return d.value > 1; 
      } 
    }); 
    ```
    The `Predicate` interface described above can be used anywhere there is a need to "do something with an object and return a boolean" and is actually provided by the standard java library in `java.util.function` package. This package provides a few other useful functional interfaces. 

    `Predicate<T>` Represents a predicate (boolean-valued function) of one argument of type `T`. 

    `Consumer<T>` Represents an operation that accepts a single input argument of type `T` and returns no result. 

    `Function<T,R>` Represents a function that accepts one argument of type `T` and produces a result of type `R` 

    `Supplier<T>` Represents a supplier of results of type `T`. 

    For the exam, you only need to be aware of `Predicate`. 

    Please see [Lambda Expressions](http://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html) for learning Lambda expressions in Java. 

#### 结束 

这个错题整理也太长了，到这里结束了，其他内容放到其他文章。 