



## perf ##

 Perf是Linux kernel自带的系统性能优化工具。Perf的优势在于与linux Kernel的紧密结合，它可以最先应用到加入Kernel的new feature。

性能调优工具如 perf，Oprofile 等的基本原理都是对被监测对象进行采样，最简单的情形是根据 tick 中断进行采样，即在 tick 中断内触发采样点，在采样点里判断程序当时的上下文。假如一个程序 90% 的时间都花费在函数 foo() 上，那么 90% 的采样点都应该落在函数 foo() 的上下文中。运气不可捉摸，但我想只要采样频率足够高，采样时间足够长，那么以上推论就比较可靠。因此，通过 tick 触发采样，我们便可以了解程序中哪些地方最耗时间，从而重点分析。



每隔一个固定的时间，就在CPU上（每个核上都有）产生一个中断，在中断上看看，当前是哪个pid，哪个函数，然后给对应的pid和函数加一个统计值，这样，我们就知道CPU有百分几的时间在某个pid，或者某个函数上了.

![img](E:\WorkSpace\github\ZenBlog\static\post\windows\gperf-tools\9a1cce72e02b748c02d182d56dc5df40_b.jpg)



有些程序慢是因为计算量太大，其多数时间都应该在使用 CPU 进行计算，这叫做 CPU bound 型；有些程序慢是因为过多的 IO，这种时候其 CPU 利用率应该不高，这叫做 IO bound 型；对于 CPU bound 程序的调优和 IO bound 的调优是不同的



Task-clock-msecs：CPU 利用率，该值高，说明程序的多数时间花费在 CPU 计算上而非 IO。

Context-switches：进程切换次数，记录了程序运行过程中发生了多少次进程切换，频繁的进程切换是应该避免的。

Cache-misses：程序运行过程中总体的 cache 利用情况，如果该值过高，说明程序的 cache 利用不好

CPU-migrations：表示进程 t1 运行过程中发生了多少次 CPU 迁移，即被调度器从一个 CPU 转移到另外一个 CPU 上运行。

Cycles：处理器时钟，一条机器指令可能需要多个 cycles，

Instructions: 机器指令数目。

IPC：是 Instructions/Cycles 的比值，该值越大越好，说明程序充分利用了处理器的特性。

Cache-references: cache 命中的次数

Cache-misses: cache 失效的次数。



```
# 硬件（CPU 中的 Performance Monitor Unit）指标
branch-instructions      # 执行的跳转指令数
branch-misses            # 分支预测失败数
bus-cycles               # 不知道……（以下用 - 代替）
cache-misses             # 缓存未命中
cache-references         # 缓存访问数
cpu-cycles or cycles     # CPU 时钟周期数
instructions             # 执行的指令数
ref-cycles               # - （跟 bus-cycles 有些乱糟的关系）
stalled-cycles-frontend  # CPU 前端等待（前端是指取指/译码、分支预测、访存等等东西，后端是指执行指令的过程）

# 软件指标
alignment-faults        # 对齐错误，x86/x64 会自动处理访存不对齐，所以不用关注
bpf-output              # 跟 eBPF 有关，不知道是干啥的
context-switches or cs  # 上下文切换数（程序被调度走了）
cpu-clock               # CPU 时钟（这里是软件统计的，不如上面的准)
cpu-migrations          # CPU 迁移（程序从 CPU1 执行，但是被调度到 CPU2 上去了）
dummy                   # -
emulation-faults        # -
major-faults            # 主要缺页错误（需要的页不在内存中，要去磁盘上取出再填进去）
minor-faults            # 次要缺页错误（需要的页在内存中，只是缺页表项，填上页表项就好了）
page-faults OR faults   # == major-faults + minor-faults
task-clock              # -

# 硬件指标（Hardware cache event）
L1-dcache-load-misses      # L1 数据缓存未命中
L1-dcache-loads            # L1 数据缓存访问数
L1-dcache-prefetch-misses  # L1 数据缓存预取未命中
L1-dcache-store-misses     # L1 数据缓存RFO未命中（RFO: read-for-ownership，读取并且失效这个缓存）
L1-dcache-stores           # L1 数据缓存RFO
L1-icache-load-misses      # L1 指令缓存未命中
LLC-load-misses            # LLC: Last Level Cache，即 L2/L3 缓存。
LLC-loads                  # 这些根据上面的说明看名子应该能知道是什么
LLC-prefetch-misses        # 就不再一个个解释了
LLC-prefetches             #
LLC-store-misses           #
LLC-stores                 #
branch-load-misses         # BPU 缓存未命中（BPU：Branch Processing Unit)
branch-loads               # 与分支预测有关的缓存
dTLB-load-misses           # 数据 TLB 缓存未命中（TLB: Translation Lookaside Buffer）
dTLB-loads                 # TLB 是页表的缓存，用来加速虚拟地址->物理地址(VA->PA)转换的
dTLB-store-misses          # 同不一个个解释了……
dTLB-stores                #
iTLB-load-misses           # 指令 TLB 缓存未命中
iTLB-loads                 #
node-load-misses           # 本地访存未命中，需要跨 NUMA node（其实就是 CPU）访存 
node-loads                 # 访存数（这里访存数跟 LLC miss 对不上号，因为 LLC miss 后可能会跨 core 取到缓存）
node-prefetch-misses       #
node-prefetches            #
node-store-misses          #
node-stores                #
```



```shell
perf top  -e cache-misses -p ${pid}

perf top 
```



[使用 perf 进行性能分析时如何获取准确的调用栈](https://gaomf.cn/2019/10/30/perf_stack_traceback/)

```shell
 function record() {
 	pid=$(ps aux |grep bin/nginx |grep -v grep | awk '{print $2}')
   	perf record -e cpu-clock -F 99 -p $pid --call-graph dwarf -- sleep 10
 }
 function report() {
   file=$1
   perf report --show-total-period -i $file
}
record
sleep 2
report perf.data
```



```
http://www.ibm.com/developerworks/cn/linux/l-cn-perf1/
http://www.ibm.com/developerworks/cn/linux/l-cn-perf2/
https://perf.wiki.kernel.org/index.php/Tutorial
http://lwn.net/Articles/339361/
http://linuxplumbersconf.org/2009/slides/Arnaldo-Carvalho-de-Melo-perf.pdf
```







## gperf ##

```cpp
#include <gperftools/profiler.h>
//....
int main(int argc, const char* argv[])
{
	ProfilerStart("test_capture.prof");
	//.....
	ProfilerStop();
}

```

