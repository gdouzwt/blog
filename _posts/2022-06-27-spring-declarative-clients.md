---
layout:     post
title:     Spring 中的声明式 HTTP 客户端
date:       '2022-06-27T00:48'
subtitle:   Declarative clients in Spring
categories: Spring
author:     招文桃
catalog:    true
tags:
    - Spring
    - http
---


如果使用 RestTemplate 的话，就太不简洁了。很多代码。


Client interface method calls   ====> proxy  ====> HTTP calls

Feign 是其中一种解决方案。


Feign 支持多种 HTTP client 实现， 而且支持 Contracts， 支持自定义注解，参数解析

支持多种 编码器、解码器，包括 Jackson 和 GSON

支持 Metrics 包括 Micrometer


Spring Cloud OpenFeign

Spring MVC 和 Spring Cloud 支持 OpenFeign

注解支持
自动装配
Spring Cloud LoadBalancer 支持
Spring Cloud CircuitBreaker 支持
Tracing 支持


HttpMethod
@RequestHeader
@RequestParam
@RequestBody
@RequestAttribute


ResponseEntity
HttpHeaders
Body
void


url
method
contentType
accept


URI

HttpMethod

@RequestHeader

@PathVariable

@RequestBody

@RequestParam

@CookieValue

