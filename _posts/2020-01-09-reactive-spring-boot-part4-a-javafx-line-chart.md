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

> 原文由 Trisha Gee 在当地时间2019年11月18日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-javafx-line-chart/)

In this step we see how to create a JavaFX application that shows a [line chart](https://docs.oracle.com/javase/8/javafx/user-interface-tutorial/line-chart.htm#CIHGBCFI). This application uses Spring for features like [inversion of control](https://en.wikipedia.org/wiki/Inversion_of_control).

在这一步，我们会看一下如何创建个一JavaFX应用程序显示一个折线图。这个应用程序会用到 Spring 的特性，类如[控制反转](https://en.wikipedia.org/wiki/Inversion_of_control)



<!--more-->

### 创建一个 Scene

1. Open the stock-client project that we created back in [step 2](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-rest-client-for-reactive-streams), and go back to the [stock-ui](https://github.com/trishagee/s1p-stocks-ui/tree/master/ui) module that we created in [step 3](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-javafx-spring-boot-application). 打开在第2步中创建的 stock-client工程，回到在第3步创建的 stock-ui 模块
2. Open StageInitializer, we’re going to update this to display the user interface for the application. 打开StageInitializer，我们要更新这个用于显示应用程序的用户界面。
3. In onApplicationEvent, call stage.setScene() and give it a parent (currently undefined) and a width and height, 800 by 600. 在onApplicationEvent方法里，调用stage.setScene()，并给它传入一个父级元素（当前未定义），并将宽与高分别设为 800乘以600

```java
public void onApplicationEvent(StageReadyEvent event) {
    Stage stage = event.getStage();
    stage.setScene(new Scene(parent, 800, 600));
}
```

(note: this code will not compile yet)

（注意：这些代码目前未能通过编译）

1. Create parent as a local variable of type [Parent](https://openjfx.io/javadoc/13/javafx.graphics/javafx/scene/Parent.html). 创建一个类型为Parent的局部变量parent
2. (Tip: If you press Alt+Enter on the red parent text and choose “Create local variable” IntelliJ IDEA creates the variable and works out this needs to be of type Parent.) （提示：如果你在红色的parent字上按下Alt+Enter并选择"Create local variable" IntelliJ IDEA 创建一个变量，并直到它需要是 Parent类型）
3. Call stage.show() after initialising the stage. 在 stage 初始化之后调用 stage.show()

```java
public void onApplicationEvent(StageReadyEvent event) {
    Parent parent;
    Stage stage = event.getStage();
    stage.setScene(new Scene(parent, 800, 600));
    stage.show();
}
```

Now we need to work out where this parent is going to come from.

现在我们要明确这个父级元素是来自哪里的



### 使用 FXML

We’re going to use [FXML](https://docs.oracle.com/javase/8/javafx/api/javafx/fxml/doc-files/introduction_to_fxml.html) to define which elements are on the user interface. Declaring the view elements in FXML gives a nice clean separation between the view and the model and controller if we’re following an [MVC](https://en.wikipedia.org/wiki/Model–view–controller) pattern.

我们要使用 FXML 定义用户界面上需要哪些元素。在 FXML 上定义视图元素使得视图与模型以及控制器之间清晰地分离开（如果我们遵循 MVC模式的话）

1. Declare an [FXMLLoader](https://openjfx.io/javadoc/13/javafx.fxml/javafx/fxml/FXMLLoader.html) local variable in the onApplicationEvent method. 在 onApplicationEvent方法中定义一个 FXMLLoader 局部变量。

```java
public void onApplicationEvent(StageReadyEvent event) {
    FXMLLoader fxmlLoader;
    Parent parent;
 
    // ...其它方法
}
```

We haven’t declared a dependency on FXML classes yet, so let’s add a Maven dependency.

我们尚未定义 FXML 相关类的依赖，然我们添加一个 Maven 依赖。

1. In our pom.xml file, we need to add a dependency on javafx-fxml. 在我们的 pom.xml 文件，我们要添加一个 javafx-fxml 依赖。
2. (Tip: pressing Alt+Enter on the red FXMLLoader text in the editor gives the option to “[Add Maven Dependency](https://www.jetbrains.com/help/idea/work-with-maven-dependencies.html#generate_maven_dependency)“.) （提示：在编辑器里边红色的 FXMLLoader 红色字按下 Alt+Enter 会给我们一个"Add Maven Dependency"选项）
3. Add [org.openjfx:javafx-fxml](https://mvnrepository.com/artifact/org.openjfx/javafx-fxml/13) as a dependency, version 13.  添加 org.openjfx:javafx-fxml 依赖，版本为13

```xml
<dependency>
    <groupId>org.openjfx</groupId>
    <artifactId>javafx-fxml</artifactId>
    <version>13</version>
</dependency>
```

1. Now import the [FXMLLoader](https://openjfx.io/javadoc/13/javafx.fxml/javafx/fxml/FXMLLoader.html) class in StageInitializer. 现在在 StageInitializer 里面导入 FXMLLoader 类
2. (Tip: pressing Alt+Enter on the red FXMLLoader text in the editor gives the option to “[Import class](https://www.jetbrains.com/help/idea/creating-and-optimizing-imports.html#Creating_and_Optimizing_Imports.xml)“, or IntelliJ IDEA can do this without prompting [if auto-import is set up this way](https://www.jetbrains.com/help/idea/creating-and-optimizing-imports.html#automatically-add-import-statements).) （提示：在编辑器的红色 FXMLLoder 文字上按下Alt+Enter 会有 "Import class"选项，或者IntelliJ IDEA可以不加提示地完成这操作如果设置了自动导入的方式）
3. Create a chartResource field in the StageInitializer, it’s going to be a Spring [Resource](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/core/io/Resource.html). 在 StageInitializer 中创建一个 chartResource字段，它的类型将会是 Spring Resource
4. We can use the [@Value](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/beans/factory/annotation/Value.html) annotation to tell Spring where to find the file, let’s say it’s on the classpath and it’s a file called chart.fxml. 我们可以使用@Value注解去告诉Spring 在哪里找到文件，让我们说它在类路径上并且是一个名为chart.fxml的文件。
5. In the FXMLLoader constructor, pass in chartResource.[getURL](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/core/io/Resource.html#getURL--)().  在 FXMLLoader的构造函数里，传入 chartResource.getURL()
6. This getURL throws an Exception, so surround the call with a try/catch block. In the catch section we’ll throw a new RuntimeException for the purposes of keeping the tutorial simple, but this is not a useful way to deal with Exceptions in production code. 这个getURL会抛出异常，所以让我们用 try/catch 块围起来。简单起见，在 catch 部分我们将会抛出一个新的 RuntimeException，但是生成环境这种处理异常的方式没什么用。
7. Now we can finally initialise our parent, by calling fxmlLoader.[load](https://openjfx.io/javadoc/13/javafx.fxml/javafx/fxml/FXMLLoader.html#load())(). 最后我们现在可以初始化我们的父级元素了，通过调用 fxmlLoader.load()方法

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

1. Go to the resources directory (src/main/resources) and create a new FXML file, chart.fxml. 去到 resource 目录(src/main/resources)并创建一个x新的 FXML 文件。
2. (Tip: If you create a “new FXML file” using IntelliJ IDEA, you’ll get a basic FXML file created for you.) （提示：如果你使用 IntelliJ IDEA创建一个 "new FXML file" 你会得到一个基础的 FXML 文件。）
3. The top level element should be a [VBox](https://openjfx.io/javadoc/13/javafx.graphics/javafx/scene/layout/VBox.html), if the file was created by IntelliJ IDEA we need to change it from AnchorPane to VBox. 顶层元素应该是一个 VBox，如果文件是由 IntelliJ IDEA创建的，我们需要将它由AnchorPane 改为 VBox
4. Make sure the VBox has an [fx:controller](https://docs.oracle.com/javase/8/javafx/api/javafx/fxml/doc-files/introduction_to_fxml.html#controllers) property with a value of ChartController. 确保 VBox 有一个 fx:controller 属性，其值为 ChartController
5. (Tip: IntelliJ IDEA has code generation even inside the FXML file, so we can create this missing controller class by pressing Alt+Enter on the red ChartController text and selecting “Create class”.)（提示：IntelliJ IDEA即使在 FXML 文件内也可以代码生成，所以我们可以在 ChartController文字的末尾按下Alt+Enter并选择”Create class"。）
6. Create the ChartController in the same package as all the other classes. Make sure the path to the controller in fx:controller contains the full package name. （在与其它类相同的包里创建一个 ChartController 类。确保 fx:controller 指向的路径包含了完整的报名）
7. We can use [Optimize Imports](https://www.jetbrains.com/help/idea/creating-and-optimizing-imports.html#optimize-imports) to remove all the unnecessary imports from the FXML file. 我们可以使用 Optimize Imports 去移除FXML文件内不必要的导入。



```xml
<?xml version="1.0" encoding="UTF-8"?>
 
<?import javafx.scene.layout.VBox?>
<VBox xmlns="http://javafx.com/javafx"
      xmlns:fx="http://javafx.com/fxml"
      fx:controller="ChartController">
 
</VBox>
```

Start this application, by going back to the SpringBootApplication class and [running it](https://www.jetbrains.com/help/idea/running-applications.html) using Ctrl+Shift+F10 for windows or Ctrl+Shift+R for macOS. 回到 SpringBootApplication类使用 Ctrl+Shift+F10（Windows）或Ctrl+Shift+R（macOS）运行这个应用程序。

A Java window should pop up with the dimensions we set in the Stage. There’s nothing in there yet as we haven’t put anything into the view.

一个Java窗口应该会弹出来，宽高是我们在 Stage 设置的那样。这里还没有什么，因为我们还未放东西上去。

### 设置应用程序的标题

We’re going to make a small change to see that we can control what is displayed in the window.  

我们要做一些小改动，看我们是否能够控制在窗口显示的内容。

1. Go back to StageInitializer, and add a line to set the title of the view to be applicationTitle. 回到 StageInitialzer，并添加一行去将视图的标题设为 applicationTitle
2. Create a String field for applicationTitle. 为applicationTitle创建一个String类型的字段
3. (Tip: we can get IntelliJ IDEA to create a constructor with the appropriate parameters to initialise this field.)（提示：我们可以让IntelliJ IDEA创建一个构造函数以适当的参数去初始化这个字段。）
4. Adding a constructor parameter to populate this field means we can use Spring to populate the value of this title.添加一个构造函数参数以填充这个字段意味着我们可以使用Spring去填充这个标题的值。
5. Use the @Value annotation to set a default value for this parameter. 我们使用@Value 注解为这个参数设置默认的值。

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

当我们重新运行应用程序的时候，我们应该看到 JavaFX在标题栏中使用这个新的标题。



### 设置从 applicatio.properties 读取应用程序标题

Hard-coding string values is not good practice for a number of reasons, so let’s get this title from somewhere else.

硬编码字符串怎么说都是不好的，所以让我们从其它地方获取这个标题的值。

1. In src/main/resources/[application.properties](https://docs.spring.io/spring-boot/docs/current/reference/html/appendix-application-properties.html), add a new property called spring.application.ui.title, and set a value for the title. 在 src/main/resources/application.properties，添加一个新的属性值 spring.application.ui.title 并设置一个值用于标题文字。

```properties
spring.application.ui.title=Stock Prices
```

1. In StageInitializer, we can use [SpEL](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#expressions) to say that we want to use this property for the title of our application. Change the @Value of application title to point to this property 在StageInitializer，我们可以使用 SpEL 去表面我们想使用这个属性值作为我们的应用程序的标题。将应用程序标题的 @Value 改为指向这个属性。

```java
public StageInitializer(@Value("${spring.application.ui.title}") String applicationTitle) {
    this.applicationTitle = applicationTitle;
}
```

Now when we run the application (for example by [pressing Ctrl twice to Run Anything](https://www.jetbrains.com/help/idea/mastering-keyboard-shortcuts.html#d4d5314b)), we should see this value from application properties used as the title of the window.

现在当我们运行这个应用程序（例如通过按两下 Ctrl 运行任何东西），我们应该能看到窗口标题使用了从这个应用程序属性获得的值。



### 从 Spring 获取 JavaFX 控制器

There’s one last thing we need to do to make the most of Spring in this JavaFX application, and that’s to be able to use the beans from the application context in the JavaFX wiring.

为充分利用Spring的特性，我们还有最后一件事需要做，这就是让 JavaFX从 Spring 的应用程序上下文中获取 Beans

1. Call [setControllerFactory](https://openjfx.io/javadoc/13/javafx.fxml/javafx/fxml/FXMLLoader.html#setControllerFactory(javafx.util.Callback)) on our fxmlLoader. We need to give this a lambda expression that, given a class, returns an Object. This sounds like a job for the [Spring application context](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#beans-basics). 在我们的fxmlLoader上调用 setControllerFactory。我们需要给它一个 lambda expression说明，给定一个类，返回一个对象。
2. Create an [ApplicationContext](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/context/ApplicationContext.html) field called applicationContext. 创建一个类型为 ApplicationContext的字段 applicationContext
3. Add a new constructor parameter for this field so that is initialised. 为这个添加新的构造函数参数，以便将其初始化。
4. (Tip: if you press Alt+Enter on a field that has not been initialised, IntelliJ IDEA will offer the option to add a constructor parameter.) （提示：如果你在尚未初始化的一个字段上按下Alt+Enter，IntelliJ IDEA会提供选项让你为构造函数添加参数）
5. Now we can call getBean on applicationContext within the setControllerFactory lambda parameter to provide the controllers that JavaFX needs. 现在我们可以在setControllerFactory lambda 表达式的参数中 applicationContext调用 getBean方法为 JavaFX提供所需的控制器）

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

现在我们整合好了，最后让我们创建折线图

1. In chart.fxml, inside the VBox, we’ll declare we want a [LineChart](https://openjfx.io/javadoc/13/javafx.controls/javafx/scene/chart/LineChart.html). 在chart.fxml里面，在VBox内，我们想要一个 LineChart
2. We need to add, as a sub element, an xAxis. 我们需要添加一个子元素，一个 xAxis x轴
3. Inside xAxis, add a [CategoryAxis](https://openjfx.io/javadoc/13/javafx.controls/javafx/scene/chart/CategoryAxis.html), this means the x-axis is going to have strings as values. This is our Time axis so add a label of “Time”. 在 xAixs 内，添加一个 CategoryAxis 这意味着 x轴会有字符串类型的值。这是我们的时间轴，所以给它一个 "Time"标签
4. At the same level as xAxis, add a yAxis. 在与 xAixs 同一级，添加一个 yAxis
5. Inside the yAxis, declare a [NumberAxis](https://openjfx.io/javadoc/13/javafx.controls/javafx/scene/chart/NumberAxis.html). This axis is for the stock price, so add a label of “Price”. 在 yAxis 内，声明一个 NumberAxis。 这个轴是用于股票价格，所以为它添加一个 "Price"标签。
6. Set the height of the chart to 600 by setting the prefHeight property on LineChart to 600. 通过将 LineChart 的 prefHeight 属性设为 600，设置了图表的高度为 600
7. We need to give the LineChart an fx:id, which is the ID of the field in the ChartController that will contain the reference to this LineChart. Let’s call it “chart”. 我们需要给这个 LineChart一个 fx:id，这就是 ChartController 里面的字段 ID，会包含对这个LineChart 的一个引用，让我们将它命名为 "chart"

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

1. (Tip: IntelliJ IDEA can identify there’s no field called chart in the controller class. Press Alt+Enter on the “chart” value of fx:id and select “Create field ‘chart'”, and the IDE will generate the correct field on ChartController.) （提示：IntelliJ IDEA 可以识别到在控制器类里面没有chart 字段。在 fx:id 的值 “chart"上按下 Alt+Enter 并选择 "Create field 'chart'"，然后 IDE 会在 ChartController 内生成正确的字段。）
2. ChartController should have a LineChart field called chart. We said the chart has a String x axis and a Number y axis, so we can declare this as a LineChart<String, Double> ChartController 应该有一个类型为 LineChart 的字段称为 chart。我们说这个图表有一个 String 类型的 x轴和一个 Number类型的y轴，所以我们可以将它定义为 LineChart<String, Double>
3. We can add the [FXML](https://openjfx.io/javadoc/13/javafx.fxml/javafx/fxml/FXML.html) annotation to show this field is populated from an FXML file. 我们为它添加一个 @FXML注解，表示这个字段由 FXML 填充。
4. Make sure ChartController is annotated as a Spring [@Component](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/stereotype/Component.html). 确保 ChartController 被注解为 Spring @Component

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

现在当我们运行应用程序，我们应该窗口中显示一个折线图的轮廓，带有显示数值的价格 y轴，和显示时间的 x轴

We have successfully created a JavaFX application that is integrated into Spring Boot, that uses FXML to declare what should be in the view. In the following videos of this tutorial, we’ll get this chart updating itself with stock prices in real time.

我们已经成功的创建了一个集成到Spring Boot的 JavaFX应用程序，它可以用 FXML定义视图呈现什么内容。在接下来的教程，我们会让这个图实时更新股票价格数据。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























