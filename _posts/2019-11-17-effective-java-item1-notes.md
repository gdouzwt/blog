---
typora-root-url: ../
layout:     post
title:        Effective Java 条款1
date:       '2019-11-17T10:50'
subtitle:   读书笔记
author:     招文桃
catalog:    true
tags:
    - Effective Java
    - Best Practices
---

## ITEM 1: Consider static factory methods instead of constructors

属于 “创建和销毁对象” 那章。静态工厂方法跟“四人帮”设计模式里面的*工厂方法*模式是不同的。<!--more-->

### 静态工厂方法的好处

1. 有名称，容易读。

2. 静态工厂方法不一定每次都创建新实例。有点类似*享元*模式（*Flyweight* pattern)。如果创建对象代价比较大，使用静态工厂方法可以提高性能。这种类被称为*实例受控*（*instance-controlled*）类。可以确保*单例*（*singleton*）或不被实例化。还有让*值不可变*类（immutable value class）保存没有两个相等的实例存在。

3. 可返回任意子类的对象。

4. 静态工厂方法返回的对象可以因调用参数不同而不同。

5. 返回的对象可以先不存在，这就是 service provider framework 的基础，例如 Java Database Connectivity API (JDBC). 

   服务提供者框架的三个主要组件：服务接口（service interface），代表实现。服务提供者注册接口（provider registration API），用于注册服务的实现。服务访问接口（service access API），客户端用来获取服务实例的方式。以 JDBC 为例子，`Connection` 就是服务接口， `DriverManager.registerDriver` 是服务提供者注册接口， `DriverManager.getConnection` 是服务访问接口，然后 `Driver` 是服务提供者接口。

### 静态工厂方法的缺点

1. 只提供私有静态工厂方法（没有 `public` 或 `protected` 构造器）的类不能被继承（派生），不过有时候是好事，因为鼓励使用组合而不是继承。
2. 比较难找，因为不想构造器那样出现在 java doc。



### 一些静态工厂方法的例子：

- **from** —— 一种类型转换方法，取一个参数并返回此类型对应的实例，例如：

  `Data d = Date.from(instant);`

- **of** —— 一种聚集方法，取多个参数，返回此类型的实例，整合了这些参数的值，例如：

  `Set<Rank> faceCards = EnumSet.of(JACK, QUEEN, KING);`

- **valueOf** —— 更详尽版本的 **of** ，例如：

  `BigInteger prime = BigInteger.valueOf(Integer.MAX_VALUE);`

- **instance** 或 **getInstance** —— 返回参数描述的实例，但不一定得到同样的值。例如：

  `StackWalker luke = StackWalker.getInstance(options);`

- **create** 或 **newInstance** —— 像前一个，但是保证每次都返回新实例。例如：

  `Object newArray = Array.newInstance(classObject, arrayLen);`

- **get*Type*** —— 像 **getInstance** 但是在不同类里面，***Type*** 是静态工厂方法返回的对象类型，例如：

  `FileStore fs = Files.getFileStore(path);`

- **new*Type*** —— 像 **newInstance** 但是在不同类里面，***Type*** 是静态工厂方法返回的对象类型，例如：

  `BufferedReader br = Files.newBufferedReader(path);`

- **type** —— **get*Type*** 和 **new*Type*** 的更精简替换，例如：

  `List<Complaint> litany = Collections.list(legacyLitany);`



### 总结

通常使用静态工厂方法更好，所以可以考虑一下，而不是只想到公有构造器。