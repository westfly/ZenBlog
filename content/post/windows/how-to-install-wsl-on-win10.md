---
title: "Win10 中 WSL 安装指北"
date: 2019-11-30T21:35:02+08:00
tags:
    - wsl
    - windows
categories:
    - windows
comment: false
draft: false
---
[WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)是“Windows Subsystem for Linux”的缩写，顾名思义，WSL就是Windows系统的Linux子系统，其作为Windows组件搭载在Windows10周年更新（1607）后的Windows系统中。

WSL是微软拥抱开源文化的一部分，一经发布就被誉为是最好的Linux发行版本。

本文从实用的角度，记录安装过程中的一些问题和解决方案。

## 1. 安装

网上的安装教程有很多，请[参考](https://github.com/iWangJiaxiang/WSL-Guideline/blob/master/WSL-Guideline/%E4%B8%AD%E6%96%87/02-%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE.md)。
主要步骤有如下三步
1. 控制面板>程序和功能>启用或关闭window功能>勾选“适用于Linux的Windows子系统”以启用WSL
2. Microsoft Store 安装Linux，比较成熟的版本是Ubuntu。
3. 在命令行中输入wls，配置用户名和密码（完全独立于Host，建议密码简单些）


这样你就得到了一个基本功能的 Ubuntu。


## 2. 管理
如果你有多个版本需要管理或者从旧机器迁移数据，[LxRunOffline](https://github.com/DDoSolitary/LxRunOffline) 工具是你的福音，能够实现版本的备份和回恢复，其使用方法也比较简单。
LxRunOffline 是免安装软件，解压出来添加到系统的Path中，在CMD下即可用，常用的命令
```shell
#查看所使用的系统
lxrunoffline list
# 将系统迁移到D盘
lxrunoffline move -n Debian -d D:\Debian
# 获取系统的目录
lxrunoffline get-dir -n Debian
```

## 3. 配置

得到一个Ubuntu 只是一个初步的环境，为了能够用起来，还需要一些基本的配置。

### 3.1 更新源
Ubuntu的官方更新源，在国内访问不是很快，推荐更新到阿里云提供的更新源，[具体的方法](https://www.sunzhongwei.com/modify-the-wsl-ubuntu-1804-default-source-for-ali-cloud-images)为
切换到 root，修改 source.list
```shell
sudo su
# vim 打开直接用替换命令
vim /etc/apt/source.list
# %s/archive.ubuntu.com/mirrors.aliyun.com/g
# %s/security.ubuntu.com/mirrors.aliyun.com/g
sudo apt update     #更新软件源
apt-get upgrade     # 更新整个系统的安装包
```

如果有需要确认的，输入Y或者Enter即可。一般会经过一个Linux系统的Reboot过程。

可以通过 uname 查看当前系统的版本

```shell
uname -a
lsb_release -a
```

### 3.2 配置Xshell登陆

因为Win10自带的终端CMD功能比较弱，推荐使用XShell或类似的软件进行登陆WSL系统。

首先需要在WSL系统中启用SSHD服务进程，某些博客文章中说，Windows自带了openssh.exe客户端，需要卸载，并在Ubuntu中重新安装openssh。笔者并未卸载，用默认的貌似也行，具体如下

```shell
#使用vim进行编辑，按i进入insert模式
sudo vim /etc/ssh/sshd_config
#在vim中分别找到并对应修改
Port = 2222                  # 默认是 22
ListenAddress 0.0.0.0        # 如果需要指定监听的IP则去除最左侧的井号，并配置对应IP，默认即监听PC所有IP
PasswordAuthentication yes    # 将 no 改为 yes 表示使用帐号密码方式登录
service ssh start             #启动SSH服务
service ssh status            #检查状态
```

再用xshell使用用户名和密码登陆即可，具体的xshell配置就不赘述了。

这种情况下，每次登陆Windows后，无法用XShell直接登陆Ubuntu，每次需要用cmd.exe 使用wsl命令登陆Ubuntu，先启用sshd服务，再用XShell登陆。

```shell
sudo service ssh --full-restart 
```

多次尝试后，[找到一种通过VBScript方式配置开机自启动](https://gist.github.com/dentechy/de2be62b55cfd234681921d5a8b6be11)，具体脚本如下

```vbscript
Set wshell=wscript.createobject("wscript.shell")
wshell.run "C:\Windows\System32\bash.exe",0
wshell.run "C:\Windows\System32\bash.exe  -c 'sudo /usr/sbin/service ssh start'",0
Set wshell=Nothing
```
把这个脚本放到TurboLanch的开机自启动进程中即可，[理论上也可以通过设置计划等方式实现](https://www.cnblogs.com/slqt/p/10603973.html)，但笔者并未成功，有兴趣的可以尝试一下。
### 3.3 更新系统

系统默认安装的为长期支持的系统版本18.04，如果你希望尝试更新的系统（意味着更新的工具链），可以试试如下的步骤

```shell
# 修改Prompt=lts 为 Prompt=normal
vim /etc/update-manager/release-upgrades
sudo do-release-upgrade # 更新
```

注意 do-release-upgrade 不能在xshell中执行，因为更新的过程中不能保证ssh服务是OK的。

建议在cmd 中执行 wsl，登陆到系统后再执行 do-release-upgrade 。经过一系列的确认之后，重启“机器”即可。

```shell
#在Windows下，用管理员权限打开PowerShell，执行
Restart-Service LxssManager
#再次进入系统查看版本情况
lbs_release -a 
```

这种方法只能一个个版本的升级，从18.04不能直接升级到19.10版本，必须经过19.04。

### 3.4 图形界面
个人认为图形界面不太需要，有兴趣的可以参考如下文章进行尝试
[玩转 WSL 并配置Linux下的开发调试环境(Linux初学者福音) - 知乎](https://zhuanlan.zhihu.com/p/49227132)

### 3.5 开发环境

这一节的配置自己的开发需求进行安装，作为后端开发，一般需要安装如下
```shell
function install
{
   package_list="tmux cmake zsh silversearcher-ag"
   clang_package_list="cppcheck build-essential xz-utils curl"
   package_list=$(print "%s %s" $package_list $clang_package_list)
   for file in ${package_list[@]}
   do
	echo $file
	echo "y" | sudo apt-get install $file
   done
}
install
```
后续可以根据需要再添加。

#### 3.5.1 clang

高版本的clang安装主要是把已经编译的二进制包下载并解压到某个目录下即可，
详细可以参考[Linux and WSL - Install Clang 9 with libc++ and compile C++17 and C++20 programs](https://solarianprogrammer.com/2017/12/13/linux-wsl-install-clang-libcpp-compile-cpp-17-programs/)

笔者为了不污染系统环境和迁移数据方便，设置了 Portable 目录，系统启动的时候会自动加载 load_env 函数，将放置其中的 clang/bin自动添加到[PATH](https://en.wikipedia.org/wiki/PATH_(variable))中，具体脚本如下。
```shell
function load_env() {
  local deploy=$1
  for dir in $(ls $deploy)
  do
    bin=$deploy/$dir/bin
    if [ -d $bin ];then
        PATH=$bin:$PATH
    fi
    lib=$deploy/$dir/lib
    if [ -d $lib ];then
        LD_LIBRARY_PATH=$lib:$LD_LIBRARY_PATH
    fi
  done
}
export PortableEnv=/home/aresyang/Env
PATH="/usr/local/bin:"$PATH
load_env $PortableEnv
export PATH
export LD_LIBRARY_PATH
```
load_env 只支持一级目录遍历，也可以通过
find 目录支持多级的bin的遍历。
#### 3.5.2 golang

golang的安装比较简单，只需要从官方网站下载最新的linux版本，然后解压到上文中提到的 Portable 目录即可。

```
export GOROOT=${$(which go)%/bin/go}
export GOPAHT=$GOROOT/3rdparty
```
考虑到GOPATH有特殊的含义。


#### 3.5.3 rust-lang
[rust的安装](https://www.rust-lang.org/tools/install) 比较傻瓜化。
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
其会在HOME目录下建立 .rustup & .cargo 两个目录。
今后的更新操作可以使用rustup操作即可。

笔者也尝试过 按照 golang的方式解压到 Portable目录，基本上可行，但冗余的文件比较多。




### 3.6 配置vscode
都9102年了，可以尝试新的东西了。当前vs的版本有Remote功能，在应用市场搜索wsl，安装 Remote-WSL，可以在Windows下的VSCode中打开Ubuntu，一般情况下，直接Reload了就可以用。可以参考另外一篇文章，笔者推荐了些常用你的插件。



### 3.7 配置vim
一般情况下，我们可以通过vscode的vim插件进行即可，不需要直接配置vim，如果需要配置vim，笔者建议使用 SpaceVim。
```shell
curl -sLf https://spacevim.org/cn/install.sh | bash
```
## 4. 参考文档


[官方WSL-Wiki](https://wiki.ubuntu.com/WSL)

[wsl升级到Ubuntu19.04](https://medium.com/@rockey5520/wsl-ubuntu-upgrade-to-disco-dingo-19-04-b4abff20452d)