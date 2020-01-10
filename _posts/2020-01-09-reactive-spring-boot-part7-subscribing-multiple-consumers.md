---
typora-root-url: ../
layout:     post
title:      响应式Spring Boot系列教程7
date:       '2020-01-09T09:49'
subtitle:   订阅多个消费者
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

> Posted on December 2, 2019 by Trisha Gee
>
> 原文由 Trisha Gee 在当地时间2019年12月2日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/12/tutorial-reactive-spring-boot-subscribing-multiple-consumers/)



In this lesson we update our live-updating chart to show prices for more than one stock, which means subscribing more than one consumer to our reactive stream of prices.

This is the seventh part of our tutorial showing how to build a Reactive application using Spring Boot, Kotlin, Java and [JavaFX](https://openjfx.io/). The original inspiration was a [70 minute live demo.](https://blog.jetbrains.com/idea/2019/10/fully-reactive-spring-kotlin-and-javafx-playing-together/)

This blog post contains a video showing the process step-by-step and a textual walk-through (adapted from the transcript of the video) for those who prefer a written format.

<!--more-->

[This tutorial is a series of steps](https://blog.jetbrains.com/idea/tag/tutorial-reactive-spring/) during which we will build a full [Spring Boot](https://spring.io/projects/spring-boot) application featuring a [Kotlin](https://kotlinlang.org/) back end, a [Java](https://jdk.java.net/13/) client and a [JavaFX](https://openjfx.io/) user interface.

In the [last step](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-displaying-reactive-data) we made our JavaFX line chart subscribe to prices from our [Reactive Spring Boot service](http://blog.jetbrains.com/idea/2019/10/tutorial-reactive-spring-boot-a-kotlin-rest-service/) and display them in real time. In this step, we’re going to update the chart so that it subscribes multiple times and can show multiple sets of prices on the same chart.

### 引入价格订阅器

The ChartController, which manages how the data gets to the view, contains a call that subscribes the ChartController itself to the client that listens to the price service (look at the [previous post](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-displaying-reactive-data) to see the starting state of ChartController for this lesson). We need to change this so we can have more than one subscriber.

1. Inside the subscribe call in ChartController, replace `this` with a call to the constructor of a new type, PriceSubscriber. This class will manage everything to do with consuming prices from the client.
2. Create PriceSubscriber as an inner class, it needs to implement Consumer and consume StockPrice.
3. (Tip: IntelliJ IDEA will offer to automatically create this for us if we press Alt+Enter on the PriceSubscriber name after we first type it.)

```java
public void initialize() {
    // other code inside the initialize method here...
 
    webClientStockClient.pricesFor(symbol)
                        .subscribe(new PriceSubscriber());
}
 
private class PriceSubscriber implements Consumer<StockPrice> {
}
```

### 将职责移到 PriceSubscriber

1. Move the accept method from the ChartController and into the PriceSubscriber.
2. Remove the “implements Consumer” declaration from the ChartController.
3. Move `seriesData` from the ChartController into PriceSubscriber.
4. Call the PriceSubscriber constructor with the symbol, and update the PriceSubscriber to accept this as a constructor parameter.
5. (Tip: We can get IntelliJ IDEA to create the appropriate constructor if we pass symbol in, press Alt+Enter and select “Create constructor).
6. Move the creation of the Series into the PriceSubscriber constructor and store the series as a field.
7. Add a getter for series because the ChartController will need to get this series to add it to the chart.
8. (Tip: IntelliJ IDEA can generate [getters](https://www.jetbrains.com/help/idea/generating-code.html#generate-getters-setters) from fields.)

```java
private class PriceSubscriber implements Consumer<StockPrice> {
    private Series<String, Double> series;
    private ObservableList<Data<String, Double>> seriesData = observableArrayList();
 
    private PriceSubscriber(String symbol) {
        series = new Series<>(symbol, seriesData);
    }
 
    @Override
    public void accept(StockPrice stockPrice) {
        Platform.runLater(() ->
            seriesData.add(new Data<>(valueOf(stockPrice.getTime().getSecond()),
                                      stockPrice.getPrice()))
        );
    }
 
    public Series<String, Double> getSeries() {
        return series;
    }
}
```

Let’s fix up the initialize method of ChartController.

1. Extract the new PriceSubscriber into a local variable, we’re going to need to use this elsewhere in the method.
2. Move this `priceSubscriber` near the top of the method, and inside `data.add` call the getter.

```java
@Component
public class ChartController {
    @FXML
    private LineChart<String, Double> chart;
    private WebClientStockClient webClientStockClient;
 
    public ChartController(WebClientStockClient webClientStockClient) {
        this.webClientStockClient = webClientStockClient;
    }
 
    @FXML
    public void initialize() {
        String symbol = "SYMBOL";
        PriceSubscriber priceSubscriber = new PriceSubscriber(symbol);
        
        ObservableList<Series<String, Double>> data = observableArrayList();
        data.add(priceSubscriber.getSeries());
        chart.setData(data);
 
        webClientStockClient.pricesFor(symbol)
                            .subscribe(priceSubscriber);
    }
 
    private class PriceSubscriber implements Consumer<StockPrice> {
        // details in previous code snippet
    }
}
```

If we re-run the application, the chart should run the same way as it did before (assuming we still have the back-end service running as well), since we haven’t changed the behaviour just refactored the subscription code.



### 添加第二个订阅者

1. Rename `symbol` to `symbol1`, since we’re going to have another one of these, rename the symbol itself, and let’s also rename our priceSubscriber as well.
2. (Tip: Use the [rename refactoring](https://www.jetbrains.com/help/idea/rename-refactorings.html), Shift+F6, to do this, it makes sure all the code still compiles).
3. Duplicate these lines and change the variable names to symbol2 and priceSubscriber2.
4. (Tip: The keyboard shortcut for Duplicate Line is Ctrl+D/⌘D.)
5. Add the second series to the chart to display this second set of prices.
6. Duplicate the subscribe code and pass in the second symbol and second subscriber.

```java
public void initialize() {
    String symbol1 = "SYMBOL1";
    PriceSubscriber priceSubscriber1 = new PriceSubscriber(symbol1);
    String symbol2 = "SYMBOL2";
    PriceSubscriber priceSubscriber2 = new PriceSubscriber(symbol2);
 
    ObservableList<Series<String, Double>> data = observableArrayList();
    data.add(priceSubscriber1.getSeries());
    data.add(priceSubscriber2.getSeries());
    chart.setData(data);
 
    webClientStockClient.pricesFor(symbol1)
                        .subscribe(priceSubscriber1);
    webClientStockClient.pricesFor(symbol2)
                        .subscribe(priceSubscriber2);
}
```

Now when we re-run the application we can see two different series on the chart tracking the prices for two different stocks, like you can see at [3:30 in the video](https://youtu.be/o_hRybh7eJA?t=209).



### 整理代码

Now we have the application working the way we want, we can refactor the code if we wish.

1. We could move the call to subscribe to the top near the where we create the subscriber.
2. We can clean up any warnings, for example making the inner class static.

```java
public void initialize() {
    String symbol1 = "SYMBOL1";
    PriceSubscriber priceSubscriber1 = new PriceSubscriber(symbol1);
    webClientStockClient.pricesFor(symbol1)
                        .subscribe(priceSubscriber1);
 
    String symbol2 = "SYMBOL2";
    PriceSubscriber priceSubscriber2 = new PriceSubscriber(symbol2);
    webClientStockClient.pricesFor(symbol2)
                        .subscribe(priceSubscriber2);
 
    ObservableList<Series<String, Double>> data = observableArrayList();
    data.add(priceSubscriber1.getSeries());
    data.add(priceSubscriber2.getSeries());
    chart.setData(data);
}
```



### 额外的重构（不在视频中）

There are a number of other ways we could further refactor this to make it easier to read, to reduce duplication, or to group responsibilities differently. For example, we could move the call to subscribe into the PriceSubscriber to reduce duplication. We can even use `var` if we’re running a version of Java that supports it.

```java
public class ChartController {
 
    // ... fields and constructor ...
 
    @FXML
    public void initialize() {
        var priceSubscriber1 = new PriceSubscriber("SYMBOL1", webClientStockClient);
        var priceSubscriber2 = new PriceSubscriber("SYMBOL2", webClientStockClient);
 
        ObservableList<Series<String, Double>> data = observableArrayList();
        data.add(priceSubscriber1.getSeries());
        data.add(priceSubscriber2.getSeries());
        chart.setData(data);
    }
 
    private static class PriceSubscriber implements Consumer<StockPrice> {
        private Series<String, Double> series;
        private ObservableList<Data<String, Double>> seriesData = observableArrayList();
 
        private PriceSubscriber(String symbol, WebClientStockClient stockClient) {
            series = new Series<>(symbol, seriesData);
            stockClient.pricesFor(symbol)
                       .subscribe(this);
        }
 
        @Override
        public void accept(StockPrice stockPrice) {
            Platform.runLater(() ->
              seriesData.add(new Data<>(valueOf(stockPrice.getTime().getSecond()),
                                        stockPrice.getPrice()))
            );
        }
 
        private Series<String, Double> getSeries() {
            return series;
        }
    }
}
```



### 总结

So now we have a JavaFX application that subscribes to more than one price from our Spring Boot service, and displays each set of price data in real time in multiple series on a line chart.

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























