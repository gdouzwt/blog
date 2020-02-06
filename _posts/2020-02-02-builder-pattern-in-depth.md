---
typora-root-url: ../
layout:     post
title:      深入生成器设计模式
date:       '2020-02-02T18:42'
subtitle:   Builder Pattern in Depth
author:     招文桃
catalog:    true
tags:
    - Design Pattern
    - 设计模式
---

### Builder Pattern

#### GoF Definition

> Separate the construction of a complex object from its representation so that the same construction processes can create different representations.
>
> 将一个复杂对象的构建与它的表示分离，使得同样的构建过程可以创建不同表示。（中文版书里的翻译）

Builder 在《设计模式》的中文版里边翻译为“生成器”，那我就按这个译法吧。生成器模式属于创建型模式（Creational patterns），它关注如何创建对象。当需要构建的对象比较复杂，由多个部分组成，也就说它的构造方法会有很多参数。生成器模式认为对象的构建机制应该独立于它的组成部分（也就是属性），对象的**构建过程**不关注对象的**组成部分**。所以同一个构建过程可以构建出不同表示（属性）的对象。在 GoF 书中的生成器模式 UML 类图如下：

![Builder](/img/builder-pattern.png)

上图中，Product 是所要创建的复杂对象，ConcreteBuilder 类表示具体的生成器，它实现了 Builder 接口，负责组装构成最终对象的各部分。ConcreteBuilder 定义了**构建过程**和**对象组装机制**，就是如何用各部分、按照怎样的步骤去构造一个 Product 对象。ConcreteBuilder 还定义了 getResult() 方法，用于返回构建好的 Product 对象。然后 Director 则是负责通过使用 Builder 接口去构建最终所需的 Product 对象，就是做指挥的。

以上是经典的

### 问题







模式的4个元素：

模式名称

适用于该模式的待解决的问题

解决方案

效果

### 结论

### 参考

- [Gamma95] Gamma, Erich, Richard Helm, Ralph Johnson, and John Vlissides. 1995. *Design Patterns: Elements of Reusable Object-Oriented Software.* Reading, MA: Addison-Wesley. ISBN: 0201633612
- Sarcar, Vaskaran. *Design Patterns in Java, Second Edition.* Apress, 2019
- [Springframework guru: Builder Pattern](https://springframework.guru/gang-of-four-design-patterns/builder-pattern/)
- 

