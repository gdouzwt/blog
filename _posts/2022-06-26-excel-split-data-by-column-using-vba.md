---
layout:     post
title:      如何在 Excel 中按列分割数据到多个工作表
date:       '2022-06-26T11:13'
subtitle:   How to split data into multiple worksheets by column in excel
categories: Excel
author:     招文桃
catalog:    true
tags:
    - Excel
    - VBA
    - 数据分割
---

假设你有个 Excel 表格有很多行数据，比如有 ”年份“，”项目部“ 和 ”金额“ 这三个列（见下图 1）。然后你想将数据按照 ”项目部“ 分割成独立工作表，即工作表 “一部” 仅包含一部的数据。可能你还想将已分割的工作表分别保存到各个独立的 Excel 文件中，下文就说明如何使用 Excel VBA 脚本完成这些操作。

首先看看表格的结构，和想要分割的效果。
![分割数据](/img/excel-split-data.png)
<p align="center">图 1</p>

