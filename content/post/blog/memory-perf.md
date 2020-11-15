---
title: "内存perf"
date: 2019-12-02T21:35:02+08:00
tags:
    - vscode
    - windows
categories:
    - windows
comment: false
draft: true
---



TCMalloc全称Thread-Caching Malloc，即线程缓存的malloc，实现了高效的多线程内存管理，用于替代系统的内存分配相关的函数。



TCMalloc是[gperftools](https://github.com/gperftools/gperftools)的一部分，除TCMalloc外，gperftools还包括heap-checker、heap-profiler和cpu-profiler。



### 编译安装 ###

```shell
sudo apt install autoconf automake libtool
./autogen.sh
./configure --prefix=/usr/local
make -j8 && make
make install
```

官方[INSTALL](https://github.com/gperftools/gperftools/blob/master/INSTALL)安装文档提到，在64位Linux环境下，gperftools使用glibc内置的stack-unwinder可能会引发死锁，因此官方推荐在配置和安装gperftools之前，先安装[libunwind-0.99-beta](https://link.zhihu.com/?target=http%3A//download.savannah.gnu.org/releases/libunwind/libunwind-0.99-beta.tar.gz)，最好就用这个版本，版本太新或太旧都可能会有问题。





