---
typora-root-url: ../
layout:     post
title:      Spring Boot的类
date:       '2020-02-01T15:54'
subtitle:   学习笔记
author:     招文桃
catalog:    true
tags:
    - Spring Boot
    - Notes
---

## 常见类的用途

### SpringApplicationBuilder 

`java.lang.Object`

​	`org.springframework.boot.builder.SpringApplicationBuilder`

Builder for `SpringApplication` and `ApplicationContext` instances with convenient fluent API and context hierarchy support. Simple example of a context hierarchy:

`new SpringApplicationBuider(ParentConfig.class).child(ChildConfig.class).run(args);`

Another common use case is setting active profiles and default properties to set up the environment for an application:

```java
new SpringApplicationBuilder(Application.class).profiles("server")
    			.properties("transport=local").run(args);
```

If your needs are simpler, consider using the static convenience methods in SpringApplication instead.

(org.springframework.boot:spring-boot:2.2.4.RELEASE)

这里就是Builder模式，顺便记录一下，先上图：

![builder-pattern](/img/builder-pattern.png)

GoF 对 **Builder Pattern** 的定义如下：

> Separate the construction of a complex object from its representation so that the same construction processes can create different representations.
>
> 将一个复杂对象的构建与它的表示分离，使得同样的构建过程可以创建不同表示。（中文版书里的翻译，另外注意，在书中 Builder 译作“生成器”）

上图中，`Product` 是我们想要构建的复杂对象，`ConcreteBuilder` 通过实现抽象的 `Builder` 接口去构造和组合一个 product 的部件。具体的构造者，`ConcreteBuilder` 负责构建 product 的内部表现，和创造过程及组合机制。 `Builder` 也可以提供方法使得被创建的对象可以被使用。 Director 负责使用 Builder 取创建最终的 Product，也就是说 Director 是 Builder 的使用者。 构造者(Builders) 可以保持对所构造的对象(products)的引用，以便可以再次使用。

### SpringApplication

`java.lang.Object`

​	`org.springframework.boot.SpringApplication`

Class that can be used to bootstrap and launch a Spring application from a Java main method. By default class will perform the following steps to bootstrap your application:

- Create an appropriate `ApplicationContext` instance (depending on your classpath)
- Register a `CommandLinePropertySource` to expose command line arguments as Spring properties
- Refresh the application context, loading all singleton beans
- Trigger any `CommandLineRunner` beans

In most circumstances the static `run(Class, String[])` method can be called directly from you main method to bootstrap your application:

```java
 @Configuration
 @EnableAutoConfiguration
 public class MyApplication  {

   // ... Bean definitions

   public static void main(String[] args) {
     SpringApplication.run(MyApplication.class, args);
   }
 }
```

For more advanced configuration a `SpringApplication` instance can be created and customized before being run:

```java
public static void main(String[] args) {
   SpringApplication application = new SpringApplication(MyApplication.class);
   // ... customize application settings here
   application.run(args)
 }
```

`SpringApplication`s can read beans from a variety of different sources. It is generally recommended that a single `@Configuration` class is used to bootstrap your application, however, you may also set sources from:

- The fully qualified class name to be loaded by `AnnotatedBeanDefinitionReader`
- The location of an XML resource to be loaded by `XmlBeanDefinitionReader`, or a groovy script to be loaded by `GroovyBeanDefinitionReader`
- The name of a package to be scanned by `ClassPathBeanDefinitionScanner`

Configuration properties are also bound to the SpringApplication. This makes it possible to set SpringApplication properties dynamically, like additional sources ("spring.main.sources" - a CSV list) the flag to indicate a web environment ("spring.main.web-application-type=none") or the flag to switch off the banner ("spring.main.banner-mode=off").

`org.springframework.boot.SpringApplication`

```java
public static org.springframework.context.ConfigurableApplicationContext run(Class <?> primarySource, String ... args)
```

Static helper that can be used to run a `SpringApplication` from the specified source using default settings.  
Parameters:  
`primarySource` - the primary source to load  
`args` - the application arguments (usually passed from a Java main method)  
Returns:  
the running `ApplicationContext`  