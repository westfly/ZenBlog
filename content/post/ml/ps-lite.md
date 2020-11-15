---
title: "ps-lite学习笔记"
date: 2019-12-02T21:35:02+08:00
tags:
    - vscode
    - windows
categories:
    - windows
comment: false
draft: true
---



## ps-lite中的三种角色 ##

- worker：从事计算和读取数据的节点；
- server：储存模型参数的节点，每个node一般存储模型参数的一部分；
- scheduler：监控节点运行状态的节点，只有一个scheduler；



![【Tech1】简洁的参数服务器：ps-lite解析](E:\WorkSpace\github\ZenBlog\static\post\windows\ps-lite\v2-d6ae95eb5f05bd35cb274082d746b590_1440w.jpg)



![img](E:\WorkSpace\github\ZenBlog\static\post\windows\ps-lite\v2-06e6454a97107684a99ded13c4c8f75d_1440w.jpg)

