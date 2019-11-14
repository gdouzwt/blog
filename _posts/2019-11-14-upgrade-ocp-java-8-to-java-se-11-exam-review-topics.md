---
typora-root-url: ../
layout:     post
title:      升级到 Java SE 11 开发者考试大纲
date:       '2019-11-14T14:03'
subtitle:   考点准备
author:     招文桃
catalog:    true
tags:
    - Java 11
    - OCP
---

## 升级到 Java SE 11 开发者考试大纲

#### Understanding Modules

- Describe the Modular JDK
- Declare modules and enable access between modules
- Describe how a modular project is compiled and run

#### Migration to a Modular Application

- Migrate the application developed using a Java version prior to SE 9 to SE 11 including top-down and bottom-up migration, splitting a Java SE 8 application into modules for migration
- Use jdeps to determine dependencies and identify way to address the cyclic dependencies

#### Services in a Modular Application

- Describe the components of Services including directives
- Design a service type, load the services using ServiceLoader, check for dependencies of the services including consumer module and provider module

#### Local-Variable Type Inference

- Use local-variable type inference
- Create and use lambda expressions with local-variable type inferred parameters

#### Java Interfaces

- Create and use methods in interfaces
- Define and write functional interfaces

#### Lambda Expressions

- Create and use lambda expressions
- Use lambda expressions and method references
- Use built-in functional interfaces including Predicate, Consumer, Function, and Supplier
- Use primitive and binary variations of base interfaces of java.util.function package

#### Lambda Operations on Streams

- Extract stream data using map, peek and flatMap methods
- Search stream data using search findFirst, findAny, anyMatch, allMatch and noneMatch methods
- Use the Optional class
- Perform calculations using count, max, min, average and sum stream operations
- Sort a collection using lambda expressions
- Use Collectors with streams, including the groupingBy and partitioningBy operation

#### Parallel Streams

- Develop the code that use parallel streams
- Implement decomposition and reduction with streams

#### Java File I/O (NIO.2)

- Use Path interface to operate on file and directory paths
- Use Files class to check, delete, copy or move a file or directory
- Use Stream API with Files

#### Language Enhancements

- Use try-with-resources construct
- Develop code that handles multiple Exception types in a single catch block