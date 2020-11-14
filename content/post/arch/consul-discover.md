---
title: "consul 服务发现"
date: 2019-11-30T21:35:02+08:00
tags:
    - discover
    - consul
categories:
    - arch
comment: false
draft: true

---

## 背景 ##

在分布式架构中，服务治理是必须面对的问题，如果缺乏简单有效治理方案，各服务之间只能通过人肉配置的方式进行服务关系管理，当遇到服务关系变化时，就会变得极其麻烦且容易出错。

[Consul](https://www.consul.io/) 是一个用来实现分布式系统服务发现与配置的开源工具。它内置了服务注册与发现框架、分布一致性协议实现、健康检查、Key/Value存储、多数据中心方案，不再需要依赖其他工具（比如 ZooKeeper 等），使用起来也较为简单。

consul是使用go语言开发的服务发现、配置管理中心服务。内置了服务注册与发现框 架、分布一致性协议实现、健康检查、Key/Value存储、多数据中心方案

## etcd ##

## Envoy ##

## consul  ##

### 简介 ###

consul 提供的功能有

1. 通过DNS或HTTP，应用能轻易地找到它们依赖的系统
2. 提供了多种健康检查方式：http返回码200，内存是否超限，tcp连接是否成功
3. kv存储，并提供http api
4. 多数据中心，这点是zookeeper所不具备的。



### 架构图 ###

![Consul 架构图](http://beckjin.com/img/aspnet-consul-discovery/arch.png)

### Watch ###

支持如下类型：

Key – 监视指定K/V键值对
Keyprefix – Watch a prefix in the KV store
Services – 监视服务列表
nodes – 监控节点列表
service – 监视服务实例
checks- 监视健康检查的值
event – 监视用户事件



### 服务发现 ###







| Key                                      | 含义                                                         |
| ---------------------------------------- | ------------------------------------------------------------ |
| /v1/agent/checks                         | 返回本地agent注册的所有检查(包括配置文件和HTTP接口)          |
| /v1/agent/services                       | 返回本地agent注册的所有 服务                                 |
| /v1/agent/members                        | 返回agent在集群的gossip pool中看到的成员                     |
| /v1/agent/self                           | 返回本地agent的配置和成员信息                                |
| /v1/agent/join/<address>                 | 触发本地agent加入node                                        |
| /v1/agent/force-leave/<node>             | 强制删除node                                                 |
| /v1/agent/check/register                 | 在本地agent增加一个检查项，使用PUT方法传输一个json格式的数据 |
| /v1/agent/check/deregister/<checkID>     | 注销一个本地agent的检查项                                    |
| /v1/agent/check/pass/<checkID>           | 设置一个本地检查项的状态为passing                            |
| /v1/agent/check/warn/<checkID>           | 设置一个本地检查项的状态为warning                            |
| /v1/agent/check/fail/<checkID>           | 设置一个本地检查项的状态为critical                           |
| /v1/agent/service/register               | 在本地agent增加一个服务项，使用PUT方法传输一个json格式的数据 |
| /v1/agent/service/deregister/<serviceID> | 注销一个本地agent的服务项                                    |

```shell
json_service_fmt='{"id":"node-%s-test","name":"rs-monitor","address":"%s","port":%s,"tags":["rs","monitor"],"checks":[{"http":"http://%s:%s/metrics","interval":"35s"}]}'
data=$(printf $json_service_fmt $ip $ip $port $ip $port)
```













### 实践 ###



多云的同步



## 参考资料 ##

[.NET Core + Consul 服务注册与发现](http://beckjin.com/2019/05/18/aspnet-consul-discovery)

[服务发现框架选型，Consul还是Zookeeper还是etcd](https://www.servercoder.com/2018/03/30/consul-vs-zookeeper-etcd/)