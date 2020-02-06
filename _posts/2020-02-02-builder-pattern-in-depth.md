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

### 具体简单例子

在这个例子里会有这些参与者：Builder, Car, MotorCycle, Product, 以及 Director。其中，Car, MotorCycle 是实现了 Builder 接口的具体类。Builder 是用于构建 Product 对象的各部分，Product 则是要创建的负责对象（也就是小车或者摩托车）。因为 Car 和 MotorCycle 都实现了 Builder 接口，所以需要实现接口中的方法，即 `startUpOperations()`, `buildBody()`, `insertWheels()`, `addHeadLights()`, `endOperations()`, 和 `getVehicle()` 方法。前五个方法好理解，就是对应载具的构建过程，开始，构建车身，装轮子，装头灯，收尾。而 `getVehicle()` 方法，就是返回已构建好的载具。 然后还有 Director，它调用同一个 `construct()` 方法去构建不同类型的载具。这个具体例子的类图如下：

![builder-pattern-vehicles](/img/builder-pattern-vehicles.png)

#### 代码实现

```java
package jdp2e.builder.demo;

import java.util.LinkedList;

//The common interface
// 公共接口
interface Builder {
	void startUpOperations();

	void buildBody();

	void insertWheels();

	void addHeadlights();

	void endOperations();

	/* The following method is used to retrieve the object that is constructed. */
	Product getVehicle();
}

//Car class
class Car implements Builder {
	private String brandName;
	private Product product;

	public Car(String brand) {
		product = new Product();
		this.brandName = brand;
	}

	public void startUpOperations() {
		// Starting with brand name
		product.add(String.format("Car model is :%s", this.brandName));
	}

	public void buildBody() {
		product.add("This is a body of a Car");
	}

	public void insertWheels() {
		product.add("4 wheels are added");
	}

	public void addHeadlights() {
		product.add("2 Headlights are added");
	}

	public void endOperations() { // Nothing in this case
	}

	public Product getVehicle() {
		return product;
	}
}

//Motorcycle class
class MotorCycle implements Builder {
	private String brandName;
	private Product product;

	public MotorCycle(String brand) {
		product = new Product();
		this.brandName = brand;
	}

	public void startUpOperations() { // Nothing in this case
	}

	public void buildBody() {
		product.add("This is a body of a Motorcycle");
	}

	public void insertWheels() {
		product.add("2 wheels are added");
	}

	public void addHeadlights() {
		product.add("1 Headlights are added");
	}

	public void endOperations() {
		// Finishing up with brand name
		product.add(String.format("Motorcycle model is :%s", this.brandName));
	}

	public Product getVehicle() {
		return product;
	}
}

// Product class 
class Product {
	/*
	 * You can use any data structure that you prefer. I have used
	 * LinkedList<String> in this case.
	 */
	private LinkedList<String> parts;

	public Product() {
		parts = new LinkedList<String>();
	}

	public void add(String part) {
		// Adding parts
		parts.addLast(part);
	}

	public void showProduct() {
		System.out.println("\nProduct completed as below :");
		for (String part : parts)
			System.out.println(part);
	}
}

// Director class 
class Director {
	Builder builder;

	// Director knows how to use the builder and the sequence of steps.
	public void construct(Builder builder) {
		this.builder = builder;
		builder.startUpOperations();
		builder.buildBody();
		builder.insertWheels();
		builder.addHeadlights();
		builder.endOperations();
	}
}

public class BuilderPatternExample {

	public static void main(String[] args) {
		System.out.println("***Builder Pattern Demo***");
		Director director = new Director();

		Builder fordCar = new Car("Ford");
		Builder hondaMotorycle = new MotorCycle("Honda");

		// Making Car
		director.construct(fordCar);
		Product p1 = fordCar.getVehicle();
		p1.showProduct();

		// Making MotorCycle
		director.construct(hondaMotorycle);
		Product p2 = hondaMotorycle.getVehicle();
		p2.showProduct();
	}
}

```

输出结果：

> \*\*\*Builder Pattern Demo\*\*\*
>
> Product completed as below :
> Car model is :Ford
> This is a body of a Car
> 4 wheels are added
> 2 Headlights are added
>
> Product completed as below :
> This is a body of a Motorcycle
> 2 wheels are added
> 1 Headlights are added
> Motorcycle model is :Honda

### Q & A 

1. 使用生成器模式有什么好处?
2. 生成器模式的坏处？
3. 在上面例子中我可以使用抽象类而不是接口吗？
4. 如何确定应该使用抽象类还是接口？
5. 上面例子中，在 Car 里，brand name 在第一步添加了，而在 MotorCycle 里， brand name 在最后一步添加，这是故意的吗？
6. 为什么使用单独一个类作为 Director？应该可以使用客户端代码（client code）充当 Director 的角色啊。
7. 客户端代码（client code）是什么意思？
8. 前面多次提到改变构建步骤。能否演示一下通过改变构建步骤产生不同的最终产品？

### 改进版例子



### 结论

### 参考

- [Gamma95] Gamma, Erich, Richard Helm, Ralph Johnson, and John Vlissides. 1995. *Design Patterns: Elements of Reusable Object-Oriented Software.* Reading, MA: Addison-Wesley. ISBN: 0201633612
- Sarcar, Vaskaran. *Design Patterns in Java, Second Edition.* Apress, 2019
- [Springframework guru: Builder Pattern](https://springframework.guru/gang-of-four-design-patterns/builder-pattern/)
- Joshua Block. *Effective Java, Third Edition.* Addison-Wesley, 2018

