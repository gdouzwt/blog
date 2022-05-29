---
typora-root-url: ../
layout:     post
title:      Java模块化
date:       '2020-01-22T00:14'
subtitle:   学习Java 11模块化特性
author:     招文桃
catalog:    true
tags:
    - Java 11
---

为了准备 1Z0-816，要学习一下 Java 11 的基础部分。

<!--more-->

<img src="/img/image-20200122001604874.png" alt="image-20200122001604874"  />

#### 模块描述符语法

***ModuleDeclaration:***  
	***{Annotation} [***`open`***]*** `module` ***Identifier {. Identifier}***  
		{***{ModuleDirective}***}

***ModuleDirective:***  
  `requires` ***{RequiresModifier} ModuleName*** ;    
  `exports` ***PackageName [***`to` ***ModuleName*** ***{, ModuleName}]*** ;  
  `opens` ***PackageName [***`to` ***ModuleName {, ModuleName}]*** ;  
  `uses` ***TypeName*** ;  
  `provides` ***TypeName*** `with` ***TypeName {, TypeName}*** ;

***RequiresModifier:***  
  *(one of)*  
  `transitive` `static`

#### 创建模块

*module-info.java* 是模块描述符。最简单的一个模块如下：

```java
module io.zwt.common {
}
```

#### 定义模块间依赖

#### 模块的访问控制

#### 服务消费者与服务提供者

