---
typora-root-url: ../
layout:     post
title:      响应式Spring Boot系列教程3
date:       '2020-01-09T08:15'
subtitle:   JavaFX Spring Boot应用程序
author:     招文桃
catalog:    true
tags:
    - JavaFX
    - Tutorial
    - Spring Boot
    - Reactive
    - 教程
    - 翻译
---

> 原文由 Trisha Gee 在当地时间2019年11月11日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-javafx-spring-boot-application/)

这是第三步，演示如何创建一个 响应式应用程序，使用Spring Boot, Kotlin，Java和JavaFX。

这个第三步演示如何创建一个由Spring Boot启动并管理的JavaFX应用程序，因此我们可以在JavaFX应用程序中使用Spring的特性，例如控制反转。本文也有配套的[视频](https://www.bilibili.com/video/av82672621)。

<!--more-->

### 设置好模块

在这一节，我重用前面步骤创建的客户端，并为它添加一个新模块。但是如果我们想将这个作为一个独立的工程，我们可以创建一个新的工程而不是新模块，步骤是非常相似的（替换new module为new project)。

1. 打开前面步骤创建的`stock-client`工程后，创建一个新的模块。
2. 这会是一个Spring Boot应用程序，所以在左边选择Spring Initializr。
3. 在本教程我们使用Java 13作为SDK，虽然我们并没有后使用任何Java 13特有的特性。
4. 为工程填入groupId，和artifact名为`stock-ui`。
5. 保持Maven工程默认的Java和jar打包选项。
6. 我们选择Java 11作为Java版本，因为这是最近的长期支持版，但是对于本工程而已，这没有区别。
7. 为模块输入一个有用的描述，这是我们的第三个模块，这有助于我们清楚每个模块的作用。
8. 如有需要也可以改变默认的包结构。
9. 在这个模块，我们不需要选择任何Spring Boot Starter。
10. 保持默认的模块名和位置。

IntelliJ IDEA从Spring Initializr下载工程并将IDE设置好。如果有提示选择 "show run configuration in services" 我们可以选择它。 那个services窗口对于查看正在运行的服务和管理微服务应用比较有用。

### Spring Boot应用程序类

跟往常一样，Spring Boot为我们生成默认的应用程序类。我们需要更改一下以便启动一个JavaFX应用程序，但现在我们先留着它这样子。

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class StockUiApplication {
    public static void main(String[] args) {
        SpringApplication.run(StockUiApplication.class, args);
    }
}
```

### 更新Spring Boot设置

因为这是一个JavaFX应用程序，不是一个Web应用程序。所以在这个模块的application.properties里添加：

```properties
spring.main.web-application-type=none
```

### 创建一个 JavaFX 应用程序类

1. 在与Spring应用程序类同一个包里创建一个新的Java类，命名为`ChartApplicaion`。
2. （提示：在project窗口，Windows/Linux用户可以使用Alt+Insert（macOS用户是⌘N) 创建一个新文件或目录）。
3. 让它继承于`javafx.application.Application`。

这个类目前不在类路径上，因为我们还未添加JavaFX到依赖里，所以我们需要将它添加到pom.xml 文件。

1. （提示：在红色的`Application` 文字上按下Alt+Enter 会有"Add Maven Dependency"选项。
2. 将`org.openjfx:javafx-graphics`添加为依赖，版本是 13。

```xml
<dependency>
	<groupId>org.openjfx</groupId>
    <artifactId>javafx-graphics</artifactId>
    <version>13</version>
</dependency>
```

1. 现在可以在`ChartApplication`导入`javafx.application.Application`。
2. `Application`是一个抽象类，所以我们需要重写一个方法。
3. （提示：在红色的错误上按下Alt+Enter并选择"Implement methods"，选择要实现的方法，可以让InteliJ IDEA去帮我们实现这些方法。）。
4. 只有一个start方法是必须实现的。

```java
import javafx.application.Application;
import javafx.stage.Stage;
 
public class ChartApplication extends Application {
    @Override
    public void start(Stage stage) {
        
    }
}
```

### 设置好 Spring Boot 应用程序类

现在我们有了一个 JavaFX 应用程序，我们需要从Spring Boot应用程序里面启动它。

不使用`SpringApplication`启动应用，我们将使用JavaFX的`Application`类，并以我们的JavaFX类作为参数调用`launch`方法。

```java
import javafx.application.Application;
import org.springframework.boot.autoconfigure.SpringBootApplication;
 
@SpringBootApplication
public class StockUiApplication {
    public static void main(String[] args) {
        Application.launch(ChartApplication.class, args);
    }
}
```

我们要分离出两个应用程序类的原因跟JavaFX以及Java的模块化机制有关，这些细节已经超出了本教程的讨论范围。如果我们想要整合Spring和JavaFX但不使用Java 9的模块，这是一种做法。

### 通过应用程序上下文发布事件

让我们回到我们的JavaFX应用程序类，`ChartApplication`。

1. 创建一个字段`applicationContext`，这会是`ConfigurableApplicationContext`类型。
2. 我们的`start`方法是一个标准的JavaFX方法，它以`Stage`作为参数，但`stage`就绪时调用。我们可以使用Spring的通过应用程序上下文发布事件的模式去告诉何时`Stage`就绪。在`start()`方法内，以一个新的 `StageReadyEvent`作为参数去调用`applicationContext.publishEvent()`。
3. 将stage传入到事件的构造函数。

```java
public class ChartApplication extends Application {
    private ConfigurableApplicationContext applicationContext;
 
    @Override
    public void start(Stage stage) {
        applicationContext.publishEvent(new StageReadyEvent(stage));
    }
}
```

现在我们需要创建我们的`StageReadyEvent`。

1. 简单起见将它创建为`ChartApplication`的一个内部类。以后总能再重构出来的。
2. （提示：在红色的`StageReadyEvent`按下Alt+Enter会有个选项"Create inner class StageReadyEvent"）。
3. 在`StageReadyEvent`的构造函数，传入`stage`参数到`super`构造函数。
4. 将这个内部类改为`static`且是包内可见，其它类将会监听这个事件。

```java
static class StageReadyEvent extends ApplicationEvent {
    public StageReadyEvent(Stage stage) {
        super(stage);
    }
}
```

### 创建应用程序上下文

在`Application`类里面有些其它有用的方法我们可以重写利用一下。

1. 重写`init()`方法。这是我们需要初始化应用程序上下文的地方。
2. （提示：你可以在一个类当中使用Ctrl+O选择要重写的超类方法）。
3. 创建一个新的`SpringApplicationBuilder`，并传入一个我们的Spring Boot应用程序类，也就是 `StockUiApplication`。
4. 运行`run()`以获取应用程序上下文，并赋值到`applicationContext`字段。

```java
@Override
public void init() {
    applicationContext = new SpringApplicationBuilder(StockUiApplication.class).run();
}
```

### 关闭应用程序上下文

因为我们有一个`init()`方法，我们也应该有一些适当的拆卸或清理步骤。

1. 重写`Application`类的`stop`方法。
2. 在`stop`方法内，调用`applicationContext.close()`方法。
3. 同时也在JavaFX程序结束处调用`Platform.exit()`。

```java
@Override
public void stop() {
    applicationContext.close();
    Platform.exit();
}
```

现在我们有了Spring Boot应用程序类用来启动 JavaFX的`Application`类，即`ChartApplication`：

```java
import javafx.application.Application;
import javafx.application.Platform;
import javafx.stage.Stage;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ConfigurableApplicationContext;
 
public class ChartApplication extends Application {
    private ConfigurableApplicationContext applicationContext;
 
    @Override
    public void init() {
        applicationContext = new SpringApplicationBuilder(StockUiApplication.class).run();
    }
 
    @Override
    public void start(Stage stage) {
        applicationContext.publishEvent(new StageReadyEvent(stage));
    }
 
    @Override
    public void stop() {
        applicationContext.close();
        Platform.exit();
    }
 
    static class StageReadyEvent extends ApplicationEvent {
        public StageReadyEvent(Stage stage) {
            super(stage);
        }
    }
}
```

### 监听应用程序事件

我们需要一些东西去监听我们所创建的`StageReadyEvent`。

1. 当它就绪时这个会设置好我们的JavaFX Stage。
2. 这个类应该用Spring的`@Component`注解。
3. 这个类需要实现`ApplicationListener`接口，去监听我们的`StageReadyEvent`事件。
4. 我们需要实现这个接口上的方法，即`onApplicationEvent`。
5. `onApplicationEvent`方法需要一个`StageReadyEvent`。 事件触发`getStage`被调用并将结果赋值到一个类型为`Stage`的局部变量。

```java
import com.mechanitis.demo.stockui.ChartApplication.StageReadyEvent;
import javafx.stage.Stage;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;
 
@Component
public class StageInitializer implements ApplicationListener<StageReadyEvent> {
    @Override
    public void onApplicationEvent(StageReadyEvent event) {
        Stage stage = event.getStage();
    }
}
```

（注意：这些代码当前未能通过编译）

这个方法不存在，所以我们需要创建这个`StageReadyEvent`。

1. （提示：我们可以在`StageInitialize`r里面红色的`getStage`方法上按下Alt+Enter并选择"Create method getStage" 去让IntelliJ IDEA帮我们生成这个。
2. 父类里面有个我们想要的方法，`getSource`这会返回一个对象，所以调用这个方法并将返回值。

```java
static class StageReadyEvent extends ApplicationEvent {
    public StageReadyEvent(Stage stage) {
        super(stage);
    }
 
    public Stage getStage() {
        return ((Stage) getSource());
    }
}
```

我们知道source就是`Stage`类型，因为当我们将stage的构造函数参数传入到父类的构造函数时，它就变成了 source。

### 最后步骤

这个`Stage`已经准备就是可用于我们的用户界面。我们可以运行我们的`StockUiApplication`，然后看到它成功地作为一个Spring Boot应用程序启动了。同时它也启动了一个Java进程显示一个UI如果我们有创建的话。目前位置，我们已经成功地创建了一个由Spring管理并启动的JavaFX应用程序，并且允许我们方便地使用Spring应用程序的特性。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)





















