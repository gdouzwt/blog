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
    - 教程
    - 翻译
---

> 原文由 Trisha Gee 在当地时间2019年11月29日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-displaying-reactive-data/)

In this lesson we look at connecting our JavaFX chart to our Kotlin Spring Boot service to display real time prices. 在这一节，我们看一下如何连接JavaFX折线图到Kotlin Spring Boot服务以实时显示股票价格数据。

In [step four](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-javafx-line-chart/), we created a JavaFX Spring Boot application that shows an empty line chart. In the last step ([step five](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-auto-configuration-for-shared-beans)), we wired in a [WebClientStockClient](https://github.com/trishagee/s1p-stocks-ui/blob/master/client/src/main/java/com/mechanitis/demo/client/WebClientStockClient.java) to connect to the prices service. In this step we’re going get the line chart to show the prices coming from our Kotlin Spring Boot service in real time.

在第四步，我们创建了一个JavaFX Spring Boot应用程序显示一个空的折线图。在上一步（第五步），我们整合了WebClientStockClient去连接到股票价格服务。在这一步我们要让折线图实时显示来自Kotlin Spring Boot服务的股票价格数据。

<!--more-->

### 设置好图表数据

1. In ChartController from the stock-ui module, create an `initialize` method, which is called once any FXML fields have been populated. This initialize method will set up where the chart data is going to come from. 在 stock-ui模块的ChartController，创建一个 initialize 方法，这个方法会在 FXML的字段被值填充完成后被调用。这个 initialize方法会设置好图表数据的来源。
2. Call [setData](https://openjfx.io/javadoc/11/javafx.controls/javafx/scene/chart/XYChart.html#setData(javafx.collections.ObservableList)) on the chart and create a local variable called data for the List of [Series](https://openjfx.io/javadoc/12/javafx.controls/javafx/scene/chart/XYChart.Series.html) that needs to be passed into this method. 在图表上调用 setData方法并创建一个局部变量 data 用于保存系列数据列表，用于传入到这个方法。
3. Create a [Series](https://openjfx.io/javadoc/12/javafx.controls/javafx/scene/chart/XYChart.Series.html) to add to the data list and pass in `seriesData`. 创建一个 Series 添加到data 列表，并传入到 seriesData
4. Create `seriesData` as a field which is an empty list, using [FXCollections.observableArrayList()](https://openjfx.io/javadoc/11/javafx.base/javafx/collections/FXCollections.html#observableArrayList()). 创建seriesData作为一个字段，即空列表，使用 FXCollections.observableArrayList()

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

We need to get the data for our chart from somewhere. This is what we added the webClientStockClient for. 我们需要为图表从某处获取数据。这就是我们为什么添加了 webClientStockClient

1. Inside the initialize method call `pricesFor` on `webClientStockClient` and pass in a symbol to get the prices for. For now, we can hard-code this value as “SYMBOL”. 在 initialize 方法内调用 webClientStockClient的pricesFor方法，并传入用于获取股票价格的代码。
2. We need to subscribe something to the [Flux](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html) that is returned from this call.  The simplest thing to do here is to call [subscribe](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html#subscribe-java.util.function.Consumer-) and pass in `this`. 我们需要将一些东西订阅到由这个调用返回的Flux。最简单的做法是调用subscribe并传入 this
3. Make the ChartController implement [java.util.function.Consumer](https://docs.oracle.com/javase/8/docs/api/java/util/function/Consumer.html), and have it consume StockPrice. 让 ChartController实现 java.util.function.Consumer 并让它消费 StockPrice
4. Implement the accept method from Consumer.  实现Consumer里边的 accept方法
5. (Tip: We can get IntelliJ IDEA to implement the methods required to fulfill this interface by pressing Alt+Enter on the red class declaration text and selecting “[Implement methods](https://www.jetbrains.com/help/idea/implementing-methods-of-an-interface.html)“.) （提示：我们可以通过在类声明上红色的字按下Alt+Enter并选择"implement methods"让IntelliJ IDEA 实现满足接口所需的方法。）

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

We need to decide what do with a StockPrice when we receive one. We need to add the right values from the stock price to the chart’s seriesData. 我们要决定当获取到 StockPrice的时候要做什么。我们从股票价格数据里面添加适当的值到图表的系列数据上。

1. Inside `accept`, call `seriesData.add` with a new instance of [Data](https://openjfx.io/javadoc/11/javafx.controls/javafx/scene/chart/XYChart.Data.html). 在 accept内，已新的 Data 实例调用seriesData.add
2. For the y value of Data, we can get the time from the stock price and get the value of “second”. This is an int, and needs to be a String, so wrap it in a [String.valueOf](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/lang/String.html#valueOf(int)) call. 对于Data的y值，我们可以从股票价格的时间获取，然后取其中的“秒”值。这是 int 类型，它需要转换为 String，因此放在一个 String.valueOf调用里。
3. (Tip: we can use the [postfix](https://www.jetbrains.com/help/idea/settings-postfix-completion.html) completion “arg” to automatically wrap an expression in a method call to simplify calling String.valueOf when we’ve already typed the expression) （提示：我们可以用后缀补全参数去将一个表达式包含在一个方法调用里以简化对String.valueOf的调用，当我们已经输入了表达式）
4. For the x value, we use the price value from stock price. 对于 x 值，我们使用来自股票价格的price值

```java
public void accept(StockPrice stockPrice) {
    seriesData.add(new XYChart.Data<>(String.valueOf(stockPrice.getTime().getSecond()),
                                      stockPrice.getPrice()));
}
```

This seems fine as it is, but there’s another thing to consider with this programming model. Changing the series data will be reflected by an update in the user interface, which will be drawn by the UI thread. This `accept` method is running on a different thread, listening to events from the back-end service. So we need to tell the UI thread to run this piece of code when it gets a chance.

这看起来不错，但是这个编程模型还有一样东西需要考虑。修改系列数据会反映在对用户界面的更新，会被UI线程绘制。这个 accept 方法是运行在不同的线程的，监听着来自后端服务的事件。我们要告知UI线程，当有机会时运行这段代码。

Call [Platform.runLater](https://openjfx.io/javadoc/12/javafx.graphics/javafx/application/Platform.html#runLater(java.lang.Runnable)), passing in a lambda expression of the code to run on the UI thread. 调用 Platform.runLater，并在UI线程传入一个 lambda 表达式。

```java
public void accept(StockPrice stockPrice) {
    Platform.runLater(() -> 
        seriesData.add(new XYChart.Data<>(String.valueOf(stockPrice.getTime().getSecond()),
                                          stockPrice.getPrice()))
    );
}
```



### 运行 chart 应用程序

1. Make sure the back-end Kotlin Spring Boot service (StockServiceApplication) is running.   确保后端的 Kotlin Spring Boot 服务正在运行（StockSeriviceApplication）
2. Go back to the UI module and run our JavaFX application, StockUiApplication. 回到UI模块并运行我们的JavaFX应用程序，StockUiApplication
3. You should see a JavaFX line chart that updates automatically from the prices (see [3:20 into the video](https://youtu.be/OMuqIykUh5w?t=201) for an example). 你应该能看到一个JavaFX折线图根据价格数据自动地更新。（见视频里 3:20的例子）

### 显示股票代码名称

1. Extract the hard-coded symbol into a local variable, we want to use it in more than one place. 将硬编码的股票代码提取到一个局部变量，我们想在不止一个地方用到它。
2. (Tip: we can use IntelliJ IDEA’s Extract Variable ([documentation](https://www.jetbrains.com/help/idea/extract-variable.html)) ([video overview](https://youtu.be/W_IiuORF16E)) to easily do this) （提示：我们可以使用 IntelliJ IDEA 的 Extract Variable([文档](https://www.jetbrains.com/help/idea/extract-variable.html)) ([视频](https://youtu.be/W_IiuORF16E)) 轻松完成此操作。）
3. We can give the series a label by passing the symbol in to the [Series](https://openjfx.io/javadoc/12/javafx.controls/javafx/scene/chart/XYChart.Series.html#(java.lang.String,javafx.collections.ObservableList)) constructor. 我们可以给系列一个标签，通过在Series的构造器传入股票代码作为参数。

```java
public void initialize() {
    String symbol = "SYMBOL";
    ObservableList<XYChart.Series<String, Double>> data = FXCollections.observableArrayList();
    data.add(new XYChart.Series<>(symbol, seriesData));
    chart.setData(data);
 
    webClientStockClient.pricesFor(symbol).subscribe(this);
}
```

Now when we re-run the application, we see the symbol’s name on the label for the series. 现在当我们重新运行应用程序，我们可以看到股票代码出现在系列的标签上。

### 代码清理

This code is a little bit unwieldy with all the type information, so let’s simplify. We can use Alt+Enter on many of the class names mentioned here to have IntelliJ IDEA suggest making this changes automatically.

这些代码太多类型信息有点笨拙，让我们简化一下。我们可以在这里提到的很多类的名称上按下 Alt+Enter去让IntelliJ IDEA建议自动执行这些更改。

1. Import [Series](https://openjfx.io/javadoc/12/javafx.controls/javafx/scene/chart/XYChart.Series.html) itself to remove the unnecessary [XYChart](https://openjfx.io/javadoc/12/javafx.controls/javafx/scene/chart/XYChart.html) prefix. 导入Series本身以移除不必要的 XYChart 前缀。
2. Add a static import for [observableArrayList](https://openjfx.io/javadoc/12/javafx.base/javafx/collections/FXCollections.html#observableArrayList(E...)), so we don’t need to repeat [FXCollections](https://openjfx.io/javadoc/12/javafx.base/javafx/collections/FXCollections.html) everywhere. 为 observableArrayList添加一个静态导入，这样我们就不用到处重复FXCollections
3. Add an import for [valueOf](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html#valueOf-int-), to make the line that sets the chart data a little shorter 添加一个valueOf导入，使得设置图表数据那行更简短一些。
4. Import the [Data](https://openjfx.io/javadoc/12/javafx.controls/javafx/scene/chart/XYChart.Data.html) class to remove another repetition of XYChart. 导入 Data 类以移除其它重复的 XYChart

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

This refactoring shouldn’t have changed the behaviour of the code, so when we re-run we’ll see everything working the same way as before.

这次重构并不会改变代码的行为，所以我们重新运行看到一切都跟之前一样可用。

### 总结

With these very few lines of code, we’ve created a JavaFX application that uses Spring’s WebClient to connect to a Spring Boot service, subscribes to the reactive stream of prices and draws the prices on a line chart in real time.

用这几行代码，我们创建了一个JavaFX应用程序使用了Spring 的WebClient去连接到 Spring Boot 服务，订阅到价格数据流并实时将股票价格数据绘制在折线图上。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























