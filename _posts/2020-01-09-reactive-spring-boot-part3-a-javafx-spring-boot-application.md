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

这是第三步，演示如何创建一个 响应式应用程序，使用 Spring Boot, Kotlin，Java 和 JavaFX。

这个第三步演示如何创建一个由 Spring Boot 启动并管理的 JavaFX 应用程序，因此我们可以在 JavaFX 应用程序中使用 Spring 的特性，例如控制反转。本文也有配套的[视频](https://www.bilibili.com/video/av82672621)。

<!--more-->

### 设置好模块

In the video we re-use the client project we created for the previous step, and add a new module to it. But if we wanted to create this as a standalone project we could create this as a new project rather than a new module, the steps would be very similar (replacing “new module” with “new project”).

在这一节，我重用前面步骤创建的客户端，并为它添加一个新模块。但是如果我们想将这个作为一个独立的工程，我们可以创建一个新的工程而不是新模块，步骤是非常相似的（替换 new module 为 new project)

1. With the stock-client project from the previous step open in IntelliJ IDEA, [create a new module](https://www.jetbrains.com/help/idea/creating-and-managing-modules.html#add-new-module). 打开了前面步骤创建的 stock-client 工程后，创建一个新的模块
2. This is a Spring Boot application so [choose Spring Initializr from the options on the left](https://www.jetbrains.com/help/idea/spring-boot.html#create-spring-boot-project). 这将会是一个 Spring Boot 应用程序，所以在左边选择 Spring Initializr
3. We’re using Java 13 as the SDK for this tutorial, although we’re not using any of the Java 13 features (you can [download JDK 13.0.1](http://jdk.java.net/13/) here, then [define a new IntelliJ IDEA SDK](https://www.jetbrains.com/help/idea/sdk.html#define-sdk) for it). 在本教程我们使用 Java 13 作为 SDK，虽然我们并没有后使用任何 Java 13 特有的特性（你可以在这里下载 JDK 13.0.1，然后在IntelliJ IDEA定义一个新的SDK）
4. Enter the group name for the project, and call the artifact stock-ui. 为工程填入 groupId，和 artifact 名为 stock-ui
5. Keep the defaults of a Maven Project with Java and Jar packaging.  保持Maven 工程默认的 Java 和 jar打包选项。
6. We’ll select Java 11 as the Java version as this is the [most recent Long Term Support](https://blog.jetbrains.com/idea/2018/09/using-java-11-in-production-important-things-to-know/) version for Java, but for the purposes of this project it makes no difference. 我们选择 Java 11 作为 Java 版本，因为这是最近的长期支持版，但是对于本工程而已，这没有区别。
7. Enter a helpful description for the module, this is our third module so it helps us to keep clear in our mind what each module is responsible for. 为模块输入一个有用的描述，这是我们的第三个模块，这有助于我们清楚每个模块的作用。
8. We can optionally change the default package structure if we wish.  如有需要也可以改变默认的包结构
9. We don’t need to select any Spring Boot Starters for this module. 在这个模块，我们不需要选择任何 Spring Boot Starter
10. Keep the default module name and location. 保持默认的模块名和位置

IntelliJ IDEA downloads the created project from Spring Initializr and sets up the IDE correctly. If we’re given the option to “show run configurations in services”, we can select this. The [services window](https://www.jetbrains.com/help/idea/services-tool-window.html#Services_Tool_Window.xml) is a slightly nicer and more useful way to see our running services and can help us to manage microservice applications.

IntelliJ IDEA从 Spring Initializr 下载工程并将IDE设置好。如果有提示选择 "show run configuration in services" 我们可以选择它。 那个 services 窗口对于查看正在运行的服务和管理微服务应用比较有用。

### Spring Boot 应用程序类

As usual, Spring Boot generated a default application class for us. We will need to change this in order to launch a JavaFX application but for now we’ll just leave this as it is.

跟往常一样，Spring Boot 为我们生成默认的应用程序类。我们需要更改一下以便启动一个 JavaFX 应用程序，但现在我们先留着它这样子。

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



### 更新 Spring Boot 设置

Since this is a JavaFX application and not a web application, add this to the application.properties file of this module:

因为这是一个JavaFX应用程序，不是一个 Web 应用程序。所以在这个模块的application.properties里添加：

```java
spring.main.web-application-type=none
```



### 创建一个 JavaFX 应用程序类

1. Create a new Java class in the same package as the Spring application class and call it ChartApplication.在与Spring 应用程序类同一个包里创建一个新的Java 类，命名为 ChartApplicaion
2. (Tip: you can use Alt+Insert for Windows/Linux (⌘N on macOS) in the [project window](https://www.jetbrains.com/help/idea/project-tool-window.html#Project_Tool_Window.xml) to create a new file or directory). （提示：在 project 窗口，Windows/Linux用户可以使用 Alt+Insert（macOS用户是⌘N) 创建一个新文件或目录）
3. Have it extend [javafx.application.Application](https://openjfx.io/javadoc/13/javafx.graphics/javafx/application/Application.html). 让它继承于 javafx.application.Application

This is not currently on the classpath since we haven’t added JavaFX to our dependencies yet, so we need to add it to our pom.xml file.

这个类目前不在类路径上，因为我们还未添加 JavaFX到依赖里，所以我们需要将它添加到 pom.xml 文件。

1. (Tip: pressing Alt+Enter on the red Application text in the editor gives the option to “[Add Maven Dependency](https://www.jetbrains.com/help/idea/work-with-maven-dependencies.html#generate_maven_dependency)“.) （提示：在红色的 Application 文字上按下 Alt+Enter 会有"Add Maven Dependency"选项
2. Add [org.openjfx:javafx-graphics](https://mvnrepository.com/artifact/org.openjfx/javafx-graphics/13.0.1) as a dependency, version 13. 将 org.openjfx:javafx-graphics 添加为依赖，版本是 13

```xml
<dependency>
	<groupId>org.openjfx</groupId>
    <artifactId>javafx-graphics</artifactId>
    <version>13</version>
</dependency>
```

1. Now import [javafx.application.Application](https://openjfx.io/javadoc/13/javafx.graphics/javafx/application/Application.html) in ChartApplication. 现在可以在 ChartApplication 导入 javafx.application.Application
2. Application is an abstract class, so we need to override a method. Application 是一个抽象类，所以我们需要重写一个方法。
3. (Tip: we can get IntelliJ IDEA to implement these methods by pressing Alt+Enter on the red error, selecting [Implement methods](https://www.jetbrains.com/help/idea/implementing-methods-of-an-interface.html#Implementing_Methods_of_an_Interface.xml), and choosing the methods to implement.) （提示：在红色的错误上按下 Alt+Enter并选择"Implement methods"，选择要实现的方法，可以让InteliJ IDEA去帮我们实现这些方法。）
4. We only have one method we need to implement, [start](https://openjfx.io/javadoc/13/javafx.graphics/javafx/application/Application.html#start(javafx.stage.Stage)). 只有一个方法是必须实现的 start

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

Now we have a JavaFX application, we need to launch it from the Spring Boot application. 

现在我们有了一个 JavaFX 应用程序，我们需要从 Spring Boot 应用程序里面启动它

Instead of using SpringApplication to run the application, we’ll use the JavaFX Application class, and call launch with the class that is our JavaFX class, ChartApplication, and the application arguments.

不用 SpringApplication启动应用，我们将使用 JavaFX 的 Application 类，并以我们的 JavaFX 类作为参数调用launch方法。

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

The reason we need two separate application classes for our application is because of [JavaFX and Java Modules](http://mail.openjdk.java.net/pipermail/openjfx-dev/2018-June/021977.html), it’s beyond the scope of this tutorial to go into the details. If we want to use JavaFX and Spring together but aren’t going to use [Java Modules](https://www.oracle.com/corporate/features/understanding-java-9-modules.html) from Java 9, this is one way to get it to work.



### 通过应用程序上下文发布事件

Let’s go back to our JavaFX application class, ChartApplication.

1. Create a field applicationContext, this will be a [ConfigurableApplicationContext](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/ConfigurableApplicationContext.html).
2. Our start method, which is a standard JavaFX method, is called with a [Stage](https://openjfx.io/javadoc/13/javafx.graphics/javafx/stage/Stage.html) object when the stage is ready to be used. We can use the Spring pattern of [publishing events via the application context](https://www.baeldung.com/spring-events) to signal when this Stage is ready. Inside start(), call applicationContext.[publishEvent](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/ApplicationEventPublisher.html#publishEvent-org.springframework.context.ApplicationEvent-)() with a new StageReadyEvent.
3. Pass the stage into the event constructor.



```java
public class ChartApplication extends Application {
    private ConfigurableApplicationContext applicationContext;
 
    @Override
    public void start(Stage stage) {
        applicationContext.publishEvent(new StageReadyEvent(stage));
    }
}
```

Now we need to create our StageReadyEvent.

1. Create it as an inner class in ChartApplication for simplicity. It can always be refactored out at a later date.
2. (Tip: pressing Alt+Enter on the red StageReadyEvent offers the option to “Create inner class StageReadyEvent).
3. In the StageReadyEvent constructor, pass the stage parameter into the super constructor.
4. Make this inner class static and package visible, other classes will be listening for this event.

```java
static class StageReadyEvent extends ApplicationEvent {
    public StageReadyEvent(Stage stage) {
        super(stage);
    }
}
```



### 创建应用程序上下文

There are some other useful methods in Application that we can override and make use of.

1. Override the [init](https://openjfx.io/javadoc/13/javafx.graphics/javafx/application/Application.html#init())() method. This is where we need to initialise our application context.
2. (Tip: you can use Ctrl+O within a class to [select superclass methods to override](https://www.jetbrains.com/help/idea/overriding-methods-of-a-superclass.html#Overriding_Methods_of_a_Superclass.xml)).
3. Create a new [SpringApplicationBuilder](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/builder/SpringApplicationBuilder.html), and give it our Spring Boot application class, which is StockUiApplication.
4. Call [run](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/builder/SpringApplicationBuilder.html#run-java.lang.String...-)() to get the application context and assign it to the applicationContext field.

```java
@Override
public void init() {
    applicationContext = new SpringApplicationBuilder(StockUiApplication.class).run();
}
```



### 关闭应用程序上下文

Since we have an init() method, we should probably have some sort of tear down or cleanup too.

1. Override Application’s [stop](https://openjfx.io/javadoc/13/javafx.graphics/javafx/application/Application.html#stop()) method.
2. Inside stop(), call applicationContext.[close](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/ConfigurableApplicationContext.html#close--)().
3. Also call [Platform.exit()](https://openjfx.io/javadoc/13/javafx.graphics/javafx/application/Platform.html#exit()) to end the JavaFX program.

```java
@Override
public void stop() {
    applicationContext.close();
    Platform.exit();
}
```

Now we have our SpringBoot application class which launches our JavaFX Application class, ChartApplication:

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

We need something which is going to listen to the StageReadyEvent that we created.

1. Create a new class, StageInitializer. This will set up our JavaFX Stage when it’s ready.
2. This class should be annotated as a Spring [@Component](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/stereotype/Component.html).
3. This class needs to implement [ApplicationListener](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/ApplicationListener.html), listening for our StageReadyEvent.
4. We need to implement the method on this interface, [onApplicationEvent](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/ApplicationListener.html#onApplicationEvent-E-).
5. (Tip: IntelliJ IDEA can do this for us, press Alt+Enter on the red error and select “[Implement methods](https://www.jetbrains.com/help/idea/implementing-methods-of-an-interface.html#Implementing_Methods_of_an_Interface.xml)“).
6. The onApplicationEvent takes a StageReadyEvent. Call getStage on the event and assign the result to a [Stage](https://openjfx.io/javadoc/13/javafx.graphics/javafx/stage/Stage.html) local variable.

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

(note: this code will not compile yet)

This method doesn’t exist, so we need to create it on StageReadyEvent.

1. (Tip: we can get IntelliJ IDEA to create this for us by pressing Alt+Enter on the red getStage method name in StageInitializer and selecting “Create method getStage”).
2. The superclass has a method that does what we want, [getSource](https://docs.oracle.com/javase/8/docs/api/java/util/EventObject.html?is-external=true#getSource--). This returns an object, so call it and cast the returned value to a Stage.

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

We know the source is a Stage because when we passed our stage constructor parameter into the super constructor, this became the source.

### 最后步骤

The Stage is ready for us to set up our user interface. We can run our StockUIApplication, and see it successfully start up as a SpringBoot application. It does also launch a Java process which would show a UI if we had created one. For now, we have successfully created a JavaFX application which is launched and managed with Spring, and allows us to use the convenient features of any Spring application.

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























