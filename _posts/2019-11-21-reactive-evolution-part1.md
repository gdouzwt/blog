---
typora-root-url: ../
layout:     post
title:      响应式变革 Reactive Evolution 第 1 部分
date:       '2019-11-21T08:10'
subtitle:   根据龙之春 Josh Long Devoxx Belgium 2019 演讲整理
author:     招文桃
catalog:    true
tags:
    - Reactive Programming
    - 响应式编程
    - Spring WebFlux
    - Spring Cloud Gateway
    - RSocket
    - R2DBC
    - Kotlin
---

## 响应式变革第 1 部分——构造服务端

### 传统的方式

​		响应式编程不是一个特别新的话题，不是新的概念。大概在 5 年前就开始讨论这个话题了。它更多地应该是一个答案。对更老的问题的答案，一个已经存在很久了的问题——如何扩展系统，可以支持更多用户，处理更多进入系统的请求。响应式编程是一种表达方式，一种新的答案。而答案的本身，并不是很新颖。响应式编程，更多是关于线程的使用效率。是关于让你的系统，让你的软件，在 JVM 上更好地处理线程的一种方式。这是很重要的，因为线程代价高，JVM 的线程开销大。<!--more-->

​		所以现在问题是，为什么我们为什么关心这个，对吧？我们支持更多用户的动机是什么？问题不是特别难回答，我相信你们能够指出一些方面。在过去 10 年 或是 12 年促使我们扩展的原因，并处理更多的用户，并不难找到这类东西。我才用这东西自拍了， iPhone 对吧？还有安卓设备，各种这些智能设备，这又促使了一大波，还有物联网的浪潮。这些联网设备随着我们连接更多的东西到互联网，随着我们逐步地迁移到一个HTTP 请求的世界
并加上 CSS 和 JavaScript 构成一个视图的年代。我们从那个世界，迁移到了另一个世界，现在单独的一个用户界面，可以由十几个网络请求的，一系列的网络请求，最终才组合组成你看到的视图，对吧？而且这对于不同的连接设备都不同，当我们进到新的世界。现在一个用户界面又十几个网络请求组成，我们后端的服务变得更加棘手。

​		尤其是这些服务没花什么时间，产生结果原因是正确的传统构建软件的方式，在JVM构建软件的传统方式一直比较简单。当请求进来的时候你得到一个 `java.net.ServerSocket`，监听在 8080 端口并且当这些请求进来的时候`ServerSocket` 接受客户端进来的 socket 请求然后客户端将载荷发送到服务器，服务器接收给与 `SeverSocket` 和 socket 都有 `InputStream` 和 `OutputStream`然后他们开始相互通信了。它们来回传输字节通过网络。然后，当那个请求到达服务器，在传统的服务器 15 年前。那是非常简单的 `while` 循环，接受请求，创建一个新线程，在线程中你从请求中读取输入的字节。你在输出流产生响应，然后你发送回去，产生一个响应需要什么？现今，要做什么产生一个响应？你要做很多事情，你要调用数据库。你要调用 Web 服务，调用。额，其它的 API。传统的做法使用输入输出流，所以全部的 `while` 循环都在这个线程。你发出一个请求，并等待数据返回，只能停在那里等、等、等。你在等待这些字节返回，同一时间你在那个线程做什么？没事干，只是等 ，空闲状态。然后，这就是真正的犯罪，这是真正的问题。因为占用线程不做任何事情，这是非常不高效的线程使用方法。线程代价高，我们不能无限地创建它们，对吧？ 

​		所以这是第一个问题，希望还是有的，对吧?在视野之内几年内，幸运的话，我们有望迎来纤程，对吧？我不知道什么时候才有，算他两年吧，最快的情况。但愿这能让你创建更多的线程，另一个问题。当然，假设你部署，最新版本的 JVM 到生产环境。我是这样做的，你也应该这样做。如果不，我可以看到你们一些人有点不自在，所以我就不问了。你们还有多少人还在用 Java 8 不过……我们可能，哦哦 我看到你们有些人不自在了，好不管怎样，关键是假设你们有，使用最新版的 Java，并且假设我们在未来两年或三年有纤程之类的。额，然后，现在我们需要解决另一个问题 构建分布式系统。现在我们思考数据跨越网络的情况，考虑服务之间通过线路交互。是傻子的想法傻子的做法，去认为当我们请求的时候立即就能获取数据就好像数据在打个响指就在那了。对吧，傻子才这么想，才会认为 服务响应迅速，快捷，或者是可靠的。而且一直是高可用的，而且不会出错。当构建分布式系统这些交互情况是常见的，而且这种方式，这种传统方式，读取下一个字节。并不断地等待下一个字节，忽视那样的现实，忽视网络是不稳的。不稳定的，有时候还有问题的地方数据可能会丢包。所以我们需要更好的范式，更好的通信方式。用于处理这样特别的现实情况，所以，我们面对的是…… 噢 好东西。我们面对这样的需求，构建更好的系统，构建更好的软件。要支持它，目前，我们使用响应式编程。响应式编程，使得我们可以处理更好利用我们线程的需求。并允许我们编写更多消息传递风格的代码，将世界想象成为一系列的异步事件。事实确是如此 世界是异步的，是充满事件的。不是一系列的同步数据，你随意能获取想要的。所以，我们有这样的目标，目标是我们有一堆线程，随着请求进来。我们不想占着线程等待下一个字节到来，我们得有些转变，我们要改变传统方式。处理数据流的方式，而不是坐在那里等待数据到来，随着我们将数据从输入流取出来。

​		而不是这样操作，让我们切换到另一个世界。比如说，我们等待数据推送给我们，我们等待数据的生产者发布数据给我们。然而这是很难的概念对吧，想一下我们所做的事情可能阻塞线程。我们有什么东西是阻塞线程的，额 当然啦 有很多显而易见的事情。例如占用 CPU 的任务，像计算斐波那契数列。或者是加密，挖矿对吧？额 额…… 安全之类的东西，因为那需要加密。会符合这一类型，额…… 运行 Slack 对吧 需要很多 CPU 资源，基本上全占用了，对吧？你不希望这些东西独占 CPU 是很显然的。而且你不能解决这个问题，使用响应式编程。有些东西就是要占用 CPU 的，但是有些东西是 IO 密集的。受限于输入输出的，然后这些东西是天然适合。我们现时所作的一些修改，你发现，我们不需要做同步的。阻塞的输入输出，没理由让我们查询数据。从输入流 我们可以让数据准备好给我们。我们可以告诉操作系统，看这里操作系统。这是一个文件描述符，它有数据但是目前还不可用。请给我一个消息，给我一个中断回调。当数据可用的时候，对吧？ 这是操作系统很容易做到的事情它可以查询可以管理，它可以高效地选择，成千上万的文件描述符。但它不能创建成千上万的线程，这就是问题所在。所以更好的情况是，嘿 操作系统。给我一个回调当数据可用的时候，我会当它现在可用的状态继续工作，而不是更早的时候。同时，之前我用于询问数据的线程，我已经离开了那个线程。并让操作系统的其它用户使用那线程做其它事情。这仍然不是什么新东西，它有个老术语叫多线程协作，很简单的概念。我们说，嘿，我将会这样写代码。去告诉系统，我什么时候用完这个线程，我会表达更加明确，我会多花些功夫使得。那是一个多租户的系统，这是一个很简单的概念，响应式编程出现的原因是。给我们一种编程范式、模式，去让我们这样的表达这个世界可以让我们这样说 嘿，我请求了这个数据，但是它还不存在这里。这是异步的，它现在还不在这里。还未被解决 但最终会到来的，而且，可能不止一个值，这就是事情变得有点不同的原因。我要怎么说，我有一个值需要获取使用现在的 JDK，你说我有个 `Future` `Future<String>` 或 `Future<Integer>` 随意啦。甚至 `CompletableFuture` 更好，会给你一个值。

### 响应式解决方案——响应式数据流规范 Project Reactor 背景

​		等了这么久还缺的是 一种方式表达，我有一连串的异步解决的值。所以我们需要一种范式 一种计算方面的模式，允许我们去描述这样的一种数据，这就是 *Reactive Streams* 规范的作用。

![image-20191205002630664](/img/image-20191205002630664.png)

*Reactive Streams* 规范是一些通用的底层接口，由这些组织提出 Pivotal, Netflix, Lightbend, Eclipse 基金会还有其它的。这是 4 不同的接口和一个类，给你能力。异步的数据串流，而且它们是非常非常基础的。它允许我们说 嘿 有数据进来了，除此以外并没有给你什么了。它不支持我们常用的操作，我们处理数据时期待的操作。我将它们比作数组 就像 Java 的数组，你们有多少人写代码用到数组的。大多数时候，是的，数组常常用到，对吧？通常你不会这样做的，如果我要描述一系列数字或什么的 我使用 `List` 或者 `Set` 随意吧，对吧？那会使用数据类型，因为这样处理数据方便惯用，我可以扩展它们，可以操作它们。可以流式操作，可以过滤它们之类的。所以这是非常常见的抽象，对吧？Java 数组不太好用，你们这些不看的，你们大概有二十人举手了。然后我说 “大多数时候”，大部分人放低手了。因为大部分人没有经常使用数组，我们使用更高层次的数据类型。这里也有同样的需求，对于这些响应式流。它们非常基础，作为一种基石。但我不会在生产环境只是要这些，我需要操作符，使用，组合处理流数据，更加容易，这就是 Project Reactor 的意义。Project Reactor 来自 Pivotal，它类似于 RxJava，它为你提供了这些好用的操作符。

​		好，我们完事了吗？可以回家了吗？还不行，当然不了，对吧？这是我们迎来另一个问题的情况，假设，只是假设出于某种原因，只是假象，好吧，好吧？我不承诺任何事情，但想象一下在一条时间线上。技术，你用着熟悉的技术。了解的并使用了很多年，几十年的，对吧？想象这些技术例如 Spring 例如 Hibernate，想象由于某种原因这些你们已经熟悉的技术。不能理解，`java.util.Collection`，或者是 `java.util.Set`，`java.util.Map` 之类的。假设想象一下，例如。只是假想一下，你想要映射一对多的关系，在 Hibernate 的实体里面 使用 `java.util.Set` 想象一下 当你这样做的时候 Hibernate 不仅抛出异常，想象一下你这样做了 Hibernate 不仅抛出异常，它实际上还渲染一个纯文本组成的竖中指，在控制台，并引起你机器的内核恐慌。帮你关机，它非常讨厌 `java.util.Set`，你还会继续在 Hibernate 继续用 `java.util.Set` 吗？如果你知道会出现这样的情况，当然不会啦，对吧？你不会弃用 Hibernate 如果你想做的是同步地阻塞，并映射对象到 JDBC 的数据结构？没有比这更好的了，那是现有最好的东西了。你不会重造 Hibernate 的轮子，你只是使用阻力最小的方式而已。如果这意味着使用其它数据类型，那就使用吧。因为那会让你可以到生产环境，最终那才是最重要的。它可以让你使用你熟悉的数据访问技术去到生产环境，所以我们有同样的需求。我想要处理的我的日常需求我希望可以构建数据访问层，能支持安全 Web 服务，还有其它的作为开发者的日常，开发交付到生产环境的东西。但我不想放弃所有那些，只是为了支持响应式类型。所以这就是 Spring 团队的第一步，在 2017 年 我们发布了，Spring 框架 5.0。5.0 是首个版本整合了，Pivotal Project 原生地，与此同时还有 *Reactive Streams* 规范。在此基础上我们构建了响应式 Web 运行时， 我们整合了对，Spring Data 的支持，还有 Spring Security 还有 Spring Boot 和 Spring Cloud，所以今天在 2019 年，快到 2020 年了。我们可以构建端到端的微服务系统在 Spring 的生态系统。

### 生成项目

​		到 [start.spring.io](https://start.spring.io/) 生成一个 reservation-service 工程。使用 Java 13。

![image-20191209084207037](/img/image-20191209084207037.png)

依赖

![image-20191209084254754](/img/image-20191209084254754.png)

### 开始写代码

​		额，我们现在有。一个全新的项目 Spring Boot 项目。最新最好的 Java 版本，我要注释掉一些我现在还不需要的东西。我去掉这些，我不需要这些，我要注释掉。R2DBC 的依赖，并注释掉 R2DBC 本身。

```
<!--
<dependency>
    <groupId>org.springframework.boot.experimental</groupId>
    <artifactId>spring-boot-starter-data-r2dbc</artifactId>
</dependency>
-->
```

刚开始先注释掉 r2dbc 的依赖， 即 Reactive Relational Database Connectivity，响应式关系数据库连接。

我们留下，设置自动导入。现在我的选择满足了，让我们去到我们的应用。我们的应用只是一个 `main` 方法入口，我们应用程序的入口。只是一个全新的应用，它所作的全部只是一个普通的 Spring Boot 应用，我们所要作的是写数据到数据库。

刚开始的 `ReservationServiceApplication.java`

```java
// 省略 import 语句
@SpringBootApplication
public class ReservationServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(ReservationServiceApplication.class, args);
    }
}
```

通过创建一个实体。我要像这样地创建一个实体好吧，这个实体，这是个实体。但是需要，你懂得，需要一些常规东西。`getter` 和 `setter`， 我需要 `toString` 我需要 `equals` 和 `hashCode`我需要构造器等东西。还有这个
OK 另一个构造器，好。好东西，对吧？我需要这些，这就是 Java，额，这非常现代！非常现代，如何现代... 
我不那么做，那很糟糕！

我是用 Lombok。Lombok 是一个编译时注解处理器，Lombok 使得我可以整合
getter 和 `setter` `toString`, `equals`, `hashCode` 之类的。在此之上我加入 Spring Data 的 `@id` 注解，
它会告诉 MongoDB 这个文档，这个实体，这个对象。我在这里描述的，将会被持久化到一个单独行。称之为集合，在 MongoDB 里面。在那个世界，在 MongoDB 里的叫法。一个记录被称为文档，所以这是一个文档，在一个集合中。这个文档有一个 `id` 字段，还有 `name` 字段，它们都在这里描述了。

```java
// 用于 MongoDB 的实体类
@Data
@AllArgsConstructor
@NoArgsConstructor
@Document
class Reservation {

    @Id
    private String id;
    private String name;
}
```

这基本上就是我要做的，让这个能用。现在我要创建一个，repository。repository 只是一个东西，会将数据存储到数据库的东西。会处理无聊的到掉土渣的，读/写 更新/删除 的生命周期方法，支持处理我们数据的方法。这个 repository，支持所有可能的操作。在这你可以看到，所有这些常用方法，你在生产环境需要的，并将任务完成。例如 `save`, `saveAll`，`count`, `delete`, `findById`，检查是否存在，诸如此类的。所有这些方法我猜想，对于你们来说应该很熟悉了。

```java
// 创建数据负责数据访问的 repository
interface ReservationRepository extends ReactiveCrudRepository<Reservation, String> {

}
```

### 开始讲 Reactive Streams Spec

一些现在还未熟悉的是，是参数的类型，第一个参数是一个 `Publisher`，这个 `Publisher` 你可以看到，来自于
`org.reactivestreams:reactive-streams`，这是一个 `Publisher`，产生 0 到 n 个记录，对吧？是一个产生记录的 `Publisher`，异步地，不受限地，输出到一个订阅者，`Subscriber`。当它首次订阅，它会给一个指针到一个 `Subscription`，在这里看到我们有这个 `Subscription`。下我们再回头看这个 `Subscription`，稍后再看
这个可以说是最重要的部分了，当数据到来的时候 1 2 3，十亿，万亿，无限的数据。当它们到达的时候，`onNext` 方法会被调用，是在 `onNext` 方法里面，我们才能，消耗并处理到达的数据流。那些来自 `Publisher` 的数据。如果遇到错误，当出现错误，`onError` 方法会被调用。就是在这个 `onError` 方法我们有机会，去 额…… 处理一些错误。请记住，错误。可在任何地方发生，但是堆栈追踪信息。那个 *try-catch* 机制，是限制在单个线程的。所以我们而是通过这个机制传播错误，因为请记住，我们的代码，会轻易地从一个线程切换到另一个线程，随着我们在响应式管道中执行代码。所以我们不能假设它们在同一个地方，所以这是非常能用的，自然的方式去处理数据。我们将错误作为另一种数据，而且这也是多线程代码中处理错误的自然方式，最后当我们处理完的数据。
`onComplete` 方法会被调用，就是在 `onComplete` 方法里面我们知道。我们无异常地完成了所有事情，你懂得，没有错误。现在，让我们回到这个 `onSubscribe` 方法。这个我之前说了，应该是最重要的部分了。这个订阅，
对于这个订阅者是唯一的，每个订阅者，当订阅到一个发布者，获得一个新的订阅。这个订阅，代表链接，联系 ，会话，可以这样想的话。存在于生产者于消费者之间的，`Subscriber` 和 `Publisher`，就是在这个订阅当中
消费者或者订阅者才可以请求，更多的数据或者，另一方面，去取消，数据的产生。所以这是很重要的，订阅者
通过使用订阅，控制消耗的速率。订阅者说，嘿，我在要多十个记录，然后，哇啦，如果有多十个记录的话。就会发给订阅者。但是不会给多，而且时间也不能确定，对吧？在规范里面没有提到这十个记录，会在未来一秒到达之类的。你可能在十年获得十个记录，你不知道，对吧？未来十年你可能每年得到一个记录，是没有保证的，或者你在下一纳秒就得到了十个记录。还是，没有保证的。所以你选择一个数字，那是，一个你可以想象到的。同一时间舒适地，安全地处理。或接近于同一时间，对吧？这是很重要的，有你掌控，消耗的速率。你控制发布者的速率给你数据的速率。这意味着，如果你受不了。如果你的订阅者，消费者，受不了这么多数据。那是谁的错？那是你的错。其实这还好，我宁愿你能掌控自己的命运，而不让过于积极的发布者主宰我命运，对吧？所以这给我了这种能力，它给我了数据的客户端，去管理控制流的能力，我控制数据流。这称为，客户端管理的流控制。这，绝对不是什么新概念，对吧？自从同一个网络中有一个计算机和另一个，我们就有了这个概念——流控制。确保方程的一端
产生数据不会比另一端快，绝不是什么新概念，新的东西。只是，现在我们在这个概念套了一层表面 API，作为顶层的结构。这是我们可以在 API 显示地做的事情，好吧？如果我们想要取消，取消数据流。我们同样也可以 这也是很重要的，你不希望卡在一种情形，无法阻止数据太多流控制，在响应式编程的世界。有时候，多亏营销，被称为背压式。如果你有听过背压式这个词的话，你可以将其与客户端管理流控制交替使用，这就是已经存在了数十年的概念，对吧？从世界起源开始，哪个世界并不重要，在过去的 70 80 年里的任何东西 对吧？好了，现在，哈，我们有，发布者，订阅者，和订阅。那是三个，我说有四个的，第四个类型是，是 `Processor`，而处理器。是一个桥梁 一个水源和水槽，在订阅者与发布者之间，消费者 和…… 生产者。ok？ 就是这样，它就是一个桥梁这就是完整的 *Reactive Streams* 规范。早告诉你了，很简单的规范。很荒芜的没什么东西，那里边没有什么值得关心的内容的。非常简单的 API，如果你理解所有这些，就目前来说的话。我毫不怀疑你们都懂了，那么恭喜你们，你们是已认证的响应式编程人员。走，去硅谷，筹集数百万资金，炸了各种傻逼派对。你已经准备好了，你可以的了。你已经走在很多硅谷人之前了，ok ？

​		现在，我们有这四种类型。正如我所说，它们是非常基础的。非常原始的，够了吗？ 这些类型够了吗？
我会说 额…… 不够。是吧？ 我们没有简单的方式可以，支持操作，例如支持 `mapping` 和 `flatMapping` 之类。
因此，我们有特别实现。首先是 `Flux`，`Flux` 来自 Project Reactor，那是一个 Pivotal 的项目。它构建在响应式流规范的 `Publisher` 之上，你可看到 `CorePublisher` 最终是实现 `Publisher`。所以你可以看到 `Flux`说到底只是一个 `Publisher`。但同时它也提供了很多，很多，很多操作符，你看到吗？很多不同的东西，相信我，你不想花费太多时间在这些代码里。你会晕头转向的，所以，只需相信它做了你期望的事情。你想要做什么，OK? 这些代码支持像 `map` 和 `flatMap` 的操作。还有 `filter` 所有这些你需要的处理流数据的东西，`Flux` 是生产者。但它产生 0 到 n 个值。可能不受限的，OK ? 另一方面  `Mono` 也是一个发布者。它也有这些很多不同的操作符，很多很多操作符。哇！ 对吧？你可以使用很多东西，但是 `Mono` 最多产生一个值，0 个 或 1 个。有点像 `CompletableFuture` 但它支持背压式，OK？ 而且它是基于推的，区别于基于拉的 。好的，那么这就是`CorePublisher` 这是一个 `Mono` 现在我们有这两种不同的东西。问题是公平起见，为什么我使用其中一种？
有人让你渲染一个用户界面，然后给你一个 `Publisher<Customer>` 你怎么知道该怎么做？如果它们给你一个`Mono` 发布者。那么你就知道这是单个详细记录，他们可能想让我渲染这个记录的详情。对吧，这区别于，`Flux<Customer>`那样的话，他们可能想让你渲染所有用户概况列表。对吧，其中之一现在我们有这两种不同的类型。我们可以用它们写一些样例数据到数据库，我要创建 `SampleDataInitializer` 它会监听一些事件，就像这样 `@EvenListener`，然后我们说，OK？

### 写入数据库 MongoDB

​		我们要写些数据到数据库。所以 `@Component` 只是一个普通的 Spring Bean，在这里注入 `reservationRepository` 注入到构造器。我需要 `@RequireArgsConstructor`还有参数。定义这些数据然后我将数据写入到数据库，通过创建一些名字，好吗？所以我要过一遍，并获取一些名字，这些是在 Spring 团队的人。显然我在其中，很高兴见到你们，我是 Josh，额... 还有谁？ 我们有 Madhura 她很厉害。我们有，Mark Paluch 他也很厉害，我们还有 Olga 她也很厉害，我们还有，四个了。还要四个 我们有……Spencer 他很厉害。还有Ria 她很厉害。Stéphane 法国的不是荷兰的 虽然他也很厉害，OK 有那么一个人。额 还有，额…… 还有谁，还有谁。我说的是在 Devoxx 那位，不是那个 我觉得还有一个在我们 Spring 团队的，尽管 也欢迎他，额…… 不对，额…… 还有谁呢?，还有额 Violetta 好吧？她也很厉害 好了，现在我们有 ，所有这些不同的名字，好吧，好东西
要开始了 就是这些名字。我们要做的是，我们要访问这每一个名字，我们有由名字组成的响应式流，我们要访问每一个 并将它变成。reservation 的数据流，OK 所以 reservations 就这样。我们将访问其中每一个，我想要将它们保存到数据库。我可以写 map ，我可以这样做，我可以写。然后，我这样做会怎样？额 map，返回 `Mono<Reservation>` OK。而我不想一个 `Mono<Reservation>`，因为如果我这样做，我会得到这个`Flux<Mono<Reservation>>` 不是很理想。而是，我想取出这个内部的发布者。我有个内部的发布者被这个，这个 Lambda 的返回值创建的。而且我想压平这个，压平它。所以我只有 `Flux<Mono>`，为了达到目的，你使用 `flatMap` OK？ 就像这样，你可以替换为方法引用。哇啦，这就是你的新的响应式流，好吧？

```java
@Component
@RequiredArgsConstructor
@Log4j2
class SampleDataInitializer {

    private final ReservationRepository reservationRepository;

    // 注册一个事件监听器，应用启动就绪时调用该方法。
    @EventListener(ApplicationReadyEvent.class)
    public void ready() {
        
        var saved = Flux
            .just("Josh", "Madhura", "Mark", "Olga","Spencer", "Ria","Stéphane", "Violetta")
            .map(name -> new Reservation(null, name))
            .flapMap(this.reservationRepository::save);

        this.reservationRepository
                .deleteAll() // 先删除所有记录
                .thenMany(saved) // 然后才写入
                .thenMany(this.reservationRepository.findAll()) //然后才查找
                .subscribe(log::info); // 控制台日志输出结果
    }
}
```

所以，现在这是我们的数据。我要将它存到数据库里，额，我现在有了这些数据。如果我现在运行这个程序，啥都不会发生，你可以看到。这个响应式流，这是我们所说的冷的数据流，什么都还未发生。我们需要实际激活它，对吧？这有一个终端函数需要被调用，我们的终端方法就像，就像 Java 8 Streams API。所以我们说，或者我们可以提供一个消费者或者订阅者，对吧？不要提供订阅者，太多方法了。最近我使用 `Consumer`，对吧？非常简单，当然这可以是，Java 8 lambda。所以，哇啦。`log.info` OK？Log4j2，然后是 reservations，好 这可以是一个方法引用。所以 就是这样 OK？这就是所有东西，现在，我可以那样做。但在我做之前，让我们想一下会发生什么。我要运行这个程序它是 额…… 顺便设置一下。我懒，我希望我的代码也是。所以就这样，现在。我要运行这个程序，它会将一串数据。它会创建一个预约流，并会保存每一个到数据库，当我运行这个程序。多次运行 经过连续的迭代，我会看到数据库反映同样的数据，多次。那不是我想要的，我想先清理一下。所以我先删除所有东西，所以让我们写这会返回一个 `Mono`，那是一个异步的 `Void`。那么之后，不是订阅。我可以写`.subscribe` 但那就会很奇怪了。我会有一个嵌套的，我会有一个嵌套的回调，而不是做。嵌套的回调之类的东西，我是用操作符，将各种串联起来。一个发布者到另一个，所以我要写 `saved`。然后，我想写，找到数据，然后当且仅当，我才想打印日志出结果。所以我实际上，所以我实际上使用操作符去保证。所有东西都删除了，异步地加个限制。仅当它全部完成了，之后我才管保存数据，仅当那个时候。在我保存了所有东西之后，才管问数据库取数据。另一个要注意的是，正如我在这串起的管道。你也可以 ，你更经常，你会在这里串起这些东西。所以在管道的定义，让我们看一下那个代码。因此， OK。现在就是这样，完成了这部分，这就变成一个 Reservation。OK 这就是新的管道。保存数据记录的管道。额，老实说，这是正确的做法，对吧？Java 有 `var` 前缀了。，所以，你应该用那个，OK？

​		现在，额，这边。我的管道。额，你可以看到。这个，这些操作符，让使用响应式流的类型非常有用，对吧？ 而响应式流类型是，它们是 JDK 8，友好的，对吧？这并不是说必须要用 Java 8，你可以用更早的版本，对吧？顺便说一下，它们是，而且这很重要。它们是，这些等价的类。在 Java 本身里面了，自从 Java 9 开始所以你可以看到 `java.util.concurrent` `Flow.Processor`， `Flow.Subscription`，`Flow.Subscriber` 还有 `Flow.Publisher`这些类型被镜像到 JDK 里面了。已经超过两年了，每行都一样的，唯一不同的只是，包不同。所以当你谈论响应式流，重要的是要注意，你可能说的是 Java 9 的响应式流，或者是或者是响应式流规范本身。
那个给了 Java 9 响应式流灵感的，大部分 API 例如 Reactor，支持从一种切换到另一个你可以适配。Java Flow 的 `Publisher` 到普通的 `Publisher`反之亦然，OK? 现在，让我们运行这些代码 看有什么结果。现在好了，编译。我们看看，你看看。朋友们看到吗？数据在这呢，这行得通。你可以看到这数据，已经反映出来了。在这里并显示在控制台上，这行得通，这当然行啦。因为这是个 demo 你还期待什么呢？这总是行得通的，这并没有很有趣对吗？我们可以看到那个 id 是 UUID，那与 MongoDB 里的相匹配。如果我到这里，输入 `db.reservation.find({ })；`然后这是数据，你可以看到，Mark Stéphane 等等。所有这些名字，都反映在数据库里。

[![image-20191209093846979](/img/image-20191209093846979.png)](/img/image-20191209093846979.png)

---

日志显式格式，不同的系统可能不一样，但内容应该差不多。

在 Mongo shell 输入 `db.reservation.find( { } );` 可以看到结果已经写入数据库。

![image-20191209100723571](/img/image-20191209100723571.png)

但并没有按照特定的顺序出现 对吧？对吧？那是因为，我们使用 `flatMap`，好吧? 所以 `flatMap`压扁了所有东西。但它这样做乱串了结果，一样东西被压扁，如果一样东西解决了。首先，在内部的发布者，那么解释的数据流 `saved` 可能会是乱序的。我可能有 1 2 3，但我可能得到 3 2 1。然后最后的东西被 `flatMap` OK? 这就是
这很有趣。我们有数据在数据库，这能运行 这当然能运行啦，像我所说那样。这是 demo 肯定能跑的，这真的不是我在这里的原因。如往常一样。


​		OK 那么现在我们有很漂亮的纯文本艺术字，我们有很漂亮的纯文本艺术字。我们有数据在数据库里面，目前为止我使用的是 MongoDB。MongoDB 是一个不错的数据库，用于响应式处理，它有不少特性，有点有趣。我认为我已经表达的很清楚了，在响应式的世界里，例如 有些东西称为 `Tailable` 查询，你可以告诉MongoDB ，我想问你一个问题。我想你一直检查自己，等待一个答案，例如一个小时之后，如果有匹配问题。那么请告诉我，给我一个结果集。解释的结果与断言匹配，而不是一直在拉取数据库。我可以让 MongoDB 告诉我，这是一个很自然的事情。在响应式的世界里，嘿，在我的数据仓库里面。你说，你只需要添加 `@Tailable`。你可以写 我想表达一个一个查询。额，一个 `finder` 方法 `findByName` OK ? 这就能用了，你只需要，你需要确保你已经启用 MongoDB 在一个集群模式。这个我还没有设置好，所以我不演示了。但 在那之后你只需要，你可以在你的代码仓库运行这个法，然后它就会给你发送符合断言的结果，非常有用 额…… MongoDB 是个很好的体验，你可以做各种酷事情。在响应式的世界里。不过，这不是唯一的选择。我们在 Spring Data 的世界里，有很多项目现在支持响应式 NoSQL 数据访问。包含但不仅限于 MongoDB，我们有 Cassandra，有 CouchBase。我们有 Redis 这些都已经是 GA 了的响应式支持 NoSQL 选择。但更进一步，我们有 Azure Cosmos DB。现在也支持响应式数据访问了，来自微软的 微软 Azure Cosmos DB。我们有 Neo4J 2.0，对吧 新的 Rx Neo4J，Spring Data 项目。那也支持响应式NoSQL 之类的数据访问，用于那个图数据库，我们有很多选择，包括已经 GA 的和还在开发的。那正在向前看的，我们甚至有更多，除了我不太能确定可以说的。OK 这些都在出来，但是人们经常问的问题是。OK 这很好。

### 讲完 Reactive MongoDB 之后讲 R2DBC PostgreSQL 为例

​		我可以做 SQL 数据访问吗？这是很多人在问的，对吧？所以你们有多少人用 MongoDB 的？OK 比我想象中的人多，你懂得。五年前，额，你们有多少人使用 Cassandra？这有 一些人 我可以给你们买啤酒都不觉得破费，额 你们有多少人用 Redis？我猜 这个估计是最受欢迎的了 嗯 是的 OK 但 仍然是 我们讨论的只是少数人 我认为没有 10% 我会说 大概 5% 对吧？所以不是很多人使用那东西，CouchBase 呢? CouchBase 好东西。啊 大概有五六个人啊。OK 你们有多少人有 SQL 存储的？在你的代码里，呀 OK 大多数人对吧？只是小的大多数 但还是大多数人所以 问题是在响应式我们怎么支持 SQL 数据访问？这是非常常见的问题，所以几年前，我们创建了 R2DBC？OK R2DBC。是…… 额 是一个抽象层，支持响应式关系数据库链接。那里有个核心的 SPI，还有数个不同的实现，有不同的驱动 如果你这样想的话。支持对像 PostgreSQL 等的访问，微软的 SQL Server 还有 H2 现在也有一个第三方项目。支持 MySQL，对吧？这里还有更多，R2DBC 实现，在路上（正在开发中），额 Mark 我们还有什么实现。那个我已经提到过了，Spanner, Google Cloud Spanner 是的，SAP Hive 所以我们也有这些进来，所以有很多正在开发。还有很多我们不能提及的，那些正在开发中的，对吧？这些是所有不同的 R2DBC 实现，R2DBC 在目前还有没有 GA。 还没有 GA 的，所以我在这一刻，在这一刻。我希望你觉得，持有像对待 PHP 一样的犹豫怀疑态度，PHP 这边是生产环境，这边是 PHP，他们不应该相遇的，OK? 不过，不过，我刚被通知，这个很快就会 GA 了，那是什么时候？我的朋友，感恩节，不是加拿大的感恩节。OK 那是更加往后的，大概在那一周后，所以这个月的下旬。十一月底，最后一个星期四。额，或者是差不多的时候，我们应该会有 GA 的，那会包含存储过程吗？没有，所以它会有 基本上。按照我的理解，它会支持大多数东西，除了存储过程。我们会让 API 稳定下来再看看那会是怎么样。在我们实现那个之前，所以你能够像 GA 的风格使用它。去做几乎所有你想做的事情，用这些 API R2DBC。现在已经可用了，你可以尝试。我们在大会上已经宣布了在华盛顿 DC，在 2018 年的时候。就是那时候我们向公众发布的。所以自我们发布到现在几乎有一年了，对吧？在此之前已经不止一年了，因为我们一直在开发它。我们知道它已经经过考验了，有经过迭代了的，而且它很有用。你总能从现今开始使用它，这就是我们已经做了的。

当我在 start.spring.io，在那 Spring Initializr 我勾选了 R2DBC 这项，OK 所以我要在这里。将它放进来 放进这个，好东西。

```xml
<dependency>
    <groupId>org.springframework.boot.experimental</groupId>
    <artifactId>spring-boot-starter-data-r2dbc</artifactId>
</dependency>
```

然后我要注释掉 MongoDB OK? 这会添加依赖，就这样。

```
<!--
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-mongodb-reactive</artifactId>
</dependency>
-->
```

然后在这里添加这个，然后这里我们需要重构一下代码，还有，我不想建议。通过我的做法，我的说法，你应该按某种方式写代码。然后能够从 MongoDB 迁移到 R2DBC 没意义对吧？我的代码是非常简单，要让它能够跑起来，总的来说 如果你有场景发现 MongoDB 是最适合的话，可能那个应用场景不是 R2BC 或 SQL 适合的。或者等价的替换，好吧？嗯 额…… Spring Data 的目的并不是支持这种奇葩的可移植性 OK？所以我有这代码，移除 `@Document` 额 我的实体 我的东西。我的记录，将会被存储在单调递增的主键，作为数据库中的主键。所以我将它从 `String`，也就是 UUID 支持 UUID 的改成 `Integer` 好吗？改完之后，我的代码又可以运行了。

```java
// R2DBC
@Data
@AllArgsConstructor
@NoArgsConstructor
class Reservation {

    @Id
    private Integer id;
    private String name;
}
```

```java
interface ReservationRepository extends ReactiveCrudRepository<Reservation, Integer> {

}
```

`application.properties` 文件内容，指定了 r2dbc 的 url，这里演示使用的是 PostgreSQL 数据库，可以替换成其它支持的关系型数据库，例如 MySQL，不过 MySQL 的 r2dbc 驱动属于第三方维护的。

```java
spring.main.lazy-initialization=true
spring.r2dbc.url=r2dbc:postgres://localhost/orders
spring.r2dbc.username= [你的用户名]
spring.r2dbc.password= [你的密码]
```

我们可以再次运行这个程序，就是这样，它抱怨了，因为我没有，一个指向我的数据库的属性，我要去到我的属性文件 `application.properties` 然后我要指定 r2dbc url 对吧？所以 r2dbc url，而这是，这是我们之间的小秘密 OK 你不能告诉别人。这是我小小的生产环境的密码，OK？我们要，指定用户名。现在当然，你会被建议，记住你可以使用环境变量。你可以使用 Spring Cloud 配置服务器 。也可以用 Azure 配置服务器，你可以用很多方式外部化你的用户名和密码，但就我们演示目的这应该可以用，让我们再次运行这个，OK？然后这是数据，在数据库你可以看到已经反映在那了。额 在控制台。这里 我们单调递增地，增加主键也反映在数据库上，`psql -Uorders orders \d reservation` 然后可以看到那个模式，有个主键 是 integer 类型 然后有一个列称为 name ，类型为 varchar 我可以敲入，来吧，好东西。OK 这也行得通，现在我们可以响应式地，我们响应式地写数据到 MongoDB 和 SQL 数据存储，那是好东西。

```
orders=# \d reservation
                               数据表 "public.reservation"
 栏位 |       类型        | 校对规则 |  可空的  |                  预设
-------+-------------------+----------+----------+-----------------------------------------
 id   | integer           |          | not null | nextval('reservation_id_seq'::regclass)
 name | character varying |          | not null |
索引：
    "reservation_pk" PRIMARY KEY, btree (id)
```

然后执行 `select * from reservation;`

```
orders=# select * from reservation;
 id  |   name
-----+-----------
 283 | Madhura
 284 | Violetta
 285 | Spencer
 288 | Ria
 282 | Stéphane
 286 | Mark
 287 | Olga
 281 | Josh
(8 行记录)
```

### 演示事务操作

​		下一个 人们经常问的问题是，你懂得，你说得很好听。但是我还是要保证我数据的完整性的，在此背后我有这些很好的数据存储，有些东西正如我期望那样运行。而在旧的方式却不能这样期望 例如，数据的原子性如何？我如何保证当我往数据库写入十样东西，全部都写入或者全都不写入 对吧？这就是事务的应用场景，嗯 事务正如你们可能知道的，在传统的那个世界。我们基于 `ThreadLocal` 对吧？你创建… 有代码，保存与当前线程相关联的 `ThreadLocal` 那个 `ThreadLocal` 存储你的事务的状态，当前正在进行的事务，而 `ThreadLocal`。在当前线程的任何地方都可以解决，你只需请求，通常只是，通常是某个东西。在框架里面 例如 Spring 会为你做这事。它们一直追踪那个 `ThreadLocal`，并在线程结束的时候清除掉它，并在 `ThreadLocal` 安装当前事务。当一个新事务开始，那个机制，用于这方面很久了。而那个机制最终是被，`PlatformTransactionManager` 解决。这只是一个非常简单的接口，给你三个选项，给我一个事务 给我一个定义，提交事务或者回滚，这种抽象允许我们。可以抽象大部分不同的 API。很多不同的 API，都有它们自己相应的资源本地事务。问题是所有这些都假设 `ThreadLocal`，所有都基于一种概念，那会有一种存储机制附着在当前线程，我可以在往后任意时间解决它。那是非常不好的假设。尤其是在响应式的世界里，对吧？在响应式的世界里，我们不能保证，请求会从一个线程开始 并保持在那个线程，在整个事务的生命周期。所以 而是，我们需要其它东西，所以在 Spring 框架 5.2.x，那是刚刚发布的。我们正在使用的 已经 GA 了，在 Spring 5.2.x，我们发布了一个 `ReactiveTransactionManager`
所以就算这边的这个东西。而那个 `ReactiveTransactionManager` 也是继承于 `TransactionManager` 的，对吧 它们都只是标记性接口。额 它继承了那个接口，并且它有对应的响应式。就如你所见的在 `PlatformTransactionManager` 里面的。包括给我一个当前的事务。或给我一个新的事务提交事务还有回滚，OK? 这个 `ReactiveTransactionManager`，允许我们做事务的包裹，以熟悉的方式。让我们创建一个 `@service` 在这里我们添加 `ReservationService` 而这个服务会让我们可以写数据到数据库里，给定的一系列的数据流的名字。这是变长参数的名字数组，所以为了这样做，我要注入我们的 `ReservationRepository` ，正如往常一样。让它是 `@RequireArgsConstructor` 就会合成了。由 Lombok 合成，所以我想从那里获取数据 所以 `Flux.fromArray`... OK? 这是我的 String 类型的发布者，我将取其中的每一个我要 `map` 每个名字都 Reservation 里面，我们在创建某些方面我们之前就有了东西。这是一系列的已经 map 了的数据，我要写 对于它们每一个 我要 `flatMap` 每个记录。存入到数据库里面，这它传入进去。额 这会给我，我想要验证每一个，我想要写。`reservatoin.doOnEach(...` OK 我写 `doOnNext(`... 所以对于每个 reservation 我想要断言测试一下它，我想要判断它，每个记录都有一个有效的名字，给定一个 reservation，返回 `true` 或 `false` 如果那个名字是由大写字母开始的，`getName().charAt(`... 0... 然后我要写，然后我断言判断它应该是一个大写字母，如果不是的话 我想让它失败。测试，好吗？所以我们应该这样做，`doOnNext(`... 传入 r 然后 the name ... OK? 哇啦 这是我已更新了的管道。额 很明显你可以将这些都串联起来。就像我这样 我想做这样的事情串联起来那样我更容易读。即使我想将它拆开看看正在发生什么事情，然后就是这样，这是已经更新的代码，现在我们有了一个管道基本上是跟之前一样的。问题是，我首先读入数据。然后再当且仅当这样我才做验证，更加重要的是。如果我写两个记录的话会怎样，或者是十个、五个 随意吧。然后第三个记录有个小写的名字，我真的想写入前面两个记录吗？ 可能我更希望那是原子性的对吧？这取决于你 额是，风格选择问我我觉得 但是，让我们假设我真的想要原子性操作，我想要保证要么？全部名字都写入，或者全部都不写入，为了支持这个 我是用了这个新的 `ReactiveTransactionManager` 支持。所以我能够创建一个，`ReactiveTransactionManager` 实例，像这样然后这个需要，这里边有很多不同的实现，顺便说一下。我们有 `ReactiveTransactionManager` 的实现，在 额 R2DBC 给我也给 MongoDB 实现了，还有 Neo4J， 对吧 我确信还有一些我忘记了的至少目前有这些，return new ... 注入来自 R2DBC 的连接工厂然后 我们想创建一个 `TransactionalOperator`，好吗？而这个 ，`transactionalOperator` 需要 `ReactiveTransactionManager` 才能干活。所以我们创建那个，然后 哇啦 OK？所以这是我们的事务管理者，嗯 就是这些东西。现在，我想要做的是，是我想要使用那个 `TransactionalOperator` 例如 `private final TransactionalOperator` 然后我会写`this.transactionalOperator...` 然后我将整个管道，放到这个事务分区里边，使用这个 `transactionalOperator`所以 再次，所有东西在 `transactional` 里边的，在里面的整个发布者。会在一个事务当中。不在这里边的不会在一个事务里，对吧？我可以用另一种方式，写 `@EnableTransactionalManagament`对吧？然后只需要，只要返回的是一个发布者。我只需要用 `@Transactional`，在这个例子中 它们是一样效果的`TransactionalOperator`很好如果你想要更细粒度的事务控制。什么需要事务控制 而什么不需要，所以现在然我们重写这里的代码使用那个支持事务的服务，这里 private final ... 好吗，然后。我要写 `this.reservationService...` 好吗？哇啦，这是我们的服务 这是我们要写入数据库的数据。额……这会是支持事务的，所以我要写数据到数据库，支持事务地。但我要删除所有在那个事务之外的东西然后我要读取数据。在事务之外，所以这个，这行可能会显示 0 或 10，我们不清楚 或者 8 实际上这是我们有的 8 个记录。所以这只是，让我们将，Mark 的名字 暂时地 只是暂时地。我们会将 Mark 的名字改成小写，而他是操作中的第三个记录，对吧？所以现在，让我们返回到数据库这边 delete from reservation，对吧？现在里边什么都没有了 OK？现在再次运行这个代码，这些只是日志。

```java
/**
 * 一个服务，事务地往数据库写入数据。
 */
@Service
@RequiredArgsConstructor
class ReservationService {

    private final ReservationRepository reservationRepository;
    private final TransactionalOperator transactionalOperator;

    Flux<Reservation> saveAll(String... names) {
        return this.transactionalOperator
                // 在这个操作符里面是事务。
            .transactional(
            Flux
            .fromArray(names)
            .map(name -> new Reservation(null, name))
            .flatMap(this.reservationRepository::save)
            .doOnNext(r -> Assert.isTrue(isValid(r), "名字首字母必须大写！")));
    }

    // 一个断言，用于上面 Assert.isTrue()
    private boolean isValid(Reservation r) {
        // 判断首字母是否为大写
        return Character.isUpperCase(r.getName().charAt(0));
    }
}
```

上面的代码启用了事务，所以需要定义两个 bean

```java
/**
* 配置响应式事务管理
*
* @param cf 连接工厂
* @return 返回 R2dbcTransactionManager
*/
@Bean("r2dbc")
ReactiveTransactionManager reactiveTransactionManager(
    @Qualifier("connectionFactory") ConnectionFactory cf) {
    return new R2dbcTransactionManager(cf);
}

// 事务操作符
@Bean
TransactionalOperator transactionalOperator(
    @Qualifier("r2dbc") ReactiveTransactionManager transactionManager) {
    return TransactionalOperator.create(transactionManager);
}
```

之后应用启动时写入数据的代码改为：

```java
@Component
@RequiredArgsConstructor
@Log4j2
class SampleDataInitializer {

    private final ReservationRepository reservationRepository;
    private final ReservationService reservationService;

    @EventListener(ApplicationReadyEvent.class)
    public void ready() {

        var saved = this.reservationService.saveAll("Josh", "Madhura", "Mark", "Olga","Spencer", "Ria", "Stéphane", "Violetta");

        this.reservationRepository
                .deleteAll()
                .thenMany(saved)
                .thenMany(this.reservationRepository.findAll())
                .subscribe(log::info);
    }

}
```

如果将上面的人名字，某个首字母改为小写，则事务不通过，回滚，不会写入数据。

反映了这里有异常，但是这个应用没事能运行。额 现在数据库里什么都没有 OK？如果我恢复这个，大写字母，我们会看到全部 8 个，噢 就是这些。所以这里有数据 我们事务地。写入数据到数据库，正如我们期望的那样。OK 顺便问下 你们有注意到，这需要更多时间编译吗？相对比应用启动运行时间而言，对吧？我们目前所做的好处是，这是非常快，对吧？那么，我的大多数运行时间，你可以看到，少到 0.9 秒左右。额 ……这是有帮助的 顺便提一下 我还跑着 Chrome 呢。即便如此 我还能获得那样的速度。可以想象到在生产环境会是怎样吗？肯定会更加好，OK 那么现在，我有这个事务分区，我将数据写入到了数据库。

### HTTP 端点

​		额，我想是时候写一个 HTTP API 了。OK 下一件事就是写一个简单 HTTP 服务，我们写 `@RestController`
这是非常常见的东西，毫无疑问的肯定见过了 `RestController` 所以你可以写 Reservation... `ReservationController` 就像这样。你可以在这里注入它，可以写 `private final` ... OK ? 我将一个 我要将它添加为，构造器注入依赖 使用 `@RequiredArgsConstructor` 然后我创建一个简单端点，Reservation 的发布者
然后我要读取所有数据，我写 this...，`reservationRepository.findAll(`... 重启一下，，运行了吗？ 是的 跑起来了，所以 localhost:8080/reservations，这是我们的数据，好吗？这啥牛逼的，你以前就见过了 一点都不牛逼
非常简单 只是一个 `RestController` 返回一个发布者，这是很重要的，。所以，尽管这看起来像 Spring MVC
然后你可能会觉得熟悉，如果你使用 Spring MVC，这个并不是 Spring MVC，这里边没有 Servlet API 在 `classpath` 对吧 我甚至都没有使用 Servlet API 这是全新的 Reactive Web 运行时，基于 Netty 的。从底层开始构建起来支持我们这里想做的，好吗？所以，我们这里有响应式支持，而有些东西表面上是非常相似的 例如那些注解。将会感觉非常熟悉，其中不同的是 我们实际上返回 额。发布者 Spring MVC 控制器的返回值。典型的是
用于构造会被客户端渲染的响应的东西，这个实际上不是这样做的 是吗？这个它本身就是一个响应了，这是一个东西 WebFlux 这个框架，可以用来到达结果的东西，两者是不同的 它们之间的区别是很重要的，它给了一个我们可以用的。然后得到结果的结果，但不是同样的东西，所以这次进入到了问题。

```java
// 典型的类似 Web MVC 的路由配置方式
@RestController
@RequiredArgsConstructor
class ReservationRestController {
    private final ReservationRepository reservationRepository;

    @GetMapping("/reservations")
    Flux<Reservation> reservationFlux() {
        return reservationRepository.findAll();
    }
}
```

可以使用以下风格：

```java
// 函数式路由配置，作为 MVC 风格路由配置的一种替换选择。
@Bean
RouterFunction<ServerResponse> routers(ReservationRepository rr) {
    return route()
		.GET("/reservations", request -> ok().body(rr.findAll(), Reservation.class))
		.build();
}
```

​		OK 如果我想要一些东西一直活着，在一个管道的生命周期之内一直存活着。我应该怎样做？我如何附着某物
到生命周期超越这东西的，记住我们不能使用 `ThreadLocal` 对吧？`ThreadLocal` 现在用不了啦，你可以看到 我们解决了事务的问题，就在几分钟前，我们可以做的方式是 如果你想做的话。是我们可以访问一个称为 context 的东西，OK 你可以创建一个订阅者上下文。而 context 是在底层支持的，我们的能力取附着一个例如，额 事务附着到目前的管道。不管那个管道是在哪个线程执行的，这是一个可以支持我们做分布式跟踪的东西，去持续画出沿着不同线程的路线，那是可以允许我们做，安全扩散的，你可以在数个不同线程间传播认证信息，你可以创建一个与管道有关的上下文。就像这样，所以我在这里做的是，创建一个 context，以一个键和值，分别等于 a 和 b 的，对吧？它可以一直可见，在这个管道之中 我可以访问这个上下文？我的代码的任意地方 我可以写，`doOn`... 例如 ...Each... 然后我给个信号 从每个信号，我可以获取到当前的上下文。例如我可以打日志输出它，所以你自己可以做各种事情。你可以自己管理那种机制，但除此之外 这仍然是，一个 Spring MVC 风格的控制器而已。我喜欢这种风格。考虑到这只是一个简单的例子，我想要发起一个 HTTP GET 请求，然后想它返回 Reservation，就是这样而已 然而我一整个类和构造器。还有注解 方法之类的东西，只是为了支持那一个 HTTP 端点。额 你可能更喜欢这种替换的风格。称之为函数式响应式端点，在 Spring 5 及其后版本可用。所以我们支持它已经超过两年了，所以 routes。return ... 好吗？.GET(... 所以我正在做的是 我创建一个 Bean 在这个 Bean 里面。我定义一个函数式响应式路由。而我将它注入作为数据仓库的协作对象，我写 ...`findAll()`, `Reservation.class`... 然后 哇啦 OK？就是这样子，我将使用 static import 然后这就是我整个 HTTP 端点 这只是一行 我说的是，让…… 当某人，对/reservations 发起请求时。那么指派这个 Lambda 去干活，还有就是这是构建者方法，所以我实际上可以将这些串联起来，我可以做 .DELETE 我可以做... PUT 还有  POST 等所有这些东西。我可以编程地添加这些东西，我可以使用条件语句 while 循环之类 随意玩。去随意添加这些端点，所以 取决于你偏好的风格，但它们功能上来说是一样的。它们做的是同样的事情 OK？所以让我们重新运行这个程序，然后看一下我们会得到什么我？ 嗯 可以了
OK 就是这样。这就是数据，OK？现在我们有了一个可用的响应式 HTTP 端点，我们有 额……我们有 R2DBC 我们看到我们可以写 SQL 到数据库。额 当然这是一种非常常见的自然的事情，我们有这些非常…… 额…… 简单 易实现的用例对吧？我想写数据到 SQL 数据存储，然后我想从 HTTP 端点读取它们。然后问题当然是，那又怎样？我以前就可以这样做了，我并不需要响应式去从数据库读取 8 个记录。然后将它暴露为 JSON 对吗？这在以前做起来也不难 为什么今天我要这样做。

### 演示 WebSocket 实时发送消息到网页

​		这是个好问题。所以真实的用例 真实地使得，响应式编程如何迷人的。是它带来的能力和机遇，用于一些可能会独占线程的事情。那么有什么例子，什么会独占一个线程？在一个典型的应用架构我们会怎么做？可能会让一个线程一直开着。嗯 每当你需要客户端与服务器通信的时候。然后客户端想要活动地持续地更新，自是很自然的候选者。去让一个线程持续地打开，像服务端发送事件之类的。例如 WebSocket 然后这些协议支持的使用场景是什么？它们支持的使用场景必须要，持续地更新。例如，聊天 Presence 还有股票动态，这类型使用场景需要一直接入的，OK？那么让我们创建，一个服务会产生，数据的一个永不停息的数据流。OK 我们将创建一个 WebSocket 端点。那会响应一系列 WebSocket 数据流 一系列“问候”的数据流当某如需要一个“问候” 给定一个“问候”请求， 我们将要产生数据流。作为问候的响应 好吗？request OK 然后。`@service` 将这个类型放到这里 class
将这个类型放到这里，这里。好，那个请求只是有，name 它的详细内容只是包含一个名字。然后响应会有，问候消息它本身。OK ? 现在当然是 `@Data` 哇 这是什么 `@Data` `@AllArgsConstructor` `@NoArgsConstructor` 好东西。好东西 现在。我们要做的是，当某人请求一个“问候”。我们会返回一个不间断的数据流，
new Greeting ... Request 额 不好意思 是 response Hello OK? 所以这将会是不间断的数据流，现在 那是一个不间断的数据流。让我们用这个替换它，然后用 Lambda 替代。然后我们也调用 delayElements... 我要写我想要延迟它 1 秒 所以每一秒我都要产生一个新的值 现在留意下我刚才做了什么。我引入了，一个永不间断的数据流，它将会产生新的响应，一直都会，那个数据流会。会很快地滚动下来很快占满控制台，我们不看看到终结的，所以我通过使用 delayElements 分散下结果。我可以这样，我可以在这里改变时间是因为，是因为在 Reactor 背后我们所做的一切。里边都有个调度器，通常你不会注意到它存在。你也不需要知道它存在，但它一直都在那里，那个调度器。就是允许我们控制，执行的动向，从一个线程无缝的切换到另一个线程。你不需要担忧这个，调度器。处理两件事。处理调度任务，然后它处理多线程，它实际... 它有点像个线程池，加上一个定时器 你可以这样想。OK ? 额 这是我们放进 Reactor 里的抽象。通常你不需要担忧这个，但是默认情况下。一个线程占一个 CUP 核，好吗？所以你有每个线程一个核，在默认的应用程序，这意味着，如果你是在一个机器。你只有四个核 那你就只有四个线程，所以非常重要，你不阻塞这些线程。如果你使用响应式代码，那么你不能阻塞。对吧？额 在这里你有调度器
如果你觉得需要的话，如果你需要重写调度器的话，如果你需要做一些事。那会阻塞的话，非常重要的是，你处理好。额，将那个任务，放到一个不同的调度器。所以 Schedulers... 额…… elastic() ... 或者是 `fromExecutor`(...
你懂得像这样，你提供你自己的 Executors。随你所想 对吧？很重要的是，你要处理好重写调度器，那某个管道的使用。要么 `subscribeOn` 或者是 `publishOn` 对吧？我通常使用 `subscribeOn`但如果你有一个生产者它会
如果你有消费者比生产者更慢的话。你可以使用 `publishOn` 对吧？嗯 喔 这是这被认为是代码臭味我认为那会是代码臭味。如果你发现要经常这样做，如果你有代码在你的代码库里是阻塞的，与阻塞资源之间的交互，然后你要扩展开那个交互，通过添加更多线程的办法，这样是我们尝试使用响应式编程的初衷。我们想要的是，你懂得 不阻塞。我们想从中获益的，是在系统高效地复用线程。如果你只能通过增加线程扩展的话，有的问题了。你应该能找到那个代码，而且一点点，隔绝并从你的代码中移除。为帮助你做这样的事情，我们创建了称为 `blockhound` 的东西。是一个 Java 代理，你可以用它来检测，不阻塞线程的阻塞调用。你只需将它添加到 `classpath`然后只需运行 `BlockHound.install()`在你的 public static void main(... 方法里 在你启动 Spring Boot 之前，OK ？额
这样做了之后，如果你干些傻事 例如 `Thread.sleep()` 或计算斐波那契数列，不管什么 额。你会得到这个阻塞的调用。对吧 这个阻塞的异常，它会抛出异常 帮助你知道那里有错误。就那么简单，然后你可以好好调试或者，
将其隔离，或者至少处理好。将它放到它自己的调度器，这响应式的世界里这要做很重要。请记住 如果你有四个核心 你有四个线程。如果你阻塞了其中一个线程，那不只是一个请求，那是你 25% 的用户，对吧？ 你通常可能使用 PHP。去解决那样的问题 不 不要那样做。做正确的事情OK ? 那么，我们有一个调度器，你可以使用它 如果你想的话。那个调度器，是一个允许我们，像这样做事情。我们可以增加时间，时间是我们的 API 的一个维度这是响应式编程的一种好处。我们现在可以想象世界，真的作为一系列的时间  时间里一系列的事件，那么现在我们那样做了。让我们创建一个请求，额 WebSocket 端点 OK？Websocket ... 好吧 ...Configuration 然后我们会在这创建一些 Beans 那个 `WebSocketHandleerAdapter` 这是一个东西。我们需要去告诉 Spring，去查找 WebSocket 支持，对吧？我们需要那个 `WebSocketHandler` 本身，然后这里边是我们的业务逻辑，等会我们再回头看看这个这个是业务逻辑。然后我们实际上需要告诉，Spring 去装载我们的，WebSocket 端点。到一个 HTTP URL，我们需要这样做的原因是，额 WebSocket 是一个二进制协议。但当 WebSocket 客户端连接到服务器的时候，它会升级到二进制协议，所以它先是连接到 HTTP，然后有握手 接着协议升级，我们需要告诉框架。嘿 映射这个端点这个 HTTP 端点，到这个二进制协议OK? 所以我要写 Map.of... /ws/greetings 然后我要给它一个引用到 `WebSocketHandler` 它会延迟操作 对吧 我要给... 我要给这个特定的 URL 一个排序 只是为了确保它 确保它排在其它 URL 之前 OK 那么现在 这是我的 `WebSocketHandler` 这是业务逻辑所在的地方 条约很简单 当请求进来的时候
我们获得一个指向当前 WebSocket Session 的指针，而正是在那个 WebSocket Session 我们才可以。做一些像
询问传入的数据，那么什么是传入的数据，在这个例子当中，那将会是一个“问候”请求，将会是 String 类型的 name。我们可以将它变成一个问候请求，然后调用服务得到一系列的响应，再发送回给 WebSocket 客户端，所以我们将会说 嘿。给我们一个数据流，的 WebSocket 消息。接收当中的每一个，就像这样 获取载荷作为文本就像这样 `map` 这里边的文本。这些是名字实际情况只是会有一个名字，你知道的我们这里有个发布者 `map` 每一个名字。到 `GreetingRequest`就像这样 OK？`greetingRequestFlux` 然后将当中的每一个，然后我们会将它变成对服务的一个调用。然后我们注入刚刚创建的“问候服务”到这里。就像这样 `gs.greet( gr` ... 然后我们将要创建一个“问候响应” 现在对于其中每一个响应我想要将它转换成 WebSocket 消息 我可以返回给客户端，我们将要写
receive... 额 我们要写 `greetingResponseFlux`... OK？这些是 String 类型的名字，我要将它变成 WebSocket 的消息。通过写 txt... 将它变成这样 这是我的 WebSocket 信息数据流 我只需要写 `session.send(`... `map1`
这就是整个管道。很显然我不想让它这样子折叠起来成为一个容易理解的数据流 OK？所以你可以看到默认情况下我使用 map 除非我有其它东西会产生一个发布者。那样的话我会使用 `flatMap` 额 还有就是这样 这就是整个序列
所以 receive 当然这整个接口是函数式接口 所以这是它的 lambda 形式，OK? 

```java
// 配置 WebSocketHandler 初始写法
@Bean
WebSocketHandler webSocketHandler(GreetingService greetingService) {
        return new WebSocketHandler() {
            @Override
            public Mono<Void> handle(WebSocketSession webSocketSession) {

                Flux<WebSocketMessage> receive = webSocketSession.receive();
                Flux<String> names = receive.map(WebSocketMessage::getPayloadAsText);
                Flux<GreetingRequest> greetingRequestFlux = names.map(GreetingRequest::new);
                Flux<GreetingResponse> greetingResponseFlux = greetingRequestFlux.flatMap(greetingService::greet);
                Flux<String> map = greetingResponseFlux.map(GreetingResponse::getMessage);
                Flux<WebSocketMessage> map1 = map.map(webSocketSession::textMessage);

                return webSocketSession.send(map1);
            }
        };
}
```

变成

```java
// 配置 WebSocket
@Bean
WebSocketHandler webSocketHandler(GreetingService greetingService) {
    return session -> {
        var receive = session
                .receive()
                .map(WebSocketMessage::getPayloadAsText)
                .map(GreetingRequest::new)
                .flatMap(greetingService::greet)
                .map(GreetingResponse::getMessage)
                .map(session::textMessage);
        return session.send(receive);
    };
}
```

这个配置类是这样 

```java
@Configuration
class GreetingWebsocketConfiguration {

// 配置 WebSocket
@Bean
WebSocketHandler webSocketHandler(GreetingService greetingService) {
    return session -> {
        var receive = session
                .receive()
                .map(WebSocketMessage::getPayloadAsText)
                .map(GreetingRequest::new)
                .flatMap(greetingService::greet)
                .map(GreetingResponse::getMessage)
                .map(session::textMessage);
        return session.send(receive);
    };
}

// 处理 URL 升级
@Bean
SimpleUrlHandlerMapping simpleUrlHandlerMapping(WebSocketHandler webSocketHandler) {
    return new SimpleUrlHandlerMapping(Map.of("/ws/greetings", webSocketHandler), 10);
}

// 配置 WebSocket
@Bean
WebSocketHandlerAdapter webSocketHandlerAdapter() {
    return new WebSocketHandlerAdapter();
}

}
```

现在，我有一个 `WebSocketHandler` 这是一个 Bean 我在配置类里边配置的这是一个 WebSocket 端点 这东西能用但我想 我要给你们演示这个 现在我的朋友们 我有点 有点尴尬 我们这边有点问题不幸的是我要给你们演示这个然而我想不到做这事的更加优雅的方式了我想不到一个好的方式去做我想做的事情 但我必须做这件事 为了做这件事额…… 我会觉得不自在 对吧 我们是朋友啊 我觉得…… 这会破坏我们之间的信任如果我这样做 但我想不到更好的方式了 而我通常不会在体面的公司里做这样的事情 OK 如果我能避免的话 如果我可以找到其它方式 去做我想做的事那么当然我会 哎…… 我要写 JavaScript OK？好 那么 `window.addEventListener`... OK 这些代码 OK 不好意思 是 ... ws/greetings ... 对吧 就是这样 然后 当 Socket 打开的时候 然后我可以开始跟它交互了 我要做的是 我要获取 Socket 我要发送请求 我只是写 Devoxx Belgium OK? 好了吗？然后当数据进来的时候我要加载这些资源所以我要构造请求 这是我们要发送的名字 实际上我们不需要在 Belgium 后加叹号当那个消息返回的时候我们有 `onMessage` 回调 所以写 function ... ... msg ... 我将结果打印到这里 所以 console.log(... 然后我们重启应用 OK 噢 是这个 就是这样我的朋友们。

JavaScript 代码：

```html
<!DOCTYPE html>
<html lang="en">
<body>
<script>
    window.addEventListener('load', function (ev) {
        const ws = new WebSocket('ws://localhost:8080/ws/greetings');
        ws.addEventListener('open', function (ev1) {
            ws.send('Devoxx Belgium')
        });

        ws.addEventListener('message', function (msg) {
            console.log('new message: ' + msg.data);
        });
    })
</script>
</body>
</html>
```

每一秒钟 至往后无限它会产生新的结果。它会一直有…… 继续有…… 有……
永远 直到永远…… 永远…… 永远…… 它不会结束的 它是无终结的 就像海洋…… 亦如星空……还有你代码中的 bug
无穷的，无尽的 我们朋友们 那没关系好吗 那没关系 因为 我们要做的是 是在雨滴之间 在这些消息发送给客户端的过程 那个线程释放了 某物 某人在系统中之后可以使用那个线程 去做更多的事情 这是真正的好处。响应式编程带来的进步，并不是我们让每个事务更加快，是我们这样做所以。处理更加多的事务，这就是真正的胜利。对吧 做个简单的计算。这个完全算不上是真实的性能测试，但在这里使用简单数字做例子。这里的目标是用一半的硬件成本去处理。同样多的事务，对吧？或者去处理，一半…… 额一样数量的事务，或者是两倍数量的事务，以同样的硬件。对吧？那并不是要使得每个特定的事务更加快，记得吗 因为线程切换，那可能会更慢一点。但目标是你可以用同样的硬件做得更多，你更高效地使用了这个系统，所以我的朋友们 我们已经看了如何构建一个服务，在这边谈论了一些不同的东西。我们构建了一个简单服务。

在下一节，我们会讲构建一个客户端。那将会带我们进入到恐怖的微服务，当你有一个服务于另一个服务通信的时候会发生什么？在那一节我们会讨论像网关 HTTP 适配器 网关之类的。API 适配器 HTTP 客户端 你懂的。我们会用 Kotlin 写，那会是在第二节。
