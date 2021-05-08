---
title: "Docker 简明教程"
date: 2020-12-07T21:35:02+08:00
tags:
    - docker
categories:
    - docker
comment: false
draft: true
---

## 简介 ##

`Docker`的英文翻译是“搬运工”的意思，他搬运的东西就是我们常说的集装箱`Container`，Container 里面装的是任意类型的 App，我们的开发人员可以通过 Docker 将App 变成一种标准化的、可移植的、自管理的组件，我们可以在任何主流的操作系统中开发、调试和运行。

`Docker` 跟传统的虚拟机很类似，但是更加轻量级，更加方便。

## Docker Engine ##

`Docker Engine`是一个**C/S**架构的应用程序，主要包含下面几个组件：

- 常驻后台进程`Dockerd`
- 一个用来和 Dockerd 交互的 REST API Server
- 命令行`CLI`接口，通过和 REST API 进行交互（即docker命令）

![docker engine](https://www.qikqiak.com/k8s-book/docs/images/docker-engine.png)

## Docker 架构 ##

Docker 使用 C/S （客户端/服务器）体系的架构，Docker 客户端与 Docker 守护进程通信，Docker 守护进程负责构建，运行和分发 Docker 容器。Docker 客户端和守护进程可以在同一个系统上运行，也可以将 Docker 客户端连接到远程 Docker 守护进程。Docker 客户端和守护进程使用 REST API 通过`UNIX`套接字或网络接口进行通信。



## 基本命令 ##

### docker 版本 ###

```
docker version
```



### 拉取镜像 ###

```shell
docker pull NAME[:TAG]
```

如果不带tag，默认是latest，如下相当于 ubuntu:latest

```shell
#docker pull ubuntu:latest
docker pull ubuntu
```

默认会从 [DockerHub](https://hub.docker.com/explore/) 拉取



### 管理本地镜像 ###

从网络拉取镜像到本地后，如果需要查看本地镜像

```shell
docker images
docker image ls
```

使用`docker inspect`命令查看单个镜像的详细信息，或某一个单项信息

inspect 返回的是yaml格式

```shell
 docker inspect ubuntu
 #
 docker inspect -f {{".Config.Hostname"}} ubuntu
```

删除某个镜像，可以使用rmi命令，后面可以跟镜像名或ID

```
docker rmi IMAGE
```



### 启动docker ###

docker run 是运行容器命令

```shell
docker run -it --rm ubuntu:latest /bin/bash
```

-it：这是两个参数，一个是 -i：交互式操作，一个是 -t 终端

--rm：这个参数是说容器退出后随之将其删除



```
docker container start
```



### 编译docker ###

### 上传镜像 ###



```shell
docker push NAME[:TAG]
```

默认上传镜像到DockerHub官方仓库



## 维护 ##

### 清理所有停止运行的容器 ###

```shell
docker container prune
# or
docker rm $(docker ps -aq)
#停止容器
docker stop $(docker ps -a | grep "Exited" | awk '{print $1 }')
#删除容器
docker rm $(docker ps -a | grep "Exited" | awk '{print $1 }')
#删除镜像 
docker rmi $(docker images | grep "none" | awk '{print $3}')  

```



## 参考 ##

[清理Docker的container，image与volume](https://note.qidong.name/2017/06/26/docker-clean/)

[docker rm | Docker Documentation](https://docs.docker.com/engine/reference/commandline/rm/)

[docker ps | Docker Documentation](https://docs.docker.com/engine/reference/commandline/ps/)

[docker images | Docker Documentation](https://docs.docker.com/engine/reference/commandline/images/)

[docker rmi | Docker Documentation](https://docs.docker.com/engine/reference/commandline/rmi/)

[docker volume ls | Docker Documentation](https://docs.docker.com/engine/reference/commandline/volume_ls/)

[docker volume rm | Docker Documentation](https://docs.docker.com/engine/reference/commandline/volume_rm/)

[docker volume prune | Docker Documentation](https://docs.docker.com/engine/reference/commandline/volume_prune/)