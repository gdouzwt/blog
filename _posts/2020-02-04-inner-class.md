---
typora-root-url: ../
layout:     post
title:      Java 内部类
date:       '2020-02-04T22:34'
subtitle:   Inner Class
author:     招文桃
catalog:    true
tags:
    - Java
    - 语言特性
---

> 在这一篇文章，你将会学习到：
>
> - 内部类是什么
> - 如何声明内部类
> - 如何声明成员、局部，以及匿名内部类
> - 如何创建内部类的对象

### 什么是内部类？

我们知道类（class）是包（package）的成员（member）。即顶层类，直接放在包下面的类。例如以下这段代码：

```java
// TopLevel.java
package io.zwt.innerclasses;

public class TopLevel {
    private int value = 101;
    
    public int getValue() {
        return value;
    }
    
    public void setValue(int value) {
        this.value = value;
    }
}
```

上面的 `TopLevel` 类是 `io.zwt.innerclasses` 包的成员。 这个里有三个成员：

- 一个实例变量（instance variable）：`value`
- 两个方法（method）：`getValue()` and `setValue()`

A class can also be declared within another class. This type of class is called an *inner* class. If the class declared within another class is explicitly or implicitly declared static, it is called a nested class, not an inner class. The class that contains the inner class is called an *enclosing* class or an *outer* class. Consider the following declaration of the `Outer` and `Inner` classes:

一个类也可以声明在另一个类里面。这种类称为*内部类*。如果定义在另一个类中的类显式或隐式被声明为static，则它被称为嵌套类，而不是内部类。

```java
// Outer.java
pakcage io.zwt.innerclasses;

public class Outer {
	public class Inner {
		// Members of the Inner class go here
	}
	// Other members of the Outer class go here
}
```

An instance of an inner class can only exist within an instance of its enclosing class. That is, you must have an instance of the enclosing class before you can create an instance of an inner class. This is useful in enforcing the rule that one object cannot exist without the other.

An inner class has full access to all the members, including private members, of its enclosing class.<!--more-->

### Advantages of Using Inner Classes

- They let you define classes near other classes that will use them. For example, a computer will use a processor, so it is better to define a `Processor` class as an inner class of the `Computer` class.
- They provide an additional namespace to manage class structures. For example, before the introduction of inner classes, a class can only be a member of a package. With the introduction of inner classes, top-level classes, which can contain inner classes, provide an additional namespace.
- Some design patterns are easier to implement using inner classes. For example, the adapter pattern, enumeration pattern, and state pattern can be easily implemented using inner classes.
- Implementing a callback mechanism is elegant and convenient using inner classes. Lambda expressions in Java 8 offer a better and more concise way of implementing callbacks in Java. 
- It helps implement closures in Java.
- You can have a flavor of multiple inheritance of classes using inner classes. An inner class can inherit another class. Thus, the inner class has access to its enclosing class members as well as members of its superclass. Note that accessing members of two or more classes is one of the aims of multiple inheritance, which can be achieved using inner classes. However, just having access to members of two classes is not multiple inheritance in a true sense.

### Types of Inner Classes

You can define an inner class anywhere inside a class where you can write a Java statement. There are three types of inner classes. The type of an inner class depends on the location of its declaration and the way it is declared.

- Member inner class
- Local inner class
- Anonymous inner class

#### Member inner class

A member inner class is declared inside a class the same way a member field or a member method for the class is declared. It can be declared as `public`, `private`, `protected`, or package-level. The instance of a member inner class may exist only within the instance of its enclosing class.

#### Local inner class

A local inner class is declared inside a block. Its scope is limited to the block in which it is declared. Since it's scope is always limited to its enclosing block, its declaration cannot use any access modifiers such as `public`,   `private`, or `protected`. Typically, a local inner class is defined inside a method. However, it can also be defined in side static initializers, non-static initializers, and constructors. You would use a local inner class when you need to use the class only inside a block.

​	To use a local inner class outside its enclosing block, the local inner class must do one or both of the following:

- Implement a public interface
- Inherit from another public class and override some of its superclass methods

#### Anonymous Inner Class

An anonymous inner class is the same as a local inner class with one difference: it does not have a name. Since it does not have a name, it cannot have a constructor.

### A static Member Class Is Not an Inner Class

A member class defined within the body of another class may be declared `static`. The following snippet of code declares a top-level class `A` and a static member class `B`:

```java
package io.zwt.innnerclasses;
public class A {
	// A static member class
	public static class B {
		// The body of class B goes here
	}
}
```

​	A static member class is not an inner class. It is considered a top-level class. It is also called a nested top-level class. Since it is a top-level class, you do not need an instance of its enclosing class to create its object. An instance of class A and an instance of class B can exist independently because both are top-level classes. A static member class can be declared `public`, `protected`, package-level, or `private` to restrict its accessibility outside its enclosing class.

### Create Objects of Inner Classes

Creating objects of a local inner class, an anonymous class, and a static member class is straightforward. Objects of a local inner class are created using the new operator inside the block, which declares the class. An object of an anonymous class is created at the same time the class is declared. A static member class is another type of top-level class. You create objects of a static member class the same way you create objects of a top-level class.

Note that to have an object of a member inner class, a local inner class, and an anonymous class, you must have an object of the enclosing class. In the previous examples of local inner classes and anonymous inner classes, you placed these classes inside instance methods. You had an instance of the enclosing class on which you called those instance methods. Therefore, instances of those local inner classes and anonymous inner classes had the instance of their enclosing classes on which those methods were called. For example, in Listing 2-5, first you created an instance of `TitleList` class and you stored its reference in t1 as shown:

### Accessing Enclosing Class Members

### Restrictions on Accessing Local Variables

A local inner class is declared inside a block—typically inside a method of a class. A local inner class can access the instance variables of its enclosing class as well as the local variables, which are in scope. The instance of an inner class exists within an instance of its enclosing class. Therefore, accessing the instance variables of the enclosing class inside a local inner class is not a problem because they exist throughout the lifecycle of the instance of the local inner class. However, the local variables in a method exist only during the execution of that method. All local variables become inaccessible when method execution is over. Java makes a copy of the local variables that are used inside a local inner class and stores that copy along with the inner class object. However, to guarantee that the values of the local variables can be reproduced when accessed inside the local inner class code after the method call is over, Java puts a restriction that the local variables must be effectively final. An effectively final variable is a variable whose value does not change after it is initialized. One way to have an effectively final variable is to declare the variable final. Another way is not to change its value after it is initialized. Therefore, a local variable or an argument to a method must be effectively final if it is used inside a local inner class. This restriction also applies to an anonymous inner class declared inside a method.

> **提示** 在 Java 8 以前，如果一个局部变量是被局部内部类，或者匿名内部类访问的，它必须被声明为 `final`。 Java 8 更改了这个规则：局部变量不需要被声明为 `final`， 但它应该是 effectively final 的。 什么意思呢？就是说，在变量声明前面添加个 `final` 修饰符，仍然能够通过编译，相当于 `final`，就是所谓的 "effective final" ，就等效于 `final` 嘛。

### Inner Class and Inheritance

An inner class can inherit from another inner class, a top-level class, or its enclosing class. For example, in the following snippet of code, inner class C inherits from inner class B; inner class D inherits from its enclosing top-level class A, and inner class F inherits from inner class A.B:

```java
public class A {
    public class B {
    }
    public class C extends B {
    }
    public class D extends A {
    }
}

public class E extends A {
    public class F extends B {
        
    }
}

public class G extends A.B {
    // This code won't compile
    // 这段代码不能通过编译！
}

```



### No static Members in a Inner Class

The keyword static in Java makes a construct a top-level construct. Therefore, you cannot declare any static members (fields, methods, or initializers) for an inner class. The following code will not compile because inner class B declares a static field DAYS_IN_A_WEEK:

Java 里面的 `static` 关键字使得一个结构变成顶层结构。因此，你不能在一个内部类里边定义任何静态成员（字段、方法或者是初始化语句块）。以下代码不能通过编译，因为内部类 B 声明了一个静态字段 DAYS_IN_A_WEEK:

```java
public class A {
    public class B {
        // Cannot have the following declaration
        public static int DAYS_IN_A_WEEK = 7; // A compile-time error
    }
}
```

然而，内部类里面可以有性质为编译时常量的静态字段。什么意思？请看以下代码：

```java
public class A {
    public class B {
        // Can have a compile-time static constant field
        public final static int DAYS_IN_A_WEEK = 7; // OK
        // a compile-time constant, even though it is final
        // 上面一句不对，str 不能用 new String("Hello");
        // 可以用 public final static String str = "Hello";
        public final static String str = new String("Hello");
    }
}
```




### Inner Classes and the Compiler Magic

### Closures and Callbacks

In functional programming, a higher order function is an anonymous function that can be treated as a data object. That is, it can be stored in a variable and passed around from one context to another.  It might be invoked in a context that did not necessarily define it. Note that a higher order function is an anonymous function, so the invoking context does not have to know its name. A closure is a higher order function packaged with its defining environment. A closure carries with it the variables in scope when it was defined, and it can access those variables even when it is invoked in a context other than the context in which it was defined.

### Defining Inner Classes in static Contexts

### Summary