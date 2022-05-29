---
typora-root-url: ../
layout:     post
title:      响应式Spring Boot系列教程9
date:       '2020-01-09T10:10'
subtitle:   Java RSocket客户端
author:     招文桃
catalog:    true
tags:
    - JavaFX
    - Spring Boot
    - RSocket

---

> 原文由 Trisha Gee 在2019年12月13日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/12/tutorial-reactive-spring-boot-java-rsocket-client/)

在这一节，我们添加一个RSocket客户端，用来连接上一节创建的RSocket服务器。

现在，我们有了一个使用Spring WebClient的端到端应用程序。在上一节中，我们介绍了一个新的RSocket服务器，在这节，我们将看到如何创建一个客户端来连接它

<!--more-->

### 创建一个集成测试

与`WebClientStockClient`一样，我们将通过集成测试来驱动RSocket客户端，测试看起来与`WebClientStockClientIntegrationTest`几乎相同。

1. 所以让我们复制这个测试并将其重命名为`RSocketStockClientIntegrationTest`。
2. 将变量`WebClientStockClient`改为`RSocketStockClient`并重命名为`rSocketStockClient`。
3. （提示：使用IntelliJ IDEA的rename refactoring来重命名，会将其余地方用到的这个变量都重命名了，不需要查找和替换）。
4. 我们知道这不需要WebClient，因为`WebClientStockClient`才需要的。移除构造函数参数和字段声明。

```java
class RSocketStockClientIntegrationTest {
    @Test
    void shouldRetrieveStockPricesFromTheService() {
        // given
        RSocketStockClient rSocketStockClient = new RSocketStockClient();
 
        // when
        Flux<StockPrice> prices = rSocketStockClient.pricesFor("SYMBOL");
 
        // then
        Assertions.assertNotNull(prices);
        Flux<StockPrice> fivePrices = prices.take(5);
        Assertions.assertEquals(5, fivePrices.count().block());
        Assertions.assertEquals("SYMBOL", fivePrices.blockFirst().getSymbol());
    }
}
```

（注意：这代码现在还未能通过编译）

### 创建 RSocket 客户端

1. `RSocketStockClient`还不存在，让我们创建一个空类。
2. （提示：在红色的`RSocketStockClient`代码按下 Alt+Enter会给我们选择创建这个类）
3. 测试假定要一个`pricesFor`方法，所以在`RSocketStockClient`里面创建这个缺少的方法。
4. （提示：在`RSocketStockClient`里红色的`pricesFor`方法按下Alt+Enter会给我们创建这个方法的选择，并且有正确的方法签名。)

```java
public class RSocketStockClient {
    public Flux<StockPrice> pricesFor(String symbol) {
        return null;
    }
}
```

### 引入 StockClient 接口

当然方法声明看起来跟在`WebClientStockClient`里面的一样，所以这是引入接口的好时机，让两个客户端都实现同样的接口。

1. 创建一个接口`StockClient`我们希望`pricesFor`方法出现在接口上，因为这个方法在两个客户端类的方法签名一样的。
2. （提示：在`WebClientStockClient`上使用IntelliJ IDEA的Extract Interface 功能，可以自动地创建一个带有 `pricesFor`方法的接口。）

```java
public interface StockClient {
    Flux<StockPrice> pricesFor(String symbol);
}
```

3. 确保`WebClientStockClient`已经更新为实现新的`StockClient`接口了，并且添加了`@Override`注解到`pricesFor`方法上。

```java
public class WebClientStockClient implements StockClient {
    // 这里进行初始化...
 
    @Override
    public Flux<StockPrice> pricesFor(String symbol) {
        // 这里是实现
    }
}
```

4. 对`RSocketStockClient`也是同样的操作

```java
public class RSocketStockClient implements StockClient {
    @Override
    public Flux<StockPrice> pricesFor(String symbol) {
        return null;
    }
}
```

5. 目前测试能通过编译，运行它看到不能通过测试。它失败的原因应该是在`assertNotNull`断言上，因为我们从`pricesFor`方法返回null。

### 实现RSocket链接

通常 在测试驱动开发中，我们会采取一些小步骤来使测试通过，然后再有更详细的测试。在本课程中我们将直接进入并实现能用的RSocket客户端。

1. 在stock-client模块添加一个[spring-boot-starter-rsocket](https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-rsocket)依赖到pom.xml文件

```xml
<dependencies>
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-webflux</artifactId>
	</dependency>
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-rsocket</artifactId>
	</dependency>
	<!-- more dependencies... -->
```

2. 添加一个类型为`RSocketRequester`的字段`rSocketRequester`到`RSocketStockClient`。
3. 为它添加一个构造函数参数
4. （提示：IntelliJ IDEA可以为字段自动生构造函数参数）

```java
public class RSocketStockClient implements StockClient {
    private RSocketRequester rSocketRequester;
 
    public RSocketStockClient(RSocketRequester rSocketRequester) {
        this.rSocketRequester = rSocketRequester;
    }
 
    // pricesFor 方法...
}
```

5. 在`pricesFor`方法，调用`rSocketRequester.route`。 对于路由，我们想要使用跟在后端RSocket服务定义的相同，在我们的例子中是“stockPrices”。
6. 通过`data`方法向服务器发送一个股票代号。
7. 我们期望调用返回一个股票价格的`Flux`，所以将`StockPrice.class`传入到`retrieveFlux`方法。
8. 返回这些调用`pricesFor`方法的结果，而不是`null`。

```java
public class RSocketStockClient implements StockClient {
    private RSocketRequester rSocketRequester;
 
    public RSocketStockClient(RSocketRequester rSocketRequester) {
        this.rSocketRequester = rSocketRequester;
    }
 
    @Override
    public Flux<StockPrice> pricesFor(String symbol) {
        return rSocketRequester.route("stockPrices")
                               .data(symbol)
                               .retrieveFlux(StockPrice.class);
    }
}
```

### 创建一个 RSocketRequester

测试代码不能通过编译，因为我们添加了一个`rSocketRequester`到构造函数参数，然而在测试里我们没有`RSocketRequester`实例。

1. 在测试里创建一个名为`createRSocketRequester`的私有方法，放在上方靠近其它对象初始化的位置。
2. 为`RSocketRequester.Builder`创建一个字段。如果我们添加`@Autowired`注解，Spring将会为我们的测试注入一个实例。
3. 要让Spring管理我们的测试，我们需要将它注解为`@SpringBootTest`。
4. 在`createRSocketRequester`里面，使用`rSocketRequester`通过TCP连接到我们的RSocket服务器，它运行在localhost的7000端口。
5. 调用`block`直到连接上。

```java
@SpringBootTest
class RSocketStockClientIntegrationTest {
    @Autowired
    private RSocketRequester.Builder builder;
 
    private RSocketRequester createRSocketRequester() {
        return builder.connectTcp("localhost", 7000).block();
    }
 
    @Test
    void shouldRetrieveStockPricesFromTheService() {
        // implementation...
    }
}
```

### 通过集成测试

我们期待这个测试能运行，但我们错过了一些重要的东西。我们发现个错误，说missing a SpringBootConfiguration看起来可能有点令人费解。实际上，这个模块并没有任何SpringBootApplication。因为这是用于作为一个库，给其它应用代码共享代码的，它本身不是一个应用程序。让我们看一种解决方案让测试跑起来。

1. 在test目录里创建一个类`TestApplication`。
2. 将它注解为`@SpringBootApplication`。
3. 重新运行集成测试，所有东西应该按预期启动，并且测试应该通过了。

```java
@SpringBootApplication
public class TestApplication {
}
```

### 使用 StepVerifier 进行测试

一旦测试通过了，我们可以假设客户端已经成功地通过RSocket连接到了服务器，获取一个`Flux`的`StockPrice`对象，可以去其中的前五个，然后检查第一个是否有正确的股票代码。这是稍微简单的测试响应式应用程序的方式。还有其它的方式，其中一种就是使用StepVerifier使用这种方式，我们可以编写我们期望看到的事件。

1. 创建一个新的StepVerifier从prices Flux里面取5个价格。
2. 使用[expectNextMatches](https://projectreactor.io/docs/test/release/api/reactor/test/StepVerifier.Step.html#expectNextMatches-java.util.function.Predicate-)检查所有5个股票价格对应的股票代码是正确的。
3. 调用去检查不仅这些期望达到了，并且在这5个之后没有更多的`StockPrice`对象了。
4. 删除旧的断言（StepVerifier将它们全部替换了）。

```java
@Test
void shouldRetrieveStockPricesFromTheService() {
    // given
    RSocketStockClient rSocketStockClient = new RSocketStockClient(createRSocketRequester());
 
    // when
    Flux<StockPrice> prices = rSocketStockClient.pricesFor("SYMBOL");
 
    // then
    StepVerifier.create(prices.take(5))
                .expectNextMatches(stockPrice -> stockPrice.getSymbol().equals("SYMBOL"))
                .expectNextMatches(stockPrice -> stockPrice.getSymbol().equals("SYMBOL"))
                .expectNextMatches(stockPrice -> stockPrice.getSymbol().equals("SYMBOL"))
                .expectNextMatches(stockPrice -> stockPrice.getSymbol().equals("SYMBOL"))
                .expectNextMatches(stockPrice -> stockPrice.getSymbol().equals("SYMBOL"))
                .verifyComplete();
}
```

This approach can support much more than this simple example, and is also very useful for testing time-based publishers like ours. 这种方式可以支持比这个简单例子更多的操作，而且对于测试像我们这种基于时间的发布者很有用。

### 添加重试退避已经错误处理策略

我们还有最后一件事要考虑。我们的`WebClientStockClient`定义了一个退避重试策略，以及简单的错误处理方法。实际上我们对于`RSocketStockClient`也采取同样的方式。

1. 从`WebClientStockClient`复制`retryBackoff`和`doOnError`步骤并粘贴到 `RSocketStockClient.pricesFor`里面。
2. 重新运行测试，它应该还能通过的。

```java
@Log4j2
public class RSocketStockClient implements StockClient {
    private RSocketRequester rSocketRequester;
 
    public RSocketStockClient(RSocketRequester rSocketRequester) {
        this.rSocketRequester = rSocketRequester;
    }
 
    @Override
    public Flux<StockPrice> pricesFor(String symbol) {
        return rSocketRequester.route("stockPrices")
                               .data(symbol)
                               .retrieveFlux(StockPrice.class)
                               .retryBackoff(5, Duration.ofSeconds(1), Duration.ofSeconds(20))
                               .doOnError(IOException.class, e -> log.error(e.getMessage()));
    }
}
```

现在我们在后端有了发送股票价格的RSocket服务器，以及能够连接到它并查看价格的RSocket客户端。在下一节，我们会看一下如何从使用`WebClientStockClient`切换到`RSocketStockClient`。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)：https://github.com/zwt-io/rsb/