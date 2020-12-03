---
typora-root-url: ../
layout:     post
title:      Spring单例与单例模式
date:       '2020-11-02T02:04'
subtitle:   
keywords:   Spring
author:     zwt
catalog:    true
tags:
    - Personal
    - Notes
---
> Spring 单例不是 Java 单例。本文讨论 Spring 的单例与单例模式的区别。  

### 前言

单例是 Spring 当中 bean 的默认范围(Scope)。Spring 容器会为某个 bean 定义对象创建唯一的实例，很多时候我们会将这种设计跟《设计模式》(GoF) 书中定义的单例模式作比较。

### 1. 单例范围 vs 单例模式

Spring 当中的单例范围跟单例模式不是同一个东西。其中的两点差异如下：  

- 单例模式确保某个类加载器的某个类只有一个实例  
- 而 Spring 单例范围是每个容器的每个bean  <!--more-->

#### 1.1 单例范围的例子  

Spring 的单例实例会被放在缓存中，下次再访问那个命名的 bean 的时候就会从缓存里面取。下边看看例子。  

```java
public class Account {

    private String name;

    public Account() {
    }

    public Account(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return "Account{" +
                "name='" + name + '\'' +
                '}';
    }
}
```

Spring Boot 的 main 方法：  

```java
@SpringBootApplication
@SpringBootApplication
public class SpringSingletonApp {

    public static void main(String[] args) {
        SpringApplication.run(SpringSingletonApp.class, args);
    }

    @Bean(name = "bean1")
    public Account account() {
        return new Account("Test User 1");
    }

    @Bean(name = "bean2")
    public Account account1() {
        return new Account("Test User 2");
    }
}
```  

理解上面的代码：  

- 我们创建了同一个类的 2 个实例，并有不同的 bean id。那么上面代码中 Spring 的 IoC 容器创建了多少个实例？  

- 2 个不同的实例，在容器中分别绑定到它们的 id？
- 还是 1 个实例绑定到 2 个 bean id？

#### 1.2 测试用例  

我们使用单元测试找出答案。  

```java
@SpringBootTest
class SpringSingletonAppTests {

    private static final Logger log = LoggerFactory.getLogger(SpringSingletonAppTests.class);

    @Resource(name = "bean1")
    Account account1;

    @Resource(name = "bean1")
    Account duplicateAccount;

    @Resource(name = "bean2")
    Account account2;

    @Test
    public void testSingletonScope() {
        log.info(account1.getName());
        log.info(account2.getName());

        log.info("Accounts are equal -> {}", account1 == account2);
        log.info("Duplicate account  -> {}", account1 == duplicateAccount);
    }
}
```

输出为：  

```bash
20:06:31.165 [main] INFO  i.z.s.SpringSingletonAppTests - Test User 1
20:06:31.165 [main] INFO  i.z.s.SpringSingletonAppTests - Test User 2
20:06:31.165 [main] INFO  i.z.s.SpringSingletonAppTests - Accounts are equal -> false
20:06:31.167 [main] INFO  i.z.s.SpringSingletonAppTests - Duplicate account  -> true
```

从上面的输出我们发现：
Spring 返回了两个不同的实例，单例范围的同一个类可以有多于一个的对象实例。

对于某个 bean id，Spring 容器仅维护唯一的共享单例 bean，在我们上面的例子中，Spring IoC 容器基于同一个类的 bean 定义创建了两个实例，并将它们绑定到对应的 id。
Spring 的 bean 定义就像键值对那样，bean id 就是 key，bean 的实例就是 value。每个 key 引用都会返回同一个 bean 实例（例如 bean1 引用始终返回 id 为 bean1 的 bean）

### 总结  

Spring 单例跟传统的单例模式是不同的。Spring 确保在每个容器对给定 bean id 定义只创建一个 bean 实例。 传统单例模式是保证给定一个类加载器所加载的某个类只有唯一的一个实例。  
