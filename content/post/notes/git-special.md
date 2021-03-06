---
title: "Git简明教程"
date: 2020-01-07T21:35:02+08:00
tags:
    - git
categories:
    - cpp
comment: false
draft: false
---


## 1. 安装 ##

Git 是跨平台的 可以下载安装 [GitForWindows](https://gitforwindows.org/) ，安装后将其添加到系统的Path即可。

在Linux下可以直接用命令行安装即可，主流的发行版本默认是自带的。

### 1.1 配置项 ###

除了安装之外，需要配置一下

```shell
git config --global user.email=yweiyun@163.com
git config --global user.name=aresyang
git config --global core.editor=vim
#彩色的 git 输出
git config color.ui true
git config format.pretty oneline
```

如上命令会在 ~/.gitconfig 生成配置文件

```bash
cat ~/.gitconfig
[user]
	email = yweiyun@163.com
	name = aresyang
[core]
	editor = vim
```

当前也可以将生成的配置文件拷贝到$HOME下，用于系统迁移。

还可以使用命令查看

```shell
git config --list
# 查看帮助
git help config
```



### 1.2 免登陆配置 ###

通过如下命令生成公钥和私钥

```shell
ssh-keygen -t rsa -C "aresyang@gmail.com" 
```

至于 $HOME/.ssh目录下，然后配置 config，可以为多个站点配置不同的用户名&授权sshkey，需要注意权限问题

```shell
cat ~/.ssh/config
Host github.com
 HostName github.com
 User westfly
 IdentityFile ~/.ssh/westfly.rsa
```



## 2. 简介 ##

### 2.1 基本命令 ###

如下基本命令遵循建立、下载、修改、推送各个阶段

```shell
# 初始化一个空的repo
git init
# clone 一个库 http协议 # 如果是 private_repo 可能需要输入用户名&密码
git clone https://github.com/westfly/mssh.git 
# 用ssh认证的方式clone，请确认有权限
git clone git@github.com:westfly/mssh.git
# 重命令为mymssh目录
git clone git@github.com:westfly/mssh.git mymssh
# 添加
git add README.md
# 查看当前状态（如果有修改会列出文件名）
git status 
git commit -m "add README of Repo" README.md
# 推送到 remote
git push origin master:master
```



### 2.2 分支操作 ###

 分支的概念是为了多版本开发引入的，可以有多个branch，Git提供合并到主干（master）的功能。

![branches](https://rogerdudler.github.io/git-guide/img/branches.png)

如下是branches的一些命令

```shell
# 如果没有则新建名为dev的branches
git branches dev
# 切换到dev branche，需要确认当前 branch 所有修改已经提交
git checkout dev
# 创建dev分支，并切换到dev分支
git checkout -b dev
# 与远程建立联系
git branch --set-upstream-to=origin/master master
# 删除本地 dev 分支
git branch -d dev
git branch -D dev # 强制删除
# 重命名分支
git branch -m newdev

```

### 2.3 工作目录 ###

工作目录其实是一个本地的修改镜像，当用户提交后，推修改本地的Index，最后一次提交的记录被称为HEAD

![branches](https://rogerdudler.github.io/git-guide/img/trees.png)



### 2.4 更新和合并 ###

```shell
#从remote的branch拉取最新的修改	
git pull
# 合并
git merge
```

git pull & git merge 都会将remote & local的改动进行合并。

如果合并失败，则需要根据提示解决conflicts。

如果涉及到不同branch的合并，需要用到rebase命令

```shell
# 从 master 分支 rebase 修改到当前分支 
git pull --rebase origin master:master
# 解决完冲突继续rebase
git rebase --continue
# 如果没有修改（或者解决冲突后是平的）则 --skip 掉即可
git rebase --skip
```

如果是fork第三方的仓库，为了跟原作者的repo通过，可以通过如下方式

```shell
git remote add upstream https://github.com/sogou/workflow
git fetch upstream
git merge upstream/master
```



### 2.5 Diff  和 Patch ###

Git 提供了两种补丁方案，一是用git diff生成的UNIX标准补丁.diff文件，二是git format-patch生成的Git专用.patch 文件。.diff文件只是记录文件改变的内容，不带有commit记录信息，多个commit可以合并成一个diff文件。.patch文件带有记录文件改变的内容，也带有commit记录信息,每个commit对应一个patch文件。

```shell
git diff
git diff commit_id1 commit_id2 > function.diff
#检查能否合并
git apply --check function.diff
git apply function.diff
```



### 2.6 撤销与恢复 ###

```shell
git reset # 将已经add过的改回"Changed but not updated"状态
git reset file # 只撤销某个文件的add.
git reset --soft #
git reset --hard #
git reset HEAD^ # 将本地仓库的最近一个提交版本干掉. 最好不要干掉已经push出去的提交.
```



## 3. 标签 ##

标签类似于svn的tag，提供一个发布的节点命名，可以是一个功能特性或BugFix等。

```shell
# 查看当前所有Tag
git tag
# 只list出有v1.8前缀的Tag
git tag -l 'v1.8.*'
# 新增tagv1.4 
git tag -a v1.4 -m "v1.4 fix stringstream performance"
# 删除Tag
git tag -d v1.4
```

一般gitlab会提供WebUI，也可以在界面上操作，比较方便。

## 4. 杂项 ##

### 4.1 添加gitignore文件 ###

```shell
echo "*.d" > .gitignore #忽略编译生成的deps文件
```

业界 gitignore 文件可以从 https://www.gitignore.io/ 上查看并下载，如下是C++的一个示例

```shell
### C++ ###
# Prerequisites
*.d
# Compiled Object files
*.slo
*.lo
*.o
*.obj
# Precompiled Headers
*.gch
*.pch
# Compiled Dynamic libraries
*.so
*.dylib
*.dll
# Fortran module files
*.mod
*.smod
# Compiled Static libraries
*.lai
*.la
*.a
*.lib
# Executables
*.exe
*.out
*.app

```

### 4.2 历史记录 ###

```shell
# 查看 当前branch的提交记录
git log
# 只看某一个人的提交记录:
git log --author=aresyang
# 一个压缩后的每一条提交记录只占一行的输出
git log --pretty=oneline
# 查看有哪些文件修改
git log --name-status
```

### 4.2 跨Repo合并更新 ###

针对第三方库的情况，合并原Repo的Feature更新，如下是更新 https://github.com/chen3feng/toft 的方式，upstream 的名称可以修改。

```shell
git remote add upstream https://github.com/chen3feng/toft
git fetch upstream
git pull --rebase upstream master:master
git push orignal master:master
```



## 参考 ##

[git速查笔记](http://mikewootc.com/wiki/tool/versionmanage/git.html)

[git - 简明指南](https://rogerdudler.github.io/git-guide/index.zh.html)