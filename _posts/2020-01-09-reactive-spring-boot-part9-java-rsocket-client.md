---
typora-root-url: ../
layout:     post
title:      Reactive Spring Boot 系列教程 - Part 9
date:       '2020-01-09T10:10'
subtitle:   java rsocket 客户端
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

## 响应式 Spring Boot 第 9 部分 - java rsocket 客户端

> Posted on December 13, 2019 by Trisha Gee
>
> 原文由 Trisha Gee 在当地时间2019年12月13日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/12/tutorial-reactive-spring-boot-kotlin-rsocket-server/)



In this lesson we add an [RSocket](https://rsocket.io/) client that can talk to the [RSocket server we created in the last lesson](https://blog.jetbrains.com/idea/2019/12/tutorial-reactive-spring-boot-kotlin-rsocket-server/).

This is the ninth part of our tutorial showing how to build a Reactive application using Spring Boot, Kotlin, Java and [JavaFX](https://openjfx.io/). The original inspiration was a [70 minute live demo.](https://blog.jetbrains.com/idea/2019/10/fully-reactive-spring-kotlin-and-javafx-playing-together/)

This blog post contains a video showing the process step-by-step and a textual walk-through (adapted from the transcript of the video) for those who prefer a written format.

<!--more-->

[This tutorial is a series of steps](https://blog.jetbrains.com/idea/tag/tutorial-reactive-spring/) during which we will build a full [Spring Boot](https://spring.io/projects/spring-boot) application featuring a [Kotlin](https://kotlinlang.org/) back end, a [Java](https://jdk.java.net/13/) client and a [JavaFX](https://openjfx.io/) user interface.

By now, we have an application that works end to end via Spring’s [WebClient](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/reactive/function/client/WebClient.html). [Last lesson](https://blog.jetbrains.com/idea/2019/12/tutorial-reactive-spring-boot-kotlin-rsocket-server/), we introduced a new RSocket server, which is currently running, and in this lesson we’re going to see how to create a client to connect to it.

### 创建一个集成测试

As with the WebClientStockClient, we’re going to drive the RSocket client with an integration test. The test looks almost identical to the WebClientStockClientIntegrationTest.

1. Create a copy of [WebClientStockClientIntegrationTest](https://github.com/trishagee/jb-stock-client/blob/master/stock-client/src/test/java/com/mechanitis/demo/stockclient/WebClientStockClientIntegrationTest.java) in the same test directory and rename it to RSocketStockClientIntegrationTest.
2. Change the WebClientStockClient variable to an RSocketStockClient variable and rename the variable to rSocketStockClient.
3. (Tip; using IntelliJ IDEA’s [rename refactoring](https://www.jetbrains.com/help/idea/rename-refactorings.html) will change the name of this variable everywhere it’s used so there’s no need to find/replace).
4. We know this isn’t going to need a web client, because that was only needed for the WebClient stock client. Remove the constructor argument and the field declaration.

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

(note: this code will not compile yet)

### 创建 RSocket 客户端

1. RSocketStockClient doesn’t exist yet, so create it as an empty class.
2. (Tip: pressing Alt+Enter on the red RSocketStockClient code gives the option of creating this class.)
3. The test assumes a pricesFor method, so create the missing method on RSocketStockClient.
4. (Tip: pressing Alt+Enter on the red pricesFor method gives the option of creating this method with the correct signature on RSocketStockClient.)

```java
public class RSocketStockClient {
    public Flux<StockPrice> pricesFor(String symbol) {
        return null;
    }
}
```



### 引入 StockClient 接口

Of course the method declaration looks exactly the same as it does in WebClientStockClient, so it feels like a good time to introduce an interface that both clients can implement.

1. Create a new interface called StockClient. We want the pricesFor method to appear on the interface since this is the method that has the same signature on both client classes.
2. (Tip: use IntelliJ IDEA’s [Extract Interface](https://www.jetbrains.com/help/idea/extract-interface.html) feature on WebClientStockClient to automatically create the new interface with a pricesFor method.)

```java
public interface StockClient {
    Flux<StockPrice> pricesFor(String symbol);
}
```

3. Make sure the WebClientStockClient class has been updated to implement the new StockClient, and has the [@Override](https://docs.oracle.com/en/java/javase/13/docs/api/java.base/java/lang/Override.html) annotation on the pricesFor method.

```java
public class WebClientStockClient implements StockClient {
    // initialisation here...
 
    @Override
    public Flux<StockPrice> pricesFor(String symbol) {
        // implementation here...
    }
}
```



### 重构减少模板代码

The prices functions on both the RestController and the RSocketController are now simply calling the PriceService, so all the common code is in one place. Kotlin allows us to simplify this code even further.

1. Convert the `prices` function to an [expression body](https://kotlinlang.org/docs/reference/basic-syntax.html#defining-functions) and remove the declared return type.
2. (Tip: if we press Alt+Enter on the curly braces of the function, IntelliJ IDEA offers the option of “Convert to expression body”. Once we’ve done this, the return type will be highlighted and we can easily delete it.)
3. Do this with both `prices` functions.

```java
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

4. Do the same in RSocketStockClient.

```java
public class RSocketStockClient implements StockClient {
    @Override
    public Flux<StockPrice> pricesFor(String symbol) {
        return null;
    }
}
```

5. Now the test is compiling run it to see it fail. It should fail on the assertNotNull assertion, since we’re returning null from the pricesFor method.

### 实现 RSocket 链接

Normally with Test Driven Development we’d take small steps to make the tests pass and have more granular tests. To keep this lesson focused we’re going to jump right in and implement the working RSocket client.

1. Add [spring-boot-starter-rsocket](https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-rsocket) to the pom.xml file for the stock-client module.

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

1. Add an [RSocketRequester](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/messaging/rsocket/RSocketRequester.html) field called rSocketRequester to RSocketStockClient.
2. Add a constructor parameter for it.
3. (Tip: IntelliJ IDEA can [automatically generate constructor parameters](https://www.jetbrains.com/help/idea/generating-code.html#generate-constructors) for fields.)

```java
public class RSocketStockClient implements StockClient {
    private RSocketRequester rSocketRequester;
 
    public RSocketStockClient(RSocketRequester rSocketRequester) {
        this.rSocketRequester = rSocketRequester;
    }
 
    // pricesFor method...
}
```

1. In pricesFor, call rSocketRequester.[route](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/messaging/rsocket/RSocketRequester.html#route-java.lang.String-java.lang.Object...-). For the route, we want to use the same route we defined in the back-end RSocket service, which in our case was “stockPrices”.
2. Send the stock symbol to the server, via the [data](https://docs.spring.io/spring/docs/current/javadoc-api/index.html?org/springframework/messaging/rsocket/RSocketRequester.Builder.html) method.
3. We expect the call to return a Flux of StockPrice, so pass StockPrice.class into the [retrieveFlux](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/messaging/rsocket/RSocketRequester.RetrieveSpec.html#retrieveFlux-org.springframework.core.ParameterizedTypeReference-) method.
4. Return the result of these calls from the pricesFor method instead of null.

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

The test doesn’t compile because we added an rSocketRequester constructor parameter and we don’t have an instance of RSocketRequester in our test.

1. Create a private method called createRSocketRequester in the test near the top where other objects are typically initialised.
2. Create a field for an [RSocketRequester.Builder](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/messaging/rsocket/RSocketRequester.Builder.html). If we add the [@Autowired](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/annotation/Autowired.html) annotation, Spring will inject an instance of this into our test.
3. To tell Spring to manage the test we need to annotate it with [@SpringBootTest](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/test/context/SpringBootTest.html).
4. Inside createRSocketRequester, use the rSocketRequester to [connect via TCP](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/messaging/rsocket/RSocketRequester.Builder.html#connectTcp-java.lang.String-int-) to our RSocketServer, which is running on localhost at port 7000.
5. Call block to wait until we’re connected.

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

We expect this test to work when we run it, but actually we’re missing something important. We get an error that we’re [missing a SpringBootConfiguration](https://www.baeldung.com/spring-boot-unable-to-find-springbootconfiguration-with-datajpatest), which might be a little puzzling. In fact, this module doesn’t have a SpringBootApplication at all, because it was designed to be library code shared among other application code, it’s not an application in its own right. Let’s look at one way to get our test to work.

1. Create a class TestApplication in the same directory as the test.
2. Annotate this with [@SpringBootApplication](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/autoconfigure/SpringBootApplication.html).
3. Re-run the integration test, everything should start up as expected, and the test should pass.

```java
@SpringBootApplication
public class TestApplication {
}
```

### 使用 StepVerifier 进行测试

Since the test passes we can assume the client successfully connects to the server via RSocket, gets a Flux of StockPrice objects, can take the first five of these and checks the first one has the correct symbol. This is a slightly simplistic approach to testing reactive applications. There are other approaches, one of which is to use the [StepVerifier](https://projectreactor.io/docs/test/release/api/reactor/test/StepVerifier.html). Using this approach, we can [code our expectations](https://www.baeldung.com/reactive-streams-step-verifier-test-publisher) for the events that we see.

1. Create a new StepVerifier with five prices from the prices Flux.
2. Use [expectNextMatches](https://projectreactor.io/docs/test/release/api/reactor/test/StepVerifier.Step.html#expectNextMatches-java.util.function.Predicate-) to check the symbol for all five prices is correct.
3. Call [verifyComplete](https://projectreactor.io/docs/test/release/api/reactor/test/StepVerifier.LastStep.html#verifyComplete--) to not only check these expectations are met, but also that there are no more StockPrice objects after these five.
4. Delete the old assertions (the StepVerifier replaces them all).

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

This approach can support much more than this simple example, and is also very useful for testing time-based publishers like ours.

### 添加重试退避已经错误处理策略

We have one final piece to consider. Our WebClientStockClient defined a retryBackoff strategy, and a simple approach for handling errors. We can actually apply exactly the same approach to our RSocketStockClient as well.

1. Copy the retryBackoff and doOnError steps from WebClientStockClient and paste into RSocketStockClient.pricesFor.
2. Re-run the test, it should all still pass.

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

Now we have an RSocket server on the back end emitting stock prices and an RSocket client that can connect to it and see those prices. In the next lesson we’re going to see how to switch from using the WebClientStockClient to using our new RSocketStockClient.

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























