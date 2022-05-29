---
typora-root-url: ../
layout:     post
title:      Java线程间通信
date:       '2020-01-30T09:35'
subtitle:   生产者与消费者例子
author:     招文桃
catalog:    true
tags:
    - Java
    - Thread
---

### 生产者与消费者

一种典型的线程间通信的例子是涉及到生产者线程与消费者线程之间的关系。生产者生产数据项被消费者消费，每个被生产出的数据项被存放在共享的变量中。

想象线程以不同的速度运行，消费者可能来不及处理掉生产者之前生产出来并放到共享变量中的数据项。还有可能就是消费者消费速度太快了，未等到生产者产生数据就去取了。

为了克服这类问题，生产者线程必须等到它被通知之前生产的数据项已经被消费掉了才继续生产，而消费者线程必须等到它被通知已经有新的数据项产生了才取消费。下面代码展示如何通过使用 `wait()` 和 `notify()` 完整这样的任务。<!--more-->

```java
package io.zwt;

// PC stands for Producer and Consumer
public class PC {
    public static void main(String[] args) {
        Shared s = new Shared(); // 共享变量
        new Producer(s).start(); // 生产者线程
        new Consumer(s).start(); // 消费者线程
    }
}

// 表示共享数据的类
class Shared {
    private char c; // 字符
    private volatile boolean writable = true; // 是否可写入状态

    // 一个同步方法，设置共享变量所保存的字符 c，这个方法对应生产者的操作
    synchronized void setSharedChar(char c) {
        // 若不可写入，就在一个 while 循环中等待
        while (!writable)
            try {
                wait();
            } catch (InterruptedException ignored) {
            }
        this.c = c; // 写入数据
        writable = false; // 改变状态
        notify(); // 生产好了，通知消费者
    }

    // 对应消费者的操作
    synchronized char getSharedChar() {
        // 可写入状态则等待，说明在生产，所以要等待
        while (writable)
            try {
                wait();
            } catch (InterruptedException ignored) {
            }
        writable = true;
        notify(); // 消费完了，通知生产者
        return c; // 读取到的字符
    }
}

// 生产者线程
class Producer extends Thread {
    private final Shared s;

    Producer(Shared s) {
        this.s = s;
    }

    @Override
    public void run() {
        for (char ch = 'A'; ch <= 'Z'; ch++) {
            s.setSharedChar(ch);
            System.out.println(ch + " produced by producer.");
        }
    }
}

// 消费者线程
class Consumer extends Thread {
    private final Shared s;

    Consumer(Shared s) {
        this.s = s;
    }

    @Override
    public void run() {
        char ch;
        do {
            ch = s.getSharedChar();
            System.out.println(ch + " consumed by consumer.");
        } while (ch != 'Z');
    }
}
```

