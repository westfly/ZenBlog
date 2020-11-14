

## 单机版 ##

### CPU密集 ###

### IO密集 ###

#### vmstat ####

vmstat（Virtual Meomory Statistics）——虚拟内存统计，可对操作系统的虚拟内存、进程、CPU活动进行监控。他是对系统的整体情况进行统计，不足之处是无法对某个进程进行深入分析。

```shell
vmstat [-a] [-n] [-S unit] [delay [ count]]
vmstat [-s] [-n] [-S unit]
vmstat [-m] [-n] [delay [ count]]
vmstat [-d] [-n] [delay [ count]]
vmstat [-p disk partition] [-n] [delay [ count]]
vmstat [-f]
vmstat [-V]
```

参数详解

```
-a：显示活跃和非活跃内存
-f：显示从系统启动至今的fork数量 。
-m：显示slabinfo
-n：只在开始时显示一次各字段名称。
-s：显示内存相关统计信息及多种系统活动数量。
delay：刷新时间间隔。如果不指定，只显示一条结果。
count：刷新次数。如果不指定刷新次数，但指定了刷新时间间隔，这时刷新次数为无穷。
-d：显示磁盘相关统计信息。
-p：显示指定磁盘分区统计信息
-S：使用指定单位显示。参数有 k 、K 、m 、M ，默认单位为K
-V：显示vmstat版本信息。
```



```shell
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
```



|                  |                                                              |
| ---------------- | ------------------------------------------------------------ |
| Procs（进程）：  | r: 运行队列中进程数量                                        |
|                  | b: 等待IO的进程数量                                          |
| Memory（内存）： | swpd: 使用虚拟内存大小                                       |
|                  | free: 可用内存大小                                           |
|                  | buff: 用作缓冲的内存大小                                     |
|                  | cache: 用作缓存的内存大小                                    |
| Swap：           | si: 每秒从交换区写到内存的大小                               |
|                  | so: 每秒写入交换区的内存大小                                 |
|                  | IO：（现在的Linux版本块的大小为1024bytes）                   |
|                  | bi: 每秒读取的块数                                           |
|                  | bo: 每秒写入的块数                                           |
| 系统：           | in: 每秒中断数，包括时钟中断。                               |
|                  | cs: 每秒上下文切换数。                                       |
|                  | CPU（以百分比表示）：                                        |
|                  | us: 用户进程执行时间(user time)                              |
|                  | sy: 系统进程执行时间(system time)                            |
|                  | id: 空闲时间(包括IO等待时间),中央处理器的空闲时间 。以百分比表示。 |
|                  | wa: 等待IO时间                                               |





#### iostat ####









