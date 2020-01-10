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



In this lesson we look at connecting our JavaFX chart to our Kotlin Spring Boot service to display real time prices.

This is the sixth part of our tutorial showing how to build a Reactive application using [Spring Boot](https://spring.io/projects/spring-boot), [Kotlin](https://kotlinlang.org/), Java and [JavaFX](https://openjfx.io/). The original inspiration was a [70 minute live demo.](https://blog.jetbrains.com/idea/2019/10/fully-reactive-spring-kotlin-and-javafx-playing-together/)

This blog post contains a video showing the process step-by-step and a textual walk-through (adapted from the transcript of the video) for those who prefer a written format.

<!--more-->

[This tutorial is a series of steps](https://blog.jetbrains.com/idea/tag/tutorial-reactive-spring/) during which we will build a full [Spring Boot](https://spring.io/projects/spring-boot) application featuring a [Kotlin](https://kotlinlang.org/) back end, a [Java](https://jdk.java.net/13/) client and a [JavaFX](https://openjfx.io/) user interface.

In [step four](https://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-a-javafx-line-chart/), we created a JavaFX Spring Boot application that shows an empty line chart. In the last step ([step five](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-auto-configuration-for-shared-beans)), we wired in a [WebClientStockClient](https://github.com/trishagee/s1p-stocks-ui/blob/master/client/src/main/java/com/mechanitis/demo/client/WebClientStockClient.java) to connect to the prices service. In this step we’re going get the line chart to show the prices coming from our Kotlin Spring Boot service in real time.

### 设置好图表数据

1. In ChartController from the stock-ui module, create an `initialize` method, which is called once any FXML fields have been populated. This initialize method will set up where the chart data is going to come from.
2. Call [setData](https://openjfx.io/javadoc/11/javafx.controls/javafx/scene/chart/XYChart.html#setData(javafx.collections.ObservableList)) on the chart and create a local variable called data for the List of [Series](https://openjfx.io/javadoc/12/javafx.controls/javafx/scene/chart/XYChart.Series.html) that needs to be passed into this method.
3. Create a [Series](https://openjfx.io/javadoc/12/javafx.controls/javafx/scene/chart/XYChart.Series.html) to add to the data list and pass in `seriesData`.
4. Create `seriesData` as a field which is an empty list, using [FXCollections.observableArrayList()](https://openjfx.io/javadoc/11/javafx.base/javafx/collections/FXCollections.html#observableArrayList()).

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

We need to get the data for our chart from somewhere. This is what we added the webClientStockClient for.

1. Inside the initialize method call `pricesFor` on `webClientStockClient` and pass in a symbol to get the prices for. For now, we can hard-code this value as “SYMBOL”.
2. We need to subscribe something to the [Flux](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html) that is returned from this call.  The simplest thing to do here is to call [subscribe](https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html#subscribe-java.util.function.Consumer-) and pass in `this`.
3. Make the ChartController implement [java.util.function.Consumer](https://docs.oracle.com/javase/8/docs/api/java/util/function/Consumer.html), and have it consume StockPrice.
4. Implement the accept method from Consumer.
5. (Tip: We can get IntelliJ IDEA to implement the methods required to fulfill this interface by pressing Alt+Enter on the red class declaration text and selecting “[Implement methods](https://www.jetbrains.com/help/idea/implementing-methods-of-an-interface.html)“.)

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

We need to decide what do with a StockPrice when we receive one. We need to add the right values from the stock price to the chart’s seriesData.

1. Inside `accept`, call `seriesData.add` with a new instance of [Data](https://openjfx.io/javadoc/11/javafx.controls/javafx/scene/chart/XYChart.Data.html).
2. For the y value of Data, we can get the time from the stock price and get the value of “second”. This is an int, and needs to be a String, so wrap it in a [String.valueOf](https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/lang/String.html#valueOf(int)) call.
3. (Tip: we can use the [postfix](https://www.jetbrains.com/help/idea/settings-postfix-completion.html) completion “arg” to automatically wrap an expression in a method call to simplify calling String.valueOf when we’ve already typed the expression)
4. For the x value, we use the price value from stock price.

```java
public void accept(StockPrice stockPrice) {
    seriesData.add(new XYChart.Data<>(String.valueOf(stockPrice.getTime().getSecond()),
                                      stockPrice.getPrice()));
}
```

This seems fine as it is, but there’s another thing to consider with this programming model. Changing the series data will be reflected by an update in the user interface, which will be drawn by the UI thread. This `accept` method is running on a different thread, listening to events from the back-end service. So we need to tell the UI thread to run this piece of code when it gets a chance.

Call [Platform.runLater](https://openjfx.io/javadoc/12/javafx.graphics/javafx/application/Platform.html#runLater(java.lang.Runnable)), passing in a lambda expression of the code to run on the UI thread.

```java
public void accept(StockPrice stockPrice) {
    Platform.runLater(() -> 
        seriesData.add(new XYChart.Data<>(String.valueOf(stockPrice.getTime().getSecond()),
                                          stockPrice.getPrice()))
    );
}
```



### 运行 chart 应用程序

1. Make sure the back-end Kotlin Spring Boot service (StockServiceApplication) is running.
2. Go back to the UI module and run our JavaFX application, StockUiApplication.
3. You should see a JavaFX line chart that updates automatically from the prices (see [3:20 into the video](https://youtu.be/OMuqIykUh5w?t=201) for an example).

### 显示股票代码名称

1. Extract the hard-coded symbol into a local variable, we want to use it in more than one place.
2. (Tip: we can use IntelliJ IDEA’s Extract Variable ([documentation](https://www.jetbrains.com/help/idea/extract-variable.html)) ([video overview](https://youtu.be/W_IiuORF16E)) to easily do this)
3. We can give the series a label by passing the symbol in to the [Series](https://openjfx.io/javadoc/12/javafx.controls/javafx/scene/chart/XYChart.Series.html#(java.lang.String,javafx.collections.ObservableList)) constructor.

```java
public void initialize() {
    String symbol = "SYMBOL";
    ObservableList<XYChart.Series<String, Double>> data = FXCollections.observableArrayList();
    data.add(new XYChart.Series<>(symbol, seriesData));
    chart.setData(data);
 
    webClientStockClient.pricesFor(symbol).subscribe(this);
}
```

Now when we re-run the application, we see the symbol’s name on the label for the series.

### 代码清理

This code is a little bit unwieldy with all the type information, so let’s simplify. We can use Alt+Enter on many of the class names mentioned here to have IntelliJ IDEA suggest making this changes automatically.

1. Import [Series](https://openjfx.io/javadoc/12/javafx.controls/javafx/scene/chart/XYChart.Series.html) itself to remove the unnecessary [XYChart](https://openjfx.io/javadoc/12/javafx.controls/javafx/scene/chart/XYChart.html) prefix.
2. Add a static import for [observableArrayList](https://openjfx.io/javadoc/12/javafx.base/javafx/collections/FXCollections.html#observableArrayList(E...)), so we don’t need to repeat [FXCollections](https://openjfx.io/javadoc/12/javafx.base/javafx/collections/FXCollections.html) everywhere.
3. Add an import for [valueOf](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html#valueOf-int-), to make the line that sets the chart data a little shorter
4. Import the [Data](https://openjfx.io/javadoc/12/javafx.controls/javafx/scene/chart/XYChart.Data.html) class to remove another repetition of XYChart.

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

### 总结

With these very few lines of code, we’ve created a JavaFX application that uses Spring’s WebClient to connect to a Spring Boot service, subscribes to the reactive stream of prices and draws the prices on a line chart in real time.

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























