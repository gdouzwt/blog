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



在这一节，我们将给Kotlin后端添加一个新的服务，这次是通过RSocket，一种为响应式数据流而生的协议，发送价格数据。

目前为止，我们以及成功地创建了一个端到端的应用程序，从Kotlin Spring Boot后端发送价格数据，并且将它们展示到一个JavaFX折线图上。那用的是HTTP的服务器发送事件。 但是，既然我们这个是响应式应用程序，我们可能想要选择一种更加适合流式数据的协议。

在这一步，我们要创建一个通过RSocket协议发送价格数据的服务

<!--more-->

### 创建一个RSocket控制器

我们要对在本教程第一部分当中创建的Kotlin Spring Boot应用程序做一些更改，我们的 StockServiceApplication.kt文件。我们已存在的服务有一个REST控制器，我们将为RSocket创建一个类似的类。

1. 在StockServiceApplication.kt内，创建一个新的类`RSocketController`。
2. 将其注解为Spring的Controller。
3. 创建一个新的需要一个参数的Kotlin函数。
4. （提示：我们可以使用 fun1 Live模板去让 IntelliJ IDEA给我们创建这个函数的轮廓）。
5. 将这个函数命名为`prices`就跟RestController函数里的一样。 它需要一个String类型的参数symbol并且返回一个`Flux`的`StockPrice`。

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

（注意：这些代码还未能通过编译，函数需要返回某些东西）。

### 引入价格服务

这里的`prices`函数看起来会跟`RestController`里面的`prices`函数非常像，因为它们实际上是干同样的事情。唯一不同之处是它们以不同的方式发布价格数据。为了减少冗余，让我们引入一个价格服务包含它们共享的逻辑。

1. 添加一个类型为`PriceService`的构造函数参数`priceService`。
2. （提示：如果我们在`prices`方法体输入`priceService`，我们可以在红色的文字按下Alt+Enter，让IntelliJ IDEA 为构造函数参数创建属性`priceService`)。
3. 在同一个文件中创建一个`PriceService`类。
4. （提示：在StockServiceApplication.kt文件，我们可以在构造函数里面红色的`PriceService`按下Alt+Eneter，然后让 IntelliJ IDEA 创建类`PriceService`）。
5. 用`@Service`将`PriceService`注解。

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

1. 在`service`类创建一个函数`generatePrices`。
2. （提示：如果我们在`RSocketController`的prices函数内调用 `pricesService.generatePrices` ，我们可以在红色的函数上按 Alt + Enter ，让IntelliJ IDEA为我们生成函数）。
3. 这个函数需要一个类型为`String`的股票代号（symbol)，并返回一个`StockPrice`的`Flux`，跟我们的`prices`函数一样。
4. 这样的逻辑以及存在于`RestController.prices`，所以将那个函数体复制到新的`generatePrices` 函数里。
5. 这也需要`randomStockPrice`函数，所以从`RestController`复制这个到`PriceService`。
6. 确保`RSocketController`里面的`prices`方法调用`generatePrices`并返回结果。

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

现在这里所有东西都能通过编译，我们可以从`RestController`里移除冗余的代码。

1. 在`RestController`的构造函数参数引入`priceService`。
2. 从`RestController.prices`里面调用`generatePrices`而不是在那里调用。
3. 移除`RestController`里面的`randomStockPrice`函数，因为没有用到。
4. （提示：我们可以在灰色的`randomStockPrices`函数名上按下Alt+Enter，并选择Safe delete去将它移除。 或者我们可以函数名上使用 Alt + Delete/⌘⌦）。

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

在`RestController`和`RSocketController`上的`prices`函数现在都只是直接调用`PriceService`所有所有通用的代码都在要给地方了。Kotlin让我们可以进一步简化代码。



1. 将`prices`函数转化为一个表达式体（expression body），并移除声明的返回值类型。
2. （提示：如果我们在函数的花括号上按下 Alt + Enter，IntelliJ IDEA 会提供选项"Convert to expression body" 完成这个操作之后，返回值类型会被高亮，然后我们可以轻松将它删除）。
3. 对`prices`函数进行这样的操作。

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

### 设置好消息映射

那个`RestController`是用`@GetMapping`注解的，用于设置客户端连接到价格数据流的URL。 对于 `RSocketController`函数我们也需要类型的东西。

1. 给`RSocketController.prices`添加一个`@MessageMapping`注解。
2. 添加spring-boot-starter-rsocket依赖到pom.xml文件。
3. （提示：IntelliJ IDEA能帮我们在pom.xml里面进行代码补全，或者生成一个依赖）。

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-rsocket</artifactId>
</dependency>
```

1. 回到我们的StockServiceApplication文件，我们可以为`@MessageMapping`添加一个导入。
2. 给`@MassageMapping`注解添加一个字符串路由，以便客户端能够连接。

```kotlin
@Controller
class RSocketController(val priceService: PriceService) {
    @MessageMapping("stockPrices")
    fun prices(symbol: String) = priceService.generatePrices(symbol)
}
```



### 设置好一个 RSocket 服务器

现在如果我们启动应用程序，我们可以看到哪个服务器已经被启动。目前，我们应该只能看到8080端口的 Netty。我们想RSocket服务器也启动。

去到application.properties文件并定义一个RSocket服务端口为 7000

```properties
spring.rsocket.server.port=7000
```

只需要在这里定义端口就足以让Spring Boot为我们启动一个RSocket服务器，因此我们只需要重启应用程序，我们会看到一个Netty RSocket服务器启动在7000端口（例子可以看配套视频的最后）。



现在我们在7000端口有了一个价格服务准备好给客户端通过RSocket去连接获取价格数据了。下一节，我们将连接到这个服务器，并消费价格数据。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)：https://github.com/zwt-io/rsb/











