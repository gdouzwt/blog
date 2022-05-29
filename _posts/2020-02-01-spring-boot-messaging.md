---
typora-root-url: ../
layout:     post
title:      Spring Boot 消息
date:       '2020-02-01T10:44'
subtitle:   Messaging简单笔记
author:     招文桃
catalog:    true
tags:
    - Spring Boot
    - Messaging
---

## 消息通信



   ![messaging](/img/messaging.png)

最简单的消息机制，从A点到B点，通过某种信道传递消息，可以使一个简单的函数调用，一个socket连接，或者是一个HTTP请求。主要目的是发送端发送消息给接收端消费。

### 消息通信使用场景

下面列出一些消息通信常见的使用场景：

#### 可靠送达

通常需要一些消息确认机制，如果中间有个Broker，消息生产者要通过一些确认，了解Broker确实收到了消息。同理在消费者段也需要给Broker确认已经收到消息。通常支付、股票交易等系统会使用这种模式。<!--more-->

#### 解耦

按照业务领域解耦，使用bounded context.

#### 扩展和高可用

多个Broker扩展。

#### 异步

异步消息确保响应性，responsiveness

#### 互操作性

采用Broker架构，实现AMQP等协议。

### 消息模式和设计模式

#### 点到点

![point-to-point](/img/point-to-point.png)

#### 发布-订阅

![pub-sub](/img/pub-sub.png)

#### 设计模式

A design patterns is a solution to a commonly known problem in the software design. By the same token, messaging patterns attempt to solve problems with messaging designs.

​	You will learn about the implementation of the following patterns during the course of this book, so I want to list them here with simple definitions to introduce them:

-  *Message type patterns:* Describe different forms of messaging, such as string(maybe plain text, JSON and/or XML), byte array, object, etc.
- *Message channel patterns:* Determine what kind of a transport(channel) will be used to send a message and what kind of attributes it will have. The idea here is that the producer and consumer know how to connect to the transport(channel) and can send and receive the message. Possible attributes of this transport include a request-reply feature and a unidirectional channel, which you will learn about very soon. One example of this pattern is the point-to-point channel.
- *Routing patterns:* Describe a way to send message between producer and consumers by providing a routing mechanism(filtering that's dependent on a set of conditions) in an integrated solution. That can be accomplished by programming, or in some cases, the messaging system(the broker) can have these capabilities(as with RabbitMQ).
- *Service consumer patterns:* Describe how the consumers will behave when messages arrive, such as adding a transactional approach when processing the message. There are frameworks that allow you to initiate this kind of behavior(like the Spring Framework, which you do by adding the @Transactional, a transaction-base abstraction).
- *Contract patterns:* Contracts between the producer and consumer to have simple communications, such as when you do some REST calls, where you call a JSON or XML message with fields.
- *Message construction patterns:* Describe how a message is created so it can travel within the messaging system. For example, you can create an "envelope" that can have a body(the actual message) and some headers(with a correlation ID or a sequence or maybe a reply address). With a simple web request, you can add parameters or headers and the actual message becomes the body of the request, making the whole request part of the construction pattern. The HTTP protocol allows for that kind of communication (messaging).
- *Transformation patterns:* Describe how to change the content of the message within the messaging system. Think about a message that requires some processing and needs to be enhanced on the fly, such as a content enricher.

As you can see, these patterns not only describe the messaging process but some of them describe how to handle some of the common use cases you saw earlier. Of cause, there are a lot more messaging patterns.

