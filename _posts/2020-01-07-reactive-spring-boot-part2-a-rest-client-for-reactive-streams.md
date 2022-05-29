---
typora-root-url: ../
layout:     post
title:      响应式Spring Boot系列教程2
date:       '2020-01-07T09:18'
subtitle:   Java REST客户端
author:     招文桃
catalog:    true
tags:
    - Spring Boot
    - Reactive
    - 教程
    - 翻译
---

> 原文由 Trisha Gee 在当地时间2019年11月4日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-rest-client-for-reactive-streams/ )



这是第二步，演示如何创建一个 Java 客户端连接到一个发送一系列服务端发送事件的流。我们将使用测试驱动开发来进行开发客户端并进行测试。[视频在 B 站](https://www.bilibili.com/video/av81233693)

本教程是一系列视频，概述了构建完整的Spring Boot的许多步骤，具有 Kotlin 服务后端，Java 客户端和 JavaFX 用户界面的应用程序。

第二个视频将展示如何创建。一个响应式Spring Java客户端，连接到每秒流式传输股票价格的REST服务。

<!--more-->

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

1. Windows 或 Linux 使用 Ctrl+Shift+T (macOS 使用⇧⌘T ) 我们可以导航到某个类的测试。 在 `WebClientStockClient` 这个类还没有测试 所以让我们创建一个。
2. 选择 JUnit 5 作为测试框架。
3. 这实际上会是一个端到端测试，所以填入 `WebClientStockClientIntegrationTest` 作为类名。
4. 用快捷键 Alt+Insert (⌘N) 生成测试的方法，在生成菜单中选择 “Test Method” 。
5. 这不会是测试驱动开发的完美示例，因为我们只是创建一个只测试最佳情况的测试，有时称为快乐路径测试。将测试命名为像 `shouldRetrieveStockPricesFromTheService`
6. 为测试创建一个 `WebClientStockClient` 实例

```java
class WebClientStockClientIntegrationTest {
    @Test
    void shouldRetrieveStockPricesFromTheService() {
        WebClientStockClient webClientStockClient = new WebClientStockClient();
    }
}
```

我们可以通过测试驱动来做的其中之一，是按照我们想要的API进行编码，而不是测试我们已经创建的东西。IntelliJ IDEA 使得这样的操作更加容易，因为我们可以创建我们想要的测试，并为其生成代码，通常是使用 Alt + Enter

1. 在测试代码中，在 WebClientStockClient 上调用 pricesFor 方法。 这个方法需要一个 String 类型的参数表示想要了解其价格股票的代码。

```java
void shouldRetrieveStockPricesFromTheService() {
    WebClientStockClient webClientStockClient = new WebClientStockClient();
    webClientStockClient.pricesFor("SYMBOL");
}
```

（注意：此代码当前未能通过编译）

### 在客户端中创建一个基本的价格方法

1. （提示：在红色的 pricesFor 方法上按下 Alt + Enter 去让 IntelliJ IDEA 在 `WebClientStockClient` 里边创建这个方法，并有符合预期的签名。）
2. 将 WebClientStockClient 里的方法返回值类改成 `Flux<StockPrice>`  [Flux](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html) 
3. 最简单地创建可编译、测试的方法是，让此方法返回空的Flux：

```java
public class WebClientStockClient {
    public Flux<StockPrice> pricesFor(String symbol) {
        return Flux.fromArray(new StockPrice[0]);
    }
}
```

（注意：此代码当前未能通过编译）

### 创建一个类保存股票价格

1. （提示：最简单的方法是使用Alt + Enter让IntelliJ IDEA创建类）
2. 在与 WebClientStockClient 的包里创建 StockPrice

这就是我们要使用Lombok的地方，使用Lombok的@Data注解，我们可以创建类似于第一个视频中的Kotlin数据类。通过使用@Data注解，我们只需要使用字段定义该类的属性，getters,setters,equals,hashCode，以及toString方法均由Lombok提供。

使用Lombok IntelliJ IDEA插件获得代码补全和其他有用的功能。

1. 添加 String symbol，Double price 以及 LocalDateTime time 到 StockPrice 类。

2. 通过Lombok添加@AllArgsConstructor和@NoArgsConstructor，这对于我们的代码是必需的

   并用于JSON序列化。

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

我们回到 WebClientStockClientIntegrationTest 并添加一些断言， 我们需要检查`Flux<StockPrice>`是否符合预期。

1. 将返回的 Flux 保存到 prices 局部变量。
2. 添加此为非空的断言。
3. 添加一个断言，如果如果我们从Flux中取出五个价格，我们不止得到一个价格。

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

当我们运行此测试时，我们看到它失败了，它失败是因为Flux中包含零个元素，因为这是我们硬编码的内容。

### 将客户端连接到真实的服务

让我们回到 WebClientStockClient 并写入实现。

1. 我们要使用WebClient去连接服务。我们将其创建为一个字段，并添加为构造函数参数，以便Spring自动注入。

```java
public class WebClientStockClient {
    private WebClient webClient;
 
    public WebClientStockClient(WebClient webClient) {
        this.webClient = webClient;
    }
// ...rest of the class here
```

现在我们想要使用 WebClient 在我们的方法中调用 REST 服务。

1. 移除来自priceFor方法中的桩代码（即删除 `return Flux.fromArray(new StockPrice[0]);`）
2. 我们使用WebClient发出 GET 请求 ([get()](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/reactive/function/client/WebClient.html#get--)).
3. 传入服务的 URI (http://localhost:8080/stocks/{symbol}) 并传入股票代码（symbol）
4. 调用 [retrieve()](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/reactive/function/client/WebClient.RequestHeadersSpec.html#retrieve--).
5. 我们要指定如何将这个调用的响应转换为某种类型的 Flux，使用bodyToFlux并将数据类 StockPrice.class 作为参数。

```java
public Flux<StockPrice> pricesFor(String symbol) {
    return webClient.get()
                    .uri("http://localhost:8080/stocks/{symbol}", symbol)
                    .retrieve()
                    .bodyToFlux(StockPrice.class);
}
```

这些是要获得来自GET调用的响应流的最基本的要求，但我们还可以定义诸如retry和backoff策略，请记住了解从发布者到消费者的数据流，是创建成功的响应式应用程序的重要部分。

我们还可以定义抛出特定异常时的处理方式。例如，我们可以说 当我们看到IOException时 我们想记录它。 我们将使用Lombok的Log4j2注解，使我们能够访问日志并记录错误。

这不是处理错误的最可靠的方式，这只是表明我们可以认为异常在响应流中是数据。

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

现在我们应该可以看到测试为绿色通过。如果我们看一下输出，可以看到我们正在解码带有符号的 `StockPrice` 对象，随机价格和时间。

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

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)













