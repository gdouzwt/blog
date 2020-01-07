---
typora-root-url: ../
layout:     post
title:      Reactive Spring Boot 系列教程 - Part 2
date:       '2020-01-07T09:18'
subtitle:   Trisha Gee 在IntelliJ IDEA 博客写的教程
author:     招文桃
catalog:    true
tags:
    - Kotlin
    - Tutorial
    - Spring Boot
    - Reactive
    - 教程
    - 翻译
---

## 响应式 Spring Boot 第 2 部分 - 响应式数据流的 REST 客户端

> Posted on November 4, 2019 by Trisha Gee
>
> 原文由 Trisha Gee 在当地时间2019年11月4日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-rest-client-for-reactive-streams/ )



这是第二步，演示如何创建一个 Java 客户端连接到一个发送一系列服务端发送事件的流。我们将使用测试驱动开发来进行开发客户端并进行测试。



[视频在 B 站](https://www.bilibili.com/video/av81233693)



本教程是一系列视频，概述了构建完整的Spring Boot的许多步骤，具有Kotlin服务后端，Java客户端和JavaFX用户界面的应用程序。

第二个视频将展示如何创建。一个响应式Spring Java客户端，连接到每秒流式传输股票价格的REST服务。



### 创建客户端工程

我们将为这客户端创建一个新工程，我们希望将客户端和服务器代码完全分开，因为它们应该完全独立运行的。

1. 这个工程包含多个模块，所以开始的时候选择创建空工程。
2. 将工程命名为 stock-client 按 Finish
3. 默认情况下，当创建一个新的空 Project 时，IntelliJ IDEA显示 Project Structure 对话框的，Modules 部分。我们将在此处添加一个新模块，这将是一个 Spring Boot模块，因此我们选择左边的 Spring Initializr。
4. SDK我们使用 Java 13，但没有使用新的特性。
5. 输入组和工件的详细信息，我们称此模块为stock-client。
6. 我们将为模块填入一个有用的描述，以便清楚了解此代码的用途。
7. 我们将保留默认使用Java创建Maven项目
8. 选择Java 11作为版本，因为这是当前的长期支持版本。
9. 我们可以选择更改默认的包结构。

接下来选择所选的 Spring Boot Starter

1. 使用Spring Boot 2.2.0 RC1
2. 选择Spring Reactive Web Starter，然后也选择Lombok。
3. 默认模块名称和位置没问题, 保留不变。

IntelliJ IDEA 从 Spring Initializr 获取工程，并适当地设置IDE。选择 enable auto-import 

### 创建客户端类

1. 删除Spring Initializr为我们创建的`StockClientApplication`，在这个模块我们不需要它，因为该模块将成为其他模块的库。
2. 创建一个类WebClientStockClient。它将使用Spring的WebClient来，连接到股票价格服务。



```java
public class WebClientStockClient {

}
```



### 创建客户端的测试

驱动客户端需求并验证可行性的方法之一是，是以测试驱动的方式进行开发。

1. Windows 或 Linux 使用 Ctrl+Shift+T (macOS 使用⇧⌘T ) 我们可以导航到某个类的测试。 在 `WebClientStockClient` 这个类还没有测试 所以让我们创建一个
2. 选择 JUnit 5 作为测试框架
3. This is actually going to be an end-to-end test so enter WebClientStockClientIntegrationTest as the class name
4. Generate a test method using Alt+Insert (⌘N) and selecting “Test Method” from the generate menu.
5. This is not going to be a perfect example of test driven development, as we’re going to just create a single test which looks at only the best case, sometimes called the [happy path](https://en.wikipedia.org/wiki/Happy_path). Call the test something like shouldRetrieveStockPricesFromTheService.
6. Create an instance of WebClientStockClient in order to test it.



```java
class WebClientStockClientIntegrationTest {
    @Test
    void shouldRetrieveStockPricesFromTheService() {
        WebClientStockClient webClientStockClient = new WebClientStockClient();
    }
}
```

One of the things we can do with test driven development is to code against the API we want, instead of testing something we’ve already created. IntelliJ IDEA makes this easier because we can create the test to look the way we want, and then generate the correct code from that, usually using Alt+Enter.

1. In the test, call a method pricesFor on WebClientStockClient. This method takes a String that represents the symbol of the stock we want the prices for.

```java
void shouldRetrieveStockPricesFromTheService() {
    WebClientStockClient webClientStockClient = new WebClientStockClient();
    webClientStockClient.pricesFor("SYMBOL");
}
```

(note: this code will not compile yet)

### 在客户端中创建一个基本的价格方法

1. (Tip: press Alt+Enter on the red pricesFor method to get IntelliJ IDEA to create this method on WebClientStockClient, with the expected signature.)
2. Change the method on WebClientStockClient to return a [Flux](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html) of StockPrice objects.
3. The simplest way to create a method that compiles so we can run our test against it, is to get this method to return an empty Flux:

```java
public class WebClientStockClient {
    public Flux<StockPrice> pricesFor(String symbol) {
        return Flux.fromArray(new StockPrice[0]);
    }
}
```

(note: this code will not compile yet)

### 创建一个类保存股票价格

1. (Tip: It’s easiest to get IntelliJ IDEA to create the StockPrice class using Alt+Enter on the red StockPrice text.)
2. Create StockPrice in the same package as WebClientStockClient

Here’s where we’re going to use [Lombok](https://projectlombok.org/). Using Lombok’s [@Data](https://projectlombok.org/features/Data) annotation, we can create a data class similar to our [Kotlin data class](https://kotlinlang.org/docs/reference/data-classes.html) in the first step of this tutorial. Using this, we only need to define the properties of this class using fields, the getters, setters, equals, hashCode, and toString methods are all provided by Lombok.

Use the [Lombok IntelliJ IDEA plugin](https://projectlombok.org/setup/intellij) to get code completion and other useful features when working with Lombok.

1. Add a String symbol, a Double price and a LocalDateTime time to the StockPrice class.
2. Add an [@AllArgsConstructor and a @NoArgsConstructor via Lombok](https://projectlombok.org/features/constructor), these are needed for our code and for JSON serialisation.



```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class StockPrice {
    private String symbol;
    private Double price;
    private LocalDateTime time;
}
```



### 为测试添加断言

We’ll go back to WebClientStockClientIntegrationTest and add some assertions, we need to check our returned Flux of prices meets our expectations.

1. Store the returned Flux in a prices local variable.
2. Add an assertion that this is not null.
3. Add an assertion that if we take five prices from the flux, we have more than one price.



```java
@Test
void shouldRetrieveStockPricesFromTheService() {
    // given
    WebClientStockClient webClientStockClient = new WebClientStockClient(webClient);
 
    // when
    Flux<StockPrice> prices = webClientStockClient.pricesFor("SYMBOL");
 
    // then
    Assertions.assertNotNull(prices);
    Assertions.assertTrue(prices.take(5).count().block() > 0);
}
```

When we run this test we see that it fails. It fails because the Flux has zero elements in it, because that’s what we hard-coded into the client.

### 将客户端连接到真实的服务

Let’s go back to WebClientStockClient and fill in the implementation.

1. We want to use a WebClient to connect to the service. Create this as a field, and add a constructor parameter so that Spring automatically wires this in for us.

```java
public class WebClientStockClient {
    private WebClient webClient;
 
    public WebClientStockClient(WebClient webClient) {
        this.webClient = webClient;
    }
// ...rest of the class here
```



Now we want to [use WebClient to call our REST service](https://docs.spring.io/spring-boot/docs/current/reference/html/spring-boot-features.html#boot-features-webclient) inside our pricesFor method.

1. Remove the stub code from prices for (i.e. delete `return Flux.fromArray(new StockPrice[0]);`)
2. We’re going to use the web client to make a GET request ([get()](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/reactive/function/client/WebClient.html#get--)).
3. Give it the URI of our service (http://localhost:8080/stocks/{symbol}) and pass in the symbol.
4. Call [retrieve()](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/reactive/function/client/WebClient.RequestHeadersSpec.html#retrieve--).
5. We need to say how to turn the response of this call into a Flux of some type, so we use [bodyToFlux()](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/reactive/function/client/ClientResponse.html#bodyToFlux-java.lang.Class-) and give it our data class, StockPrice.class.

```java
public Flux<StockPrice> pricesFor(String symbol) {
    return webClient.get()
                    .uri("http://localhost:8080/stocks/{symbol}", symbol)
                    .retrieve()
                    .bodyToFlux(StockPrice.class);
}
```

These are the very basic requirements to get a reactive stream from a GET call, but we can also define things like the retry and back off strategy, remember that understanding the flow of data from publisher to consumer is an important part of creating a successful reactive application.

We can also define what to do when specific Exceptions are thrown. As an example, we can say that when we see an IOException we want to log it. We can use the [@Log4j2 annotation from Lombok](https://projectlombok.org/api/lombok/extern/log4j/Log4j2.html) to give us access to the log, and log an error.

This is not the most robust way to handle errors, this simply shows that we can consider Exceptions as a first class concern in our reactive streams.

```java
import lombok.extern.log4j.Log4j2;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;
 
import java.io.IOException;
import java.time.Duration;
 
@Log4j2
public class WebClientStockClient {
    private WebClient webClient;
 
    public WebClientStockClient(WebClient webClient) {
        this.webClient = webClient;
    }
 
    public Flux<StockPrice> pricesFor(String symbol) {
        return webClient.get()
                        .uri("http://localhost:8080/stocks/{symbol}", symbol)
                        .retrieve()
                        .bodyToFlux(StockPrice.class)
                        .retryBackoff(5, Duration.ofSeconds(1), Duration.ofSeconds(20))
                        .doOnError(IOException.class, e -> log.error(e.getMessage()));
    }
}
```



### 运行集成测试

回到 `WebClientStockClientIntegrationTest`，可以看到有些需要修复的东西。

1. 我们现在需要给客户端一个 `WebClient`， 在测试中将其创建为字段。
2. （使用智能补全 `Ctrl+Shift+空格`， IntelliJ IDEA 甚至可以建议创建 `WebClient` 实例的完整语句）



```java
class WebClientStockClientIntegrationTest {
    private WebClient webClient = WebClient.builder().build();
 
    @Test
    void shouldRetrieveStockPricesFromTheService() {
        WebClientStockClient webClientStockClient = new WebClientStockClient(webClient);
 
// ...其余代码
```



1. 为了进行集成测试，REST 服务必须要运行。回到上一个期创建的 `StockServiceApplication` 并运行起来。
2. 运行 `WebClientStockClientIntegrationTest`。 你可以用边栏上的图标或使用快捷键 `Ctrl+Shift+F10` (macOS 快捷键是 ⌃⇧R ) ，或者双击 `Ctrl` (“run anything”) 然后输入测试的名称。

现在我们应该可以看到测试为绿色通过。如果我们看一下输出，可以看到我们正在解码带有符号的StockPrice对象，随机价格和时间。



### 更多关于在集成测试中使用断言

这不是最彻底的测试，所以让我们为的断言添加更多细节，以确保客户端符合我们预期。让我们更改断言为要获取五个价格时要求有五个价格，并确保某股票价格的代号是我们所期望的。

```java
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;
 
class WebClientStockClientIntegrationTest {
    private WebClient webClient = WebClient.builder().build();
 
    @Test
    void shouldRetrieveStockPricesFromTheService() {
        // given
        WebClientStockClient webClientStockClient = new WebClientStockClient(webClient);
 
        // when
        Flux<StockPrice> prices = webClientStockClient.pricesFor("SYMBOL");
 
        // then
        Assertions.assertNotNull(prices);
        Flux<StockPrice> fivePrices = prices.take(5);
        Assertions.assertEquals(5, fivePrices.count().block());
        Assertions.assertEquals("SYMBOL", fivePrices.blockFirst().getSymbol());
    }
}
```



### 总结

测试响应式应用程序是一项技能，而且还有比我们所展示的更好的方法。但是，我们已经成功地使用了集成测试来驱动股票价格客户端的API和功能，该客户端连接到发出服务器发送事件，并返回`Flux<StockPrice>`对象可被其他服务消费的端点。在本教程的后续视频中，我们将展示如何执行此操作。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/).























