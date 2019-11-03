---
typora-root-url: ../
layout:     post
title:      回顾 Maven 的一些基本操作
date:       '2019-10-31T23:00'
subtitle:   记录一下方便以后查看
author:     招文桃
catalog:    true
tags:
    - Java
    - Maven
---

## 使用 Maven 创建最简单的项目

在安装好了 Maven 之后，可以在命令行窗口输入以下命令创建一个简单的 Maven 项目：

```shell
mvn archetype:generate -DgroupId=io.zwt.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false
```

可以看到结果生成了一个目录为 my-app 的项目：

![image-20191031231003895](/img/image-20191031231003895.png)

其目录结构如下：

```
my-app
│  pom.xml
│
└─src
    ├─main
    │  └─java
    │      └─io
    │          └─zwt
    │              └─app
    │                      App.java
    │
    └─test
        └─java
            └─io
                └─zwt
                    └─app
                            AppTest.java
```

#### 编译

`mvn compile`

#### 测试

`mvn test`

#### 移除安装到本地仓库的项目

```xml
mvn build-helper:remove-project-artifact
```

在当前项目目录运行，仅移除当前项目。



To be continued...





















