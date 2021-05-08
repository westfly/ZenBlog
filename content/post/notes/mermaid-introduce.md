---
title: "利用 mermaid在Markdown中画图"
date: 2020-11-02T21:35:02+08:00
tags:
    - tools
categories:
comment: false
draft: false
---

[mermaid](https://mermaidjs.github.io/) 是一个简明的描述做图的文本描述语言

```reStructuredText
Generation of diagrams and flowcharts from text in a similar manner as markdown
```



##  基本用法 ##

如下的语法，可以在Typora下直接显示图形

### 图形 ###

```mermaid
graph LR
A--> B
```

LR表示方向，其它实例如下

| 缩写 | 含义     |
| ---- | -------- |
| TB   | 从上到下 |
| BT   | 从下到上 |
| RL   | 从右到左 |
| LR   | 从左到右 |
| TD   | 与TB相同 |

### 节点和形状 ###

```mermaid
graph TD
	start[开始] --> split((分割)) --> join(合并) --> endx>结束]
```

| 类别             |                |
| ---------------- | -------------- |
| start            | 默认文本节点   |
| start[开始]      | 文本节点       |
| start(开始)      | 圆边节点       |
| start((开始))    | 圆形节点       |
| start>开始]      | 非对称形状     |
| start{开始}      | 菱形节点       |
| A --> B          | 带箭头的连接   |
| A --- B          | 无箭头的连接   |
| A-.->B           | 虚线           |
| A ==> B          | 粗连接         |
| A -- 指向 --> B  | 连接注释       |
| A -- 指向 -- B   | 连接注释       |
| A -->\|指向\| B  |                |
| A -- \|指向\|B   |                |
| A-. 注释 .->B    | 虚线           |
| A ==  注释 ==> B | 带文本的粗连接 |

### 子图 ###



```
subgraph title
    graph definition
end
```





```mermaid
graph TD
    B["fa:fa-twitter 和平"]
    B-->C[fa:fa-ban 禁止]
    B-->D(fa:fa-spinner);
    B-->E(A fa:fa-camera-retro 也许?);
```





## 参考资料 ##

https://www.jianshu.com/p/af48cc77b57a

https://sspai.com/post/63055