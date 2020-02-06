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
---

### Inner Class

A class can also be declared within another class. This type of class is called an *inner* class. If the class declared within another class is explicitly or implicitly declared static, it is called a nested class, not an inner class. The class that contains the inner class is called an *enclosing* class or an *outer* class. Consider the following declaration of the `Outer` and `Inner` classes:

```java
// Outer.java
pakcage com.jdojo.innerclasses;

public class Outer {
	public class Inner {
		// Members of the Inner class go here
	}
	// Other members of the Outer class go here
}
```

An instance of an inner class can only exist within an instance of its enclosing class. That is, you must have an instance of the enclosing class before you can create an instance of an inner class. This is useful in enforcing the rule that one object cannot exist without the other.

An inner class has full access to all the members, including private members, of its enclosing class.

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
package com.jdojo.innnerclasses;
public class A {
	// A static member class
	public static class B {
		// The body of class B goes here
	}
}
```

​	A static member class is not an inner class. It is considered a top-level class. It is also called a nested top-level class. Since it is a top-level class, you do not need an instance of its enclosing class to create its object. An instance of class A and an instance of class B can exist independently because both are top-level classes. A static member class can be declared `public`, `protected`, package-level, or `private` to restrict its accessibility outside its enclosing class.







---

### Closures and Callbacks

In functional programming, a higher order function is an anonymous function that can be treated as a data object. That is, it can be stored in a variable and passed around from one context to another. It might be invoked