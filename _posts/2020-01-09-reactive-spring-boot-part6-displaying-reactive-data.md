---
typora-root-url: ../
layout:     post
title:      响应式Spring Boot系列教程6
date:       '2020-01-09T09:38'
subtitle:   显示响应式数据
author:     招文桃
catalog:    true
tags:
    - JavaFX
    - Tutorial
    - Spring Boot
    - Reactive
---

> 原文由 Trisha Gee 在当地时间2019年11月29日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-displaying-reactive-data/)

在这一节，我们看一下如何连接JavaFX折线图到Kotlin Spring Boot服务以实时显示股票价格数据。

在第四步，我们创建了一个JavaFX Spring Boot应用程序显示一个空的折线图。在上一步（第五步），我们整合了WebClientStockClient去连接到股票价格服务。在这一步我们要让折线图实时显示来自Kotlin Spring Boot服务的股票价格数据。

<!--more-->

### 设置好图表数据

1. 在stock-ui模块的`ChartController`，创建一个`initialize`方法，这个方法会在FXML的字段被值填充完成后被调用。这个`initialize`方法会设置好图表数据的来源。
2. 在图表上调用`setData`方法并创建一个局部变量`data`用于保存系列数据列表，用于传入到这个方法。
3. 创建一个`Series`添加到data列表，并传入到`seriesData`。
4. 创建`seriesData`作为一个字段，即空列表，使用`FXCollections.observableArrayList()`。

```java
public class ChartController {
    @FXML
    private LineChart<String, Double> chart;
    private WebClientStockClient webClientStockClient;
    private ObservableList<Data<String, Double>> seriesData = FXCollections.observableArrayList();
 
    public ChartController(WebClientStockClient webClientStockClient) {
        this.webClientStockClient = webClientStockClient;
    }
 
    @FXML
    public void initialize() {
        ObservableList<XYChart.Series<String, Double>> data = FXCollections.observableArrayList();
        data.add(new XYChart.Series<>(seriesData));
        chart.setData(data);
    }
}
```

### 订阅到价格数据

我们需要为图表从某处获取数据。这就是我们为什么添加了`webClientStockClient`。

1. 在`initialize`方法内调用`webClientStockClient`的`pricesFor`方法，并传入用于获取股票价格的代号。现在我们可以暂时将这个值设为“SYMBOL”。
2. 我们需要将一些东西订阅到由这个调用返回的`Flux`。最简单的做法是调用`subscribe`并传入`this`。
3. 让`ChartController`实现`java.util.function.Consumer`并让它消费`StockPrice`。
4. 实现`Consumer`里边的`accept`方法。
5. （提示：我们可以通过在类声明上红色的字按下Alt+Enter并选择"implement methods"让IntelliJ IDEA 实现满足接口所需的方法）。

```java
public class ChartController implements Consumer<StockPrice> {
 
    // fields and constructor here...
 
    @FXML
    public void initialize() {
        ObservableList<XYChart.Series<String, Double>> data = FXCollections.observableArrayList();
        data.add(new XYChart.Series<>(seriesData));
        chart.setData(data);
 
        webClientStockClient.pricesFor("SYMBOL").subscribe(this);
    }
 
    @Override
    public void accept(StockPrice stockPrice) {
        
    }
}
```

### 显示价格数据

我们要决定当获取到`StockPrice`的时候要做什么。我们从股票价格数据里面添加适当的值到图表的系列数据上。

1. 在`accept`内，已新的Data实例调用`seriesData.add`。
2. 对于Data的y值，我们可以从股票价格的时间获取，然后取其中的“秒”值。这是`int`类型，它需要转换为 `String`，因此放在一个`String.valueOf`调用里。
3. （提示：我们可以用后缀补全参数去将一个表达式包含在一个方法调用里以简化对`String.valueOf`的调用，当我们已经输入了表达式）。
4. 对于x值，我们使用来自股票价格的`price`值。

```java
public void accept(StockPrice stockPrice) {
    seriesData.add(new XYChart.Data<>(String.valueOf(stockPrice.getTime().getSecond()),
                                      stockPrice.getPrice()));
}
```

这看起来不错，但是这个编程模型还有一样东西需要考虑。修改系列数据会反映在对用户界面的更新，会被UI线程绘制。这个`accept`方法是运行在不同的线程的，监听着来自后端服务的事件。我们要告知UI线程，当有机会时运行这段代码。

调用`Platform.runLater`，并在UI线程传入一个Lambda表达式。

```java
public void accept(StockPrice stockPrice) {
    Platform.runLater(() -> 
        seriesData.add(new XYChart.Data<>(String.valueOf(stockPrice.getTime().getSecond()),
                                          stockPrice.getPrice()))
    );
}
```



### 运行 chart 应用程序

1. 确保后端的Kotlin Spring Boot服务正在运行（`StockSeriviceApplication`）。
2. 回到UI模块并运行我们的JavaFX应用程序，`StockUiApplication`。
3. 你应该能看到一个JavaFX折线图根据价格数据自动地更新。（见视频里 3:20的例子）

### 显示股票代码名称

1. 将硬编码的股票代号提取到一个局部变量，我们想在不止一个地方用到它。
2. （提示：我们可以使用 IntelliJ IDEA 的 Extract Variable([文档](https://www.jetbrains.com/help/idea/extract-variable.html)) ([视频](https://youtu.be/W_IiuORF16E)) 轻松完成此操作。）
3. 我们可以给系列一个标签，通过在`Series`的构造器传入股票代码作为参数。

```java
public void initialize() {
    String symbol = "SYMBOL";
    ObservableList<XYChart.Series<String, Double>> data = FXCollections.observableArrayList();
    data.add(new XYChart.Series<>(symbol, seriesData));
    chart.setData(data);
 
    webClientStockClient.pricesFor(symbol).subscribe(this);
}
```

现在当我们重新运行应用程序，我们可以看到股票代码出现在系列的标签上。

### 代码清理

这些代码太多类型信息有点笨拙，让我们简化一下。我们可以在这里提到的很多类的名称上按下Alt+Enter去让IntelliJ IDEA建议自动执行这些更改。

1. 导入Series本身以移除不必要的XYChart前缀。
2. 为`observableArrayList`添加一个静态导入，这样我们就不用到处重复`FXCollections`。
3. 添加一个`valueOf`导入，使得设置图表数据那行更简短一些。
4. 导入`Data`类以移除其它重复的`XYChart`。

```java
@Component
public class ChartController implements Consumer<StockPrice> {
    @FXML
    private LineChart<String, Double> chart;
    private WebClientStockClient webClientStockClient;
    private ObservableList<Data<String, Double>> seriesData = observableArrayList();
 
    public ChartController(WebClientStockClient webClientStockClient) {
        this.webClientStockClient = webClientStockClient;
    }
 
    @FXML
    public void initialize() {
        String symbol = "SYMBOL";
        ObservableList<Series<String, Double>> data = observableArrayList();
        data.add(new Series<>(symbol, seriesData));
        chart.setData(data);
 
        webClientStockClient.pricesFor(symbol).subscribe(this);
    }
 
    @Override
    public void accept(StockPrice stockPrice) {
        Platform.runLater(() ->
            seriesData.add(new Data<>(valueOf(stockPrice.getTime().getSecond()),
                                      stockPrice.getPrice()))
        );
    }
}
```

这次重构并不会改变代码的行为，所以我们重新运行看到一切都跟之前一样可用。

### 总结

用这几行代码，我们创建了一个JavaFX应用程序使用了Spring 的WebClient去连接到 Spring Boot 服务，订阅到价格数据流并实时将股票价格数据绘制在折线图上。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)：https://github.com/zwt-io/rsb/