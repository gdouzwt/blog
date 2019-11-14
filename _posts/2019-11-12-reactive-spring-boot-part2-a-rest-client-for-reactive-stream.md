---
typora-root-url: ../
layout:     post
header-img: img/reactive-stream.png
title:      Reactive Spring Boot 系列教程 - Part 2
date:       '2019-11-12T14:16'
subtitle:   根据 Trisha Gee 教程整理
author:     招文桃
catalog:    true
tags:
    - Java
    - Tutorial
    - Spring Boot
    - Reactive
    - 教程
---

## 响应式 Spring Boot 第 2 部分 - 一个 REST 客户端

这是我们的教程的第二部分展示如何构建一个响应式应用，使用 Spring Boot，Kotlin，Java 还有 JavaFX。最初灵感来自于一个[时长70分钟的现场演示](https://blog.jetbrains.com/idea/2019/10/fully-reactive-spring-kotlin-and-javafx-playing-together/)，我已经将它分成了一系列更简短的视频配以博客文章会更加容易消化，可以更慢、更详细地介绍每一步。

这是第二步展示如何创建一个 Java 客户端以连接到一个会发出一系列服务端发送事件的端点。我们会采用 TDD的方式来创建客户端并测试它。

这篇博文包含一个视频演示一步步操作过程和一个文字版的操作过程（从视频的讲稿演变而来）给那些更偏好文字版的人。

这个教程是我们构建一个完整的使用 [Kotlin](https://kotlinlang.org/) 写的 Spring Boot 应用作后端， [Java](https://jdk.java.net/13/) 写客户端以及一个  JavaFX 写的用户界面的其中一些步骤。

### 为客户端创建要给项目

我们要创建一个新的的项目，我们想要将客户端和服务端的代码完全分开，因为它们是完全独立地运行的。

1. 这个项目将会包含多个模块，开始的时候我们选择空项目。
2. 命名为 stock-client 并按 Finish
3. 默认情况当空项目创建时， IntelliJ IDEA 在Project Sturcture 对话框显示 modules 部分选项。Add a new module here，这会是一个 Spring Boot 模块，所以选择左边的 Spring Initializr.
4. 我们使用 Java 13 作为这个教程使用的 SDK，尽管我们没有使用 Java 13 的新特性。
5. 填入项目的 group name，然后我们将它命名为 stock-client
6. 为模块输入有用的描述，所以很清楚这是做什么用的。
7. 使用 Java 语言，然后其他默认
8. 我们会使用 Java 11 作为 Java 的版本，这是最近的长期支持版，不过没关系。
9. 可以修改默认的包结构，如果需要的话。

接下来选择我们所需的 Spring Boot Starters.

1. 使用 Spring Boot 2.2.0 RC1 因为后面我们会用到这个版本的一些特性。
2. 选择 Spring Reactive Web starter 还有 Lombok。
3. 模块的默认选项没问题，保持这样即可

IntelliJ IDEA 会使用 Spring Initializr 去创建项目，并将它正确地导入 IDE，选择 enable auto-import on Maven 那样当我们修改 pom.xml 的时候就会自动刷新了。

### 创建客户端类

1. 删除 SpringInitializr 为我们创建的 StockClientApplication，这个模块我们不需要它，因为这个模块是要作为一个库给其它应用使用的，它自身不是一个应用程序。

2. 创建一个 WebClientStockClient 类，这将会使用到 Spring 的 WebClient 连接到股票价格服务

   ```java
   public class WebClientStockClient {
       
   }
   ```

### 创建客户端的测试

找出客户端的需求的一种方法，并看是否行得通是使用测试驱动的方式。

1. 使用 Ctrl + Shift + T 快捷键我们可以导航到一个类的测试。如果在 WebClientStockClient 使用这个快捷键，我们会发现这个类还没有测试。选择 "Create New Test" 选项，会显示 Create Test 对话框。

2. 选择 JUnit 5 作为测试框架（注意 IntelliJ IDEA 提供很多测试框架可选择）。

3. 这个实际上是一个端对端测试，所以填入 WebClientStockIntegrationTest 作为类名。

4. 生成测试方法，使用 Alt + Insert 并选择 "Test Method"

5. 这并不是一个完美的测试例子，因为我们只是创建了一个测试例子并只看最好的情况，这种情况有时候称之为 happy path。 将测试命名为 shouldRetrieveStockPricesFromTheService 之类的。

6. 创建一个 WebClientStockClient 的实例以便测试。

   ```java
   class WebClientStockClientIntegrationTest {
       @Test
       void shouldRetrieveStockPricesFromTheService() {
           WebClientStockClient webClientStockClient = new WebClientStockClient();
       }
   }
   ```

测试驱动可以让我们根据针对 API 写代码，而不是测试我们已经创建的东西。IntelliJ IDEA 使得这过程很容易，并生成正确的代码，通常使用 Alt + Enter。

1. 在测试当中，调用 WebClientStockClient 的 pricesFor 方法。这个方法接受一个 String 类型参数，表示股票代号。

   ```java
   void shouldRetrieveStockPricesFromTheService() {
       WebClientStockClient webClientStockClient = new WebClientStockClient();
       webClientStockClient.pricesFor("SYMBOL");
   }
   ```

   （注意：现在代码还未能通过编译）

### 创建一个存储股票价格的类

1. （提示：可以用快捷键生成 Alt + Enter）
2. 在与 WebClientStockClient 同一个包中创建 StockPrice

这里我们将使用 Lombok。 使用 @Data 注解，我们可以创建一个类似上一个教程的 Kotlin data class。这样我们只需要用字段为这个类定义属性，然后 getters，setters，equals，hashCode 还有 toString 方法都由 Lombok 提供了。

1. 添加 String symbol，Double price 还有 LocalDateTime time 到 StockPrice 类。

2. 添加 @AllArgsConstructor 还有 @NoArgsConstructor 注解，这些在 JSON 序列化的时候需要。

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

### 在测试中添加断言

我们回到 WebClientStockClientIntegrationTest 并添加一些断言，我们需要检查返回的 Flux 价格符合我们预期。

1. 将返回的 Flux 保存在局部变量 prices

2. 添加一个这是非空的断言、

3. 添加一个断言，如果我们获取 5 个股票价格，我们就有了不止一个价格。

   ```java
   @Test
   void shouldRetrieveStockPricesFromTheService() {
       // given
       WebClientSotckClient webClientStockClient = new WebClientStockCLient(webClient);
       
       // when
       Flux<StockPrice> prices = webClientStockClient.pricesFor("SYMBOL");
       
       // then
       Assertions.assertNotNull(prices);
       Assertions.assertTrue(prices.take(5).count().block() > 0);
   }
   ```

当我们运行这个测试，我们看到没通过测试。因为 Flux 里面什么都没有，因为那是我们写死在代码里面的。



### 客户端连接到真实的服务

让我回到 WebClientStockClient 并实现需求。

1. 我们想使用 WebClient 连接到服务。创建要给字段，并添加到构造器参数，这样 Spring 就会将其自动注入。

   ```java
   public class WebClientStockClient {
       private WebClient webClient;
       
       public WebClientStockClient(WebClient webClient) {
           this.webClient = webClient;
       }
       ...
   }
   ```

现在想在 pricesFor 方法里面使用 WebClient 调用我们的 REST 服务。

1. 移除 pricesFor 方法的桩代码（删除 `return Flux.fromArray(new StockPrice[0]);`）
2. 我们将要用 webClient 发起一个 GET 请求（get()）
3. 传入我们服务的 URI (http://localhost:8080/stocks/{symbol}) 并传入 symbol
4. 调用 retrieve()
5. 



