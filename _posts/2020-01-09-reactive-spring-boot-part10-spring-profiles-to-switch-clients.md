---
typora-root-url: ../
layout:     post
title:      Reactive Spring Boot 系列教程 - Part 10
date:       '2020-01-09T10:10'
subtitle:   用 Spring Profiles 切换客户端
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

## 响应式 Spring Boot 第 10 部分 - 用 Spring Profiles 切换客户端

> Posted on December 16, 2019 by Trisha Gee
>
> 原文由 Trisha Gee 在当地时间2019年12月16日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/12/tutorial-reactive-spring-boot-kotlin-rsocket-server/)



In this lesson we use Spring Profiles to enable an application to determine which of our two clients ([server-sent events via WebClient](https://www.baeldung.com/spring-server-sent-events), or [RSocket](http://rsocket.io/)) to use to connect to our Kotlin Spring Boot price service.

This is the final part of our tutorial showing how to build a Reactive application using Spring Boot, Kotlin, Java and [JavaFX](https://openjfx.io/). The original inspiration was a [70 minute live demo.](https://blog.jetbrains.com/idea/2019/10/fully-reactive-spring-kotlin-and-javafx-playing-together/)

This blog post contains a video showing the process step-by-step and a textual walk-through (adapted from the transcript of the video) for those who prefer a written format.

<!--more-->

[This tutorial is a series of steps](https://blog.jetbrains.com/idea/tag/tutorial-reactive-spring/) during which we will build a full [Spring Boot](https://spring.io/projects/spring-boot) application featuring a [Kotlin](https://kotlinlang.org/) back end, a [Java](https://jdk.java.net/13/) client and a [JavaFX](https://openjfx.io/) user interface.

Now we have an [RSocket client that lets us connect to our RSocket server](https://blog.jetbrains.com/idea/2019/12/tutorial-reactive-spring-boot-java-rsocket-client/), we want to use this from [our JavaFX application](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-displaying-reactive-data/).

### 创建 RSocketStockClient Bean

We intentionally have two implementations of our StockClient, one for connecting via RSocket and one via WebClient. Our ClientConfiguration only exposes one of these, the WebClientStockClient, [as a bean](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-definition). If we want applications to be able to use the Rsocket client we need to add an RSocket client bean as well.

1. Create a new [@Bean](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Bean.html) method on ClientConfiguration in the stock-client module, called rSocketStockClient, which returns a StockClient.
2. The body of this method needs to return a new RSocketStockClient, which will need to take an rSocketRequester as a constructor argument.
3. Add an [RSocketRequester](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/messaging/rsocket/RSocketRequester.html) as a method parameter to this rSocketStockClient method.
4. (Tip: we can get IntelliJ IDEA to add the correct method parameter if we pass an unknown variable rSocketRequester into the RSocketStockClient constructor, [press Alt+Enter](https://www.jetbrains.com/help/idea/migrating-from-eclipse-to-intellij-idea.html#273a3d24) on the unknown variable and select “Create parameter”.)
5. (Tip: IntelliJ IDEA Ultimate will warn you that this parameter can’t be autowired because no beans match this type.)
6. Create another @Bean method called rSocketRequester that returns an RSocketRequester.
7. Declare an [RSocketRequester.Builder](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/messaging/rsocket/RSocketRequester.Builder.html) parameter `builder` for the method. This should be wired in automatically by Spring.
8. Use the builder’s [connectTcp](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/messaging/rsocket/RSocketRequester.Builder.html#connectTcp-java.lang.String-int-) method and give it “localhost” and port 7000 (that’s where our Spring Boot RSocket server is running). Call block() to complete this connection.

```java
@Configuration
public class ClientConfiguration {
    // WebClientStockClient bean method...
 
    @Bean
    public StockClient rSocketStockClient(RSocketRequester rSocketRequester) {
        return new RSocketStockClient(rSocketRequester);
    }
 
    @Bean
    public RSocketRequester rSocketRequester(RSocketRequester.Builder builder) {
        return builder.connectTcp("localhost", 7000).block();
    }
 
    // WebClient bean method...
}
```



### 选择使用哪个 Bean

If we go to our JavaFX ChartController (in the stock-ui module), this is the class that uses the StockClient to connect to the price service and display prices on the chart. IntelliJ IDEA Ultimate shows a warning in this class that there’s more than one Bean that matches the StockClient type, our RSocket stock client and our WebClient stock client. We need to figure out a way to specify which client we really want to use. One way to do this is with [Spring profiles](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-definition-profiles-java).

1. Add a [@Profile](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Profile.html) annotation to the webClientStockClient method, passing in a value of `sse` (Server-Sent Events).
2. Give the RSocketStockClient a [@Profile](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/annotation/Profile.html) of “rsocket”.

```java
@Bean
@Profile("sse")
public StockClient webClientStockClient(WebClient webClient) {
    return new WebClientStockClient(webClient);
}
 
@Bean
@Profile("rsocket")
public StockClient rSocketStockClient(RSocketRequester rSocketRequester) {
    return new RSocketStockClient(rSocketRequester);
}
```



### 选择激活的配置

If we’re using IntelliJ IDEA Ultimate, when we go to the ChartController we can see the error has gone away now. But we still [need to say which profile we want to use](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-definition-profiles-enable).

1. Go to application.properties in the stock-ui module.
2. Set the spring.profiles.active property to `sse`. This should give us the same bean and the same functionality that we had before.

```properties
# web-application and application title properties here...
spring.profiles.active=sse
```

3. Re-run the application, the application should start up as expected and the chart should show two sets of prices as before.
4. Note in the run window that the JavaFX application has started up with the *sse* profile.



### 调试日志

If we want to be extra sure that we’re using the bean we think we’re using, we could go back to the clients and add some logging.

1. In the pricesFor method of WebClientStockClient add an info-level log message to state that this is the WebClient stock client.

```java
public Flux<StockPrice> pricesFor(String symbol) {
    log.info("WebClient stock client");
    return // create Flux here...
}
```

2. Do something similar for the RSocketStockClient.

```java
public Flux<StockPrice> pricesFor(String symbol) {
    log.info("RSocket stock client");
    return // create Flux here...
}
```

3. Re-run the application, we should see two log messages that we’re using the WebClient stock client.

### 通过 RSocket 获取价格

Let’s finally use RSocket to get prices to display on our JavaFX line chart.

1. Go back to the application.properties file in stock-ui and change the active profile to `rsocket`.
2. Re-run the application, everything should still works the way we expect. This time we’re using the *rsocket* profile and connecting to the RSocket price server via the RSocketStockClient.

```properties
# web-application and application title properties here...
spring.profiles.active=rsocket
```

So there we have it. A full end-to-end application with a JavaFX line chart that subscribes to a reactive stream of prices from a Kotlin Spring Boot application, and can be configured to get those prices either via server sent events or via the new RSocket protocol.

Full code is available on GitHub:

- [Client project](https://github.com/trishagee/jb-stock-client) (stock-client and stock-ui modules).
- [Server project](https://github.com/trishagee/jb-stock-service) (Kotlin Spring Boot application)

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























