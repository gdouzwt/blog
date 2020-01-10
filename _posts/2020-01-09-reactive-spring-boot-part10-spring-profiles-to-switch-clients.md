---
typora-root-url: ../
layout:     post
title:      响应式Spring Boot系列教程10
date:       '2020-01-09T11:12'
subtitle:   用Spring Profiles切换客户端
author:     招文桃
catalog:    true
tags:
    - JavaFX
    - Spring Boot
    - Reactive
    - 教程
---

> 原文由 Trisha Gee 在当地时间2019年12月16日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/12/tutorial-reactive-spring-boot-kotlin-rsocket-server/)

在这一节，我们使用 Spring Profiles让应用程序决定使用哪个客户端（使用服务端发送事件的 WebClient，或 RSocket）连接到 Kotlin Spring Boot 股票价格服务。

现在我们有了一个RSocket客户端，可以让我们连接到我们的RSocket服务器，我们想在我们的JavaFX应用程序中使用它。

<!--more-->

### 创建 RSocketStockClient Bean

我们特意创建两种 StockClient 实现，一个通过 RSocket连接，然后另一个是用 WebClient。我们的ClientConfiguration仅将其中一个Bean暴露，即WebClientStockClient，如果我们希望应用程序能够使用RSocket客户端，则也需要添加一个RSocketClient Bean。

1. 在stock-client模块的ClientConfiguration创建一个新的 @Bean 方法，命名为rSocketStockClient，其返回值类型为 StockClient。

1. 这个方法体需要返回一个新的 RSocketStockClient，所以需要一个 rSocketRequester 作为构造函数参数。

2. 给rSocketStockClient方法添加一个RSocketRequester作为参数。

3. 提示：我们可以让IntelliJ IDEA添加适当的方法参数，如果我们传入一个未知变量rSocketRequester到RSocketStockClient的构造器，在未知变量按下 Alt+Enter并选择“Create parameter"）

4. 提示：IntelliJ IDEA Ultimate会警告你说这个参数不能自动注入，因为没有类型匹配的 Beans）

5. 创建另一个名为 rSocketRequester的 @Bean方法，返回RSocketRequester。

6. 给方法声明一个类型为 RSocketRequester.Builder 的参数`builder` 这应该会被Spring 自动注入。

7. 使用 builder 的 connectTcp 方法，并给它 "localhost" 和端口 7000(这是Spring Boot的RSocket运行地址)。调用 block() 方法完成这次连接。

```java
@Configuration
public class ClientConfiguration {
    // WebClientStockClient bean 方法...
 
    @Bean
    public StockClient rSocketStockClient(RSocketRequester rSocketRequester) {
        return new RSocketStockClient(rSocketRequester);
    }
 
    @Bean
    public RSocketRequester rSocketRequester(RSocketRequester.Builder builder) {
        return builder.connectTcp("localhost", 7000).block();
    }
 
    // WebClient bean 方法...
}
```



### 选择使用哪个 Bean

如果我们回到 JavaFX 的 ChartController（在stock-ui 模块），这个类就是用了 StockClient 去连接到价格服务，并在图表上显示价格的。IntelliJ IDEA 旗舰版在这个类显示警告，说这里边有多于一个Bean符合 StockClient 类型，也就是我们的 rSocketStockClient 和 webClientStockClient。我们需要配置一种方式，指定我们实际想要使用哪个客户端。一种做法是使用 Spring profiles.

1. 添加一个 @Profile 注解到 webClientStockClient方法，传入一个值 `sse`（表示 Server-Sent Events)。
2. 给 rSocketStockClient添加一个 @Profile注解，值为`rsocket`

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

如果我们使用的是IntelliJ IDEA旗舰版，当我们在 ChartController里面，我们可以看到错误已经消失了。但我们还是需要指定想要使用哪个配置(profile)。

1. 去到stock-ui模块的application.properties文件
2. 设置 spring.profiles.active属性的值为`sse` 这应该会给我们同样的 Bean和之前同样的功能。

```properties
# web-application and application title properties here...
spring.profiles.active=sse
```

3.  重新运行应用程序，程序应该按预期启动，并像之前那样显示两组价格数据。
4. 注意到在运行窗口，JavaFX应用程序已经以 *sse* 配置启动。



### 调试日志

如果我们想更加确认我们所使用的Bean，我们可以回到客户端并添加一些日志功能。

1. 在WebClientStockClient里面的pricesFor方法添加一个info等级的日志信息表示当前使用的是 WebClient stock client

```java
public Flux<StockPrice> pricesFor(String symbol) {
    log.info("WebClient stock client");
    return // 在这里创建Flux
}
```

2. 在RSocketStockClient也做类似的操作

```java
public Flux<StockPrice> pricesFor(String symbol) {
    log.info("RSocket stock client");
    return // 在这里创建Flux
}
```

3. 重新运行应用程序，我们应该看到两个日志消息，表示我们当前使用的是 WebClient stock client



### 通过 RSocket 获取价格

最后让我们使用 RSocket去获取股票价格并显示到 JavaFX的折线图上吧。

1. 回到stock-ui的application.properties 文件，并将活动的配置改为 `rsocket`。
2. 重新运行应用程序，所有东西应该按预期运行。这次我们使用的是 *rsocket* 配置，并通过 RSocketStockClient连接到 RSocket 价格服务器。

```properties
#这里是 web-application 和 application title 的属性...
spring.profiles.active=rsocket
```

所以就是这样子。一个完整的带有JavaFX折线图，并订阅到一个Kotlin Spring Boot应用程序的响应式数据流的价格数据的端到端应用程序。而且我们能够配置通过服务端发送事件或新的RSocket协议获取这些股票价格。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)