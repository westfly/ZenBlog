---
title: "非法指令导致Core"
date: 2020-03-23T21:35:02+08:00
tags:
    - debug
    - c++
categories:
    - arch
comment: false
draft: false
---

最近线上服务上线过程中，某些机器遇到 mxnet 非法指令的bug，通过汇编语言，显示是andn指令无法识别，如下图所示。

![andn](andn.jpg)

[查看 x86 Assembly Documentation](https://hjlebbink.github.io/x86doc/) 的文档，最后一列是CPU指令集合，发现 属于BMI1 。

到对应的linux机器上，查看cpu所有支持的指令集，注意查看flags选项的输出

```shell
cat /proc/cpuinfo |grep flags
```

```shell
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology cpuid pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm cpuid_fault pti fsgsbase smep erms xsaveopt
```

发现没有BMI1指令集支持，可能要换机器，或添加编译的arch，减少该指令的使用。
