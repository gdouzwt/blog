---
typora-root-url: ../
layout:     post
title:      响应式Spring Boot系列教程5
date:       '2020-01-09T09:28'
subtitle:   共享Bean的自动装配
author:     招文桃
catalog:    true
tags:
    - JavaFX
    - Tutorial
    - Spring Boot
    - Reactive
---

> 原文由 Trisha Gee 在当地时间2019年11月25日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-auto-configuration-for-shared-beans/)

这一节我们看一下如何在一个模块中使用另一个不同的模块中的Spring Beans，通过使用自动装配。

在上一节 ，我们创建了一个JavaFX Spring Boot应用程序显示一个空的折线图。在这篇文章，我们要看一下如何为 Spring Beans设置自动装配，以便我们可以在stock-ui模块里面使用在stock-client定义的Beans。

<!--more-->

### 添加另一个模块的依赖

1. 打开我们在上一节创建的`ChartController`类。这个类将会负责在折线图上更新和显示数据。
2. 我们的`ChartController`需要使用在第二节的`WebClientStockClient`，它将使用这个连接到股票价格服务。为客户端创建一个新字段并确保这个类已经导入。

```java
public class ChartController {
    @FXML
    public LineChart<String, Double> chart;
    private WebClientStockClient webClientStockClient;
}
```

3. 我们需要给stock-ui模块添加一个对stock-client模块的依赖。
2. （提示：我们可以通过在红色的字段上按下Alt+Enter，并选择"Add maven dependency"去让IntelliJ IDEA为我们添加这依赖。它会在Maven的 pom.xml文件添加依赖，所以这个依赖是由构建文件而不是IDE管理的）。

```xml
<dependency>
    <groupId>com.mechanitis</groupId>
    <artifactId>stock-client</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <scope>compile</scope>
</dependency>
```

1. Add a constructor parameter so it gets wired in. 添加到构造函数参数使之注入。
2. （提示：如果你在灰色的字段名按下Alt+Enter，IntelliJ IDEA会让你添加构造函数参数，或者我们可以生成构造函数）。

```java
public class ChartController {
    @FXML
    public LineChart<String, Double> chart;
    private WebClientStockClient webClientStockClient;
 
    public ChartController(WebClientStockClient webClientStockClient) {
        this.webClientStockClient = webClientStockClient;
    }
}
```

### 创建 WebClientStockClient bean

IntelliJ IDEA 通过告知我们找不到类型为`WebClientStockClient`去帮助我们发现`ChartController`存在的问题。让我们修复它。

1. 在stock-client模块，我们需要创建一个新的Java类，`ClientConfiguration`，并为其添加`@Configuration`注解。我们会在这里定义我们的Beans。
2. 创建一个由`@Bean`注解的方法，并且返回值类型为`WebClientStockClient`. 为了创建一个这样的东西，我们需要传入一个`webClient`参数。
3. （提示：我们可以通过在红色的`webClient`变量上按下Alt+Enter并选择"create parameter"去让IntelliJ IDEA为这个传进一个参数）。
4. 定义另一个`@Bean`方法，这个返回值类型为`WebClient`。我们可以使用WebClient Builder默认设置去创建一个新的实例。
5. 我们也可以用`@ConditionalOnMissingBean`去注解这个方法，表示仅当不存在`WebClient`实例时才去创建Bean。我们在这里使用它，因为其它用到这部分代码的地方可能也创建了`WebClient`。

```java
@Configuration
public class ClientConfiguration {
    @Bean
    public WebClientStockClient webClientStockClient(WebClient webClient) {
        return new WebClientStockClient(webClient);
    }
 
    @Bean
    @ConditionalOnMissingBean
    public WebClient webClient() {
        return WebClient.builder().build();
    }
}
```

### 启用自动装配

回到stock-ui模块，IntelliJ IDEA告知我们还找不到这个Bean因为它是定义在不同的模块里并且这个模块不能看到定义在那里的Bean。我们要使用Spring Boot 的自动装配来帮助解决这个问题。

1. 在stock-client的src/main/resources里创建一个META-INF目录。
2. 在里边创建一个名为spring.factories的文件。
3. 在spring.properties，将`EnableAutoConfiguration`属性的值指向我们的`ClientConfiguration`类，这能够让其它使用这个模块的模块能够访问到定义在`ClientConfiguration`里面的Bean。

```properties
org.springframework.boot.autoconfigure.EnableAutoConfiguration=com.mechanitis.demo.stockclient.ClientConfiguration
```

现在当我们回到`ChartController`类，它知道去哪里找`webClientStockClient` Bean了。

### 总结

这是本教程的一个小步骤，但这一步让我们可以创建可以被不同的Spring Boot应用程序重用的模块。现在这一步完成了，我们可以`ChartController`里面的客户端连接到价格服务，并开始在折线图上实时地显示价格数据。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)：https://github.com/zwt-io/rsb/