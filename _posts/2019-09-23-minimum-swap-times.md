---
layout:     post
title:      男女位置最小交换次数
date:       '2019-09-24 23:51:36'
subtitle:   不要将简单问题想得太复杂
author:     招文桃
catalog:    true
tags:
    - 笔试面试
---

### 题目

幼儿园的小朋友准备上体育课，老师让他们手牵手排成一列。现在老师需要通过让相邻的小朋友交换位置来形成新的一列，实现男生和女生分开，也就是在这一列中，除了中间的唯一一对小朋友是男生和女生牵手，其余的小朋友只可以牵同性的手。请补齐下面的代码，输出最小的交换次数。示例：输入：

{“男”，“女”，“男”，“女”}，输出：1。

```java
public class Kindergarten {
	public Integer childrenPartition(String[] children){
		//todo:
	}
}
```

### 思考过程

两次冒泡，一次正序，一次逆序，分别记录交换次数，取较小值。<!--more-->

### Java实现

```java
import java.util.Arrays;

public class Kindergarten {
    private Integer childrenPartition(String[] children) {

        // 正序交换次数
        int a;
        // 逆序交换次数
        int b;

        // 创建长度等于人数的整型数组
        int[] forward = new int[children.length];

        // 1 代表“男”，0 代表“女”，存入整型数组
        for (int i = 0; i < children.length; i++) {
            forward[i] = children[i].equals("男") ? 1 : 0;
        }

        // 克隆一个用来做反向数组
        int[] backward = forward.clone();

        // 将数组反转
        for (int start = 0, end = forward.length - 1; start < end; start++, end--) {
            int temp = backward[end];
            backward[end] = backward[start];
            backward[start] = temp;
        }

        System.out.println("forward:");
        System.out.println(Arrays.toString(forward));
        a = bubble(forward);
        System.out.printf("swap times: %d\n", a);

        System.out.println("------------------------------");

        System.out.println("backward:");
        System.out.println(Arrays.toString(backward));
        b = bubble(backward);
        System.out.printf("swap times: %d\n\n", b);

        System.out.print("最少交换次数：");

        return Math.min(a, b);

    }

    private int bubble(int[] array) {
        int length = array.length;
        int temp, count = 0;

        // 对较小的数进行冒泡排序，并记录交换次数
        for (int i = 0; i < length - 1; i++) {
            for (int j = 1; j < length - i; j++) {
                if (array[j - 1] > array[j]) {
                    temp = array[j - 1];
                    array[j - 1] = array[j];
                    array[j] = temp;
                    count++;
                }
            }
        }

        return count;
    }

    public static void main(String[] args) {
        Kindergarten kindergarten = new Kindergarten();

        String[] children = new String[]{"男", "女", "男", "女", "女", "男", "男", "男", "女", "男"};

        System.out.println(kindergarten.childrenPartition(children));

    }
}

```

### 最后

练习，代码未必最优。