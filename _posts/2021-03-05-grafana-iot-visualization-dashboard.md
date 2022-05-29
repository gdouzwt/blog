---
typora-root-url: ../
layout:     post
title:      基于Grafana的物联网可视化仪表盘
date:       '2021-03-05T02:45'
subtitle:   设置过程记录
keywords:   IoT
author:     招文桃
catalog:    true
tags:
    - IoT
    - 可视化
    - 物联网
    - 传感器
---

> 本文介绍如何在Ubuntu Server 20.04.2 LTS 服务器设置一个物联网可视化仪表盘。用到的技术包括 Docker, InfluxDB, MQTT, Grafana, Telegraf, NodeRed
硬件方面采用 ESP8266、Arduino 或者其它任何兼容它的。本系统用于监控物联网设备的情况。其中 InfluxBD 用于存储来自传感器的数据。

![image-20210305030358768](/img/image-20210305030358768.png)


#### 服务器

我的服务器用的是旧的台式电脑安装 Ubuntu Server 20.04.2 LTS 操作系统，然后安装 Docker Engine。根据 Docker [官网文档提供的方法 ](https://docs.docker.com/engine/install/ubuntu/) <!--more-->

先安装一些必要的包（如还没有）：

```bash
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg
```

接下来：

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

```bash
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```bash
 sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io
```

等 Docker 安装完成后：

```bash
sudo usermod -aG docker $USER
```

接下来是安装其它软件。

##### 安装并配置 Mosquitto

```bash
docker pull eclipse-mosquitto
```

一款开源的 MQTT broker，然后运行它。

```bash
docker run -it -p 1883:1883 -p 9001:9001 eclipse-mosquitto
```

##### 安装并配置 InfluxDB

InfluxBD 是一款时间序列数据库，可以用于存储与时间相关的数据，适合存传感器收集到的数据。

```bash
docker pull influxdb
```

运行 InfluxDB

```bash
docker run -d -p 8086:8086 -v influxdb:/var/lib/influxdb --name influxdb influxdb
```

这里是将influxdb作为守护进程启动，并创建了卷用于存储数据在 `/var/lib/influxdb`

###### 如何创建 InfluxDB 数据库和用户

这里需要创建数据库和用户，后面 Telegraf 需要访问数据库，以存储来自 MQTT 的数据。

首先打开 InfluxDB CLI：

```
docker exec -it influxdb influx
```

接下来创建数据库和用户：

```bash
create database sensors

create user "telegraf" with password "telegraf"

grant all on sensors to telegraf
```

