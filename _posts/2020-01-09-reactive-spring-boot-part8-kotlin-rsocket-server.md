---
typora-root-url: ../
layout:     post
title:      响应式Spring Boot系列教程8
date:       '2020-01-09T09:49'
subtitle:   Kotlin RSocket服务器
author:     招文桃
catalog:    true
tags:
    - RSocket
    - Kotlin
    - Spring Boot
    - Reactive
    - 教程
    - 翻译
---

> 原文由 Trisha Gee 在当地时间2019年12月9日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/12/tutorial-reactive-spring-boot-kotlin-rsocket-server/)



In this lesson we add a new back end service in Kotlin, this time emitting the prices via [RSocket](https://rsocket.io/), a protocol for reactive streams.

This is the eighth part of our tutorial showing how to build a Reactive application using Spring Boot, Kotlin, Java and [JavaFX](https://openjfx.io/). The original inspiration was a [70 minute live demo.](https://blog.jetbrains.com/idea/2019/10/fully-reactive-spring-kotlin-and-javafx-playing-together/)

This blog post contains a video showing the process step-by-step and a textual walk-through (adapted from the transcript of the video) for those who prefer a written format.

<!--more-->

[[This tutorial is a series of steps](https://blog.jetbrains.com/idea/tag/tutorial-reactive-spring/) during which we will build a full [Spring Boot](https://spring.io/projects/spring-boot) application featuring a [Kotlin](https://kotlinlang.org/) back end, a [Java](https://jdk.java.net/13/) client and a [JavaFX](https://openjfx.io/) user interface.

At this point in the tutorial series, we’ve successfully created an end to end application that publishes prices from a Kotlin Spring Boot service and [shows them on a JavaFX line chart](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-displaying-reactive-data). This uses HTTP and [server sent events](https://en.wikipedia.org/wiki/Server-sent_events). However, since this is a reactive application we might want to choose a protocol that’s better suited to streaming data.

In this step we’re going to create a service that produces price data via the [RSocket protocol](https://rsocket.io/).

### 创建一个 RSocket 控制器

We’re going to make these changes in the Kotlin Spring Boot application that we created back in [Part One](https://blog.jetbrains.com/idea/2019/10/tutorial-reactive-spring-boot-a-kotlin-rest-service/) of this tutorial, our [StockServiceApplication.kt](https://github.com/trishagee/s1p-stocks-service/blob/master/src/main/kotlin/com/mechanitis/demo/stocks/service/ServiceApplication.kt). Our existing service has a REST Controller. We’re going to create a similar class for RSocket.

1. Inside StockServiceApplication.kt, create a new class `RSocketController`.
2. Annotated it as a Spring [Controller](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/stereotype/Controller.html).
3. Create a new Kotlin function that takes a single argument.
4. (Tip: we can use the *fun1* [Live Template](https://www.jetbrains.com/help/idea/using-live-templates.html) to get IntelliJ IDEA to create the outline of this function for us.)
5. Call the function `prices`, the same as the `RestController` function. This takes a String symbol and returns a [Flux](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html) of `StockPrice`.

```kotlin
@SpringBootApplication
class StockServiceApplication
 
// main function here...
 
@RestController
class RestController() {
    // controller body here...
}
 
@Controller
class RSocketController() {
    fun prices(symbol: String): Flux<StockPrice> {
        
    }
}
 
// StockPrice data class here
```

(note: this code will not compile yet, the function needs to return something)

### 引入价格服务

This prices function is going to look a lot like the prices function in the RestController since it’s actually going to do the same thing. The only difference is it’s going to publish the prices in a different way. To reduce duplication, let’s introduce a price service that contains the shared logic.

1. Add a `priceService` constructor parameter of type `PriceService`.
2. (Tip: if we type priceService into the prices method body, we can press Alt+Enter on the red text and get IntelliJ IDEA to “create property priceService as a constructor parameter”)
3. Create the `PriceService` class inside this same file.
4. (Tip: we can press Alt+Enter on the red `PriceService` type in the constructor and get IntelliJ IDEA to “Create class PriceService” in this StockServiceApplication.kt file)
5. Annotate the `PriceService` with @[Service](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/stereotype/Service.html).

```kotin
@SpringBootApplication
class StockServiceApplication
 
// main function here...
 
// @RestController here... 
 
@Controller
class RSocketController(val priceService: PriceService) {
    fun prices(symbol: String): Flux<StockPrice> {
        
    }
}
 
@Service
class PriceService {
 
}
 
// StockPrice data class here...
```



### 将共享代码移入 PriceService

1. Create a function called `generatePrices` in the service class.
2. (Tip: if we call `priceService.generatePrices` from inside the prices function of `RSocketController`, we can press Alt+Enter on the red function call and get IntelliJ IDEA to generate the function for us.)
3. This function needs to take a symbol of type String, and return a `Flux` of `StockPrice`, the same as our `prices` functions.
4. The logic for this function already exists in `RestController.prices`, so copy the body of that function into the new `generatePrices` function.
5. This needs the `randomStockPrice` function too, so copy this from `RestController` into `PriceService`.
6. Make sure the prices method of `RSocketController` calls `generatePrices` and returns the results.

```kotlin
@SpringBootApplication
class StockServiceApplication
 
// main function here...
 
// @RestController here... 
 
@Controller
class RSocketController(val priceService: PriceService) {
    fun prices(symbol: String): Flux<StockPrice> {
        return priceService.generatePrices(symbol)
    }
}
 
@Service
class PriceService {
    fun generatePrices(symbol: String): Flux<StockPrice> {
        return Flux
            .interval(Duration.ofSeconds(1))
            .map { StockPrice(symbol, randomStockPrice(), now()) }
    }
 
    private fun randomStockPrice(): Double {
        return ThreadLocalRandom.current().nextDouble(100.0)
    }
}
 
// StockPrice data class here...
```

### 减少重复代码

Now everything here is compiling, we can remove the duplicated code in the RestController.

1. Introduce a `priceService` constructor parameter to the `RestController`.
2. Call `generatePrices` from inside `RestController.prices` instead of generating the prices there.
3. Remove the `randomStockPrice` function inside `RestController` since it’s not being used.
4. (Tip: we can press Alt+Enter on the grey `randomStockPrices` function name and select [Safe delete](https://www.jetbrains.com/help/idea/safe-delete.html) to remove this. Or we can use Alt+Delete/⌘⌦ on the function name).

```kotlin
@RestController
class RestController(val priceService: PriceService) {
    @GetMapping(value = ["/stocks/{symbol}"],
                produces = [MediaType.TEXT_EVENT_STREAM_VALUE])
    fun prices(@PathVariable symbol: String): Flux<StockPrice> {
        return priceService.generatePrices(symbol)
    }
}
 
@Controller
class RSocketController(val priceService: PriceService) {
    fun prices(symbol: String): Flux<StockPrice> {
        return priceService.generatePrices(symbol)
    }
}
 
@Service
class PriceService {
    fun generatePrices(symbol: String): Flux<StockPrice> {
        return Flux
            .interval(Duration.ofSeconds(1))
            .map { StockPrice(symbol, randomStockPrice(), now()) }
    }
 
    private fun randomStockPrice(): Double {
        return ThreadLocalRandom.current().nextDouble(100.0)
    }
}
```



### 重构减少模板代码

The prices functions on both the RestController and the RSocketController are now simply calling the PriceService, so all the common code is in one place. Kotlin allows us to simplify this code even further.

1. Convert the `prices` function to an [expression body](https://kotlinlang.org/docs/reference/basic-syntax.html#defining-functions) and remove the declared return type.
2. (Tip: if we press Alt+Enter on the curly braces of the function, IntelliJ IDEA offers the option of “Convert to expression body”. Once we’ve done this, the return type will be highlighted and we can easily delete it.)
3. Do this with both `prices` functions.

```kotlin
@RestController
class RestController(val priceService: PriceService) {
    @GetMapping(value = ["/stocks/{symbol}"],
                produces = [MediaType.TEXT_EVENT_STREAM_VALUE])
    fun prices(@PathVariable symbol: String) = priceService.generatePrices(symbol)
 
}
 
@Controller
class RSocketController(val priceService: PriceService) {
    fun prices(symbol: String) = priceService.generatePrices(symbol)
}
```

Because this function is a simple delegation, this might be a more useful, and certainly shorter, way to write it.

### 设置好消息映射 message mapping

The RestController function is annotated with GetMapping, which sets up the URL for clients to connect to consume this stream of prices. We need to do something similar for the RSocketController function.

1. Add a [MessageMapping](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/messaging/handler/annotation/MessageMapping.html) annotation onto `RSocketController.prices`.
2. Add the dependency `spring-boot-starter-rsocket` to the pom.xml file.
3. (Tip: IntelliJ IDEA can help us here with code completion in pom.xml, or you can [generate a dependency](https://www.jetbrains.com/help/idea/work-with-maven-dependencies.html))

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-rsocket</artifactId>
</dependency>
```

1. Back in our StockServiceApplication file, we can add an import for MessageMapping.
2. Pass in to the @MessageMapping annotation a String route so that clients can connect.

```kotlin
@Controller
class RSocketController(val priceService: PriceService) {
    @MessageMapping("stockPrices")
    fun prices(symbol: String) = priceService.generatePrices(symbol)
}
```



### 设置好一个 RSocket 服务器

If we start the application now, we can see which servers have been started. At this time, we should only have Netty on port 8080. We want an RSocket server as well.

Go to application.properties and define an RSocket server port as 7000.

```properties
spring.rsocket.server.port=7000
```

Simply defining the port here is enough to get Spring Boot to start an RSocket server for us, so when we re-start the application, we will see a Netty RSocket server started on port 7000 (for an example see [the end of the video](https://youtu.be/JYg159twPYE?t=281)).

Now we have a prices service started on port 7000 ready for a client to connect to it to receive stock prices via RSocket. Stay tuned for the next lesson, where we’ll connect to this server and consume the prices.

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























