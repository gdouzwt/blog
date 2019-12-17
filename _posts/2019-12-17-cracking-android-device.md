---
typora-root-url: ../
layout:     post
title:      刷机过程记录
date:       '2019-12-16T09:19'
subtitle:   Redmi Note 4X（高通平台）
author:     招文桃
catalog:    true
tags:
    - Android
---



LineageOS Android Distribution https://lineageos.org/

https://download.lineageos.org/extras



https://wiki.lineageos.org/devices/mido/install



Resurrection Remix OS https://www.resurrectionremix.com/

mido https://get.resurrectionremix.com/?dir=mido

[TeamWin - TWRP](https://twrp.me/)

### [Download twrp-3.3.1-0-mido.img](https://dl.twrp.me/mido/twrp-3.3.1-0-mido.img)



OpenGAPPS

https://opengapps.org/#aboutsection



音量键下 + 开机键进入recovery，然后输入以下命令：

```
fastboot flash recovery twrp-3.3.1-0-mido.img
```

接着

```
fastboot boot twrp-3.3.1-0-mido.img
```



一番wipe 之后，sideload，使用以下命令

```
adb sideload lineage-16.0-20191215-nightly-mido-signed.zip
```



明天早详细整理