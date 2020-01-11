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
    - 教程
    - 翻译
---

> 原文由 Trisha Gee 在当地时间2019年11月25日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-auto-configuration-for-shared-beans/)

In this lesson we look at how to use Spring beans from one module in a different module, using auto-configuration.

这一节我们看一下如何在一个模块中使用另一个不同的模块中的Spring Beans，通过使用自动装配。

In the [last lesson](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-javafx-line-chart), we created a JavaFX Spring Boot application that shows an empty line chart. In this video, we’re going to see how to set up auto-configuration for Spring Beans so that we can use beans defined in our stock-client module in the stock-ui module.

在上一节 ，我们创建了一个JavaFX Spring Boot应用程序显示一个空的折线图。在这篇文章，我们要看一下如何为 Spring Beans设置自动装配，以便我们可以在stock-ui模块里面使用在stock-client定义的beans

<!--more-->

### 添加另一个模块的依赖

1. Open the ChartController class we created in the last lesson. This class is going to be responsible for updating the data we display on the line chart.  打开我们在上一节创建的 ChartController类。这个类将会负责在折线图上更新和显示数据。
2. Our ChartController needs to use the WebClientStockClient from the [second lesson](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-rest-client-for-reactive-streams/), it will use this to connect to the stock prices service. Create a new field for the client and make sure the class is imported. 我们的ChartController 需要使用在第二节的 WebClientStockClient，它将使用这个连接到股票价格服务。为客户端创建一个新字段并确保这个类已经导入。

```java
public class ChartController {
    @FXML
    public LineChart<String, Double> chart;
    private WebClientStockClient webClientStockClient;
}
```

3. We need to add a dependency upon stock-client from the stock-ui module 我们需要给stock-ui模块添加一个对stock-client模块的依赖
2. (Tip: we can get get IntelliJ IDEA to add this dependency by pressing Alt+Enter on the red field, and selecting “[Add maven dependency](https://www.jetbrains.com/help/idea/work-with-maven-dependencies.html)“. It will add the dependency in the Maven pom.xml file, so this dependency is managed by the build file not by the IDE.) （提示：我们可以通过在红色的字段上按下 Alt+Enter，并选择"Add maven dependency"去让IntelliJ IDEA为我们添加这依赖。它会在 Maven的 pom.xml文件添加依赖，所以这个依赖是由构建文件而不是IDE管理的）

```xml
<dependency>
    <groupId>com.mechanitis</groupId>
    <artifactId>stock-client</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <scope>compile</scope>
</dependency>
```

1. Add a constructor parameter so it gets wired in. 添加到构造函数参数使之注入。
2. (Tip: IntelliJ IDEA will offer to add a constructor parameter if we press Alt+Enter on the grey field name, or we can [generate constructors](https://www.jetbrains.com/help/idea/generating-code.html#generate-constructors)).（提示：如果你在灰色的字段名按下Alt+Enter，IntelliJ IDEA会让你添加构造函数参数，或者我们可以生成构造函数）

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

IntelliJ IDEA helps us identify a problem in ChartController by telling us there are no beans of type WebClientStockClient available. Let’s fix this.

IntelliJ IDEA 通过告知我们找不到类型为WebClientStockClient去帮助我们发现ChartController存在的问题。让我们修复它。

1. In the stock-client module, we need to create a new Java class, ClientConfiguration, and add the [Configuration](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Configuration.html) annotation. Here we’ll define our Beans. 在stock-client模块，我们需要创建一个新的Java类，ClientConfiguration，并为其添加@Configuration注解。我们会在这里定义我们的Beans
2. Create a method annotated with [@Bean](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Bean.html) that returns a WebClientStockClient. To create one of these we need to pass in a webClient parameter. 创建一个由 @Bean注解的方法，并且返回值类型为 WebClientStockClient. 为了创建一个这样的东西，我们需要传入一个 webClient参数。
3. (Tip: We can get IntelliJ IDEA to pass in a parameter for this by pressing Alt+Enter on the red webClient variable and selecting “create parameter”).（提示：我们可以通过在红色的 webClient变量上按下 Alt+Enter并选择"create parameter"去让IntelliJ IDEA为这个传进一个参数）
4. Define another [@Bean](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Bean.html) method, which returns a WebClient. We can use the WebClient builder with default settings to create a new instance.定义另一个 @Bean方法，这个返回值类型为 WebClient。我们可以使用 WebClient Builder 默认设置去创建一个新的实例。
5. We can also annotate this method with [ConditionalOnMissingBean](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/autoconfigure/condition/ConditionalOnMissingBean.html), which means this method will only be used to create the bean if a WebClient bean doesn’t already exist. We’re using this here because it’s possible that something else that uses this code might also create a WebClient. 我们也可以用 @ConditionalOnMissingBean 去注解这个方法，表示仅当不存在 WebClient实例时才去创建Bean。我们在这里使用它，因为其它用到这部分代码的地方可能也创建了WebClient

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

Back in the stock-ui module, IntelliJ IDEA tells us we still can’t see this bean. That’s because it was defined in a different module and this module can’t see the beans defined there. We’re going to use [Spring Boot’s auto-configuration](https://docs.spring.io/spring-boot/docs/current/reference/html/spring-boot-features.html#boot-features-developing-auto-configuration) to help us here.

回到 stock-ui 模块，IntelliJ IDEA告知我们还找不到这个 Bean 因为它是定义在不同的模块里并且这个模块不能看到定义在那里的beans。我们要使用 Spring Boot 的自动装配来帮助解决这个问题。

1. Create a META-INF directory in stock-client src/main/resources. 在stock-client的 src/main/resources里创建一个 META-INF 目录。
2. Inside this create a file, [spring.factories](https://docs.spring.io/spring-boot/docs/current/reference/html/spring-boot-features.html#boot-features-locating-auto-configuration-candidates). 在里边创建一个名为 spring.factories 的文件。
3. In spring.properties, set the property [EnableAutoConfiguration](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/autoconfigure/EnableAutoConfiguration.html) to point to our ClientConfiguration class. This will give other modules that use this module access to the beans in our ClientConfiguration.在 spring.properties，将 EnableAutoConfiguration 属性的值指向我们的 ClientConfiguration类，这能够让其它使用这个模块的模块能够访问到定义在ClientConfiguration里面的Bean

```properties
org.springframework.boot.autoconfigure.EnableAutoConfiguration=com.mechanitis.demo.stockclient.ClientConfiguration
```

Now when we go back to our ChartController class, it knows where to find the webClientStockClient bean.

现在当我们回到 ChartController类，它直到去哪里找webClientStockClient bean了

### 总结

This was a fairly small step in the tutorial, but it lets us create modules that can be re-used by different Spring Boot applications. Now this step is complete, we can use the client in ChartController to connect to the price service and start showing real-time prices on the line chart.

这是本教程的一个小步骤，但这一步让我们可以创建可以被不同的Spring Boot应用程序重用的模块。现在这一步完成了，我们可以 ChartController 里面的客户端连接到价格服务，并开始在折线图上实时地显示价格数据。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























