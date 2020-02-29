---
title: "利用consul进行数据更新"
date: 2019-11-30T21:34:58+08:00
tags:
    - consul online
categories:
    - arch
comment: false
draft: true
---

## 背景 ##



## 架构 ##

### Consul ###

[Consul](https://www.consul.io/) 是一个用来实现分布式系统服务发现与配置的开源工具。它内置了服务注册与发现框架、分布一致性协议实现、健康检查、Key/Value存储、多数据中心方案，不再需要依赖其他工具（比如 ZooKeeper 等），使用起来也较为简单。

Consul 本质上说是将分布式的问题单独剥离出来，通过数据

是Go实现的。

解决分布式锁

#### KV 存储 ####

[Consul KV HTTP API](https://www.consul.io/api/kv.html)

Consul提供一个简单的KV存储，可以通过命令行访问

```shell
# put
consul kv put spacename/mlflow/lr_model LRModelSparse
# get
consul kv get spacename/mlflow/lr_model
consul kv get -detailed spacename/mlflow/lr_model
## 递归Get获取
consul kv get -recurse spacename/mlflow
consul kv get -detailed -recurse spacename/mlflow
# modify
# delete
```



#### Watch ####

Watch 是

WebUI

提供一个简单的WebUI，支持在UI上。

#### HTTP ####

consul 不提供第三方的SDK，通过提供HTTP接口，返回JSON格式串。

一把包括两个接口

```shell
#递归接口
#单独接口
```

用户需要自己解析JSON。

对于递归的接口，用户需要自己保存变化。

可以通过modify-index 字段标识。

这种变化的保存。



### 多机房 ###





### OnlineUpdate ###

在线服务的数据更新跟业务的场景有很大的关系，笔者所知一般有如下场景

有些在线服务存在天级别的重启，在重启前更新大量的数据，如物料（或素材）

有些数据是小时级别的全量，每小时生效一次，如策略模型数据。

有些数据实时更新，通过消息中间件来更新消息，如物料的在线索引，屏蔽规则等。

#### Lock ####

对于一些细粒度的场景，我们单独通过一个线程去加载数据，然后通过加锁的方式，将数据Swap到线上，为了。

```cpp
void Update(const std::string& filename) {
    IndexedBuilder online_builder;
    SyncFromFile(filename, &online_builder);
    {
        Lock write_lock(&mutex);
        online_builder.Swap(&curr_builder);
    }
    ...
}
void GetIndex() {
    Lock read_lock(&mutex);
}

```



#### 引用计数 ####



## 支持 ##







