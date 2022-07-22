---
layout:     post
title:     Spring Cloud OpenFeign 文档学习记录
date:       '2022-06-27T02:01'
subtitle:   Learning Spring Cloud OpenFeign
categories: Spring
author:     招文桃
catalog:    true
tags:
    - Spring
    - http
---


> 本文涉及 Spring Cloud OpenFeign 的版本为 3.1.3

Spring Cloud OpenFeign 通过自动装配和绑定为 Spring Boot 应用提供了 OpenFeign 在 Spring 环境及其他 Spring　编程模型中使用的集成。

### 1. 声明式 REST 客户端：Feign

Feign 是一种声明式 Web 服务客户端。它使得编写 Web 服务客户端更简单。要使用 Feign 只需创建一个接口并加上注解就可以了。它具有可插拔的注解支持，包括 Feign 本身的注解已经 JAX-RS 标准的注解。
同时 Feign 也支持可插拔的编码器和解码器。 Spring Cloud (为 Feign) 添加了 Spring MVC 注解支持，并且使用了在 Spring Web 中一样的的默认 `HttpMessageConverters` 注解。 Spring Cloud
集成了 Eureka，Spring Cloud CircuitBreaker 以及 Spring Cloud LoadBalancer 以便在使用 Feign 时候可以提供一种经过负载均衡了的客户端。

#### 1.1 如何引入 Feign

在你的工程中使用 group 为 `org.springframework.cloud` 并且 artifact id 是 `spring-cloud-starter-openfeign` 的依赖。

简单代码示例：

```java
@SpringBootApplication
@EnableFeignClients
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

**StoreClient.java**

```java
@FeignClient("stores")
public interface StoreClient {
    @RequestMapping(method = RequestMethod.GET, value = "/stores")
    List<Store> getStores();

    @RequestMapping(method = RequestMethod.GET, value = "/stores")
    Page<Store> getStores(Pageable pageable);

    @RequestMapping(method = RequestMethod.POST, value = "/stores/{storeId}", consumes = "application/json")
    Store update(@PathVariable("storeId") Long storeId, Store store);

    @RequestMapping(method = RequestMethod.DELETE, value = "/stores/{storeId:\\d+}")
    void delete(@PathVariable Long storeId);
}
```

以上代码中，注解 `@FeignClient` 里面的值 "store" 表示自定义的客户端名称，被用于创建一个 Spring Cloud LoadBalancer 客户端。 你也可以通过 `url` 属性指定一个 URL（绝对路径或者是一个主机名）。 它对应的 Bean 的名称是它的全限定名称。要指定别名，你可以使用`@FeignClient` 注解里面的 `qualifiers` 的值。

上面所说的负载均衡的会尝试去发现 "store" 服务的物理地址。 如果你的应用是一个 Eureka 客户端，那么它会从 Eureka 服务注册中心解析服务。如果你不想用 Eureka，你可以使用 `SimpleDiscoveryClient` 配置一个服务器列表在外部化配置中。

