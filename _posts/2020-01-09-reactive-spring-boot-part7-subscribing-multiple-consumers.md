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



In this lesson we update our live-updating chart to show prices for more than one stock, which means subscribing more than one consumer to our reactive stream of prices. 在这一节，我们更新实时更新图表显示多于一种股票价格，也就意味着订阅多于一个消费者到我们的响应式价格数据流。

In the [last step](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-displaying-reactive-data) we made our JavaFX line chart subscribe to prices from our [Reactive Spring Boot service](http://blog.jetbrains.com/idea/2019/10/tutorial-reactive-spring-boot-a-kotlin-rest-service/) and display them in real time. In this step, we’re going to update the chart so that it subscribes multiple times and can show multiple sets of prices on the same chart.

在上一步，我们让JavaFX折线图订阅到来自响应式Spring Boot的服务，并实时显示它们。在这一步，我们要更新图表，让它能多次订阅并在同一个图表显示多组数据。

<!--more-->

### 引入价格订阅器

The ChartController, which manages how the data gets to the view, contains a call that subscribes the ChartController itself to the client that listens to the price service (look at the [previous post](http://blog.jetbrains.com/idea/2019/11/tutorial-reactive-spring-boot-displaying-reactive-data) to see the starting state of ChartController for this lesson). We need to change this so we can have more than one subscriber.

那个 ChartController负责管理数据如何显示的，包含了一个将ChartController自身订阅到客户端的调用，那个客户端监听股票价格服务（请看前面的文章了解ChartController的初始状态）我们要修改这个，所以我们有不止一个订阅者。



1. Inside the subscribe call in ChartController, replace `this` with a call to the constructor of a new type, PriceSubscriber. This class will manage everything to do with consuming prices from the client.在ChartController内的订阅者调用，替换 this 为一个新的类型的构造函数，PriceSubscriber. 这个类会负责管理从客户端消费价格数据。
2. Create PriceSubscriber as an inner class, it needs to implement Consumer and consume StockPrice. 将PriceSubscriber作为内部类，它需要实现 Consumer并消费StockPrice.
3. (Tip: IntelliJ IDEA will offer to automatically create this for us if we press Alt+Enter on the PriceSubscriber name after we first type it.) （提示：IntelliJ IDEA能够为我们自动创建这个，如果我们在 PriceSubscriber名称初次敲入时按下Alt+Enter）

```java
public void initialize() {
    // 其它代码...
 
    webClientStockClient.pricesFor(symbol)
                        .subscribe(new PriceSubscriber());
}
 
private class PriceSubscriber implements Consumer<StockPrice> {
}
```

### 将职责移到 PriceSubscriber

1. Move the accept method from the ChartController and into the PriceSubscriber. 将accept方法从 ChartController移到 PriceSubscriber
2. Remove the “implements Consumer” declaration from the ChartController. 从 ChartController 当中移除 "implements Consumer"声明
3. Move `seriesData` from the ChartController into PriceSubscriber. 将 seriesData 从ChartController移入到 PriceSubscriber
4. Call the PriceSubscriber constructor with the symbol, and update the PriceSubscriber to accept this as a constructor parameter. 以symbol做参数调用 PriceSubscriber构造函数，并更新PriceSubscriber去接受this作为构造函数参数。
5. (Tip: We can get IntelliJ IDEA to create the appropriate constructor if we pass symbol in, press Alt+Enter and select “Create constructor).（提示：我们可以让 IntelliJ IDEA去创建适当的构造函数，如果我们传入symbol，按下Alt+Enter并选择“Create constructor")
6. Move the creation of the Series into the PriceSubscriber constructor and store the series as a field. 将创建Series操作移入到 PriceSubscriber的构造函数并将series存为字段。
7. Add a getter for series because the ChartController will need to get this series to add it to the chart. 为series添加getter，因为ChartController需要获取这个series并添加到图表。
8. (Tip: IntelliJ IDEA can generate [getters](https://www.jetbrains.com/help/idea/generating-code.html#generate-getters-setters) from fields.)（提示：IntelliJ IDEA可以由字段生成getters）

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

Let’s fix up the initialize method of ChartController. 让我们修复ChartController的初始化方法

1. Extract the new PriceSubscriber into a local variable, we’re going to need to use this elsewhere in the method. 将新的PriceSubscriber提取到一个本地变量，我们要在方法的别处使用这个
2. Move this `priceSubscriber` near the top of the method, and inside `data.add` call the getter. 将这个priceSubscriber移动靠近方法顶部，然后在data.add里面调用getter

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

If we re-run the application, the chart should run the same way as it did before (assuming we still have the back-end service running as well), since we haven’t changed the behaviour just refactored the subscription code. 如果我们重新运行应用程序，这图表应该像之前那样运行（假设后端服务也在运行），因为我们并没有改变行为，只是重构了订阅。



### 添加第二个订阅者

1. Rename `symbol` to `symbol1`, since we’re going to have another one of these, rename the symbol itself, and let’s also rename our priceSubscriber as well. 将 symbol 重命名为 symbol1，因为我们要有另一个这东西，重命名symbol本身，然后让我们也重命名priceSubscriber
2. (Tip: Use the [rename refactoring](https://www.jetbrains.com/help/idea/rename-refactorings.html), Shift+F6, to do this, it makes sure all the code still compiles). （提示：使用 rename refactoring，Shift + F6，实现这操作，这样确保所有代码仍能通过编译。）
3. Duplicate these lines and change the variable names to symbol2 and priceSubscriber2. 重复这些行，并将变量名改为symbol2 和 priceSubscribe2
4. (Tip: The keyboard shortcut for Duplicate Line is Ctrl+D/⌘D.) （提示：重复行的键盘快捷键是Ctrl+D/⌘D）
5. Add the second series to the chart to display this second set of prices. 添加第二个系列数据到图表显示第二组价格数据
6. Duplicate the subscribe code and pass in the second symbol and second subscriber. 重复订阅者代码并传入第二个股票代码和第二个订阅者

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

现在当我们重新运行应用程序，我们可以看到两个不同的系列在图表上追踪两个不同的股票价格，正如在视频的3:30看到的那样。



### 整理代码

Now we have the application working the way we want, we can refactor the code if we wish.

现在我们的应用程序按预期运行，我们可以重构一下代码如果我们想的话。

1. We could move the call to subscribe to the top near the where we create the subscriber. 我们可以将对订阅者的调用移到接近我们创建订阅者的上方。
2. We can clean up any warnings, for example making the inner class static. 我们可以清楚任意警告，例如让内部类改为静态

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

有很多种方式可以进一步重构这些代码使之更容易阅读，减少冗余，或者按职责区别对待。例如，我们可以将对订阅的调用移入到 PriceSubscriber以减少重复。我们甚至可以使用 var 如果我们的Java版本支持的话。

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

所以现在我们有一个JavaFX应用程序，它能从Spring Boot服务订阅不止一种股票价格，而且能作折线图上一多个系列实时显示每组价格数据。

[全部代码在 GitHub](https://github.com/zwt-io/rsb/)























