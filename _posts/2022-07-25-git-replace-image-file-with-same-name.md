---
layout:     post
title:      在 Git 替换同名的图片文件
date:       '2022-07-25T15:23'
subtitle:   Replacing image file with same name in Git
categories: Git
author:     招文桃
catalog:    true
tags:
    - Git
---

### 处理 Git 当中修改图片文件名提交识别不了的问题

有时候在 Git 将一个图片文件的文件名从 `Abc.png` 改成 `abc.png` 并提交，之后再推送到远程，有可能会遇到远程仓库的文件系统里找不到 `abc.png` 的情况。
因为远程 Git 仓库还是以为这个图片文件的名称是 `Abc.png`。 简单来说是因为 Git 不太擅长追踪二进制文件的变更，如果图片内容没改动，或者改动很少，Git 生成哈希值时候可能认为是同一个文件。至于，为什么有时候在本地文件系统的 Git 当中可以识别文件重命名，推送到某个远程仓库时候却不会正常识别的原因，这里就不讨论，没有深入去探讨。 这里只是记录一种解决办法：

#### 更改文件名后 git status 没发现变化

复制一份文件，并添加到版本追踪，最后替换原文件，具体命令和步骤如下：

假设原来已经将 `Abc.png` 重命名为 `abc.png`，并提交了，但版本控制仍识别为 `Abc.png`，且 `git status` 已经不显示有变更。

1. 复制一个副本出来

```bash
cp abc.png def.png
```

2. 将副本添加到 git 追踪

```bash
git add def.png
```

3. 用副本替换原文件

```bash
git mv -f def.png abc.png
```

4. 提交到版本控制

```bash
git commit -m'rename Abc.png to abc.png for real!'
```

5. 推送到某个远程仓库

```bash
git push whatever
```

这样就可以解决在 Git 当中重命名图片文件识别不出来的问题了。
