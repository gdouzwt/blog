---
typora-root-url: ../
layout:     post
title:      控制台输入数组
date:       '2019-10-13'
subtitle:   编程题数据输入方式
author:     招文桃
catalog:    true
tags:
    - Java
    - Misc
---

## 输入数据到整型数组

#### 问题

从控制台标准输入读取键盘输入的数，存放到整型数组里面。数组的长度不确定，这种情况怎么处理？<!--more-->

#### 解决方法

先输入字符串数组，中间按照某种模式（正则表达式）分隔开，得到字符串数组。取字符串数组(String[])的长度作为整型数组（int[])的初始长度，然后将字符串数组(String[])转化为整型数组。 Java 代码实现如下：

```java
public static void main(String[] args) {
	Scanner stdIn = new Scanner(System.in);
    
    String[] strArray = null;
    strArray = stdIn.nextLine().split("\\s*,\\s*");  // ','分割，前后可以有空格
    int[] intArray = new int[strArray.length];
    for(int i = 0; i< strArray.length; i++) {
        intArray[i] = Integer.parseInt(strArray[i]);
    }
}
```

#### 结束

基本可以满足要求，如果想到更加方便，简洁的方式再更新。


