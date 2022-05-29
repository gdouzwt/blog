---
typora-root-url: ../
layout:     post
title:      剑指Offer 面试题 3
date:       '2020-12-07T03:03'
subtitle:   数组中重复的数字
keywords:   Java, 剑指Offer
author:     招文桃
catalog:    true
tags:
    - Java
    - 面试
---

#### 题目

> 在一个长度为n的数组里的所有数字都在 0 到 n-1 的范围内。 数组中某些数字是重复的，但不知道有几个数字是重复的。也不知道每个数字重复几次。请找出数组中第一个重复的数字。 例如，如果输入长度为7的数组{2 ,3, 1, 0, 2, 5, 3}，那么对应的输出是第一个重复的数字 2。  

这个题目在牛客网是**请找出数组中第一个重复的数字**，书中是“请找出数组中**任意一个**重复的数字”。如果直接按照书中的代码，那就不能通过牛客网的全部测试用例，这就有点搞了。不过还是先讲一下解题思路吧。  

##### 先排序，再扫描  

排序后的数组很容易可以找出重复数字，从头到尾扫描一遍，发现相邻两个数相等的情况即找到了重复数字。时间复杂度为 $O(nlogn)$

##### 利用哈希表

从头到尾扫描一遍数组，如果哈希表中没有这个数字，就将它加入哈希表，如果该数字已存在，则找到了重复数字。这个方法可以用 $O(1)$ 的时间来判断哈希表是否包含当前扫描到的数字，整个算法的时间复杂度是 $O(n)$ ，但代价是需要一个 $O(n)$ 大小的哈希表。

##### 利用数组下标

因为数组中所有数字都在0~n-1范围内，如果数组没有重复数字，那么数组排序后里面数字应该与它对应的下标相等。但因为数组中数字有重复，所以某个位置上的数字应该会出现多于一次。其实说的是，某个下标对应着的与下标相等的数字可能出现多次。原书中那句话是，“由于数组中有重复的数字，有些位置可能存在多个数字，同时有些位置可能没有数字。”，当时看到这句话有点懵，难道数组的一个位置还可以挤下两个数字？后来知道他所指的“位置”是指，下标值与数值相等的这种情况。说起位置，就有点想起 `PositionalList` ...  

清楚了上面的情况，那么怎么可以找出重复数字？书中也是一段文字描述，按照里边描述的确可以找出重复数字，但看起来有点不直观，所以画个流程图看看。<!--more-->

![image-20201207035713049](/img/image-20201207035713049.png)

这实际上是一个 **in-place** 的排序操作，一边排序同时判断是否有重复数字。上图中 *i* 表示数组的下标值，*m* 表示数字值。我们开始从头到尾依次扫描这个数组，当扫描到下标为 *i* 的数字时，首先比较这个数字(*m*)是否等于 *i*。如果是，就扫描下一个数字；如果不等，则将该数字与第 *m* 个数字进行比较（即与下标值等于 *m* 的那个数比较）。此时，如果它和第 *m* 个数字相等，则找到了一个重复数字，因为这个数字在下标值为 *i* 和 *m* 的位置都出现了。如果它和第 *m* 个数字不相等，就将第 *i* 个数字和第 *m* 个数字交换，这个操作就是将 *m* 放到下标值等于其数值的位置，放在它该出现的位置上。这个过程其实就是一个插入排序（Insertion Sort），利用了数组下标有序，in-place 操作做到空间复杂度为 $O(1)$ ，每个数字最多只要交换两次就可以找到它自己的位置，因此总的时间复杂度是 $O(n)$，代码如下：

```java
/**
 * @param numbers     输入的数组
 * @param length      数组的长度
 * @param duplication 原书中的是 C/C++ 的一个指针，用于返回数组中重复的数字，
                      在这里可能只是为了统一，将重复数字存在数组第一个位置
 * @return            true 如果有重复，否则 false
 */
public boolean duplicate(int numbers[], int length, int[] duplication) {
    // 判空
    if (numbers == null || length <= 0) {
        return false;
    }

    // 判断是否数组内数字是否符合题目要求范围
    for (int i = 0; i < length; i++) {
        if (numbers[i] < 0 || numbers[i] > length - 1) {
            return false;
        }
    }

    for (int i = 0; i < length; i++) {
        while(numbers[i] != i) {  // 原题是找到任意一个重复数字，但这样做不符合牛客网的要求
        // if (numbers[i] != i) {  // 改为 if 可以通过牛客网题目测试，但题解不正确，因为测试用例有问题，奇怪。
            if (numbers[i] == numbers[numbers[i]]) {
                duplication[0] = numbers[i];
                return true;
            }

            // swap numbers[i] and numbers[numbers[i]]
            int temp = numbers[i];
            numbers[i] = numbers[temp];
            numbers[temp] = temp;
        }
    }
    return false;
}
```

可以通过测试的一种解法

```java
public boolean duplicate(int[] numbers, int length, int[] duplication) {

    if (numbers == null || length <= 0) {
        return false;
    }

    Set<Integer> values = new HashSet<>();
    for (int i = 0; i < length; i++) {
        if (numbers[i] < 0 || numbers[i] > length - 1) {
            return false;
        }
    }

    int[] cloned = Arrays.copyOf(numbers, numbers.length);

    for (int i = 0; i < length; i++) {
        while (numbers[i] != i) {  //原题是找到任意一个重复数字
            if (numbers[i] == numbers[numbers[i]]) {
                //duplication[0] = numbers[i];
                values.add(numbers[i]);
                break;
            }

            // swap numbers[i] and numbers[numbers[i]]
            int temp = numbers[i];
            numbers[i] = numbers[temp];
            numbers[temp] = temp;
        }
    }

    if (!values.isEmpty()) {
        for (int i : cloned) {
            if (values.contains(i)) {
                duplication[0] = i;
                break;
            }
        }
    }

    return !values.isEmpty();
}
```

改成这样还不如下面这种方法：

```java
// 使用临时数组
public boolean duplicate(int numbers[], int length, int[] duplication) {
    if (numbers == null || numbers.length == 0)
        return false;
    int[] temp = new int[length];
    for (int i = 0; i < length; i++) {
        temp[numbers[i]]++;
        if (temp[numbers[i]] > 1) {
            duplication[0] = numbers[i];
            return true;
        }
    }
    return false;
}
```

上面这个方法参考自：[牛客网的一个解题](https://blog.nowcoder.net/n/1fe32887be5c453aae05429990659f52)  

##### 结束了

这个题是剑指 Offer 开局的第一题，有点经典，除了上面主要着重分析的方法，还有其它各种解法，但传统解题以点到为止。时间不太够，要继续刷其它题了。
