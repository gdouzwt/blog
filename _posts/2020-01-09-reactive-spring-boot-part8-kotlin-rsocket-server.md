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
---

> 原文由 Trisha Gee 在当地时间2019年12月9日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/12/tutorial-reactive-spring-boot-kotlin-rsocket-server/)



In this lesson we add a new back end service in Kotlin, this time emitting the prices via [RSocket](https://rsocket.io/), a protocol for reactive streams. 在这一节，我们将给Kotlin后端添加一个新的服务，这次是通过 RSocket，一种为响应式数据流而生的协议，发送价格数据。

At this point in the tutorial series, we’ve successfully created an end to end application that publishes prices from a Kotlin Spring Boot service and [shows them on a JavaFX line chart](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-displaying-reactive-data). This uses HTTP and [server sent events](https://en.wikipedia.org/wiki/Server-sent_events). However, since this is a reactive application we might want to choose a protocol that’s better suited to streaming data. 目前为止，我们以及成功地创建了一个端到端的应用程序，从Kotlin Spring Boot后端发送价格数据，并且将它们展示到一个 JavaFX 折线图上。那用的是 HTTP 的服务器发送事件。 但是，既然我们这个是响应式应用程序，我们可能想要选择一种更加适合流式数据的协议。

In this step we’re going to create a service that produces price data via the [RSocket protocol](https://rsocket.io/).

在这一步，我们要创建一个通过 RSocket协议发送价格数据的服务

<!--more-->

### 创建一个 RSocket 控制器

We’re going to make these changes in the Kotlin Spring Boot application that we created back in [Part One](https://blog.jetbrains.com/idea/2019/10/tutorial-reactive-spring-boot-a-kotlin-rest-service/) of this tutorial, our [StockServiceApplication.kt](https://github.com/trishagee/s1p-stocks-service/blob/master/src/main/kotlin/com/mechanitis/demo/stocks/service/ServiceApplication.kt). Our existing service has a REST Controller. We’re going to create a similar class for RSocket.

我们要对在本教程第一部分当中创建的Kotlin Spring Boot应用程序做一些更改，我们的 StockServiceApplication.kt文件。我们已存在的服务有一个 REST 控制器，我们将为 RSocket 创建一个类似的类。

1. Inside StockServiceApplication.kt, create a new class `RSocketController`. 在 StockServiceApplication.kt 内，创建一个新的类 RSocketController
2. Annotated it as a Spring [Controller](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/stereotype/Controller.html). 将其注解为 Spring 的 Controller
3. Create a new Kotlin function that takes a single argument. 创建一个新的需要一个参数的 Kotlin 函数
4. (Tip: we can use the *fun1* [Live Template](https://www.jetbrains.com/help/idea/using-live-templates.html) to get IntelliJ IDEA to create the outline of this function for us.) （提示：我们可以使用 fun1 Live模板去让 IntelliJ IDEA给我们创建这个函数的轮廓）
5. Call the function `prices`, the same as the `RestController` function. This takes a String symbol and returns a [Flux](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html) of `StockPrice`. 将这个函数命名为 `prices` 就跟 RestController 函数里的一样。 它需要一个 String类型的参数 symbol 并且返回一个 Flux 的`StockPrice`

```kotlin
@SpringBootApplication
class StockServiceApplication
 
// main 函数在这里...
 
@RestController
class RestController() {
    // 控制器主体在这里...
}
 
@Controller
class RSocketController() {
    fun prices(symbol: String): Flux<StockPrice> {
        
    }
}
 
// 这里是StockPrice数据类
```

(note: this code will not compile yet, the function needs to return something)

（注意：这些代码还未能通过编译，函数需要返回某些东西）

### 引入价格服务

This prices function is going to look a lot like the prices function in the RestController since it’s actually going to do the same thing. The only difference is it’s going to publish the prices in a different way. To reduce duplication, let’s introduce a price service that contains the shared logic.

这里的 prices 函数看起来会更 RestController里面的 prices 函数非常像，因为它们实际上是干同样的事情。唯一不同之处是它们以不同的方式发布价格数据。为了减少冗余，让我们引入一个价格服务囊括它们共享的逻辑。

1. Add a `priceService` constructor parameter of type `PriceService`. 添加一个类型为 PriceService 的构造函数参数 priceService
2. (Tip: if we type priceService into the prices method body, we can press Alt+Enter on the red text and get IntelliJ IDEA to “create property priceService as a constructor parameter”) （提示：如果我们在prices方法体输入 priceService，我们可以在红色的文字按下 Alt+Enter，让IntelliJ IDEA 为构造函数参数创建属性 priceService)
3. Create the `PriceService` class inside this same file. 在同一个文件中创建一个 PriceService 类
4. (Tip: we can press Alt+Enter on the red `PriceService` type in the constructor and get IntelliJ IDEA to “Create class PriceService” in this StockServiceApplication.kt file) （提示：在StockServiceApplication.kt文件，我们可以在构造函数里面红色的PriceService 按下Alt+Eneter，然后让 IntelliJ IDEA 创建类 PriceService）
5. Annotate the `PriceService` with @[Service](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/stereotype/Service.html). 用@Service 将`PriceService`注解。

```kotlin
@SpringBootApplication
class StockServiceApplication
 
// main函数在这里
 
// @RestController在这里
 
@Controller
class RSocketController(val priceService: PriceService) {
    fun prices(symbol: String): Flux<StockPrice> {
        
    }
}
 
@Service
class PriceService {
 
}
 
// StockPrice数据类在这里
```



### 将共享代码移入 PriceService

1. Create a function called `generatePrices` in the service class. 在service类创建一个函数 generatePrices
2. (Tip: if we call `priceService.generatePrices` from inside the prices function of `RSocketController`, we can press Alt+Enter on the red function call and get IntelliJ IDEA to generate the function for us.) （提示：如果我们在RSocketController的prices函数内调用 `pricesService.generatePrices` ，我们可以在红色的函数上按 Alt + Enter ，让IntelliJ IDEA为我们生成函数）
3. This function needs to take a symbol of type String, and return a `Flux` of `StockPrice`, the same as our `prices` functions. 这个函数需要一个类型为 String 的股票代码（symbol)，并返回一个 StockPrice 的Flux，跟我们的 prices 函数一样。
4. The logic for this function already exists in `RestController.prices`, so copy the body of that function into the new `generatePrices` function. 这样的逻辑以及存在于 RestController.prices，所以将那个函数体复制到新的`generatePrices` 函数里。
5. This needs the `randomStockPrice` function too, so copy this from `RestController` into `PriceService`. 这也需要 `randomStockPrice` 函数，所以从 `RestController` 复制这个到 `PriceService`
6. Make sure the prices method of `RSocketController` calls `generatePrices` and returns the results. 确保 `RSocketController` 里面的 `prices`方法调用 `generatePrices` 并返回结果。

```kotlin
@SpringBootApplication
class StockServiceApplication
 
// main函数在这里...
 
// @RestController在这里
 
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
 
// StockPrice数据类在这里
```

### 减少重复代码

Now everything here is compiling, we can remove the duplicated code in the RestController.

现在这里所有东西都能通过编译，我们可以从RestController里移除冗余的代码。

1. Introduce a `priceService` constructor parameter to the `RestController`. 在RestController的构造函数参数引入 priceService
2. Call `generatePrices` from inside `RestController.prices` instead of generating the prices there. 从RestController.prices里面调用 generatePrices 而不是在那里调用。
3. Remove the `randomStockPrice` function inside `RestController` since it’s not being used. 移除RestController里面的randomStockPrice函数，因为没有用到。
4. (Tip: we can press Alt+Enter on the grey `randomStockPrices` function name and select [Safe delete](https://www.jetbrains.com/help/idea/safe-delete.html) to remove this. Or we can use Alt+Delete/⌘⌦ on the function name). （提示：我们可以在灰色的 randomStockPrices 函数名上按下 Alt+Enter，并选择 Safe delete 去将它移除。 或者我们可以函数名上使用 Alt + Delete/⌘⌦）

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

在 RestController 和 RSocketController上的 prices 函数现在都只是直接调用 PriceService 所有所有通用的代码都在要给地方了。Kotlin 让我们可以进一步简化代码。



1. Convert the `prices` function to an [expression body](https://kotlinlang.org/docs/reference/basic-syntax.html#defining-functions) and remove the declared return type. 将 prices 函数转化为一个表达式体（expression body），并移除声明的返回值类型。
2. (Tip: if we press Alt+Enter on the curly braces of the function, IntelliJ IDEA offers the option of “Convert to expression body”. Once we’ve done this, the return type will be highlighted and we can easily delete it.) （提示：如果我们在函数的花括号上按下 Alt + Enter，IntelliJ IDEA 会提供选项"Convert to expression body" 完成这个操作之后，返回值类型会被高亮，然后我们可以轻松将它删除）
3. Do this with both `prices` functions. 对 prices 函数进行这样的操作。

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

Because this function is a simple delegation, this might be a more useful, and certainly shorter, way to write it. 因为这个函数是一个简单的委派，这可能更有用，肯定是更加简短，便于编写。

### 设置好消息映射 message mapping

The RestController function is annotated with GetMapping, which sets up the URL for clients to connect to consume this stream of prices. We need to do something similar for the RSocketController function.

那个RestController是用GetMapping 注解的，用于设置客户端连接到价格数据流的 URL。 对于 RSocketController函数我们也需要类型的东西。

1. Add a [MessageMapping](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/messaging/handler/annotation/MessageMapping.html) annotation onto `RSocketController.prices`. 给RSocketController.prices添加一个 MessageMapping 注解。
2. Add the dependency `spring-boot-starter-rsocket` to the pom.xml file. 添加 spring-boot-starter-rsocket 依赖到 pom.xml 文件
3. (Tip: IntelliJ IDEA can help us here with code completion in pom.xml, or you can [generate a dependency](https://www.jetbrains.com/help/idea/work-with-maven-dependencies.html)) （提示：IntelliJ IDEA能帮我们在 pom.xml里面进行代码补全，或者生成一个依赖）

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-rsocket</artifactId>
</dependency>
```

1. Back in our StockServiceApplication file, we can add an import for MessageMapping. 回到我们的StockServiceApplication文件，我们可以为 MessageMapping 添加一个导入。
2. Pass in to the @MessageMapping annotation a String route so that clients can connect. 给@MassageMapping 注解添加一个字符串路由，以便客户端能够连接。

```kotlin
@Controller
class RSocketController(val priceService: PriceService) {
    @MessageMapping("stockPrices")
    fun prices(symbol: String) = priceService.generatePrices(symbol)
}
```



### 设置好一个 RSocket 服务器

If we start the application now, we can see which servers have been started. At this time, we should only have Netty on port 8080. We want an RSocket server as well.

现在如果我们启动应用程序，我们可以看到哪个服务器已经被启动。目前，我们应该只能看到8080端口的 Netty。我们想RSocket服务器也启动。

Go to application.properties and define an RSocket server port as 7000.

去到 application.properties文件并定义一个RSocket服务端口为 7000

```properties
spring.rsocket.server.port=7000
```

Simply defining the port here is enough to get Spring Boot to start an RSocket server for us, so when we re-start the application, we will see a Netty RSocket server started on port 7000 (for an example see [the end of the video](https://youtu.be/JYg159twPYE?t=281)). 只需要在这里定义端口就足以让Spring Boot为我们启动一个RSocket服务器，因此我们只需要重启应用程序，我们会看到一个 Netty RSocket服务器启动在 7000端口（例子可以看配套视频的最后）

Now we have a prices service started on port 7000 ready for a client to connect to it to receive stock prices via RSocket. Stay tuned for the next lesson, where we’ll connect to this server and consume the prices.

现在我们在7000端口有了一个价格服务准备好给客户端通过RSocket去连接获取价格数据了。敬请留意下一节，我们将连接到这个服务器，并消费价格数据。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























