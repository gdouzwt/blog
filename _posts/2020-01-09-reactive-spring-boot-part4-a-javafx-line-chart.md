---
typora-root-url: ../
layout:     post
title:      响应式Spring Boot系列教程4
date:       '2020-01-09T09:15'
subtitle:   JavaFX折线图
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

> Posted on November 18, 2019 by Trisha Gee
>
> 原文由 Trisha Gee 在当地时间2019年11月18日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-javafx-line-chart/)



In this step we see how to create a JavaFX application that shows a [line chart](https://docs.oracle.com/javase/8/javafx/user-interface-tutorial/line-chart.htm#CIHGBCFI). This application uses Spring for features like [inversion of control](https://en.wikipedia.org/wiki/Inversion_of_control).

This is the fourth part in our tutorial showing how to build a Reactive application using Spring Boot, Kotlin, Java and [JavaFX](https://openjfx.io/). The original inspiration was a [70 minute live demo.](https://blog.jetbrains.com/idea/2019/10/fully-reactive-spring-kotlin-and-javafx-playing-together/)

This blog post contains a video showing the process step-by-step and a textual walk-through (adapted from the transcript of the video) for those who prefer a written format.

<!--more-->

[This tutorial is a series of steps](https://blog.jetbrains.com/idea/tag/tutorial-reactive-spring/) during which we will build a full [Spring Boot](https://spring.io/projects/spring-boot) application featuring a [Kotlin](https://kotlinlang.org/) back end, a [Java](https://jdk.java.net/13/) client and a [JavaFX](https://openjfx.io/) user interface.

This step continues our integration of JavaFX and Spring, and at the end of it we’ll be able to show an empty [line chart](https://docs.oracle.com/javase/8/javafx/user-interface-tutorial/line-chart.htm#CIHGBCFI). We’ll populate it with data later in the tutorial.

### 创建一个 Scene

1. Open the stock-client project that we created back in [step 2](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-rest-client-for-reactive-streams), and go back to the [stock-ui](https://github.com/trishagee/s1p-stocks-ui/tree/master/ui) module that we created in [step 3](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-javafx-spring-boot-application).
2. Open StageInitializer, we’re going to update this to display the user interface for the application.
3. In onApplicationEvent, call stage.setScene() and give it a parent (currently undefined) and a width and height, 800 by 600.

```java
public void onApplicationEvent(StageReadyEvent event) {
    Stage stage = event.getStage();
    stage.setScene(new Scene(parent, 800, 600));
}
```

(note: this code will not compile yet)

1. Create parent as a local variable of type [Parent](https://openjfx.io/javadoc/13/javafx.graphics/javafx/scene/Parent.html).
2. (Tip: If you press Alt+Enter on the red parent text and choose “Create local variable” IntelliJ IDEA creates the variable and works out this needs to be of type Parent.)
3. Call stage.show() after initialising the stage.

```java
public void onApplicationEvent(StageReadyEvent event) {
    Parent parent;
    Stage stage = event.getStage();
    stage.setScene(new Scene(parent, 800, 600));
    stage.show();
}
```

Now we need to work out where this parent is going to come from.



### 使用 FXML

We’re going to use [FXML](https://docs.oracle.com/javase/8/javafx/api/javafx/fxml/doc-files/introduction_to_fxml.html) to define which elements are on the user interface. Declaring the view elements in FXML gives a nice clean separation between the view and the model and controller if we’re following an [MVC](https://en.wikipedia.org/wiki/Model–view–controller) pattern.

1. Declare an [FXMLLoader](https://openjfx.io/javadoc/13/javafx.fxml/javafx/fxml/FXMLLoader.html) local variable in the onApplicationEvent method.

```java
public void onApplicationEvent(StageReadyEvent event) {
    FXMLLoader fxmlLoader;
    Parent parent;
 
    // ...rest of the method
}
```

We haven’t declared a dependency on FXML classes yet, so let’s add a Maven dependency.

1. In our pom.xml file, we need to add a dependency on javafx-fxml.
2. (Tip: pressing Alt+Enter on the red FXMLLoader text in the editor gives the option to “[Add Maven Dependency](https://www.jetbrains.com/help/idea/work-with-maven-dependencies.html#generate_maven_dependency)“.)
3. Add [org.openjfx:javafx-fxml](https://mvnrepository.com/artifact/org.openjfx/javafx-fxml/13) as a dependency, version 13.

```xml
<dependency>
    <groupId>org.openjfx</groupId>
    <artifactId>javafx-fxml</artifactId>
    <version>13</version>
</dependency>
```

1. Now import the [FXMLLoader](https://openjfx.io/javadoc/13/javafx.fxml/javafx/fxml/FXMLLoader.html) class in StageInitializer.
2. (Tip: pressing Alt+Enter on the red FXMLLoader text in the editor gives the option to “[Import class](https://www.jetbrains.com/help/idea/creating-and-optimizing-imports.html#Creating_and_Optimizing_Imports.xml)“, or IntelliJ IDEA can do this without prompting [if auto-import is set up this way](https://www.jetbrains.com/help/idea/creating-and-optimizing-imports.html#automatically-add-import-statements).)
3. Create a chartResource field in the StageInitializer, it’s going to be a Spring [Resource](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/core/io/Resource.html).
4. We can use the [@Value](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/beans/factory/annotation/Value.html) annotation to tell Spring where to find the file, let’s say it’s on the classpath and it’s a file called chart.fxml.
5. In the FXMLLoader constructor, pass in chartResource.[getURL](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/core/io/Resource.html#getURL--)().
6. This getURL throws an Exception, so surround the call with a try/catch block. In the catch section we’ll throw a new RuntimeException for the purposes of keeping the tutorial simple, but this is not a useful way to deal with Exceptions in production code.
7. Now we can finally initialise our parent, by calling fxmlLoader.[load](https://openjfx.io/javadoc/13/javafx.fxml/javafx/fxml/FXMLLoader.html#load())().

```java
import javafx.fxml.FXMLLoader;
import javafx.scene.*;
import javafx.stage.Stage;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationListener;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;
import java.io.IOException;
 
@Component
public class StageInitializer implements ApplicationListener<StageReadyEvent> {
    @Value("classpath:/chart.fxml")
    private Resource chartResource;
 
    @Override
    public void onApplicationEvent(StageReadyEvent event) {
        try {
            FXMLLoader fxmlLoader = new FXMLLoader(chartResource.getURL());
            Parent parent = fxmlLoader.load();
 
            Stage stage = event.getStage();
            stage.setScene(new Scene(parent, 800, 600));
            stage.show();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
```



### 创建 FXML 文件

1. Go to the resources directory (src/main/resources) and create a new FXML file, chart.fxml.
2. (Tip: If you create a “new FXML file” using IntelliJ IDEA, you’ll get a basic FXML file created for you.)
3. The top level element should be a [VBox](https://openjfx.io/javadoc/13/javafx.graphics/javafx/scene/layout/VBox.html), if the file was created by IntelliJ IDEA we need to change it from AnchorPane to VBox.
4. Make sure the VBox has an [fx:controller](https://docs.oracle.com/javase/8/javafx/api/javafx/fxml/doc-files/introduction_to_fxml.html#controllers) property with a value of ChartController.
5. (Tip: IntelliJ IDEA has code generation even inside the FXML file, so we can create this missing controller class by pressing Alt+Enter on the red ChartController text and selecting “Create class”.)
6. Create the ChartController in the same package as all the other classes. Make sure the path to the controller in fx:controller contains the full package name.
7. We can use [Optimize Imports](https://www.jetbrains.com/help/idea/creating-and-optimizing-imports.html#optimize-imports) to remove all the unnecessary imports from the FXML file.



```xml
<?xml version="1.0" encoding="UTF-8"?>
 
<?import javafx.scene.layout.VBox?>
<VBox xmlns="http://javafx.com/javafx"
      xmlns:fx="http://javafx.com/fxml"
      fx:controller="ChartController">
 
</VBox>
```

Start this application, by going back to the SpringBootApplication class and [running it](https://www.jetbrains.com/help/idea/running-applications.html) using Ctrl+Shift+F10 for windows or Ctrl+Shift+R for macOS.

A Java window should pop up with the dimensions we set in the Stage. There’s nothing in there yet as we haven’t put anything into the view.

### 设置应用程序的标题

We’re going to make a small change to see that we can control what is displayed in the window.

1. Go back to StageInitializer, and add a line to set the title of the view to be applicationTitle.
2. Create a String field for applicationTitle.
3. (Tip: we can get IntelliJ IDEA to create a constructor with the appropriate parameters to initialise this field.)
4. Adding a constructor parameter to populate this field means we can use Spring to populate the value of this title.
5. Use the @Value annotation to set a default value for this parameter.

```java
public class StageInitializer implements ApplicationListener<StageReadyEvent> {
    @Value("classpath:/chart.fxml")
    private Resource chartResource;
    private String applicationTitle;
 
    public StageInitializer(@Value("Demo title") String applicationTitle) {
        this.applicationTitle = applicationTitle;
    }
 
    public void onApplicationEvent(StageReadyEvent event) {
        try {
            FXMLLoader fxmlLoader = new FXMLLoader(chartResource.getURL());
            Parent parent = fxmlLoader.load();
 
            Stage stage = event.getStage();
            stage.setScene(new Scene(parent, 800, 600));
            stage.setTitle(applicationTitle);
            stage.show();
        } catch (IOException e) {
            throw new RuntimeException();
        }
    }
}
```

When we re-run the application, we should see JavaFX uses this new title in the title bar



### 设置从 applicatio.properties 读取应用程序标题

Hard-coding string values is not good practice for a number of reasons, so let’s get this title from somewhere else.

1. In src/main/resources/[application.properties](https://docs.spring.io/spring-boot/docs/current/reference/html/appendix-application-properties.html), add a new property called spring.application.ui.title, and set a value for the title.

```properties
spring.application.ui.title=Stock Prices
```

1. In StageInitializer, we can use [SpEL](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#expressions) to say that we want to use this property for the title of our application. Change the @Value of application title to point to this property

```java
public StageInitializer(@Value("${spring.application.ui.title}") String applicationTitle) {
    this.applicationTitle = applicationTitle;
}
```

Now when we run the application (for example by [pressing Ctrl twice to Run Anything](https://www.jetbrains.com/help/idea/mastering-keyboard-shortcuts.html#d4d5314b)), we should see this value from application properties used as the title of the window.



### 从 Spring 获取 JavaFX 控制器

There’s one last thing we need to do to make the most of Spring in this JavaFX application, and that’s to be able to use the beans from the application context in the JavaFX wiring.

1. Call [setControllerFactory](https://openjfx.io/javadoc/13/javafx.fxml/javafx/fxml/FXMLLoader.html#setControllerFactory(javafx.util.Callback)) on our fxmlLoader. We need to give this a lambda expression that, given a class, returns an Object. This sounds like a job for the [Spring application context](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-basics).
2. Create an [ApplicationContext](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/ApplicationContext.html) field called applicationContext.
3. Add a new constructor parameter for this field so that is initialised.
4. (Tip: if you press Alt+Enter on a field that has not been initialised, IntelliJ IDEA will offer the option to add a constructor parameter.)
5. Now we can call getBean on applicationContext within the setControllerFactory lambda parameter to provide the controllers that JavaFX needs.

```java
// ...start of class happens above this line
    private ApplicationContext applicationContext;
 
    public StageInitializer(@Value("${spring.application.ui.title}") String applicationTitle, 
                            ApplicationContext applicationContext) {
        this.applicationTitle = applicationTitle;
        this.applicationContext = applicationContext;
    }
 
    @Override
    public void onApplicationEvent(StageReadyEvent event) {
        try {
            FXMLLoader fxmlLoader = new FXMLLoader(chartResource.getURL());
            fxmlLoader.setControllerFactory(aClass -> applicationContext.getBean(aClass));
// ...rest of the class
```



### 创建一个折线图

All our wiring is complete, so let’s finally create our line chart.

1. In chart.fxml, inside the VBox, we’ll declare we want a [LineChart](https://openjfx.io/javadoc/13/javafx.controls/javafx/scene/chart/LineChart.html).
2. We need to add, as a sub element, an xAxis.
3. Inside xAxis, add a [CategoryAxis](https://openjfx.io/javadoc/13/javafx.controls/javafx/scene/chart/CategoryAxis.html), this means the x-axis is going to have strings as values. This is our Time axis so add a label of “Time”.
4. At the same level as xAxis, add a yAxis.
5. Inside the yAxis, declare a [NumberAxis](https://openjfx.io/javadoc/13/javafx.controls/javafx/scene/chart/NumberAxis.html). This axis is for the stock price, so add a label of “Price”.
6. Set the height of the chart to 600 by setting the prefHeight property on LineChart to 600.
7. We need to give the LineChart an fx:id, which is the ID of the field in the ChartController that will contain the reference to this LineChart. Let’s call it “chart”.

```xml
<?xml version="1.0" encoding="UTF-8"?>
 
<?import javafx.scene.layout.VBox?>
<?import javafx.scene.chart.LineChart?>
<?import javafx.scene.chart.CategoryAxis?>
<?import javafx.scene.chart.NumberAxis?>
<VBox xmlns="http://javafx.com/javafx"
      xmlns:fx="http://javafx.com/fxml"
      fx:controller="com.mechanitis.demo.stockui.ChartController">
    <LineChart prefHeight="600" fx:id="chart">
        <xAxis>
            <CategoryAxis label="Time"/>
        </xAxis>
        <yAxis>
            <NumberAxis label="Price"/>
        </yAxis>
    </LineChart>
</VBox>
```

1. (Tip: IntelliJ IDEA can identify there’s no field called chart in the controller class. Press Alt+Enter on the “chart” value of fx:id and select “Create field ‘chart'”, and the IDE will generate the correct field on ChartController.)
2. ChartController should have a LineChart field called chart. We said the chart has a String x axis and a Number y axis, so we can declare this as a LineChart<String, Double>
3. We can add the [FXML](https://openjfx.io/javadoc/13/javafx.fxml/javafx/fxml/FXML.html) annotation to show this field is populated from an FXML file.
4. Make sure ChartController is annotated as a Spring [@Component](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/stereotype/Component.html).

```java
import javafx.fxml.FXML;
import javafx.scene.chart.LineChart;
import org.springframework.stereotype.Component;
 
@Component
public class ChartController {
 
    @FXML
    public LineChart<String, Double> chart;
}
```

Now when we run the application, we should see the outline of a line chart shown in our window, with numbers for our price y axis, and time on the x axis.

We have successfully created a JavaFX application that is integrated into Spring Boot, that uses FXML to declare what should be in the view. In the following videos of this tutorial, we’ll get this chart updating itself with stock prices in real time.

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























