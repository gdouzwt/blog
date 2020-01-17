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
---

> 原文由 Trisha Gee 在当地时间2019年12月2日发布在 [INTELLIJ IDEA BLOG](https://blog.jetbrains.com/idea/2019/12/tutorial-reactive-spring-boot-subscribing-multiple-consumers/)

在这一节，我们更新实时更新图表显示多于一种股票价格，也就意味着订阅多于一个消费者到我们的响应式价格数据流。

在上一步，我们让JavaFX折线图订阅到来自响应式Spring Boot的服务，并实时显示它们。在这一步，我们要更新图表，让它能多次订阅并在同一个图表显示多组数据。

<!--more-->

### 引入价格订阅器

那个`ChartController`负责管理数据如何显示的，包含了一个将`ChartController`自身订阅到客户端的调用，那个客户端监听股票价格服务（请看前面的文章了解`ChartController`的初始状态）我们要修改这个，所以我们有不止一个订阅者。



1. 在`ChartController`内的订阅者调用，替换`this`为一个新的类型的构造函数，`PriceSubscriber`. 这个类会负责管理从客户端消费价格数据。
2. 将`PriceSubscriber`作为内部类，它需要实现`Consumer`并消费`StockPrice`。
3. （提示：IntelliJ IDEA能够为我们自动创建这个，如果我们在`PriceSubscriber`名称初次敲入时按下Alt+Enter）。

```java
public void initialize() {
    // 其它代码...
 
    webClientStockClient.pricesFor(symbol)
                        .subscribe(new PriceSubscriber());
}
 
private class PriceSubscriber implements Consumer<StockPrice> {
}
```

### 将职责移到PriceSubscriber

1. 将`accept`方法从`ChartController`移到`PriceSubscriber`。
2. 从`ChartController`当中移除 "implements Consumer"声明。
3. 将`seriesData`从`ChartController`移入到`PriceSubscriber`。
4. 以symbol做参数调用`PriceSubscriber`构造函数，并更新`PriceSubscriber`去接受`this`作为构造函数参数。
5. （提示：我们可以让 IntelliJ IDEA去创建适当的构造函数，如果我们传入symbol，按下Alt+Enter并选择“Create constructor")。
6. 将创建Series操作移入到`PriceSubscriber`的构造函数并将series存为字段。
7. 为series添加getter，因为`ChartController`需要获取这个series并添加到图表。
8. （提示：IntelliJ IDEA可以由字段生成getters）。

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

让我们修复`ChartController`的初始化方法

1. 将新的`PriceSubscriber`提取到一个本地变量，我们要在方法的别处使用这个。
2. 将这个`priceSubscriber`移动靠近方法顶部，然后在`data.add`里面调用getter。

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
        // 之前代码的细节
    }
}
```

如果我们重新运行应用程序，这图表应该像之前那样运行（假设后端服务也在运行），因为我们并没有改变行为，只是重构了订阅。



### 添加第二个订阅者

1. 将`symbol`重命名为`symbol1`，因为我们要有另一个这东西，重命名symbol本身，然后让我们也重命名`priceSubscriber`。
2. （提示：使用 rename refactoring，Shift + F6，实现这操作，这样确保所有代码仍能通过编译。）
3. 重复这些行，并将变量名改为`symbol2`和`priceSubscribe2`。
4. （提示：重复行的键盘快捷键是Ctrl+D/⌘D）。
5. 添加第二个系列数据到图表显示第二组价格数据。
6. 重复订阅者代码并传入第二个股票代码和第二个订阅者

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

现在当我们重新运行应用程序，我们可以看到两个不同的系列在图表上追踪两个不同的股票价格，正如在视频的3:30看到的那样。



### 整理代码

现在我们的应用程序按预期运行，我们可以重构一下代码如果我们想的话。

1. 我们可以将对订阅者的调用移到接近我们创建订阅者的上方。
2. 我们可以清楚任意警告，例如让内部类改为静态。

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

有很多种方式可以进一步重构这些代码使之更容易阅读，减少冗余，或者按职责区别对待。例如，我们可以将对订阅的调用移入到`PriceSubscriber`以减少重复。我们甚至可以使用`var`如果我们的Java版本支持的话。

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

所以现在我们有一个JavaFX应用程序，它能从Spring Boot服务订阅不止一种股票价格，而且能作折线图上一多个系列实时显示每组价格数据。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)：https://github.com/zwt-io/rsb/