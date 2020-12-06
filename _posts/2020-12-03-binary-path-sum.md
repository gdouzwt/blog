---
typora-root-url: ../
layout:     post
title:      剑指Offer 面试题 34
date:       '2020-12-03T21:40'
subtitle:   二叉树中和为某一值的路径
keywords:   Java, 剑指Offer
author:     zwt
catalog:    true
tags:
    - Java
    - 面试
---

#### 题目

书中原题目是：  
> 题目：输入一棵二叉树和一个整数，打印出二叉树中节点值的和为输入整数的所有路径。从树的根节点开始往下一直到叶节点所经过的节点形成一条路径。二叉树节点的定义如下：

```cpp
struct BinaryTreeNode
{
  int               m_nValue;
  BinaryTreeNode    m_pLeft;
  BinaryTreeNode    m_pRight;
}
```

不过牛客网上的题目，稍微有点不同：

> 输入一颗二叉树的根节点和一个整数，按字典序打印出二叉树中结点值的和为输入整数的所有路径。路径定义为从树的根结点开始往下一直到叶结点所经过的结点形成一条路径。  

题目是要求返回 `ArrayList<ArrayList<Integer>>`，还有那个按字典序打印。  

这道题主要是对树进行前序遍历，访问到某个节点时累加起来，直到叶子节点，判断路径节点值之和是否为要求的整数。思路相对来说比较简单和直接，但是需要注意实现采用的数据结构的细节。  
首先，从一个具体例如入手分析，输入下图 1 中二叉树和整数 22  <!--more-->
![二叉树](/img/binary-tree.png)  

从根节点 10 开始按前序遍历，下一个节点是 5，此时路径包含两个节点，分别是 10，5。接下来将访问到 4 这个节点，这时候已经达到叶子节点，但路径上的节点值之和是 19，不等于 22，所以不符合要求。之后回溯到父子点 5，接着再去访问右节点 7，此时路径中的节点的值 10，5，7之和刚好是 22，符合要求。  
其中的规律是，当用前序遍历的方式访问到某一节点时，我们把该节点添加到路径上，并累加该节点的值。如果该节点为叶节点，并且路径中节点值的和刚好等于输入的整数，则当前路径符合要求，我们把它添加到`ArrayList`里边。如果当前节点不是叶节点，则继续访问它的子节点。当前节点访问结束后，递归方法将自动回到它的父节点。因此，我们在方法退回之前在路径上删除当前节点并减去当前节点的值，以确保返回父节点时路径刚好是从根节点到父节点。可以看出保存路径的数据结构实际上是一个栈，因为路径要与递归调用状态一致，而递归调用的本质就是一个压栈和出栈的过程。这里的内容基本跟书里的讲解差不多，只不过按牛客网的题目要求，并且用 Java 实现的话，我自己的做法是使用了集合框架里的 `Deque` 接口，一个双端队列。因为这样子，可以保证队列的顺序符合最终要求返回的路径内节点的顺序，同时也可以当作一个栈在队尾（相当于栈顶）操作。具体代码如下：  

```java
package io.zwt.ch4;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;

/**
 * 输入一颗二叉树的根节点和一个整数，
 * 按字典序打印出二叉树中结点值的和为输入整数的所有路径。
 * 路径定义为从树的根结点开始往下一直到叶结点所经过的结点形成一条路径。
 */
public class FindPathSum {

    private final ArrayList<ArrayList<Integer>> lists;

    public FindPathSum() {
        this.lists = new ArrayList<>();
    }

    public static class TreeNode {
        int val = 0;
        TreeNode left = null;
        TreeNode right = null;

        public TreeNode(int val) {
            this.val = val;
        }
    }

    /**
     * @param root   输入的二叉树的根节点
     * @param target 预期路径节点值之和
     * @return 路径组成的 List
     */
    public ArrayList<ArrayList<Integer>> FindPath(TreeNode root, int target) {
        if (root == null) {
            return new ArrayList<>();
        }
        Deque<Integer> path = new ArrayDeque<>();  // 一个双端队列存储路径
        int currentSum = 0;
        return findPath(root, target, path, currentSum);
    }

    /**
     * @param root       当前节点
     * @param target     路径节点值之和
     * @param path       路径
     * @param currentSum 当前路径值之和
     * @return 返回多少路径
     */
    private ArrayList<ArrayList<Integer>> findPath(TreeNode root, int target, Deque<Integer> path, int currentSum) {

        currentSum += root.val;
        path.offer(root.val);  // 放入队列

        // 如果是叶节点，并且路径上节点值的和等于输入的值，
        // 则将这条路径添加到 ArrayList
        boolean isLeaf = root.left == null && root.right == null;  // 递归结束条件
        if (currentSum == target && isLeaf) {
            lists.add(new ArrayList<>(path));
        }

        // 如果不是叶节点，则遍历它的子节点
        if (root.left != null) {
            findPath(root.left, target, path, currentSum);
        }
        if (root.right != null) {
            findPath(root.right, target, path, currentSum);
        }

        // 在返回父节点之前，在路径上删除当前节点
        path.pollLast();
        return lists;

    }
}

```  
