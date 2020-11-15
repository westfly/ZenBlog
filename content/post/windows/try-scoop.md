---
title: "Scoop 初体验"
date: 2020-08-22T09:35:02+08:00
tags:
  - scoop
  - windows
categories:
  - windows
comment: false
draft: false
---

## 1. 简介 ##

[Scoop](https://scoop.sh/) 是Windows上的软件包管理器，类似于Linux下的（yum | apt | pacman 等）工具。

在windows 下类似的软件有[Chocolatey](http://chocolatey.org/)，但相比于[Chocolatey](http://chocolatey.org/)，Scoop则更专注于开源的命令行工具，使用 Scoop 安装的应用程序通常称为"便携式"应用程序，需要的权限更少，对系统产生的副作用也更少。

## 2. 简明教程 ##

### 2.1 安装 ###

```powershell
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
# or shorter
iwr -useb get.scoop.sh | iex
```

在我的电脑里面，直接被Macfee杀掉了，所以我只能将 http://get.scoop.sh 的内容保存下来，通过powershell执行（虽然也是被kill掉）但是可以安装成功。

查看这个脚本的内容，可以发现就是从 https://github.com/lukesampson/scoop clone 软件。

如果不想安装到默认的位置，可以提取设置环境变量

```powershell
env:SCOOP='D:\ScoopApps'
[environment]::setEnvironmentVariable('SCOOP',$env:SCOOP,'User')
```



### 2.2 基本命令 ###

Scoop 命令的设计很简单（和 Homebrew 等 Unix-style 的工具一样），是「`scoop` + 动作 + 对象」的语法。其中「对象」是可省略的。

![执行方法](https://cdn.sspai.com/2019/01/11/69f2db0e372074441ceb4f2fcf96d31d.png?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

主要有如下几个命令

| 命令      | 动作         |
| --------- | ------------ |
| 🌟search   | 搜索软件名   |
| 🌟install  | 安装软件     |
| update    | 更新软件     |
| 🌟status   | 查看软件状态 |
| uninstall | 卸载软件     |
| info      | 查看软件详情 |
| home      | 打开软件主页 |

比如我们安装软件，每次可以安装多个，也可以卸载多个

```powershell
scoop install typora racket
scoop list
```



### 2.3 bucket ###

因为scoop主要是面向命令行，入选main bucket 的比较严格，所以有扩展的bucket，基本上涵盖了必须的软件，格式工厂都有，可以查看知名的bucket 列表

```powershell
scoop bucket known
main
extras
versions
nightlies
nirsoft
php
nerd-fonts
nonportable
java
games
jetbrains
```

一般我们添加下extras & versions即可

```powershell
scoop bucket add extras
scoop bucket add versions
```

上面几个 bucket 都是 Scoop 官方维护认证的 bucket，当然我们也有很多由社区（用户）维护的 bucket。这里是一个按照 Github score（由 Star 数量、Fork 数量和 App 数量综合决定的 Github score）排列的 bucket 列表：[Scoop buckets by Github score](https://github.com/rasa/scoop-directory/blob/master/by-score.md)，加载会比较慢，https://rasa.github.io/scoop-directory/by-score 这个是Web端。

Scoop 社区仓库排行榜

我们可以通过这样的方式来将社区维护的 bucket 添加至本机的 Scoop bucket 列表：

```powershell
scoop bucket add <仓库名> <仓库地址>
```

再举个例子，比如添加「🐟 dorado」仓：

```
scoop bucket add dorado https://github.com/h404bi/dorado
```



### 2.4 软件推荐 ###

https://scoop.netlify.app/apps/ 搜索apps所在的包（buckets）



### 2.5 更新 ###

基本上更新就是下载文件，这里建议配置aria2 进行多线程下载，但是有些网站不支持多线程，也需要经常把aria2设置为false，希望后续官方出一个blacklist的功能吧。

```shell
scoop install aria2
# aria2 在 Scoop 中默认开启
scoop config aria2-enabled true
# 关于以下参数的作用，详见aria2的相关资料
scoop config aria2-retry-wait 4
scoop config aria2-split 16
scoop config aria2-max-connection-per-server 16
scoop config aria2-min-split-size 4M
```

### 2.6 维护 ###

scoop基本上有如下几个步骤

1. 下载包，会先检查cache中包存在与否，如果存在就不会先下载
2. 解压安装包
3. 更新路径，对go等增加系统path等
4. 多版本的软链接

所以维护主要就是这样的几个命令而已

```powershell
# 全部更新
scoop update *
# 删除冗余的版本
scoop cleanup *
# 查看 cache 相关
scoop cache show 
scoop cache rm vscode*
scoop cache rm *
```



## 3. 总结 ##

scoop依赖于github，对网络有一定的要求，否则会比较慢，希望社区做大了，有一个aliyun的镜像用于加快下载

如果在执行过程中被中断，可能导致scoop的更新中断，被删除，导致后期会输入一些命令去修复。

依赖于powershell，无法在wsl中执行。

优势：

* 熟悉的linux命令行，即使是包含图形界面的程序在安装过程中无干扰
* 安装路径规范，一键更新，无须自己找链接下载（社区的人帮忙做了）



## 参考 资料 ##

[「一行代码」搞定软件安装卸载，用 Scoop 管理你的 Windows 软件](https://sspai.com/post/52496)
[Scoop包管理器的相关技巧和知识](https://www.thisfaner.com/p/scoop/)
[给 Scoop 加上这些软件仓库，让它变成强大的 Windows 软件管理器](https://jszbug.com/13333)
[搭建 Windows 统一开发环境（Chocolatey，Scoop）](https://zhuanlan.zhihu.com/p/128955118)