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

在这一步，我们会看一下如何创建个一JavaFX应用程序显示一个折线图。这个应用程序会用到Spring的特性，类如[控制反转](https://en.wikipedia.org/wiki/Inversion_of_control)。

<!--more-->

### 创建一个 Scene

1. 打开在第2步中创建的stock-client工程，回到在第3步创建的stock-ui模块。
2. 打开StageInitializer，我们要更新这个用于显示应用程序的用户界面。
3. 在`onApplicationEvent`方法里，调用`stage.setScene()`，并给它传入一个父级元素（当前未定义），并将宽与高分别设为800×600。

```java
public void onApplicationEvent(StageReadyEvent event) {
    Stage stage = event.getStage();
    stage.setScene(new Scene(parent, 800, 600));
}
```

（注意：这些代码目前未能通过编译）

1. 创建一个类型为`Parent`的局部变量`parent`。
2. （提示：如果你在红色的`parent`字上按下Alt+Enter并选择"Create local variable" IntelliJ IDEA 创建一个变量，并直到它需要是`Parent`类型）
3. 在`stage`初始化之后调用`stage.show()`。

```java
public void onApplicationEvent(StageReadyEvent event) {
    Parent parent;
    Stage stage = event.getStage();
    stage.setScene(new Scene(parent, 800, 600));
    stage.show();
}
```

现在我们要明确这个父级元素是来自哪里的。

### 使用 FXML

我们要使用FXML定义用户界面上需要哪些元素。在FXML上定义视图元素使得视图与模型以及控制器之间清晰地分离开（如果我们遵循MVC模式的话）。

1. 在`onApplicationEvent`方法中定义一个`FXMLLoader`类型的局部变量。

```java
public void onApplicationEvent(StageReadyEvent event) {
    FXMLLoader fxmlLoader;
    Parent parent;
 
    // ...其它方法
}
```

我们尚未定义FXML相关类的依赖，然我们添加一个Maven依赖。

1. 在我们的pom.xml文件，我们要添加一个`javafx-fxml`依赖。
2. （提示：在编辑器里边红色的FXMLLoader红色字按下Alt+Enter会给我们一个"Add Maven Dependency"选项）。
3. 添加`org.openjfx:javafx-fxml`依赖，版本为13。

```xml
<dependency>
    <groupId>org.openjfx</groupId>
    <artifactId>javafx-fxml</artifactId>
    <version>13</version>
</dependency>
```

1. 现在在StageInitializer里面导入FXMLLoader类。
2. （提示：在编辑器的红色FXMLLoder文字上按下Alt+Enter 会有 "Import class"选项，或者IntelliJ IDEA可以不加提示地完成这操作如果设置了自动导入的方式）。
3. 在StageInitializer中创建一个`chartResource`字段，它的类型将会是Spring的Resource。
4. 我们可以使用`@Value`注解去告诉Spring在哪里找到文件，让我们说它在类路径上并且是一个名为chart.fxml的文件。
5. 在`FXMLLoader`的构造函数里，传入`chartResource.getURL()`。
6. 这个`getURL`会抛出异常，所以让我们用try/catch块围起来。简单起见，在catch部分我们将会抛出一个新的 `RuntimeException`，但是生成环境这种处理异常的方式没什么用。
7. 最后我们现在可以初始化我们的父级元素了，通过调用`fxmlLoader.load()`方法。

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

1. 去到resource目录(src/main/resources)并创建一个新的FXML文件。
2. （提示：如果你使用 IntelliJ IDEA创建一个 "new FXML file" 你会得到一个基础的FXML文件）。
3. 顶层元素应该是一个`VBox`，如果文件是由IntelliJ IDEA创建的，我们需要将它由`AnchorPane`改为`VBox`
4. 确保`VBox`有一个`fx:controller`属性，其值为`ChartController`。
5. （提示：IntelliJ IDEA即使在FXML文件内也可以代码生成，所以我们可以在`ChartController`文字的末尾按下Alt+Enter并选择”Create class"）。
6. （在与其它类相同的包里创建一个`ChartController`类。确保`fx:controller`指向的路径包含了完整的报名）。
7. 我们可以使用Optimize Imports去移除FXML文件内不必要的导入。

```xml
<?xml version="1.0" encoding="UTF-8"?>
 
<?import javafx.scene.layout.VBox?>
<VBox xmlns="http://javafx.com/javafx"
      xmlns:fx="http://javafx.com/fxml"
      fx:controller="ChartController">
 
</VBox>
```

回到SpringBootApplication类使用Ctrl+Shift+F10（Windows）或Ctrl+Shift+R（macOS）运行这个应用程序。

一个Java窗口应该会弹出来，宽高是我们在`Stage`设置的那样。这里还没有什么，因为我们还未放东西上去。

### 设置应用程序的标题

我们要做一些小改动，看我们是否能够控制在窗口显示的内容。

1. 回到`StageInitialzer`，并添加一行去将视图的标题设为`applicationTitle`。
2. 为`applicationTitle`创建一个`String`类型的字段。
3. （提示：我们可以让IntelliJ IDEA创建一个构造函数以适当的参数去初始化这个字段）。
4. 添加一个构造函数参数以填充这个字段意味着我们可以使用Spring去填充这个标题的值。
5. 我们使用`@Value`注解为这个参数设置默认的值。

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

当我们重新运行应用程序的时候，我们应该看到JavaFX在标题栏中使用这个新的标题。

### 设置从applicatio.properties读取应用程序标题

硬编码字符串怎么说都是不好的，所以让我们从其它地方获取这个标题的值。

1. 在 src/main/resources/application.properties，添加一个新的属性值`spring.application.ui.title`并设置一个值用于标题文字。

```properties
spring.application.ui.title=Stock Prices
```

1. 在`StageInitializer`，我们可以使用SpEL去表面我们想使用这个属性值作为我们的应用程序的标题。将应用程序标题的`@Value`改为指向这个属性。

```java
public StageInitializer(@Value("${spring.application.ui.title}") String applicationTitle) {
    this.applicationTitle = applicationTitle;
}
```

现在当我们运行这个应用程序（例如通过按两下Ctrl运行任何东西），我们应该能看到窗口标题使用了从这个应用程序属性获得的值。

### 从 Spring 获取 JavaFX 控制器

为充分利用Spring的特性，我们还有最后一件事需要做，这就是让 JavaFX从Spring的应用程序上下文中获取 Beans。

1. 在我们的`fxmlLoader`上调用`setControllerFactory`。我们需要给它一个Lambda expression说明，给定一个类，返回一个对象。
2. 创建一个类型为`ApplicationContext`的字段`applicationContext`。
3. 为这个添加新的构造函数参数，以便将其初始化。
4. （提示：如果你在尚未初始化的一个字段上按下Alt+Enter，IntelliJ IDEA会提供选项让你为构造函数添加参数）。
5. 现在我们可以在`setControllerFactory` Lambda 表达式的参数中`applicationContext`调用`getBean`方法为JavaFX提供所需的控制器）。

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

现在我们整合好了，最后让我们创建折线图。

1. 在chart.fxml里面，在`VBox`内，我们想要一个`LineChart`。
2. 我们需要添加一个子元素，一个`xAxis`x轴。
3. 在`xAixs`内，添加一个`CategoryAxis`这意味着x轴会有字符串类型的值。这是我们的时间轴，所以给它一个 "Time"标签。
4. 在与`xAixs`同一级，添加一个`yAxis`。
5. 在`yAxis`内，声明一个`NumberAxis`。 这个轴是用于股票价格，所以为它添加一个 "Price"标签。
6. 通过将`LineChart`的`prefHeight`属性设为600，设置了图表的高度为600。
7. 我们需要给这个`LineChart`一个`fx:id`，这就是`ChartController`里面的字段`ID`，会包含对这个`LineChart` 的一个引用，让我们将它命名为 "chart"。

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

1. （提示：IntelliJ IDEA 可以识别到在控制器类里面没有`chart`字段。在`fx:id`的值 “chart"上按下Alt+Enter并选择 "Create field 'chart'"，然后IDE会在`ChartController`内生成正确的字段）。
2. `ChartController`应该有一个类型为`LineChart`的字段称为chart。我们说这个图表有一个String类型的x轴和一个`Number`类型的y轴，所以我们可以将它定义为`LineChart<String, Double>`。
3. 我们为它添加一个`@FXML`注解，表示这个字段由FXML填充。
4. 确保`ChartController`被注解为Spring的`@Component`。

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

现在当我们运行应用程序，我们应该窗口中显示一个折线图的轮廓，带有显示数值的价格y轴，和显示时间的x轴。

我们已经成功的创建了一个集成到Spring Boot的JavaFX应用程序，它可以用FXML定义视图呈现什么内容。在接下来的教程，我们会让这个图实时更新股票价格数据。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)：https://github.com/zwt-io/rsb/