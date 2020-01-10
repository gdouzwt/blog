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

In this lesson we add an [RSocket](https://rsocket.io/) client that can talk to the [RSocket server we created in the last lesson](https://blog.jetbrains.com/idea/2019/12/tutorial-reactive-spring-boot-kotlin-rsocket-server/).

在这一节，我们添加一个RSocket客户端，用来连接上一节创建的 RSocket服务器。

By now, we have an application that works end to end via Spring’s [WebClient](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/reactive/function/client/WebClient.html). [Last lesson](https://blog.jetbrains.com/idea/2019/12/tutorial-reactive-spring-boot-kotlin-rsocket-server/), we introduced a new RSocket server, which is currently running, and in this lesson we’re going to see how to create a client to connect to it.

现在 我们有了一个使用Spring WebClient的端到端应用程序
在上一课中 我们介绍了一个新的RSocket服务器
该服务器当前正在运行
在此视频中我们将看到如何创建一个客户端来连接它

<!--more-->

### 创建一个集成测试

As with the WebClientStockClient, we’re going to drive the RSocket client with an integration test. The test looks almost identical to the WebClientStockClientIntegrationTest.

与WebClientStockClient一样
我们将通过集成测试来驱动RSocket客户端
测试看起来与WebClientStockClientIntegrationTest几乎相同

1. Create a copy of [WebClientStockClientIntegrationTest](https://github.com/trishagee/jb-stock-client/blob/master/stock-client/src/test/java/com/mechanitis/demo/stockclient/WebClientStockClientIntegrationTest.java) in the same test directory and rename it to RSocketStockClientIntegrationTest. 所以让我们复制这个测试并将其重命名为
   RSocketStockClientIntegrationTest
2. Change the WebClientStockClient variable to an RSocketStockClient variable and rename the variable to rSocketStockClient. 将变量 WebClientStockClient改为RSocketStockClient并重命名为rSocketStockClient
3. (Tip; using IntelliJ IDEA’s [rename refactoring](https://www.jetbrains.com/help/idea/rename-refactorings.html) will change the name of this variable everywhere it’s used so there’s no need to find/replace).（提示：使用IntelliJ IDEA的rename refactoring来重命名，会将其余地方用到的这个变量都重命名了，不需要查找和替换）
4. We know this isn’t going to need a web client, because that was only needed for the WebClient stock client. Remove the constructor argument and the field declaration. 我们知道这不需要 web client，因为 WebClientStockClient才需要的。移除构造函数参数和字段声明。

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

（注意：这代码现在还未能通过编译）

### 创建 RSocket 客户端

1. RSocketStockClient doesn’t exist yet, so create it as an empty class. RSocketStockClient还不存在，让我们创建一个空类。
2. (Tip: pressing Alt+Enter on the red RSocketStockClient code gives the option of creating this class.)（提示：在红色的 RSocketStockClient代码按下 Alt+Enter会给我们选择创建这个类）
3. The test assumes a pricesFor method, so create the missing method on RSocketStockClient. 测试假定要一个 pricesFor方法，所以在RSocketStockClient里面创建这个缺少的方法。
4. (Tip: pressing Alt+Enter on the red pricesFor method gives the option of creating this method with the correct signature on RSocketStockClient.)（提示：在RSocketStockClient里红色的 pricesFor方法按下Alt+Enter会给我们创建这个方法的选择，并且有正确的方法签名。)

```java
public class RSocketStockClient {
    public Flux<StockPrice> pricesFor(String symbol) {
        return null;
    }
}
```



### 引入 StockClient 接口

Of course the method declaration looks exactly the same as it does in WebClientStockClient, so it feels like a good time to introduce an interface that both clients can implement. 当然方法声明看起来跟在 WebClientStockClient里面的一样，所以这是引入接口的好时机，让两个客户端都实现同样的接口。

1. Create a new interface called StockClient. We want the pricesFor method to appear on the interface since this is the method that has the same signature on both client classes. 创建一个接口 StockClient 我们希望 pricesFor方法出现在接口上，因为这个方法在两个客户端类的方法签名一样的。
2. (Tip: use IntelliJ IDEA’s [Extract Interface](https://www.jetbrains.com/help/idea/extract-interface.html) feature on WebClientStockClient to automatically create the new interface with a pricesFor method.) （提示：在WebClientStockClient上使用 IntelliJ IDEA的 Extract Interface 功能，可以自动地创建一个带有 pricesFor方法的接口。）

```java
public interface StockClient {
    Flux<StockPrice> pricesFor(String symbol);
}
```

3. Make sure the WebClientStockClient class has been updated to implement the new StockClient, and has the [@Override](https://docs.oracle.com/en/java/javase/13/docs/api/java.base/java/lang/Override.html) annotation on the pricesFor method. 确保 WebClientStockClient已经更新为实现新的 StockClient接口了，并且添加了 @Override注解到pricesFor方法上。

```java
public class WebClientStockClient implements StockClient {
    // 这里进行初始化...
 
    @Override
    public Flux<StockPrice> pricesFor(String symbol) {
        // 这里是实现
    }
}
```

4. 对RSocketStockClient也是同样的操作

```java
public class RSocketStockClient implements StockClient {
    @Override
    public Flux<StockPrice> pricesFor(String symbol) {
        return null;
    }
}
```

5. Now the test is compiling run it to see it fail. It should fail on the assertNotNull assertion, since we’re returning null from the pricesFor method. 目前测试能通过编译，运行它看到不能通过测试。它失败的原因应该是在 `assertNotNull` 断言上，因为我们从 pricesFor方法返回  null

### 实现 RSocket 链接

Normally with Test Driven Development we’d take small steps to make the tests pass and have more granular tests. To keep this lesson focused we’re going to jump right in and implement the working RSocket client. 

通常 在测试驱动开发中，我们会采取一些小步骤来使测试通过，然后再有更详细的测试。在本课程中我们将直接进入并实现能用的RSocket客户端。

1. Add [spring-boot-starter-rsocket](https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-rsocket) to the pom.xml file for the stock-client module. 在stock-client模块添加一个 [spring-boot-starter-rsocket](https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-rsocket)依赖到 pom.xml文件

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

2. Add an [RSocketRequester](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/messaging/rsocket/RSocketRequester.html) field called rSocketRequester to RSocketStockClient. 添加一个类型为 RSocketRequester的字段 rSocketRequester 到 RSocketStockClient
3. Add a constructor parameter for it. 为它添加一个构造函数参数
4. (Tip: IntelliJ IDEA can [automatically generate constructor parameters](https://www.jetbrains.com/help/idea/generating-code.html#generate-constructors) for fields.)（提示：IntelliJ IDEA可以为字段自动生构造函数参数）

```java
public class RSocketStockClient implements StockClient {
    private RSocketRequester rSocketRequester;
 
    public RSocketStockClient(RSocketRequester rSocketRequester) {
        this.rSocketRequester = rSocketRequester;
    }
 
    // pricesFor 方法...
}
```

5. In pricesFor, call rSocketRequester.[route](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/messaging/rsocket/RSocketRequester.html#route-java.lang.String-java.lang.Object...-). For the route, we want to use the same route we defined in the back-end RSocket service, which in our case was “stockPrices”.  在pricesFor方法，调用rSocketRequester.route . 对于路由，我们想要使用跟在后端RSocket服务定义的相同，在我们的例子中是“stockPrices”
6. Send the stock symbol to the server, via the [data](https://docs.spring.io/spring/docs/current/javadoc-api/index.html?org/springframework/messaging/rsocket/RSocketRequester.Builder.html) method.  通过 data 方法向服务器发送一个股票代码。
7. We expect the call to return a Flux of StockPrice, so pass StockPrice.class into the [retrieveFlux](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/messaging/rsocket/RSocketRequester.RetrieveSpec.html#retrieveFlux-org.springframework.core.ParameterizedTypeReference-) method. 我们期望调用返回一个股票价格的Flux，所以将StockPrice.class传入到retrieveFlux方法。
8. Return the result of these calls from the pricesFor method instead of null. 返回这些调用pricesFor方法的结果，而不是 null

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

The test doesn’t compile because we added an rSocketRequester constructor parameter and we don’t have an instance of RSocketRequester in our test. 测试代码不能通过编译，因为我们添加了一个 rSocketRequester到构造函数参数，然而在测试里我们没有RSocketRequester实例。

1. Create a private method called createRSocketRequester in the test near the top where other objects are typically initialised. 在测试里创建一个名为 createRSocketRequester的私有方法，放在上方靠近其它对象初始化的位置。
2. Create a field for an [RSocketRequester.Builder](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/messaging/rsocket/RSocketRequester.Builder.html). If we add the [@Autowired](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/annotation/Autowired.html) annotation, Spring will inject an instance of this into our test. 为RSocketRequester.Builder创建一个字段。如果我们添加 @Autowired 注解，Spring将会为我们的测试注入一个实例。
3. To tell Spring to manage the test we need to annotate it with [@SpringBootTest](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/test/context/SpringBootTest.html). 要让 Spring 管理我们的测试，我们需要将它注解为 @SpringBootTest
4. Inside createRSocketRequester, use the rSocketRequester to [connect via TCP](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/messaging/rsocket/RSocketRequester.Builder.html#connectTcp-java.lang.String-int-) to our RSocketServer, which is running on localhost at port 7000. 在 createRSocketRequester里面，使用 rSocketRequester 通过 TCP 连接到我们的 RSocket 服务器，它运行在 localhost的7000端口
5. Call block to wait until we’re connected. 调用 block直到连接上

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

我们期待这个测试能运行，但我们错过了一些重要的东西。我们发现个错误，说 missing a SpringBootConfiguration 看起来可能有点令人费解。实际上，这个模块并没有任何 SpringBootApplication。因为这是用于作为一个库，给其它应用代码共享代码的，它本身不是一个应用程序。让我们看一种解决方案让测试跑起来。

1. Create a class TestApplication in the same directory as the test. 在test目录里创建一个类 TestApplication
2. Annotate this with [@SpringBootApplication](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/autoconfigure/SpringBootApplication.html). 将它注解为 @SpringBootApplication
3. Re-run the integration test, everything should start up as expected, and the test should pass. 重新运行集成测试，所有东西应该按预期启动，并且测试应该通过了。

```java
@SpringBootApplication
public class TestApplication {
}
```

### 使用 StepVerifier 进行测试

Since the test passes we can assume the client successfully connects to the server via RSocket, gets a Flux of StockPrice objects, can take the first five of these and checks the first one has the correct symbol. This is a slightly simplistic approach to testing reactive applications. There are other approaches, one of which is to use the [StepVerifier](https://projectreactor.io/docs/test/release/api/reactor/test/StepVerifier.html). Using this approach, we can [code our expectations](https://www.baeldung.com/reactive-streams-step-verifier-test-publisher) for the events that we see.

一旦测试通过了，我们可以假设客户端已经成功地通过RSocket连接到了服务器，获取一个Flux的StockPrice对象，可以去其中的前五个，然后检查第一个是否有正确的股票代码。这是稍微简单的测试响应式应用程序的方式。还有其它的方式，其中一种就是使用 [StepVerifier](https://projectreactor.io/docs/test/release/api/reactor/test/StepVerifier.html) 使用这种方式，我们可以编写我们期望看到的事件。

1. Create a new StepVerifier with five prices from the prices Flux. 创建一个新的 StepVerifier 从 prices Flux里面取5个价格
2. Use [expectNextMatches](https://projectreactor.io/docs/test/release/api/reactor/test/StepVerifier.Step.html#expectNextMatches-java.util.function.Predicate-) to check the symbol for all five prices is correct.  使用[expectNextMatches](https://projectreactor.io/docs/test/release/api/reactor/test/StepVerifier.Step.html#expectNextMatches-java.util.function.Predicate-)检查所有5个股票价格对应的股票代码是正确的。
3. Call [verifyComplete](https://projectreactor.io/docs/test/release/api/reactor/test/StepVerifier.LastStep.html#verifyComplete--) to not only check these expectations are met, but also that there are no more StockPrice objects after these five. 调用去检查不仅这些期望达到了，并且在这5个之后没有更多的 StockPrice对象了。
4. Delete the old assertions (the StepVerifier replaces them all). 删除旧的断言（StepVerifier将它们全部替换了）

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

We have one final piece to consider. Our WebClientStockClient defined a retryBackoff strategy, and a simple approach for handling errors. We can actually apply exactly the same approach to our RSocketStockClient as well. 我们还有最后一件事要考虑。我们的WebClientStockClient定义了一个退避重试策略，以及简单的错误处理方法。实际上我们对于RSocketStockClient也采取同样的方式。

1. Copy the retryBackoff and doOnError steps from WebClientStockClient and paste into RSocketStockClient.pricesFor. 从 WebClientStockClient复制 retryBackoff 和 doOnError步骤并粘贴到 RSocketStockClient.pricesFor里面
2. Re-run the test, it should all still pass. 重新运行测试，它应该还能通过的。

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

现在我们在后端有了发送股票价格的 RSocket服务器，以及能够连接到它并查看价格的RSocket客户端。在下一节，我们会看一下如何从使用WebClientStockClient切换到RSocketStockClient

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























