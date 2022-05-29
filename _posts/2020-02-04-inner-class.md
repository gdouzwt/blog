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

一个类也可以声明在另一个类里面。这种类称为*内部类*。如果定义在另一个类中的类显式或隐式被声明为static，则它被称为嵌套类，而不是内部类。包含内部类的类称为*外层类*或*外部类*。看一下下面的 `Outer` 和 `Inner` 类声明：

```java
// Outer.java
pakcage io.zwt.innerclasses;

public class Outer {
	public class Inner {
		// 内部类的成员在这里
	}
	// 外部类的其它成员在这里
}
```

一个内部类实例只能存在于其外部类实例内。也就是说，你在创建内部类实例之前必须要有一个外部类的实例。这个规则在规范一个对象不能脱离另一个对象而存在这方面很有用。内部类可以完全访问到它的外部类的所有成员，包括私有成员。<!--more-->

### 使用内部类的好处

- 可以将一个类定义在它的使用者附近。例如，一个计算机有处理器，所以最好将 `Processor` 类定义为 `Computer` 类的内部类。
- 它们提供了额外管理类结构的命名空间。例如，在未有内部类之前，一个类只能是包的成员。有了内部类，包含内部类的顶层类，提供了额外的命名空间。
- 某些设计模式用内部类实现更简单。例如，适配器模式，枚举模式，还有状态模式，都可以用内部类轻松实现。
- 用内部类实现回调机制优雅且方便。Java 8 的 Lambda 表达式是一种更好且更简洁的回调实现方式。
- 有助于在 Java 实现闭包。
- 使用内部类你可以体验一种类的多继承。一个内部类可以继承其它类。因此，内部类可以访问它的外部类成员，以及它的超类成员。注意，访问两个以上类的成员是多继承的目标之一，这可以通过使用内部类实现。然而，只是可以访问两个类的成员，并不是真正意义上的多继承。

### 内部类的种类

你可以在类的任意可以写 Java 语句的位置定义一个内部类，有三种内部类。它们的类型取决于声明所在的位置和声明的方式。

- 成员内部类
- 局部内部类
- 匿名内部类

#### 成员内部类

成员内部类和成员字段或成员方法一样声明在一个类里面。可以声明为 `public`, `private`, `protected` 或者是包级别访问权限。其实例仅在外部类存在的条件下才存在。

#### 局部内部类

局部内部类声明在块内。它的作用范围受限于它声明所在的块。由于它作用范围始终受限于块，它的声明不可以使用任何访问修饰符，例如 `public`, `private` 或 `protected`。 通常局部内部类定义在一个方法内。然而，它也可以被定义在静态初始化块，实例初始化块，以及构造器内。当只在块内使用一个类，你可以使用局部内部类。

  要在块外使用局部内部类，它必须符合以下至少一项：

- Implement a public interface 实现一个公有接口
- 继承自另一个公有类，并重写它的超类方法。

#### 匿名内部类

匿名内部类跟局部内部类同样，除了一个区别：它没有名字。因为它没有名字，所以没有构造器。

### 静态成员类不是内部类

在另一个类中定义的成员类可以声明为 `static`。 以下代码声明了一个顶层类 `A` 和一个静态成员类 `B`：

```java
package io.zwt.innnerclasses;
public class A {
	// A static member class
	public static class B {
		// The body of class B goes here
	}
}
```

一个静态成员类不是内部类。它被看作是顶层类。它亦被称为嵌套顶层类。因为它是一个顶层类，你不需要它的外层类的实例去创建它的对象。一个类 A 的实例和类 B 的实例可以独立地存在，因为它们都是顶层类。一个静态成员类可以声明为 `public`, `protected`，包访问级别，或者是` private` 以限制它在外层类之外的访问权限。

### 创建内部类对象

创建局部内部类，匿名内部类，和静态成员类是非常直接的。局部内部类的对象在声明所在的内使用 `new` 创建对象。匿名内部类的对象在声明时候创建对象。静态成员类是另一类顶层类，其对象创建方式跟顶层类一样。

### 访问外层类的成员

### 局部变量访问的限制

A local inner class is declared inside a block—typically inside a method of a class. A local inner class can access the instance variables of its enclosing class as well as the local variables, which are in scope. The instance of an inner class exists within an instance of its enclosing class. Therefore, accessing the instance variables of the enclosing class inside a local inner class is not a problem because they exist throughout the lifecycle of the instance of the local inner class. However, the local variables in a method exist only during the execution of that method. All local variables become inaccessible when method execution is over. Java makes a copy of the local variables that are used inside a local inner class and stores that copy along with the inner class object. However, to guarantee that the values of the local variables can be reproduced when accessed inside the local inner class code after the method call is over, Java puts a restriction that the local variables must be effectively final. An effectively final variable is a variable whose value does not change after it is initialized. One way to have an effectively final variable is to declare the variable final. Another way is not to change its value after it is initialized. Therefore, a local variable or an argument to a method must be effectively final if it is used inside a local inner class. This restriction also applies to an anonymous inner class declared inside a method.

> **提示** 在 Java 8 以前，如果一个局部变量是被局部内部类，或者匿名内部类访问的，它必须被声明为 `final`。 Java 8 更改了这个规则：局部变量不需要被声明为 `final`， 但它应该是 effectively final 的。 什么意思呢？就是说，在变量声明前面添加个 `final` 修饰符，仍然能够通过编译，相当于 `final`，就是所谓的 "effective final" ，就等效于 `final` 嘛。

### 内部类与继承

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

### 内部类中不能有静态成员（除非是编译时常量）

Java 里面的 `static` 关键字使得一个结构变成顶层结构。因此，你不能在一个内部类里边定义任何静态成员（字段、方法或者是初始化语句块）。以下代码不能通过编译，因为内部类 `B` 声明了一个静态字段 `DAYS_IN_A_WEEK`:

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

        // Cannot have the following declaration, because it is not
        // a compile-time constant, even though it is final
        public final static String str = new String("Hello");
		// 可以用 public final static String str = "Hello"; 是常量
    }
}
```

> 注意 成员接口和成员枚举是隐式 static 的，因此不能声明在内部类里。

### 内部类和编译器的魔法

成员内部类和嵌套内部类：

`<outer-class-name>$<member-or-nested-class-name>`

局部内部类：

`<outer-class-name>$<a-number><local-inner-class-name>`
匿名内部类：

`<outer-class-name>$<a-number>`

### 闭包与回调

In functional programming, a higher order function is an anonymous function that can be treated as a data object. That is, it can be stored in a variable and passed around from one context to another.  It might be invoked in a context that did not necessarily define it. Note that a higher order function is an anonymous function, so the invoking context does not have to know its name. A closure is a higher order function packaged with its defining environment. A closure carries with it the variables in scope when it was defined, and it can access those variables even when it is invoked in a context other than the context in which it was defined.

### 在静态上下文定义内部类

很少有用到，发现 static {} 里面可以放 {} 这样



