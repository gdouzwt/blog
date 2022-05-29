---
typora-root-url: ../
layout:     post
title:      在 Ubuntu 20.04 安装 ffmpeg
date:       '2022-03-08T11:54'
subtitle:   
keywords:   ffmpeg, HLS
author:     招文桃
catalog:    true
tags:
    - ffmpeg
    - PPA

---

FFmpeg 5.0 "Lorentz" 已经发布，不过可能项目不需要用到那么新的版本，所以这里记录在 Ubuntu 20.04 安装 FFmpeg 4.4 "Rao" 的过程。

1. 添加 PPA:

```bash
sudo add-apt-repository ppa:savoury1/ffmpeg4
```
