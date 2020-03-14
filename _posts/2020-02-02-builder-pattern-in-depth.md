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

### GoF 定义

> Separate the construction of a complex object from its representation so that the same construction processes can create different representations.
>
> 将一个复杂对象的构建与它的表示分离，使得同样的构建过程可以创建不同表示。（中文版书里的翻译）

Builder 在《设计模式》的中文版里边翻译为“生成器”，那我就按这个译法吧。生成器模式属于创建型模式（Creational patterns），它关注如何创建对象。当需要构建的对象比较复杂，由多个部分组成，也就说它的构造方法会有很多参数，就可以考虑使用这种模式。生成器模式认为对象的构建机制应该独立于它的组成部分（也就是属性），对象的**构建过程**不关注对象的**组成部分**。所以同一个构建过程可以构建出不同表示（属性）的对象（通过**改变构建步骤**）。<!--more-->在 GoF 书中的生成器模式 UML 类图如下：

![Builder](/img/builder-pattern.png)

上图中，Product 是所要创建的复杂对象，ConcreteBuilder 类表示具体的生成器，它实现了 Builder 接口，负责组装构成最终对象的各部分。ConcreteBuilder 定义了**构建过程**和**对象组装机制**，就是如何用各部分、按照怎样的步骤去构造一个 Product 对象。ConcreteBuilder 还定义了 getResult() 方法，用于返回构建好的 Product 对象。然后 Director 则是负责通过使用 Builder 接口去构建最终所需的 Product 对象，就是做指挥的。

以上是对经典的 GoF 生成器模式的解读，下面结合具体的例子加深理解。

### 具体简单例子

在这个例子里会有这些参与者：Builder, Car, MotorCycle, Product, 以及 Director。其中，Car, MotorCycle 是实现了 Builder 接口的具体类。Builder 用于构建 Product 对象的各部分，Product 则是要被创建的复杂对象（小车或摩托车）。因为 Car 和 MotorCycle 都实现了 Builder 接口，所以需要实现接口中的方法，即 `startUpOperations()`, `buildBody()`, `insertWheels()`, `addHeadLights()`, `endOperations()`, 和 `getVehicle()` 方法。前五个方法好理解，对应载具的构建过程，开始，构建车身，装轮子，装头灯，收尾。而 `getVehicle()` 方法，就是返回已构建好的载具。 然后还有 Director，它调用同一个 `construct()` 方法去构建不同类型的载具。这个具体例子的类图如下：

![builder-pattern-vehicles](/img/builder-pattern-vehicles.png)

#### 代码实现

```java
import java.util.LinkedList;

// 公共接口
interface Builder {
	void startUpOperations();
	void buildBody();
	void insertWheels();
	void addHeadlights();
	void endOperations();

	/* 用于获取已经构建好的对象的方法。*/
	Product getVehicle();
}

// Car 类
class Car implements Builder {
	private String brandName;
	private Product product;

	public Car(String brand) {
		product = new Product();
		this.brandName = brand;
	}

	public void startUpOperations() {
		// 开始就设置品牌名称
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

// Motorcycle 类
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
		// 添加品牌名称作为收尾
		product.add(String.format("Motorcycle model is :%s", this.brandName));
	}

	public Product getVehicle() {
		return product;
	}
}

// Product 类 
class Product {
	/*
	 * 你可以使用任何数据结构，这里使用
	 * LinkedList<String> 
	 */
	private LinkedList<String> parts;

	public Product() {
		parts = new LinkedList<String>();
	}

	public void add(String part) {
		// 添加部件
		parts.addLast(part);
	}

	public void showProduct() {
		System.out.println("\nProduct completed as below :");
		for (String part : parts)
			System.out.println(part);
	}
}

// Director 类 
class Director {
	Builder builder;

	// Director 知道如何使用 builder 以及调用步骤。
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

		// 造小车 Car
		director.construct(fordCar);
		Product p1 = fordCar.getVehicle();
		p1.showProduct();

		// 造摩托 MotorCycle
		director.construct(hondaMotorycle);
		Product p2 = hondaMotorycle.getVehicle();
		p2.showProduct();
	}
}

```

**输出结果：**

```console
***Builder Pattern Demo***

Product completed as below :
Car model is :Ford
This is a body of a Car
4 wheels are added
2 Headlights are added

Product completed as below :
This is a body of a Motorcycle
2 wheels are added
1 Headlights are added
Motorcycle model is :Honda
```

### Q & A 

1. 使用生成器模式有什么好处?

   - 你可以用生成器模式逐步构建复杂对象，并且可以改变构建步骤。通过隐藏构建复杂对象的细节（构建每部分的细节），加强了封装性。 Director 可以从 Builder 获取最终构建完成的 Product，在表面看了就好像只有一个方法（construct()）用于构建最终产品，其他的内部方法只是涉及构建具体的部分。
   - 使用这种模式，同样的构建过程，可以产生不同的产品。
   - 因为你可以改变构造步骤，所以你可以改变产品的内部表示。

2. 生成器模式的坏处？

   - 不适用于处理可变对象（mutable object），即创建后可被修改的对象。
   - 可能需要写些重复代码，例如不同的具体生成器有些代码类似或重复，某些情况下可能会有不好的影响，并可能成为*[反模式](https://blog.csdn.net/jiangpingjiangping/article/details/78067595)*。
   - 一个具体的生成器专用于产生某类产品，所以要生产另一类产品，就需要编写一个用于该类产品的具体生成器。
   - 生成器模式只有在构建比较复杂的对象时用才有优势。

3. 在上面例子中我可以使用抽象类而不是接口吗？

   - 可以的。你可以使用抽象类，而不是用接口。

4. 如何确定应该使用抽象类还是接口？

   - 如果你想要一些集中的或是默认的行为，那么抽象类是更好的选择，因为这种情况下你可以提供一些默认的实现。另一方面，使用接口则需要从零开始实现，接口定义了某些规则/契约，强调应该做什么，但不强调怎么做。还有就是如果要考虑实现多继承，接口就更合适。 如果你要给接口添加一个新的方法，那么这个接口的所有实现都需要实现这个新方法，有点麻烦。但如果在抽象类中添加一个新方法，并有默认实现，那么旧代码不受影响。在 Java 8 引入了 `default` 关键字在接口的用法，可以在接口里提供默认方法。
   - 下面是抽象类更适用的场景：
     - 想要在多个联系紧密的类之间共享代码
     - 被继承的抽象类有很多公共方法或字段，或者它们当中需要非公有访问修饰符。
     - 你想使用非静态或非 `final` 字段，这样可以修改其所属对象的状态。
   - 接下来是使用接口更合适的场景：
     - 希望一些不相关的类实现你的接口。
     - 指定某种数据类型的行为，但是不关心如何实现。
     - 想要适用多继承。

5. 上面例子中，在 Car 里，brand name 在第一步添加了，而在 MotorCycle 里， brand name 在最后一步添加，这是故意的吗？

   是的。这是为了说明，每种具体生成器可以自由决定如何产生最终产品。

6. 为什么使用单独一个类作为 Director？应该可以使用客户端代码（client code）充当 Director 的角色啊。

   这方面没有限制。上面的代码例子，将 Director 角色与客户端代码分离，但是接下来的例子会直接适用客户端代码做 Director。

7. 客户端代码（client code）是什么意思？

   包含 main() 方法的类就是客户端代码（client code）。在 *Effective Java* 一书的第 4 页，有三段话讲了术语 *exported API* 以及 a *client* of the API. 引用如下：

   > This book uses a few technical terms that are not defined in *The Java Language Specification*. The term *exported API*, or simply *API*, refers to the classes, interfaces, constructors, members, and serialized forms by which a programmer accesses a class, interface, or package. (The term *API*, which is short for *application programming interface*, is used in preference to the otherwise preferable term *interface* to avoid confusion with the language construct of that name.) A programmer who writes a program that uses an API is referred to as a *user* of the API. A class whose implementation uses an API is a *client* of the API.
   >
   > Classes, interfaces, constructors, members, and serialized forms are collectively known as *API elements*. An exported API consists of the API elements that are accessible outside of the package that defines the API. These are the API elements that any client can use and the author of the API commits to support. Not coincidentally, they are also the elements for which the Javadoc utility generates documentation in its default mode of operation. Loosely speaking, the exported API of a package consists of the public and protected members and constructors of every public class or interface in the package.
   >
   > In Java 9, a *module system* was added to the platform. If a library makes use of the module system, its exported API is the union of the exported APIs of all the packages exported by the library's module declaration.

8. 前面提到改变构建步骤。能否演示一下通过改变构建步骤产生不同的最终产品？

   下面的例子给出演示。

### 改进版例子

改进版例子做了如下修改：

- 这次只关注 Car 作为最终产品。
- 定制 Car 的构建步骤包含这些：
  - 开始的消息（startUpMessage)。
  - 处理结束消息（endOperationsMessage）
  - 确定车身材料（bodyType）
  - 车轮数量（noOfWheels）
  - 车头灯数量（noOfHeadLights）
- 客户端代码同时充当了 Director 的角色。
- 生成器的接口被重命名为 ModifiedBuilder， 除 constructCar() 和 getConstructedCar() 方法外，接口中的其他方法的返回类型都是 ModifiedBuilder，这样可以实现方法链（method chaining）。

#### 代码实现

```java
// 公共接口
interface ModifiedBuilder {
	/*
	 * 所有这些方法的返回值类型都是 ModifiedBuilder。这样可以做链式调用
	 */
	ModifiedBuilder startUpOperations(String startUpMessage);
	ModifiedBuilder buildBody(String bodyType);
	ModifiedBuilder insertWheels(int noOfWheels);
	ModifiedBuilder addHeadlights(int noOfHeadLights);
	ModifiedBuilder endOperations(String endOperationsMessage);

	/* 组合部件制造最终产品。 */
	ProductClass constructCar();

	// 可选的方法：获取已构建的产品
	ProductClass getConstructedCar();
}

//Car 类
class CarBuilder implements ModifiedBuilder {
    // 默认起始消息
	private String startUpMessage = "Start building the product";
    private String bodyType = "Steel"; // 默认车身类型
	private int noOfWheels = 4; // 默认车轮数量
	private int noOfHeadLights = 2; // 默认车头灯数量
	// 默认结束消息
	private String endOperationsMessage = "Product creation completed";
	ProductClass product;

	@Override
	public ModifiedBuilder startUpOperations(String startUpMessage) {
		this.startUpMessage = startUpMessage;
		return this;
	}

	@Override
	public ModifiedBuilder buildBody(String bodyType) {
		this.bodyType = bodyType;
		return this;
	}

	@Override
	public ModifiedBuilder insertWheels(int noOfWheels) {
		this.noOfWheels = noOfWheels;
		return this;
	}

	@Override
	public ModifiedBuilder addHeadlights(int noOfHeadLights) {
		this.noOfHeadLights = noOfHeadLights;
		return this;
	}

	@Override
	public ModifiedBuilder endOperations(String endOperationsMessage) {
		this.endOperationsMessage = endOperationsMessage;
		return this;
	}

	@Override
	public ProductClass constructCar() {

		product = new ProductClass(this.startUpMessage, this.bodyType,
                                   this.noOfWheels, this.noOfHeadLights,
				this.endOperationsMessage);
		return product;
	}

    @Override
	public ProductClass getConstructedCar() {
		return product;
	}
}

// Product 类 
final class ProductClass {
	private String startUpMessage;
	private String bodyType;
	private int noOfWheels;
	private int noOfHeadLights;
	private String endOperationsMessage;

	public ProductClass(final String startUpMessage, String bodyType,
                        int noOfWheels, int noOfHeadLights,
			String endOperationsMessage) {
		this.startUpMessage = startUpMessage;
		this.bodyType = bodyType;
		this.noOfWheels = noOfWheels;
		this.noOfHeadLights = noOfHeadLights;
		this.endOperationsMessage = endOperationsMessage;
	}
	/*
	 * 没有使用 setter 方法，加强不可以变性。因为属性是私有，且没有 setter 方法，
	 * 所以不必要使用 final 关键字。
	 */
	@Override
	public String toString() {
		return "Product Completed as:\n startUpMessage=" + 
            startUpMessage + "\n bodyType=" + 
            bodyType + "\n noOfWheels=" + 
            noOfWheels + "\n noOfHeadLights=" + 
            noOfHeadLights + "\n endOperationsMessage=" + 
            endOperationsMessage;
	}
}

// Director 类 
public class BuilderPatternModifiedExample {

	public static void main(String[] args) {
		System.out.println("***Modified Builder Pattern Demo***");
		/*
		 * 构造一个定制的小车（通过使用 builder），注意步骤：
		 * 第1步：已必要的参数获取一个 builder 对象。
		 * 第2步：使用类似 setter 的方法设置可选字段。
		 * 第3步：调用 constructCar() 方法去获取最终生成的小车。
		 */
		final ProductClass customCar1 = new CarBuilder()
            .addHeadlights(5)
            .insertWheels(5)
            .buildBody("Plastic")
			.constructCar();
		System.out.println(customCar1);
		System.out.println("--------------");
		/*
		 * 用不同的步骤构造另一个定制小车（通过使用 builder）
		 */
		ModifiedBuilder carBuilder2 = new CarBuilder();
		final ProductClass customCar2 = carBuilder2
            .insertWheels(7)
            .addHeadlights(6)
            .startUpOperations("I am making my own car")
            .constructCar();
		System.out.println(customCar2);
		System.out.println("--------------");
		/*
		 * 错误，因为 customCar2 是 final 的
         * customCar2 = carBuilder2.insertWheels(70)
		 * .addHeadlights(6) .startUpOperations("I am making my own car")
		 * .constructCar(); System.out.println(customCar2);
		 */		
		// 验证 getConstructedCar() 方法
        
		final ProductClass customCar3 = carBuilder2.getConstructedCar();
		System.out.println(customCar3);
	}
}

```

**输出结果：**

```console
***Modified Builder Pattern Demo***
Product Completed as:
startUpMessage=Start building the product
bodyType=Plastic
noOfWheels=5
noOfHeadLights=5
endOperationsMessage=Product creation completed
--------------
Product Completed as:
startUpMessage=I am making my own car
bodyType=Steel
noOfWheels=7
noOfHeadLights=6
endOperationsMessage=Product creation completed
--------------
Product Completed as:
startUpMessage=I am making my own car
bodyType=Steel
noOfWheels=7
noOfHeadLights=6
endOperationsMessage=Product creation completed
```

在改进版例子中，第 124 行，构建 `customCar1`，逐步调用了 `addHeadLights()`, `insertWheels()`, `buildBody()` 方法。 然后当构建 `customCar2` 时，方法的调用顺序不同了，而没调用的方法，会取默认值。

### Q & A

9. 改进版例子中客户端代码用到 `final` 关键字，但是 `ProductClass` 的属性却没有用 `final` 关键字，为什么？

   在客户端代码使用 `final` 关键字是为了提高不可修改性（immutability），但是在 `ProductClass` 属性已经是私有且那个类没有 setter 方法，所以已经是不可修改了，不需要使用 `final` 关键字。

10. 不可修改的对象有什么好处？

    这样的对象一旦构建完成，就可以安全地共享，更重要的是它们是线程安全的（thread-safe），所以在多线程环境中省去了很多同步操作。

11. 何时应该考虑使用生成器模式？

    当你需要创建一个复杂的对象，涉及到很多步骤，而且被创建的对象需要是不可修改的对象，可以考虑使用生成器模式。

### 补充

#### 静态嵌套类，链式调用

这里补充 Effective Java 第三版里边 Item 2 所讲的 **Consider a builder when faced with many constructor parameters** 的代码例子，因为觉得这里面的例子稍微高级一点，应用到静态嵌套类（不知道这样翻译准不准确，英文是 Static nested class）。 在说完 Telescoping constructor pattern (does not scale well!) 和 JavaBeans Pattern (allows inconsistency, mandates mutability) 缺点之后，Joshua Bloch 给出了一种 Builder Pattern，代码如下：

```java
// Builder Pattern
public class NutritionFacts {
    private final int servingSize;
    private final int servings;
    private final int calories;
    private final int fat;
    private final int sodium; // 钠
    private final int carbohydrate; // 碳水化合物
    
    // 用 Static nested class 作为 Builder
    // 放在这里面可以 convey 一种 ownership，
    // 说明这个 Builder 用于生成 NutritionFacts
    public static class Builder {
        // Required parameters 必须的参数
        private final int servingSize;
        private final int servings;
        
        // Optional parameters - initialized to default values
        // 可选参数，初始化为默认值
        private int calories     = 0;
        private int fat          = 0;
        private int sodium       = 0;
        private int carbohydrate = 0;
        
        public Builder(int servingSize, int servings) {
            this.servingSize = servingSize;
            this.servings    = servings;
        }
        
        // 表示各个构造步骤，返回 Builder 自身引用，形成 fluent API 链式调用
        public Builder calories(int val)
        	{ calories = val;  return this; }
        public Builder fat(int val)
        	{ fat = val;  return this; }
        public Builder sodium(int val)
        	{ sodium = val;  return this; }        
        public Builder carbohydrate(int val)
        	{ carbohydrate = val;  return this; }
        
        // 返回最终产品
        public NutritionFacts build() {
            return new NutritionFacts(this);
        }
    }
    
    // 私有构造函数
    private NutritionFacts(Builder builder) {
        servingSize  = builder.servingSize;
        servings     = builder.servings;
        calories     = builder.calories;
        fat          = builder.fat;
        sodium       = builder.sodium;
        carbohydrate = builder.carbohydrate;
    }
        
}
```

按上面的 Builder 实现，客户端代码可以这样写：

```java
NutritionFacts cocaCola = new NutritionFacts.Builder(240, 8).
    calories(100).sodium(35).carbohydrate(27).build();
```

这样的链式调用，易写、易读，模仿了像 Python 或 Scala 中的命名参数（named optional parameters).

#### 适用于类继承体系结构

即抽象类有抽象 builder，具体类有具体的 builder，例如以下代码是一个抽象类，代表各种披萨：

```java
// Builder pattern for class hierarchies
public abstract class Pizza {
    public enum Topping { HAM, MUSHROOM, ONION, PEPPER, SAUSAGE }
    final Set<Topping> toppings;
    
    abstract static class Builder<T extends Builder<T>> {
        EnumSet<Topping> toppings = EnumSet.noneOf(Topping.class);
        public T addTopping(Topping topping) {
            toppings.add(Objects.requireNonNull(topping));
            return self();
        }
        abstract Pizza build();
        
        // Subclasses must override this method to return "this"
        protected abstract T self();
    }
    Pizza(Builder<?> builder) {
        toppings = builder.toppings.clone();  // See Item 50
    }
}
```

上面的 `Pizza.Builder` 是带有*递归类型参数*的泛型，加上抽象的 `self` 方法，可以允许子类实现方法链式调用。因为 Java 没有 self 类型，这种做法是模仿 self 类型的习惯。(This workaround for the fact that Java lacks a self type is known as the **simulated self-type idiom**.)

然后接下来是两个具体的 `Pizza` 子类：

纽约披萨：

```java
public class NyPizza extends Pizza {
    public enum Size { SMALL, MEDIUM, LARGE }
    private final Size size;
    
    public static class Builder extends Pizza.Builder<Builder> {
        private final Size size;
        
        // covariant return typing
        public Builder(Size size) {
            this.size = Objects.requiresNonNull(size);
        }
        @Override public NyPizza build() {
            return new NyPizza(this);
        }
        @Override protected Builder self() {
            return this;
        }
    }
    private NyPizza(Builder builder) {
        super(builder);
        size = builder.size;
    }
}
```

意式披萨：

```java
public class Calzone extends Pizza {
    private final boolean sauceInside;
    
    public static class Builder extends Pizza.Builder<Builder> {
        private final boolean sanceInside = false; // Default
        
        // covariant return typing
        public Builder sauceInside() {
            sauceInside = true;
            return this;
        }
        @Override public Calzone build() {
            return new Calzone(this);
        }
        @Override protected Builder self() { return this; }
    }
    private Calzone(Builder builder) {
        super(builder);
        sauceInside = builder.sauceInside;
    }
}
```

然后客户端代码看起来是这样的：

```java
NyPizza pizza = new NyPizza.Builder(SAMLL)
    .addTopping(SAUSAGE).addTopping(ONION).buid();
Calzone calzone = new Calzone.Builder()
    .addTopping(HAM).sauceInside().build();
```

### 总结

总的来说，当一个类的构造函数或者静态工厂有较多的参数时，生成器模式是一种好的选择，特别是有些参数是可选的，或者类型是相同的。【完结】

### 参考

- [Gamma95] Gamma, Erich, Richard Helm, Ralph Johnson, and John Vlissides. 1995. *Design Patterns: Elements of Reusable Object-Oriented Software.* Reading, MA: Addison-Wesley. ISBN: 0201633612
- Sarcar, Vaskaran. *Design Patterns in Java, Second Edition.* Apress, 2019
- [Springframework guru: Builder Pattern](https://springframework.guru/gang-of-four-design-patterns/builder-pattern/)
- Joshua Block. *Effective Java, Third Edition.* Addison-Wesley, 2018
- [设计模式杂谈——模式与反模式之争](https://blog.csdn.net/jiangpingjiangping/article/details/78067595)

> 更新记录：
>
> 2020年3月13日 下午3点13分 修正一些错别字，整理一下代码格式，和替换注释为中文。