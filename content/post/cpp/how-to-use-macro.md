---
title: "C++中的宏使用方法及代码赏析"
date: 2020-05-14T20:35:02+08:00
tags:
    - c++17
    - reflection
categories:
    - cpp
comment: false
draft:  false
---

宏比较重要，缺点是类型丢失，不好调试。

一般用法，函数替代



## 1. 基本用法 ##

### 1.1 宏替换 ###

宏最常见的引用就是代码替换，比如定义常量，定义宏函数

```cpp
#define MAX_BUFFER_SIZE 10240
# 带参数
#define MAX(a,b) ((a) > (b)? (a) : (b))
```



### 1.2 Token转字符串 ###

\# 实现token到字符串的转变

在 boost pp 库中，xx的实现就是

### 1.3 连接符 ###

\## 则连接标识，将两个token合并为一个

## 2. 应用 ##

### 2.1 定义日志 ###

```cpp
#define warn(...)                                       \
    __warn(__FILE__, __LINE__, __VA_ARGS__)

#define panic(...)                                      \
    __panic(__FILE__, __LINE__, __VA_ARGS__)
```





### 2.2 定义代码块 ###

介绍的是定义代码块，以伪造函数

```cpp
do { 			\
    			\
} while(0)
```

### 2.3 定义类 ###

我们还可以定义一个类。这个类



```
xxx
```



### 2.2 简化命令 ###

\# 实现token到字符串的转变，而 \## 则是连接标识，将两个token合并为一个。

```cpp
#define COMMAND(NAME)  { #NAME, NAME ## _command }
struct command {
    char *name;
    void (*function) (void);
};
```

使用时

```cpp
struct command commands[] = {
    COMMAND (quit),
    COMMAND (help),
	...
};
// 编译器展开为
struct command commands[] = {
    { "quit", quit_command },
    { "help", help_command },
    ...
};

```

可以实现枚举到XX的转换

https://en.wikipedia.org/wiki/X_Macro

简化条件语句





基本上讲解宏就到此为止了。



