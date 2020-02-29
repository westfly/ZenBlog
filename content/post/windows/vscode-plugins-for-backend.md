---
title: "后端程序员的VSCode插件配置"
date: 2019-12-02T21:35:02+08:00
tags:
    - vscode
    - windows
categories:
    - windows
comment: false
draft: true
---
## 简介 ##

[VSCode](https://code.visualstudio.com/) 是基于XX开发，支持Windows、Linux、MacOS。

当前官网提供两个版本，一个是两周左右发布Stable版本，一个是Nightly发布的Insider版本。
某些新功能会新出现在 Insider 版本中，稳定后才会提供在Stable版本中，
比如，后来提供在。
我是Insider版本提供RemoteSSH功能时完全入坑VSCode的。
随着使用的深入，累计了一些好用的插件，推荐给大家。

**注意**所有的插件都可以选中后查看帮助，无须再次查找，记住官方的文档往往是最全的。

## 便携版 ##

VSCode提供的Zip版本支持 [便携模式](https://code.visualstudio.com/docs/editor/portable)，方便数据迁移或在U盘中使用。

只需将下载的zip解压，并在目录下建立如下的data目录层级即可，如果有旧的数据需要迁移，从对应注释后的位置拷贝而来即可。

```shell
|- VSCode-win32-x64-1.25.0-insider
|   |- Code.exe (or code executable)
|   |- data
|   |   |- user-data  # %APPDATA%\Code
|   |   |   |- ...
|   |   |- extensions #%USERPROFILE%\.vscode-insider\extensions
|   |   |   |- ...
|   |- ...
```

便携版的一个弊病就是无法右键菜单打开文件或打开文件夹，如下提供了[注册右键打开方式](https://www.jianshu.com/p/b6ece66643d7) 的注册脚本。

```vbscript
Windows Registry Editor Version 5.00

; Open files
[HKEY_CLASSES_ROOT\*\shell\Open with VS Code]
@="Edit with VS Code"
"Icon"="<vscode-install-dir>\\Code.exe,0"

[HKEY_CLASSES_ROOT\*\shell\Open with VS Code\command]
@="\"<vscode-install-dir>\\Code.exe\" \"%1\""

; This will make it appear when you right click ON a folder
; The "Icon" line can be removed if you don't want the icon to appear

[HKEY_CLASSES_ROOT\Directory\shell\vscode]
@="Open Folder as VS Code Project"
"Icon"="\"<vscode-install-dir>\\Code.exe\",0"

[HKEY_CLASSES_ROOT\Directory\shell\vscode\command]
@="\"<vscode-install-dir>\\Code.exe\" \"%1\""

; This will make it appear when you right click INSIDE a folder
; The "Icon" line can be removed if you don't want the icon to appear

[HKEY_CLASSES_ROOT\Directory\Background\shell\vscode]
@="Open Folder as VS Code Project"
"Icon"="\"<vscode-install-dir>\\Code.exe\",0"

[HKEY_CLASSES_ROOT\Directory\Background\shell\vscode\command]
@="\"<vscode-install-dir>\\Code.exe\" \"%V\""
```

当然，我们也可以选用EasyMenu这个工具进行添加。

## 常用快捷键 ##

## 基础配置 ##



打开 首选项，然后搜索 trimTrailingWhitespace，勾选即可，可以在保存文件时自动去掉行尾的空白字符

  

## 辅助类插件 ##

### Chinese (Simplified) Language Pack for Visual Studio Code ###

Chinese (Simplified) Language Pack for Visual Studio Code 是官方提供的将菜单本地化为中文的插件，可以自行选择安装。

### vscode-icons ###

[vscode-icons](https://marketplace.visualstudio.com/items?itemName=robertohuertasm.vscode-icons) 插件可以实现对各种文件类型的文件前的图标进行优化显示，这样我们在查看长长的文件列表的时候，
可以直接通过文件的图标就可以快速知道文件的类型，而不是去看文件的后缀。

### Dark ###

主题插件

## 开发类插件 ##

### RemoteSSH ###

### RemoteWSL ###

如果系统中安装了WSL，VSCode会推荐你安装RemoteWSL，感觉RemoteWSl是RemoteSSH的一个特化版本，配置好了HOST、User等信息。

### Git ###

睡着Github的红火，SVN越发要退出历史的舞台了。

[GitHistory](https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory)

[GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)

[GitProjectManager](https://marketplace.visualstudio.com/items?itemName=felipecaputo.git-project-manager)

### Docker ###

这个插件是无意中搜索到的，跟RemoteSSH配合使用可以显式远程宿主机上的 Docker，通过鼠标右键的方式，可以停止容器、删除镜像等，避免docker的命令操作，比较方便。

### CodeRunner ###

如果你需要学习或者接触各种各样的开发语言，那么 [Code Runner](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner) 插件可以让你不用搭建各种语言的开发环境，直接通过此插件就可以直接运行对应语言的代码，非常适合学习或测试各种开发语言。

### Settings Sync ###

Settings Sync 同步通过github账号同步vscode插件，主题配置

```shell
shift + alt + u // 上传本地配置至github
shift + alt + d // 获取github远程配置
```

### TODO Highlight ###

[TODO Highlight](https://link.zhihu.com/?target=https%3A//marketplace.visualstudio.com/items%3FitemName%3Dwayou.vscode-todo-highlight) 能够高亮

### Indent-Rainbow ###

[Indent-Rainbow](https://marketplace.visualstudio.com/items?itemName=robertohuertasm.vscode-icons)

### Bracket Pair Colorizer ###

Bracket Pair Colorizer

[Bracket Pair Colorizer: 为代码中的括号添上一抹亮色](https://zhuanlan.zhihu.com/p/54052970)

## 语法插件 ##

### Markdown ###

系统默认是支持Markdown的预览的，有第三方的支持能变得更为强大。

#### Markdown All in One ####

Markdown All in One 插件提供了一键式的

#### Markdown Preview Enhanced ####

[Markdown Preview Enhanced](https://shd101wyy.github.io/markdown-preview-enhanced/) 是一个很好用的完善预览功能的插件，可以更加形象的展示所编写的pdf格式的文档样式。
安装后，可以通过Ctrl+K 再按v调用预览效果。

### Proto3 ###

[vscode-proto3](https://marketplace.visualstudio.com/items?itemName=zxh404.vscode-proto3) 除了提供语法高亮功能外，配置了protoc的路径后，还提供语法检查功能。

一些快捷的自动完成功能，具体可以参考插件的wiki。

### Thrift ###

### yaml ###

### Toml ###

[Better TOML](https://marketplace.visualstudio.com/items?itemName=bungcip.better-toml) 提供了对 Toml 文档的hick

### Json ###

提供了对JSON文件格式化的功能，类似于JsonView的功能。

### CMake ###

### [Clang-Format](http://clang.llvm.org/docs/ClangFormat.html) ###

[Clang-Format](http://clang.llvm.org/docs/ClangFormat.html) is a tool to format

## 语言开发插件 ##

### Cpp ###

#### 自动完成 主要是在文件下的 .vscode 配置 cpp.json ####

#### 跳转 ####

### python ###

### Rust ###

### Go ###

## 参考文章 ##

[利用vscode插件与git hook提升hexo编写部署体验](https://www.jianshu.com/p/a117650f6c76)

[vscode使用Markdown文档编写](https://www.cnblogs.com/shawWey/p/8931697.html)
