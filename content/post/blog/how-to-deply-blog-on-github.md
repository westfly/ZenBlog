---
title: "利用Github搭建技术Blog"
date: 2019-11-30T21:34:58+08:00
tags:
    - github blog
categories:
    - github
comment: false
draft: false
---
## 起始

学习和总结是技术路线上必经之路，以前在[cnblogs](https://westfly.cnblogs.com/)上写Blog，后来因为各种缘由更新不是合适很及时。

后来习惯了用 markdown 写日志、写周报，有些总结笔记也迁移到markdown上了，但多是写给自己的。所谓如果技术不发表，也就少了些许意义。

当前搭建一个Blog也无须自己申请一个域名，借用伟大的 [github](https://github.com)，我们可以搭建自己的技术博客，而且还有多种风格供选择。

## 实战

### 建立 Repo

申请github账号，配置ssh登陆环境，不在本文的讨论之列，请参考其它资料。

我们需要在github上建立两个Repo：

* BlogRepo 存放 Blog 的配置
* PageRepo 存放 Hugo public 生成的静态页面

PageRepo 可以作为 BlogRepo的一个子模块存在，通过 git 修改BlogRepo 即可。

```shell
# 添加主题
git submodule add -b master https://github.com/xianmin/hugo-theme-jane.git themes/jane
#替换为你的repo名
git submodule add -b master git@github.com:westfly/westfly.github.io.git public
```

如上的 hugo-theme-jane 是 一个[Hugo试试](https://gohugo.io/)主题，可以在[官方皮肤列表](https://github.com/spf13/hugoThemes)
中选择一个自己喜欢的。

### 安装 Hugo

[Hugo](https://gohugo.io/) 是一个用Go语言编写的静态网站生成器，它使用起来非常简单。

通过 hugo server 命令在本地启动 HTTP服务。
服务自带的Watch模式，能够自动检测Markdown的更改并刷新，达到实时预览的效果，极大的提高博客书写效率。

[Hugo 的安装有多种方式](https://gohugo.io/getting-started/installing/)，本文采用的是下载Hugo最新的[二进制版本](https://github.com/spf13/hugo/releases)（当然有余力的同学也可以从source开始编译），然后将其加入的系统的 PATH中。

```sh
# mac
brew install hugo
#ubuntu
sudo apt-get install hugo
```

hugo的使用只需要如下几个命令即可，具体的使用方式参考[官方文档](https://gohugo.io/overview/introduction/)

```shell
# 在本地新建一个站点，如果不为空 提示用force
hugo new site . --force
# 新建一个一篇博文
hugo new post/how-to-deply-blog-on-github.md
# 启动HTTP服务实时预览
hugo server --buildDrafts --watch
# 生成静态页面到 public
hugo
```

hugo hugo new site会自动生成这样一个目录结构：

```shell
  ▸ archetypes/
  ▸ content/
    config.toml
```

我们可以将这些添加到 BlogRepo 中去，在content/post下可以写markdown文件，同时

post 下支持按照目录进行分类

```shell
▸ arch
▸ cpplang
▸ golang
```

### 配置

Hugo的默认配置文件是config.toml，可以将config.toml从 主题Jane中拷贝出来，修改为你自己的信息，最重要的是修改baseURL，可以定向到自己domain，基于github.io 的话就应该是 [https://westfly.github.io](https://westfly.github.io)。

配置项都有注释，请酌情修改即可。

### 发布

如果本地预览成功了，就可以发布到github上了。
这里需要注意将markdown的draft 修改为 false，否则不会发表。
通过如下[脚本](https://gohugo.io/hosting-and-deployment/hosting-on-github/#put-it-into-a-script)可以一次性提交Repo。

```shell
#!/usr/bin/env bash
if [ $# -lt  1 ]; then
    echo "$0 <commit message>"
    exit 1
fi
msg="$1"
git commit -m "$msg"
if [ $? -ne 0 ]; then
    echo "Commit failed"
    exit 1
fi
git push origin master
if [ $? -ne 0 ]; then
    echo "Push failed"
fi
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"
# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`
# Go To Public folder
cd public
# Add changes to git.
git add .
# Commit changes.
git commit -m "$msg"
# Push source and build repos.
git push origin master
# Come Back up to the Project Root
cd ..
```

## 参考

[使用hugo搭建个人博客站点](https://blog.coderzh.com/2015/08/29/hugo/)

[如何在github.io搭建Hugo博客站](https://keysaim.github.io/post/blog/deploy-hugo-blog-in-github.io/)
