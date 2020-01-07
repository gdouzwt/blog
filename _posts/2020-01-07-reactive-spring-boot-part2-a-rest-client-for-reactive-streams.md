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



This second step shows how to create a Java client that will connect to an endpoint that emits a stream of server-sent events. We’ll be using a TDD-inspired process to create the client and test it.

这是第二步，演示如何创建一个 Java 客户端连接到一个发送一系列服务端发送事件的流。我们将使用测试驱动开发来进行开发客户端并进行测试。



This is the second part in our tutorial showing how to build a Reactive application using Spring Boot, Kotlin, Java and JavaFX. The original inspiration was a [70 minute live demo,](https://blog.jetbrains.com/idea/2019/10/fully-reactive-spring-kotlin-and-javafx-playing-together/) which I have split into a series of shorter videos with an accompanying blog post, explaining each of the steps more slowly and in more detail.



This blog post contains a video showing the process step-by-step and a textual walk-through (adapted from the transcript of the video) for those who prefer a written format.



[This tutorial is a series of steps](https://blog.jetbrains.com/idea/tag/tutorial-reactive-spring/) during which we will build a full [Spring Boot](https://spring.io/projects/spring-boot) application featuring a [Kotlin](https://kotlinlang.org/) back end, a [Java](https://jdk.java.net/13/) client and a [JavaFX](https://openjfx.io/) user interface.

This second step creates a [Reactive Spring Java client](https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html) that connects to a REST service that’s streaming stock prices once a second. This client will be used in later sections of the tutorial.

### 创建客户端工程

We’re going to create a [new project](https://www.jetbrains.com/help/idea/new-project-wizard.html) for this client, we want to keep the client and server code completely separate as they should run completely independently.

1. This project will have multiple modules in, so start by selecting empty project from the choices on the left of the [New Project Wizard](https://www.jetbrains.com/help/idea/new-project-wizard.html).
2. Call the project stock-client and press Finish.
3. By default IntelliJ IDEA shows the modules section of the Project Structure dialog when a new empty project is created. [Add a new module](https://www.jetbrains.com/help/idea/creating-and-managing-modules.html#add-new-module) here, this will be a Spring Boot module so [choose Spring Initializr on the left](https://www.jetbrains.com/help/idea/spring-boot.html#create-spring-boot-project).
4. We’re using Java 13 as the SDK for this tutorial, although we’re not using any of the Java 13 features (you can [download JDK 13.0.1](http://jdk.java.net/13/) here, then [define a new IntelliJ IDEA SDK](https://www.jetbrains.com/help/idea/sdk.html#define-sdk) for it).
5. Enter the group name for the project, and we’ll use stock-client as the name.
6. Enter a useful description for the module so it’s clear what the purpose of this code is.
7. Keep the defaults of creating a Maven project with Java as the language.
8. We’ll select Java 11 as the Java version as this is the [most recent Long Term Support](https://blog.jetbrains.com/idea/2018/09/using-java-11-in-production-important-things-to-know/) version for Java, but for the purposes of this project it makes no difference.
9. We can optionally change the default package structure if we wish.

Next we’ll select the [Spring Boot Starters](https://github.com/spring-projects/spring-boot/tree/master/spring-boot-project/spring-boot-starters) that we need.

1. Use Spring Boot 2.2.0 RC1 because we’ll need some features from this version in later videos of this tutorial.
2. Select the Spring Reactive Web starter and Lombok too.
3. The defaults for module name and location are fine so we’ll keep them as they are.

IntelliJ IDEA will use Spring Initializr to create the project and then import it correctly into the IDE. If given the option, [enable auto-import on Maven](https://www.jetbrains.com/help/idea/maven-importing.html#auto_import) so when we make changes to the pom.xml file the project dependencies will automatically be refreshed.

### 创建客户端类

1. Delete the StockClientApplication that Spring Initializr has created for the project, we don’t need this for this module, as this module is going to be a library that other applications use not an application in its own right.
2. Create a Java class WebClientStockClient, this is going to use Spring’s [WebClient](https://docs.spring.io/spring-boot/docs/current/reference/html/spring-boot-features.html#boot-features-webclient) to connect to the stock prices service.



```java
public class WebClientStockClient {

}
```



### 创建客户端的测试

One way to drive out the requirements for our client, and to see if it actually works, is to develop it in a test driven way.

1. Using Ctrl+Shift+T for Windows or Linux (⇧⌘T on macOS) we can navigate to the test for a class. If we do this from WebClientStockClient we see we don’t have one yet for this class. Choose the “Create New Test” option, which will show the [Create Test dialog](https://www.jetbrains.com/help/idea/create-test.html).
2. Choose [JUnit5](https://junit.org/junit5/docs/current/user-guide/) as the testing framework (note that IntelliJ IDEA offers a range of testing frameworks to choose from).
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

Going back to WebClientStockClientIntegrationTest, we will see there are some things we need to fix.

1. We now need to give our client a WebClient. Create a WebClient field in the test.
2. (Tip: Using [Smart Completion](https://www.jetbrains.com/help/idea/auto-completing-code.html#smart_completion), Ctrl+Shift+Space, IntelliJ IDEA will even suggest the full call to the builder that can create a WebClient instance.)



```java
class WebClientStockClientIntegrationTest {
    private WebClient webClient = WebClient.builder().build();
 
    @Test
    void shouldRetrieveStockPricesFromTheService() {
        WebClientStockClient webClientStockClient = new WebClientStockClient(webClient);
 
// ...rest of the class
```



1. In order to run the integration test the REST service must be running. Go back to StockServiceApplication from the first tutorial and run it.
2. Run WebClientStockClientIntegrationTest. You can use the gutter icons or Ctrl+Shift+F10 for Windows or Linux (⌃⇧R for macOS) from inside the test class file, or double-press Ctrl (“run anything”) and type the test name.

We should see the test go green at this point. If we look at the output, we can see we’re decoding StockPrice objects with the symbol that we used in the test, random prices and a time.

### 更多关于在集成测试中使用断言

This is not the most thorough test, so let’s add a bit more detail to our assertions to make sure the client really is doing what we expect. Let’s change the assertion to require five prices when we take five prices, and let’s make sure that the symbol of one of the stock prices is what we expect.

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

Testing reactive applications is a skill in its own right, and there are [much better ways to do it](https://www.baeldung.com/reactive-streams-step-verifier-test-publisher) than we’ve shown in this simple example. However we have successfully used an integration test to drive the API and functionality of our stock prices client. This client connects to an endpoint that emits [server-sent events](https://en.wikipedia.org/wiki/Server-sent_events) and returns a Flux of StockPrice objects that could be consumed by another service. We’ll show how to do this in later videos in this tutorial.

[Full code is available on GitHub](https://github.com/trishagee/jb-stock-client/tree/master/stock-client).























