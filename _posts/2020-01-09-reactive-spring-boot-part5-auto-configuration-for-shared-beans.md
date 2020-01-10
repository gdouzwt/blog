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

> Posted on November 25, 2019 by Trisha Gee
>
> 原文由 Trisha Gee 在当地时间2019年11月25日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-auto-configuration-for-shared-beans/)



In this lesson we look at how to use Spring beans from one module in a different module, using auto-configuration.

This is the fifth part of our tutorial showing how to build a Reactive application using Spring Boot, Kotlin, Java and [JavaFX](https://openjfx.io/). The original inspiration was a [70 minute live demo.](https://blog.jetbrains.com/idea/2019/10/fully-reactive-spring-kotlin-and-javafx-playing-together/)

This blog post contains a video showing the process step-by-step and a textual walk-through (adapted from the transcript of the video) for those who prefer a written format.

<!--more-->

[This tutorial is a series of steps](https://blog.jetbrains.com/idea/tag/tutorial-reactive-spring/) during which we will build a full [Spring Boot](https://spring.io/projects/spring-boot) application featuring a [Kotlin](https://kotlinlang.org/) back end, a [Java](https://jdk.java.net/13/) client and a [JavaFX](https://openjfx.io/) user interface.

In the [last lesson](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-javafx-line-chart), we created a JavaFX Spring Boot application that shows an empty line chart. In this video, we’re going to see how to set up auto-configuration for Spring Beans so that we can use beans defined in our stock-client module in the stock-ui module.

### 添加另一个模块的依赖

1. Open the ChartController class we created in the last lesson. This class is going to be responsible for updating the data we display on the line chart.
2. Our ChartController needs to use the WebClientStockClient from the [second lesson](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-rest-client-for-reactive-streams/), it will use this to connect to the stock prices service. Create a new field for the client and make sure the class is imported.

```java
public class ChartController {
    @FXML
    public LineChart<String, Double> chart;
    private WebClientStockClient webClientStockClient;
}
```

3. We need to add a dependency upon stock-client from the stock-ui module
2. (Tip: we can get get IntelliJ IDEA to add this dependency by pressing Alt+Enter on the red field, and selecting “[Add maven dependency](https://www.jetbrains.com/help/idea/work-with-maven-dependencies.html)“. It will add the dependency in the Maven pom.xml file, so this dependency is managed by the build file not by the IDE.)

```xml
<dependency>
    <groupId>com.mechanitis</groupId>
    <artifactId>stock-client</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <scope>compile</scope>
</dependency>
```

1. Add a constructor parameter so it gets wired in.
2. (Tip: IntelliJ IDEA will offer to add a constructor parameter if we press Alt+Enter on the grey field name, or we can [generate constructors](https://www.jetbrains.com/help/idea/generating-code.html#generate-constructors)).

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

1. In the stock-client module, we need to create a new Java class, ClientConfiguration, and add the [Configuration](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Configuration.html) annotation. Here we’ll define our Beans.
2. Create a method annotated with [@Bean](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Bean.html) that returns a WebClientStockClient. To create one of these we need to pass in a webClient parameter.
3. (Tip: We can get IntelliJ IDEA to pass in a parameter for this by pressing Alt+Enter on the red webClient variable and selecting “create parameter”).
4. Define another [@Bean](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Bean.html) method, which returns a WebClient. We can use the WebClient builder with default settings to create a new instance.
5. We can also annotate this method with [ConditionalOnMissingBean](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/autoconfigure/condition/ConditionalOnMissingBean.html), which means this method will only be used to create the bean if a WebClient bean doesn’t already exist. We’re using this here because it’s possible that something else that uses this code might also create a WebClient.

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

1. Create a META-INF directory in stock-client src/main/resources.
2. Inside this create a file, [spring.factories](https://docs.spring.io/spring-boot/docs/current/reference/html/spring-boot-features.html#boot-features-locating-auto-configuration-candidates).
3. In spring.properties, set the property [EnableAutoConfiguration](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/autoconfigure/EnableAutoConfiguration.html) to point to our ClientConfiguration class. This will give other modules that use this module access to the beans in our ClientConfiguration.

```properties
org.springframework.boot.autoconfigure.EnableAutoConfiguration=com.mechanitis.demo.stockclient.ClientConfiguration
```

Now when we go back to our ChartController class, it knows where to find the webClientStockClient bean.

### 总结

This was a fairly small step in the tutorial, but it lets us create modules that can be re-used by different Spring Boot applications. Now this step is complete, we can use the client in ChartController to connect to the price service and start showing real-time prices on the line chart.

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























