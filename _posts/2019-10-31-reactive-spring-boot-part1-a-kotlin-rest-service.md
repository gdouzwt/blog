---
typora-root-url: ../
layout:     post
title:      Reactive Spring Boot 系列教程 - Part 1
date:       '2019-10-31'
subtitle:   Trisha Gee在IntelliJ IDEA 博客写的教程
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

## 响应式 Spring Boot 第 1 部分 - 一个 Kotlin REST Service

> Posted on October 28, 2019 by Trisha Gee
>
> 原文由 Trisha Gee 在当地时间2019年10月28日发布在 [INTELLIJ IDEA BLOG]( https://blog.jetbrains.com/idea/2019/10/tutorial-reactive-spring-boot-a-kotlin-rest-service/ )

这个月（2019年10月）我在 SpringOne Platform（大会）做了一个现场代码演示，展示了如何构建一个 Spring Boot 应用，用来显示实时（股票）价格，用到了 Spring（很明显），Kotlin 还有 JavaFX。这个代码演示有录像，[是一个时长 70 分钟的视频，](https://blog.jetbrains.com/idea/2019/10/fully-reactive-spring-kotlin-and-javafx-playing-together/)不过我觉得作为一系列更简短的视频配以博客文章会更加容易消化，可以更慢、更详细地介绍每一步。

这是第一步：使用 Kotlin 创建一个响应式 Spring Boot 服务。

这篇博文包含一个视频演示一步步操作过程和一个文字版的操作过程（从视频的讲稿演变而来）给那些更偏好文字版的人。

这个教程是我们构建一个完整的使用 [Kotlin](https://kotlinlang.org/) 写的 Spring Boot 应用作后端， [Java](https://jdk.java.net/13/) 写客户端以及一个  JavaFX 写的用户界面的其中一些步骤。

教程的第一步是创建一个 [Kotlin 版的 Spring Boot 应用](https://spring.io/guides/tutorials/spring-boot-kotlin/)，作为应用程序的后端。我们将会创建一个 [REST](https://en.wikipedia.org/wiki/Representational_state_transfer) 服务，可在后面的教程中接入。

#### 创建一个 Spring Boot 服务

让我们[为我们的 Spring Boot 服务创建一个新项目](https://www.jetbrains.com/help/idea/spring-boot.html#create-spring-boot-project)。

1. 选择 [New Project](https://www.jetbrains.com/help/idea/new-project-wizard.html)，可从 IntelliJ IDEA 的菜单开始或在开始屏幕开始。
2. 选择 New Project 窗口左边的 Spring Initializr 。
3. 我们使用 Java 13 作为这个教程的 SDK，尽管我们没有用到 Java 13 的任何特性（你可以在[这里下载 JDK 13.0.1]( http://jdk.java.net/13/ )，然后为其[指定一个新的 IntelliJ IDEA SDK]( https://www.jetbrains.com/help/idea/sdk.html#define-sdk )）。
4. 给项目填入 group 名称，然后我们使用 stock-server 作为名称。
5. 我们可以使用 Maven 或 Gradle 构建此项目。我们将创建一个 Maven 项目，这会生成我们需要的 pom.xml 和 maven wrapper 文件。
6. 选择 [Kotlin]( https://kotlinlang.org/ ) 作为开发语言。 我们会选择 Java 11 作为 Java 版本，因为这是[最新的长期支持版]( https://blog.jetbrains.com/idea/2018/09/using-java-11-in-production-important-things-to-know/ ) Java，不过对于这个教程没有什么差别。
7. 项目名称自动根据构件(artifact)名称填充，我们不需要修改它。
8. 给项目添加一个有用的描述。
9. 如有需要，我们可以更改顶层包。

下一步我们选择所需的 [Spring Boot Starters]( https://github.com/spring-projects/spring-boot/tree/master/spring-boot-project/spring-boot-starters )。

1. 选使用哪个版本的 Spring Boot。在这个教程我们将使用 2.2.0 RC1，因为后面我们将用到只有在候选发布版中才有的特性。（译者注：现在可以直接用 2.2.0.RELEASE，要用到的新特性是 RSocket）
2. 我们可以搜索并选择我们需要用到的 Spring Boot Starters。这是一个响应式 REST 服务，所以我们选择 Reactive Web。
3. 我们使用默认的项目名称和保存位置。

IntelliJ IDEA 会使用 Spring Initializr 去创建项目并正确地导入到 IDE。启用 [Maven 的 auto-import （自动导入）](https://www.jetbrains.com/help/idea/maven-importing.html#auto_import)，这样当修改 pom.xml 文件时，项目的依赖会自动刷新。



#### Spring Boot 项目

在项目窗口我们看到已创建的项目的结构，包括一个 Kotlin 目录和 Spring Boot 创建的默认应用程序类。

```java
package com.mechanitis.demo.stockservice

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class StockServiceApplication

fun main(args: Array<String>) {
    runApplication<StockServiceApplication>(*args)
}
```

IntelliJ IDEA 旗舰版有[对 Spring 应用的全面支持](https://www.jetbrains.com/help/idea/spring-support.html)，包括边栏图标，使得在像 Spring Beans 这些 Spring 元素之间的导航更加容易。

如果我们快速看一下生成的 pom.xml 文件，我们看到不仅有所选的 Spring Boot Starters 和 Kotlin 依赖，我们还看到 [Spring 编译器插件](https://kotlinlang.org/docs/reference/compiler-plugins.html#spring-support)在 [kotlin-maven-plugin](https://kotlinlang.org/docs/reference/using-maven.html) 里面。这使得用 Kotlin 写 Spring 更容易一些。

从应用程序类文件中运行这个基本的应用的程序（使用快捷键）Windows 或 Linux 是 Ctrl + Shift + F10 （macOS 是  ⌃⇧R ），或者双击 Ctrl（运行任意东西）并输入 "StockServiceApplication" 以运行应用程序。它应该会成功启动的，并有 [Netty](https://netty.io/) 运行在 8080 端口。关闭它可使用快捷键 Ctrl + F2 ( ⌘F2 )。



#### 创建一个 REST Controller

现在我们知道项目能运行，我们可以开始添加功能了。

1. 为我们的 REST Controller 创建一个类。简单起见我们现在会将它放在同一个 Kotlin 文件。
2. 我们要将它注解为一个 @RestController。
3. （贴士：我们可以使用[代码模板](https://www.jetbrains.com/help/idea/using-live-templates.html)更快地创建代码。我们可以输入 “fun1" 然后按 tab 去创建一个需要一个参数的函数）
4. 创建一个函数“prices” 接受我们想知道价格的股票代号作为参数。这个方法会返回 `Flux<StockPrice>`，这是股票价格的不间断流数据。

```kotlin
// 起初的 REST Controller
@RestController
class RestController() {
    fun prices(@PathVariable symbol: String): Flux<StockPrice> {

    }
}
```



#### 为股票价格创建一个数据类（data class)

1. （贴士：我们可以让 IntelliJ IDEA 创建 `StockPrice` 类，选中红色的 StockPrice 按下 Alt + Enter 并选择“Create class StockPrice”）。
2. 在同一个 Kotlin 文件内创建一个 `StockPrice` 类。
3. 这是一个 [Kotlin 数据类（data class）](https://kotlinlang.org/docs/reference/data-classes.html#data-classes)。这是一种紧凑的方式声明带有属性的类，然后我们只需声明在构造方法参数中用到的。我们想要一个股票代号，即 String 类型，股票价格，是 Double 类型的，而且还有股票价格相关的时间，用到的是 Java 8 的 `java.time.LocalDateTime`。

```kotlin
// StockPrice 数据类
data class StockPrice(val symbol: String,
                      val price: Double,
                      val time: LocalDateTime)
```



#### 生成并返回股票价格

现在我们要定义 `prices` 方法要返回什么。这个方法将会创建一个会每秒发出随机生成的股票价格的 Flux。我们可以通过让它的 interval（时间间隔）设为 1 秒的 Duration （持续时长）。

```kotlin
fun prices(symbol: String): Flux<StockPrice> {
    return Flux.interval(Duration.ofSeconds(1))
}
```

（注意：以上代码尚未能通过编译）

然后我们为这些逐秒时间创建一个新的 `StockPrice`  对象。注意在 Kotlin 我们不需要 `new` 关键字。`StockPrice` 对象需要 `symbol`（股票代号），`price`（股票价格），在这个教程中只是随机生成的值，然后还有 time（时间，或说时刻更准确点），是当下时刻。

```kotlin
fun prices(symbol: String): Flux<StockPrice> {
    return Flux
    		.interval(Duration.ofSeconds(1))
    		.map { StockPrice(symbol, randomStockPrice(), LocalDateTime.now())}
}
```

（注意：以上代码尚未能通过编译）

创建这个 `randomStockPrice` 函数（我们可以使用 Alt + Enter 自动创建它）。一种创建任意 `Double` 对象的的方式是使用 `ThreadLocalRandom` 和它的 `nextDouble` 方法。

让我们生成一个在 0 到 100 之间的数。

```kotlin
@RestController
class RestController() {
    @GetMapping(value = ["/stocks/{symbol}"],
               produces = [MediaType.TEXT_EVENT_STREAM_VALUE])
    fun prices(@PathVariable symbol: String): Flux<StockPrice> {
        return Flux
        		.interval(Duration.ofSeconds(1))
        		.map { StockPrice(symbo, randomStockPrice(), LocalDateTime.now())}
    }
    
    private fun randomStockPrice(): Double {
        return ThreadLocalRandom.current().nextDouble(100.0)
    }
}
```



#### 运行应用

运行应用看是否能正确启动。打开浏览器并访问 http://localhost:8080/stocks/DEMO，你应该可以看到每秒有一个事件发生，并看到股票价格以 JSON 字符串的形式呈现。

```json
data:{"symbol":"DEMO","price":89.06318870033823,"time":"2019-10-17T17:00:25.506109"}
```



#### 总结

我们创建了一个使用了 Reative Steams 每秒发出随机生成的股票价格的简单 Kotlin Spring Boot 应用程序。

```kotlin
// StockServiceApplication.kt
@SpringBootApplication
class StockServiceApplication
 
fun main(args: Array<String>) {
    runApplication<StockServiceApplication>(*args)
}
 
@RestController
class RestController() {
    @GetMapping(value = ["/stocks/{symbol}"], produces = [MediaType.TEXT_EVENT_STREAM_VALUE])
    fun prices(@PathVariable symbol: String): Flux<StockPrice> {
        return Flux.interval(Duration.ofSeconds(1))
                   .map { StockPrice(symbol, randomStockPrice(), LocalDateTime.now()) }
    }
 
    private fun randomStockPrice(): Double {
        return ThreadLocalRandom.current().nextDouble(100.0)
    }
}
 
data class StockPrice(val symbol: String, val price: Double, val time: LocalDateTime)
```

在接下来的教程里，我们将会展示如何连接到这个服务器获取股票价格，还有如何创建一个图表实时显示股票价格更新。

[全部代码都在GitHub。](https://github.com/trishagee/s1p-stocks-service)























