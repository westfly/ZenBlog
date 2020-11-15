---
title: "gcc-gdb技巧"
date: 2020-01-07T21:35:02+08:00
tags:
    - c++17
categories:
    - cpp
comment: false
draft: true
---

## 1. GCC ##

### 1.1 信息显示 ###

```shell
gcc -dM -E - < /dev/null
echo | gcc -dM -E -
gcc -fdiagnostics-color f.cpp # 彩色错误提示 默认开启
```

### 1.2 预定义宏 ###

```shell
gcc -DDEBUG macro.c
gcc -DDEBUG=ON macro.c
#取消宏
gcc -UDEBUG macro.c
```

### 1.3 Address Sanitizer ###

gcc从`4.8`版本起，集成了`Address Sanitizer`工具，可以用来检查内存访问的错误（编译时指定`-fsanitize=address”）

### 1.4 Thread Sanitizer ###

-fsanitize=thread -fPIE -pie

## 2. GDB ##

gdb是调试的利器

```shell
gdb -d # 源码的目录
```

#### 2.1 STL调试支持  ####

```
wget http://www.yolinux.com/TUTORIALS/src/dbinit_stl_views-1.03.txt
cat $ >> ~/.gdbinit
```

http://www.yolinux.com/TUTORIALS/src/dbinit_stl_views-1.03.txt 

或者gdb 后，source一下加载之

```shell
pmap variable------------>打印variable这个map的定义和map里面的个数
pmap variable int  int (就是单纯的两个int) ------------>打印pmap的元素和map的个数
pmap variable int int 20------------>打印索引是20的map的值 和map的个数
pmap variable int int 20 200------->打印索引是20 值是200的map值和map的个数
```

#### 2.2  STL 支持 ####

在4.8之后的版本，内建了GBD的支持



参考资料

https://sourceware.org/gdb/wiki/STLSupport