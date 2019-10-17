---
typora-root-url: ../
layout:     post
title:      相反顺序输出一个整数
date:       '2019-10-14'
subtitle:   笔试编程题
author:     招文桃
catalog:    true
tags:
    - Java
    - 笔试
---



##### 起初

编写程序，对输入的一个整数，按相反顺序输出该数。

```java
// ReverseInt.java
import java.util.Scanner;
public class ReverseInt {
	public static void main(String[] args) {
		System.out.println("请输入一个整数：");
		Scanner input = new Scanner(System.in);
		String value = "" + input.nextBigInteger();
		input.close();
		String reversed = "";
		for (int i = value.length() - 1; i >= 0; i--) {
			reversed = reversed + value.charAt(i);
		}
		System.out.println(reversed);
	}
}
```
当时手写代码，`for` 循环的控制条件边界写错了，当时写成了 `for (int i = value.length(); i > 0; i--)`  结果数组越界了。应该是 `for (int i = value.length() - 1; i >= 0; i--)` 的。

换成 `input.nextBigInteger();` 好一点。 

##### 后来

真是没有必要这样搞，用 `StringBuilder` 就可以了：

```java
import java.util.Scanner;
public class ReverseInt {
	public static void main(String[] args) {
		System.out.println("请输入一个整数：");
		Scanner input = new Scanner(System.in);
		StringBuilder value = new StringBuilder();
		value.append(input.nextBigInteger());
		input.close();
		System.out.println(value.reverse());
	}
}
```

【完】










