---
title: "golang 学习笔记"
date: 2020-03-01T21:35:02+08:00
tags:
    - go
    - notes
categories:
    - go
comment: false
draft: true
---

## 编译环境 ##

[环境变量](https://golang.org/cmd/go/#hdr-GOPATH_environment_variable) 可以参考如下

### GOROOT ###

GOROOT 一般是安装路径。

GOROOT/bin 需要手工添加到系统的PATH中去，用于在任意地方执行go的相关命令。

### GOPATH ###

GOPATH 是工作目录，可以有多个。在go get的时候，会下载到第一个工作目录中去。一个完整的工作目录有
```shell
go   // (GOPATH目录)
-- bin // golang 编译可执行文件存放路径
-- pkg // golang编译包时，生成的.a文件存放路径
-- src // 源码路径。按照golang默认约定，go run，go install等命令的当前工作路径
```

### build ###

go build命令用于编译我们指定的源码文件或代码包以及它们的依赖包。

### get ###
go get 从网络获取包，其组织方式参考后面的

### install ###
go install 会生成可执行文件直接放到bin目录下，这个需要定义环境变量GOBIN。

##  基础语法 ##

### 命名 ###

Go语言中的函数名、变量名、常量名、类型名、语句标号和包名等所有的命名，都遵循一个简单的命名规则：一个名字必须以一个字母（Unicode字母）或下划线开头，后面可以跟任意数量的字母、数字或下划线。区分大小写。

这点跟C中是一致的。

名字的长度没有逻辑限制，但是Go语言的风格是尽量使用短小的名字，如i，j，k，

对于作用域较大的建议使用长变量名，表示其含义。

在习惯上，Go语言程序员推荐使用 驼峰式 命名，即变量中的单词优先使用大小写分隔，而不是优先用下划线分隔。因此，在标准库有QuoteRuneToASCII和parseRequestLine这样的函数命名，但是一般不会用quote_rune_to_ASCII和parse_request_line这样的命名。

### 关键字 ###

关键字不能用做变量，有特殊含义，主要有如下25个。



```go
break   default    func   interface  select
case    defer     go    map     struct
chan    else     goto   package   switch
const   fallthrough  if    range    type
continue  for      import  return   var
```



### 预定义名称

预定义名称也不能用作关键字。

```go

内建常量: true false iota nil
内建类型: int int8 int16 int32 int64
​     uint uint8 uint16 uint32 uint64 uintptr
​     float32 float64 complex128 complex64
​     bool byte rune string error
内建函数: make len cap new append copy close delete
​     complex real imag
​     panic recover
```

### 流程控制

在一般的语言中，至少支持三种流程控制。

#### 顺序 ####

c系的语言，默认都是顺序执行的。这个跟计算机底层的执行模型有关。


#### 分支判断 ####

分支

#### 循环 ####

go扩展了c中的for语法，能够完美支持while等语义。

```go
for initialization; condition; post {
  // zero or more statements
}
// a traditional "while" loop
for condition {
  // ...
}
for { // while(true)
  // ...
}

```

#### range ####

```go

```

##  数据结构 ##

### 内建类型 ###



#### 整形 ####

Go语言同时提供了有符号和无符号类型的整数运算。这里有int8、int16、int32和int64四种截然不同大小的有符号整数类型，分别对应8、16、32、64bit大小的有符号整数，与此对应的是uint8、uint16、uint32和uint64四种无符号整数类型。

还有两种一般对应特定CPU平台机器字大小的有符号和无符号整数int和uint；其中int是应用最广泛的数值类型。这两种类型都有同样的大小，32或64bit。



Unicode字符rune类型是和int32等价的类型，通常用于表示一个Unicode码点。这两个名称可以互换使用。同样byte也是uint8类型的等价类型，byte类型一般用于强调数值是一个原始的数据而不是一个小的整数

#### 浮点 ####

Go语言提供了两种精度的浮点数，float32和float64。它们的算术规范由IEEE754浮点数国际标准定义，该浮点数规范被所有现代的CPU支持。一个float32类型的浮点数可以提供大约6个十进制数的精度，而float64则可以提供约15个十进制数的精度；通常应该优先使用float64类型。

#### 复数 ####

Go语言提供了两种精度的复数类型：complex64和complex128，分别对应float32和float64两种浮点数精度。内置的complex函数用于构建复数，内建的real和imag函数分别返回复数的实部和虚部。



#### 布尔型 ####

取值为true或false，类型名为bool



#### 字符串 ####

一个字符串是一个*\*不可改变\的字节序列。字符串可以包含任意的数据，包括byte值0，但是通常是用来包含人类可读的文本。

https://i6448038.github.io/2018/08/11/array-and-slice-principle/





## 特性 ## 

### 命令行参数 ###

os.Args变量是一个字符串（string）的切片（slice），跟C 语言一样。
os.Args[0]表示程序自己的名称。

```go
for i := 1; i < len(os.Args); i++ {
  s += sep + os.Args[i]
  sep = " "
}
```


### reflection ###

[Golang Reflection](https://www.jianshu.com/p/0d346577d32f)

[goreflection 实践](https://lihaoquan.me/2018/5/4/reflect-action.html)

"reflect"包下主要是Type和Value两个struct：

  * Type 封装了"类型"的属性，定义与类型相关的东西
  * Value 主要封装了"值"的属性，与值相关的东西找他没错。此外，它是线程（goroutine）安全的
Type 
  * Type 包含 static type 和 concrete type
  * static type 可以理解为用户或推导出的类型，如 (string int)
  * concrete type 是 runtime 系统看见的类型，跟上下文有关

类型推断跟 concrete type 有关，反射主要与Golang 的 interface 类型相关，只有interface类型才有反射一说。



```go

type Class struct {
  Name  string  `json:"name"`
  Student *Student `json:"student"`
  Grade  int   `json:"grade"`
  school string  `json:"school"` 
}
type Student struct {
  Name string `json:"name"`
  Age int  `json:"age"`
}
```

遍历

```go
func Traval(obj {}interface) {
  t := reflect.TypeOf(obj)
  v := reflect.ValueOf(obj)
  for i := 0; i < v.NumField(); i++ {
​    if v.Field(i).CanInterface() { //判断是否为可导出字段，否则v.Field(i).Interface()会panic
​      fmt.Printf("%s %s = %v -tag:%s \n", 
​        t.Field(i).Name, 
​        t.Field(i).Type, 
​        v.Field(i).Interface(), 
​        t.Field(i).Tag)
​    }
  }
}
var st = Student{"aresyang", 120}
Travel(&st)
Travle(st)

```

## 常用的库函数

### flag ###

[flag](https://golang.org/pkg/flag/)是处理命令行参数的，跟gflags很像。

基本的用法如下

```go
import "flag"
var ip = flag.Int("flagname", 1234, "help message for flagname")
//或者 绑定到已定义的变量中
var (
  flagvar int
)
func init() {
  flag.IntVar(&flagvar, "flagname", 1234, "help message for flagname")
}
func main() {
  flag.Parse()
}

```

首先需要调用Parse。在执行的时候，类似于gflags的方式传递参数即可。
```shell
./binary --flagname=10
```

可以定义其它类型的，具体参考官方的reference，具有相应的接口。

### tmol ###

[toml](https://github.com/BurntSushi/toml) 处理TOML配置文件.


```go
type tomlConfig struct {
  Host string
  KeySpace string
  Table string
  KeyCond string
  Columns []string
}
var config tomlConfig
filePath := "/your/path/config.toml"
if _, err := toml.DecodeFile(filePath, &config); err != nil {
  panic(err)
}
fmt.Printf("%s %s.%s\n", config.Host, config.KeySpace,config.Table);
```

其对应的配置文件如下，拿到结构了就可以直接引用了

```
Host="172.24.254.11"
Keyspace="dmp_realtime_service"
Table="dmp_install_apps"
KeyCond="device_id"
Colums=["device_id", "apps_interests"]
```

上面演示了如何处理字符串和字符串数组，其实也支持嵌套的结构，注释是 "#" 开头即可

参考 [Golang学习--TOML配置处理](https://www.cnblogs.com/CraryPrimitiveMan/p/7928647.html)

### json ###

## 公开课



[6.824 Schedule: Spring 2015](http://nil.csail.mit.edu/6.824/2015/schedule.html)

[6.824 Schedule: Spring 2018](http://nil.csail.mit.edu/6.824/2018/schedule.html)