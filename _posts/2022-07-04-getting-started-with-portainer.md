---
layout:     post
title:      Portainer 简单上手
date:       '2022-07-04T02:05'
subtitle:   Getting started with Portainer
categories: Container
author:     招文桃
catalog:    true
tags:
    - Portainer
    - Docker
---


### Docker 单机安装 Portainer

首先在 Docker 创建一个 Volume 用来存放它的数据库：
`docker volume create portainer_data`

然后下载并安装 Portainer Server 容器：

`docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker/sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest`
