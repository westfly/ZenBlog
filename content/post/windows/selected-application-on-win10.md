---
title: "Win10常用软件推荐"
date: 2019-12-07T21:35:02+08:00
tags:
    - app
    - windows
categories:
    - windows
comment: false
draft: false
---
## 一. 简介 ##

Windows作为应用最为广泛的操作系统之一，经过多年的发展，有着当今最为丰富的生态系统，作为主力的办公软件有不可替代的角色。

在中国复杂的网络环境下，各种木马、病毒层出不穷，必须特别小心。如下选用的软件如无特别的说明，皆有绿色版本、便携版本提供，这样可以选用一个稳定的版本，不必总是收到升级的提醒。如果有强迫症，可以选用软件[SUMo (Software Update Monitor)](https://kcsoftwares.com/?sumo) 进行Check，手动更新或应用软件内置的更新。

国内推荐的下载站点

* [github](www.github.com) 相当一部分工具类软件已经开源
* [0daydown](www.0daydown.com) 会打包软件的安装包和软件的crack
* [绿软](www.xdowns.com) Win10之前很多绿色软件都从这里下载，一般不是最新版，少部分不是绿色软件
* [PortableApps](https://portableapps.com/) 国外便携版下载站点，主攻开源和免费软件，Chrome & Firefox都可以找到
* [PortableAppK](https://portableappk.com/) 是最近国内便携版下载站点，某些软件需要积分才能下载

## 二. 系统增强 ##

### 开机启动项管理 ###

微软收购[sysinternals](https://docs.microsoft.com/en-us/sysinternals/)后免费提供了其下发布的工具类软件，所有的工具软件均为免安装绿色软件，解压后，首次运行工具需要同意相关协议。[autoruns](https://docs.microsoft.com/en-us/sysinternals/downloads/autoruns)是其中使用频率最高的，它能够提供开启启动的程序、服务、计划等，比Win10当前任务管理器上的启动项管理要强大许多。

可以通过[下载合集](https://download.sysinternals.com/files/SysinternalsSuite.zip) 将所有工具都下载，以备不时之需。

![image-20191213153155905](image-20191213153155905.png)

### Dism ++ ###

[Dism++](https://www.chuyu.me/zh-Hans/) 是一款 Windows 系统管理优化工具，它解决了我们安装、维护系统的一大痛点问题——自定义设置和优化。相当于一个 “一站式” 管理优化工具集。

[Dism++ ，强大的 Windows 系统优化工具](https://zhuanlan.zhihu.com/p/37664732)

[Dism++ 良心不流氓免费而强大的 Windows 系统优化与垃圾清理工具](https://www.iplaysoft.com/dism.html)

[BleachBit](https://www.bleachbit.org/download/windows) 也可以试试看

能够很好的清理系统垃圾，卸载系统软件

![image-20191213153241852.png](image-20191213153241852.png)

### TurboLaunch 多程序管理 ###

[**TurboLaunch**](http://www.savardsoftware.com/turbolaunch/)是一款小巧好用的桌面程序小工具；**TurboLaunch**拥有安装程序、锁屏、待机、休眠等系统功能，同时在此你还可以添加你所以常用的软件应用，并且设置快捷键，从而能一键运行你所需的应用，让你使用是更加高效快捷。

[TurboLaunch](http://www.savardsoftware.com/turbolaunch/) 这个从WinXP时代就伴随左右的软件，这些年虽然没有更新，但在新时代依然有很强的生命力。建议启用安装包安装，因为它可以管理其它的Portable软件。

默认情况下，只有3个Tab，可以在选项中设置。提供批量导出配置备份为Reg的功能。

### Wox ###

[Wox](https://github.com/Wox-launcher/Wox) 是一个国人开发的开源项目，通过快捷键呼出搜索框，支持搜索、程序、书签等，通过插件还可以支持更多的搜索项。在Windows下实现类似于MacOS下软件Alfred2的效果。

如果说**TurboLaunch** 主要是利用鼠标的话，那么WOX就主要是键盘操作。

[Wox - 开源免费强大的快捷启动器辅助工具，快速高效率打开软件/搜索文件！](https://www.iplaysoft.com/wox.html)

### Everything 快速搜索 ###

利用NTFS的特性，快速检索系统的文件。官网有便携版的zip包下载，但在启动时会要求注册一个服务以开机自启动，这个服务可以为Wox识别调用，所以相当于安装版本。

[EveryThing 如何使用到极致](https://zhuanlan.zhihu.com/p/61334612)

### RocketDock ###

[RocketDock](https://punklabs.com/)实现MacOS中的Docker效果，这个工具跟 **TurboLaunch** 很类似，只是更加突出某些软件。当前基本上也不怎么更新了，跟收费的 Fence 软件一样用于减少桌面的软件图标。

![RocketDock](https://punklabs.com/images/projects/RocketDock-256.png)

[[美化] RocketDock – 微软Windows打造仿苹果MacOS工具列(任务栏)软件下载/使用教程](https://www.xiaoyuanjiu.com/6241.html)

### Ditto ####

Ditto 增强系统的剪切板，在[Windows 10 Build 17666版本更新中，微软正式为Windows 10引入了云剪切板功能](https://www.nruan.com/57814.html)通过Win+V快捷方式进行访问，支持100kb以内的纯文本、HTML以及小于1MB的图像，通过Win10内置的账号，可以达到两台Sharing的云剪切板效果。

### **Quicklook** ###

**QuickLook**是一款仿MacOS快速预览的小工具，装好之后，只要选中文件，按下键盘上的**空格键**，即可预览文件内容。

**QuickLook**支持文本、视频、音频、图片、压缩包、Office文档……，换句话说，你电脑上任何一款文件几乎都可以用它预览。同时你也可以点击预览窗右上角的按钮直接启动对应程序，非常方便。

当前有原生adm64位或Microsoft Store的UWP两个版本，因有**TurboLaunch** 管理开机启动项，就选用了adm64原生版本。

### WindowsTabs ###

[WindowTabs](https://github.com/mauricef/WindowTabs)以前是收费软件，在2018年的时候，被作者在github上开源了，但也怎么更新了，有个fork的库提供[二进制编译版本的下载](http://github.com/leafOfTree/WindowTabs/releases)。

[WindowsTabs.设置任意windows程序的多标签页使用](https://zhuanlan.zhihu.com/p/64850605)

### Quicker ###

quicker 是定位于工具类的中台，功能比较强大，暂时还为深入研究使用。

### Sandboxie ###

Sandboxie 提供一个跟当前操作系统隔离的沙盒环境，能够在这个环境里测试软件，破解软件、养病毒等。

沙盒技术在Win10中内置了后，迫使Sandboxie软件免费了。虽然网上有便携版本，但是既然要跟操作系统交互，还是使用安装版本比较放心。

[Win10大更新！Windows Sandbox沙盘功能验](https://zhuanlan.zhihu.com/p/53849618)

这个软件也给我们提供了一种绿化软件的思路，可以在Sandboxie 中安装，然后再拷贝回到宿主机上。

## 三. 系统维护 ##

### [aida64](https://www.aida64.com/) ###

Aida64是功能相当完整且实用的硬件规格检测工具，其实也不只硬件规格，一些作业系统方面、多媒体、网路与应用程式…等等相关信息也都可以查得一清二楚。

[aida64](https://www.aida64.com/) 有三个版本，差别不大，一般下载 Extreme （至尊旗舰版）即可，官方提供zip包，解压即可用。

这个[帖子](http://bbs.pcbeta.com/viewthread-1824307-1-1.html)提供了一些注册码，亲测可用。

```reStructuredText
FUUJ1-E3YDB-HTDTK-2D894-4BVAQ
4U12U-SDWD6-8WDNH-HDAM4-W3MZW
F5R3D-XUPD6-4TD9B-2D2L4-354AX
3H39D-ZFQD6-1ED96-UD274-RD44G
4U12U-SDWD6-8WDNH-HDAM4-W3MZW
```

### TreeSize ###

[TreeSize](https://jam-software.com/treesize_free/)跟[spacesniffer](http://www.uderzo.it/main_products/space_sniffer/)一样是以图形化的方式显示目录或文件的占用情况，通过这种方式可以非常直观地找出C盘的大文件占用情况，并有针对性的删除。

### PatchCleaner ###

如果C:\\Windows\Installer目录下通过TreeSize查看较大，需要清理时可以用[PatchCleaner](https://www.homedev.com.au/free/patchcleaner) 清理一下，说不定会跟清理大量垃圾。[PatchCleaner - 清理 Windows Installer 文件夹垃圾文件](https://c7sky.com/patchcleaner.html)

### DriverStoreExplorer ###

[DriverStoreExplorer](https://github.com/lostindark/DriverStoreExplorer/releases/) 给系统自带的pnputil做了个简单的图形界面，能够解决 [C:\Windows\System32\DriverStore](https://www.techcrises.com/windows-10/clean-filerepository-folder-in-driverstore/) 占用过多的问题。具体可以参考博文 [DriverStore.Explorer-Windows系统驱动核查清理专家](https://zhuanlan.zhihu.com/p/61398853)

## 四. 日常工作 ##

### WSL ###

在Windows上安装Linux，参考博文 [Win10 中 WSL 安装指北](http://westfly.github.io/post/windows/how-to-install-wsl-on-win10/)

### VSCode ###

VSCode 是新一代的编程工具。

### XShell ###

[XShell](http://www.netsarang.com/products/xmg_detail.html) 是 一款远程连接服务器的工具，从XShell4开始用到到Xshell6了，有些年头了。

[Xshell6的正确打开方式](https://zhuanlan.zhihu.com/p/80271262)

### TIM ###

专注于办公的QQ，比QQ少了很多的皮肤等功能。

### CTerm ###

作为上古时代的BBS神器，已经停止开发和维护了，但依然宝刀未老。

### Typora ###

一般 Markdown 编辑器（比如VSCode）界面都是两个窗口，左边是 Markdown 源码，右边是效果预览。有时一边写源码，一边看效果，确实有点不便。但是使用 Typora 可以实时的看到渲染效果，而且是在同一个界面，所见即所得。基于Nodejs开发的，所以程序比较大。

Typora 内置的快捷键一些快捷键能让书写更快便捷，支持富文本的拷贝。

Typora当前处于Beta免费版本，后续不排除收费的可能性，官方不提供zip版本下载，可以在沙盒中将安装。其默认的用户目录为 c:\Users\Rayan\AppData\Roaming\Typora，可以通过mklink软链到对于的目录，达到便携的目的。

## 五. 浏览器 ##

### Chrome ###

[GoogleChrome](http://www.google.cn/chrome/) 是由Google公司开发的网页浏览器，一经推出就迅速占领了浏览器市场，也带动了业界软件版本号的升级，当前已经升级到79了，不敢想象到了三位数的版本后该怎么办。

Google Chrome 虽然很好用，但在中国Google被屏蔽的情况下，其内置的服务不可用，安装的插件也只能采取离线的方式，但随着GoogleChrome屏蔽这种方式，门槛也越来越高。

有需求的地方，就有市场，这是颠簸不破的真理。国内双核浏览器、360浏览器等都基于Google Chrome做了定制，而且也有一定的市场。

### Firefox ###

作为用新一代系统级编程语言RustLang开发的应用软件Firefox，最近几年的市场份额被Chrome吃的厉害，从最高33%的市场份额跌倒10%。当前Firefox重视隐私，并且是完全开源的软件，给你完全的控制权限。

GoogleChrome并非完全的开源软件，只是其内核**Chromium**开源。

当时Firefox也需要有插件的配合才能发挥应有的效果，后续会写一篇Firefox的插件指南。

### EdgeOn**Chromium** ###

Windows 10 自带的浏览器 Edge，一直被大家戏称为“其他浏览器下载器”，因为新系统只用一次 Edge 浏览器，下载其他浏览器后，就再也不会主动打开 IE差不多退出互联网时代了。

微软于2018年12月宣布放弃自家 EdgeHTML 引擎的 Edge 浏览器，并立项开发一款基于 Chromium 内核的 Edge 浏览器作为 Windows 10 系统新的默认浏览器，经过一年多的开发，新版 Edge 浏览器已经基本成型，**微软计划在明年早期发布 Chromium Edge 正式版（预计在2020年1月15日）**

微软在当前浏览器大战中败了吗？借着Chrome的Blink内核又回来了。特别是针对国内Google被墙的情况下，微软提供的一些账号、历史、插件同步等功能，对国人来说有一定的吸引力。

如果好好发展，国内一些浏览器厂商应该会比较难受，当然当前PC的量也萎缩得非常厉害。

[墙内最好浏览器，微软带来完整版谷歌浏览器，扩展、同步无限制！](https://zhuanlan.zhihu.com/p/94247119)

## 六. 下载工具 ##

### IDM ###

强烈推荐IDM下载工具，多线程下载就是快。一般双十一会有活动，可以考虑99元以内入手，终身授权。当只支持HTTP、FTP等协议，在中国的网络环境下，不支持BT、磁力、迅雷等下载作用就少了一半。

所以在此之外，还需要额外的下载软件以满足日常的需求。

### [Aria2](https://aria2.github.io/) ###

Aria2是一个命令行下**轻量级**、多协议、多来源的**下载工具**（支持 **HTTP/HTTPS、FTP、BitTorrent**、**Metalink**），内建 **XML-RPC** 和 **JSON-RPC** 用户界面。

[AriaNg](http://ariang.mayswind.net/zh_Hans/) 是一个让 aria2 更容易使用的现代 Web 前端，可以下载[AriaNg Native](https://github.com/mayswind/AriaNg-Native) ，其内置浏览器，跟基于MFC或QT的应用程序无差别。

[抛弃迅雷，Aria2 新手入门](https://zhuanlan.zhihu.com/p/37021947)

[PanDownload](http://pandownload.com) 这个软件可以让你用百度网盘**不限速**下载软件，当然只是达到有速度。

这个软件可以免分享码地下载文件，对于某些音视频也无须转存到自己的网盘再下载，比较方便。

### BaiduPCS-Web ###

[BaiduPCS-Web](https://github.com/liuzhuoling2011/baidupcs-web) 是一个基于 BaiduPCS 命令行工具的Web界面。

### qBittorrent ###

[qBittorrent-Enhanced-Edition](https://github.com/c0re100/qBittorrent-Enhanced-Edition) 在当前中国网络环境下，只有迅雷之流有活下去的场景。

[为什么国内 BT 环境如此恶劣？下载速度如此糟糕？我总结了六点原因](https://zhuanlan.zhihu.com/p/87193566)

需要配合github上的Tracker更新才能有速度，但貌似也需要看具体的资源。

### Xdown ###

[Xdown](https://xdown.org/) 是新晋崛起的一款免费无广告的 IDM & Torrent 合成体下载软件。[Xdown](https://xdown.org/) 不但支持标准FTP/HTTP/HTTPS/HTTP2协议下载 ，[Xdown](https://xdown.org/) 还支持torrent/磁力链/百度云下载，功能十分强大，值得使用。



## 七. 影音娱乐 ##

### PotPlayer ###

软件更新比较快，基本上无损播放音视频，满足需求无问题。

### 爱奇艺 ###

UMP版本最为吸引人的地方，在于暂时还有广告的入侵。

### 网易云音乐 ###

UMP版本的已经好久没有更新了。
