---
typora-root-url: ../
layout:     post
title:      Java 中级试题
date:       '2019-11-11T18:59'
subtitle:   记录过程
author:     招文桃
catalog:    true
tags:
    - Java
    - Spring Cloud
---

# 你们的试题要求

## 中级试题

使用我们的[脚手架工具](https://github.com/deepexi/devops-recruitment/blob/master/back-end/scaffold.md)生成项目`mini-system`，实现一个系统最基本的功能：用户认证+权限控制，要求：

- 根据RBAC模型进行数据库设计
- 用户密码非明文存储
- 使用JWT进行认证控制
- 使用你喜欢的框架实现接口级的权限控制
- 为重要的逻辑添加单元测试保护

考虑到工作量的问题，不强制要求实现数据的CRUD相关接口，你可以直接往数据库中添加数据来测试上述功能。<!--more-->



计划，先生成项目 `mini-system` ，之后是权限控制，这个可以参照 JHipster 实现。 

- RBAC 的话，先做出个最简单的表。 

- 用户密码非明文这个好办 bcryt

- JWT 那就看 JWT HANDBOOK 吧

- 接口级权限控制 Spring Security

- 单元测试 JUnit