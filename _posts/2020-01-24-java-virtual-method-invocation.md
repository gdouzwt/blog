---
typora-root-url: ../
layout:     post
title:      Java虚方法调用
date:       '2020-01-24T20:04'
subtitle:   Java virtual method invocation
author:     招文桃
catalog:    true
tags:
    - Java
---

### 先回顾基本概念 Overloading and Overriding

主要需要总结的是:

​	When multiple overloaded methods are present, Java looks for the closest match first. It tries to find the following:

- Exact match by type
- Matching a superclass type
- Converting to larger primitive type
- Converting to an autoboxed type
- Varargs

For overriding, the overridden method has a few rules:

- The access modifier must be the same or more accessible.
- The return type must be the same or a more restrictive type, also known as *covariant return types*.
- If any checked exceptions are thrown, only the same exceptions or subclasses of those exceptions are allowed to be thrown.

The method must not be static. (If they are, the method is hidden and not overridden.)



#### 关于 instanceof 操作符，null 的情况，null 不是 Object.

instanceof 不能比较没有任何继承关系的类。 而接口可以，因为接口可以被实现。

然后入正题:

### Understanding Virtual Method Invocation

先看代码：

```java
abstract class Animal {
	public abstract void feed();
}

class Cow extends Animal {
	public void feed() { addHay(); }
	private void addHay() { }
}

class Bird extends Animal {
    public void feed() { addSeed(); }
    private void addSeed() { }
}

class Lion extends Animal {
    public void feed() { addMeat(); }
    private void addMeat() { }
}
```

The Animal class is abstract, and it requires that any concrete Animal subclass have a feed() method. The three subclasses that we defined have a one-line feed() method that delegates to the class-specific method. A Bird still gets seed, a Cow still gets hay, and so forth. Now the method to feed the animals is really easy. We just call feed() and the proper subclass's version is run.

​	This approach has a huge advantage. The feedAnimal() method doesn't need to change when we add a new Animal subclass. We could have methods to feed the animals all over code. Maybe the animals get fed at different times on different days. No matter. feed() still gets called to do the work.

```java
public void feedAnimal(Animal animal) {
	animal.feed();
}
```

​	We've just relied on virtual method invocation. We actually saw virtual methods on the OCA. They are just regular non-static methods. Java looks for an overridden method rather than necessarily using the one in the class that the compiler says we have. The only thing new about virtual methods on OCP is that Oracle now calls them virtual methods in the objectives. You can simply think of them as methods.

​	In the above example, we have an Animal instance, but Java didn't call feed on the Animal class. Instead Java looked at the actual type of animal at runtime and called feed on that.

​	Notice how this technique is called virtual method invocation. **Instance variables don't work this way.** In this example, the Animal class refers to name. It uses the one in the superclass and not the subclass.

```java
abstract class Animal {
    String name = "???";
    public void printName() {
        System.out.println(name);
    }
}

class Lion extends Animal {
    String name = "Leo";
}

public class PlayWithAnimal {
    public static void main(String[] args) {
        Animal animal = new Lion();
        animal.printName();
    }
}
```

​	This outputs ???. The name declared in Lion would only be used if name was referred to from Lion (or a subclass of Lion.) But no matter how you call printName(), it will use the Animal's name, not the Lion's name.

​	Aside from the formal sounding name, there isn't anything new here. Let's try one more example to make sure that the exam can't trick you. What does the following print?

```java
abstract class Animal {
    public void careFor() {
        play();
    }
    public void play() {
        System.out.println("pet animal");
    }}
class Lion extends Animal {
    public void play() {
        System.out.println("toss in meat");
    }}
public class PalyWithAnimal {
    public static void main(String[] args) {
        Animal animal = new Lion();
        animal.careFor();
    }}
```

​	This correct answer is *toss in meat*. The main method creates a new Lion and calls careFor. Since only the Animal superclass has a careFor method, it executes. That method calls play. Java looks for overridden methods, and it sees that Lion implements play. Even though the call is from the Animal class, Java still looks at subclasses, which is good because you don't want to pet a Lion!