---
typora-root-url: ../
layout:     post
title:      回顾 protected 访问修饰符
date:       '2019-11-02T07:00'
subtitle:   重读一下 OCA Guide 访问控制符与继承相关内容
author:     招文桃
catalog:    true
tags:
    - Java
    - Inheritance
---

## 使用 protected 访问控制符

这是基础内容了，但是不能轻视，越基础越要清晰理解。

### Protected Access

这是用于演示 `protected` 关键字的代码包图。

![image-20191102082917612](/img/image-20191102082917612.png)

![image-20191102204121667](/img/image-20191102204121667.png)

首先创建一个 `Bird` 类并将其成员设置为 `protected` ：

```java
package pond.shore;
public class Bird {
    protected String text = "floating";		// protected 访问
    protected void floatInWater() {			// protected 访问
        System.out.println(text);
    } 
}
```

接着我们创建一个子类：

```java
package pond.goose;
import pond.shore.Bird;		// 在不同的包
public class Gosling extends Bird {		// 创建子类
    public void swim() {
        floatInWater();		// 调用 protected 成员
        System.out.println(text);	// 调用 protected 成员
    }
}
```

运行以上代码，会打印 *floating* 两次，一次因为调用 `floatInWater()` 另一次因为 `swim()` 里面的 `println()`。 因为 `Gosling` 是 `Bird` 的子类，它可以访问这些成员，即使不在同一个包。 记住 `protected` 允许所有默认访问权限所允许的。(Remember `protected` also gives us access to everything that default access does.) 意味着与 Bird 在同一个包的类可以访问它的 `protected` 成员。

```java
package pond.shore;			// 与 Bird 在同一个包
public class BirdWatcher {
    public void watchBird() {
        Bird bird = new Bird();
        bird.floatInWater();	// 调用 protected 成员
        System.out.println(bird.text);	// 调用 protected 成员
    }
}
```

现在我们尝试在不同的包做同样的操作：

```java
package pond.inland;			// 与 Bird 不在同一个包
public class BirdWatcherFromAfar {
    public void watchBird() {
        Bird bird = new Bird();
        bird.floatInWater();	// 不能通过编译
        System.out.println(bird.text);	// 不能通过编译
    }
}
```

`BirdWatcherFromAfar` 与 `Bird` 不在同一个包，且不是 `Bird` 的子类，所以无法访问 `Bird` 的 `protected` 成员。

好了，现在看看下面这个例子：

```java
package pond.swan;
import pond.shore.Bird;			// 与 Bird 不在同一个包
public class Swan extends Bird {	// 但是 Bird 的子类
    public void swim() {
        floatInWater();		// 包访问父类
        System.out.println(text);	// 包访问父类
    }
    public void helpOtherSwanSwim() {
        Swan other = new Swan();
        other.floatInWater();	// 包访问父类
        System.out.println(other.text);		// 包访问父类
    }
    public void helpOtherBirdSwim() {
        Bird other = new Bird();
        other.floatInWater();	// 不能通过编译
        System.out.println(other.text);		// 不能通过编译
    }
}
```

上面代码，`helpOtherBirdSwim()` 方法里面 `other.floatInWater()` 和 `System.out.println(other.text)` 不能通过编译是因为引用变量 `other` 的类型是 `Bird`。 如果通过引用变量访问一个成员，能否访问取决于引用的**变量的类型**。

再看看下面这个例子：

```java
package pond.goose;
import pond.shore.Bird;			
public class Goose extends Bird {	
    public void helpGooseSwim() {
        Goose other = new Goose();
        other.floatInWater();	
        System.out.println(other.text);		
    }
    public void helpOtherGooseSwim() {
        Bird other = new Goose();
        other.floatInWater();	// 不能通过编译
        System.out.println(other.text);		// 不能通过编译
    }
}
```

上面代码中，在第二个方法 `helpOtherGooseSwim()` 有问题，尽管创建的是一个 `Goose` 对象，但是 `other` 保存的引用类型是 `Bird`。因为 `Goose` 与 `Bird` 不在同一个包，而且 `Bird` 不是 `Goose` 的子类，所以不允许访问 `Bird` 的成员。

在看多一个例子：

```java
package pond.duck;
import pond.goose.Goose;
public class GooseWatcher {
    public void watch() {
        Goose goose = new Goose();
        goose.floatInWater();	// 不能通过编译
    }
}
```

代码不能通过编译的原因是我们不在 `Goose` 类里面。 `floatInWater()` 方法是 `Bird` 类中声明的。 `GooseWatcher` 与 `Bird` 不在同一个包，而且不是 `Bird` 的子类。`Goose` 继承自 `Bird` 只是允许 `Goose` 访问 `floatInWater()` ，而不是 `Goose` 的调用者。