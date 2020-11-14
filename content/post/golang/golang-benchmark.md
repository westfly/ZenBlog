---
title: "后端程序员的VSCode插件配置"
date: 2019-12-02T21:35:02+08:00
tags:
    - vscode
    - windows
categories:
    - windows
comment: false
draft: true
---

```go
func BenchmarkSprintf(b *testing.B){
	num:=10
	b.ResetTimer()
	for i:=0;i<b.N;i++{
		fmt.Sprintf("%d",num)
	}
}
```

1. 基准测试的代码文件必须以_test.go结尾
2. 基准测试的函数必须以Benchmark开头，必须是可导出的
3. 基准测试函数必须接受一个指向Benchmark类型的指针作为唯一参数
4. 基准测试函数不能有返回值
5. b.ResetTimer是重置计时器，这样可以避免for循环之前的初始化代码的干扰
6. 最后的for循环很重要，被测试的代码要放到循环里
7. b.N是基准测试框架提供的，表示循环的次数，因为需要反复调用测试的代码，才可以评估性能

https://my.oschina.net/solate/blog/3034188



https://blog.cong.moe/post/2020-07-28-sync_github_fork/





