---
title: "Docker 简明教程"
date: 2020-12-07T21:35:02+08:00
tags:
    - docker
categories:
    - docker
comment: false
draft: true

----

## 简介 ##

## 基本命令 ##

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