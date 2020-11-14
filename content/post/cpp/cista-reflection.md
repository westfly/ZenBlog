---
title: "利用Cista实现文本行到结构体的转换"
date: 2020-04-30T21:35:02+08:00
tags:
    - c++17
    - reflection
categories:
    - cpp
comment: false
draft: false
---

## 1. Cista概况 ##

[Cista](https://cista.rocks/) 官方介绍

```markdown
Cista++ is a simple, open source (MIT license) C++17 compatible way of (de-)serializing 
C++ data structures.
***Single header. No macros. No source code generation.***
```

简单来说，就是提供的结构体提供序列化和反序列支持，跟 [Thrift](https://github.com/apache/thrift) | [Protobuf](https://github.com/protocolbuffers/protobuf) | [Arrow](https://github.com/apache/arrow) 等产品或工具类似。Cista也提供一定的反射能力，能够与实现类成员变量的读写。

### 1.1 安装 ###

安装Cista有两种方式：

* 在Release页面下载最新的头文件[cista.h](https://github.com/felixguendling/cista/releases/download/v0.7/cista.h)，并将其include到工程中即可。
* 将master的源码checkout下来，[自己编译](https://github.com/felixguendling/cista/issues/46)，具体如下

```shell
mkdir build;
cd build
cmake3 -f CMakeLists.txt -DCMAKE_CXX_COMPILER=/opt/scylladb/bin/g++ ../
make cista-test-single-header
```

对于大型的工程，作者建议通过CMake的方式，通过submoduel的方式，链接到编译系统中去。

```cmake
add_subdirectory(cista)
# ...
target_link_libraries(my_target cista)
```



## 2.  基本使用 ##

从官方的示例来看，其实很详细，如下是自己总结的一些用法。

### 2.1 遍历 ###

```cpp
struct cista_struct {
    int i_ = 1;
    int j_ = 2;
    double d_ = 100.30;
};
cista_struct a;
a.d_ = 200;
auto print_elem = [](auto &&m) {
    fmt::print("value {} with type {}\n", m, type_name<decltype(m)>());
};
cista::for_each_field(a, print_elem);
```

如上是通过 [fmt](https://github.com/fmtlib/fmt) 来实现。

[type_name](https://github.com/willwray/type_name) 来源于[Stack Overflow](http://stackoverflow.com/a/18369732) 的问题，当然cista 中也有实现。

### 2.2 序列化和反序列化 ###

```cpp
struct cista_struct {
    int i_ = 1;
    int j_ = 2;
    double d_ = 100.30;
};
cista_struct a;
a.d_ = 200;
auto print_elem = [](auto &&m) {
    fmt::print("value {} with type {}\n", m, type_name<decltype(m)>());
};
std::vector<uint8_t> buffer = cista::serialize<cista_struct>(a);
auto b = cista::raw::deserialize<cista_struct>(buffer.data(), buffer.data() + buffer.size());
cista::for_each_field(a, print_elem);
cista::for_each_field(*b, print_elem);
```

### 2.3 反射 ###

利用反射接口实现的宏，能够很方便的实现结构体的打印

```cpp
#define CATCH_CONFIG_MAIN
#define CATCH_CONFIG_ENABLE_BENCHMARKING
#include "catch2/catch.hpp"
#include "dbg-macro/dbg.h"
#include "cista/containers.h"
#include "cista/reflection/printable.h"
struct Object {
    CISTA_PRINTABLE(Object)
    int         i = 1;
    int64_t     j = 2;
    double      d = 3.30;
    std::string s;
};
TEST_CASE("bench") {
    SECTION("printable") {
        Object obj;
        dbg(obj);
    }
}
```

**CISTA_PRINTABLE** 宏自动生成对象的 结构体String类型，与**dbg**配合能够很方便的Debug，减少重复代码量。

```cpp
template<typename T>
std::ostream& operator<<(std::ostream& out, T const& o);
```

其基本的思路是通过 上述例子中提到的 reflection 接口完成的。

同列 **CISTA_COMPARABLE** 宏，可以生成 比较函数

```cpp
struct Object {
  CISTA_COMPARABLE()
  int i_ = 1;
  int j_ = 2;
  double d_ = 100.0;
  std::string s_ = "hello";
};

int main() {
  Object inst1, inst2;

  CHECK(inst1 == inst2);

  inst1.j_ = 1;

  CHECK(!(inst1 == inst2));
  CHECK(inst1 != inst2);
  CHECK(inst1 <= inst2);
```



## 3. 应用 ##

通过如上的熟悉，我们知道了其基本用法，尝试利用Cista接口完成如下场景：

有一个明文文本文件，其格式为按照 \t 分割的域

```reStructuredText
key  field_one field_two field_three
```

在服务加载时，需要转为HashMap的形式，其中Key为第一个字段，Value为如下的 Struct 结构体。

```cpp
struct Message {
	uint64_t field_one;
	int32_t  field_two;
	std::string field_three;
};
```

随着业务的发展，可能遇到如下两个问题

1. Value字段越来越多，每次有些硬编码完成类型的相关转换
2. 文件越来越大，插入HashMap的时间过长，导致服务上线或故障恢复难

本文尝试解决第一个问题，第二个问题在后续的文章中体现。

#### 3.1 接口设计 ####

任务的核心其实是将各个字符串的域转换为结构体，设计接口上，我们可以把行转换为StringTokenizer对象保存起来，然后将各个域与Struct的域类型映射起来，用到两个技术

* 模板
* 反射

核心的代码示例如下所示

```c++
template <typename Key, typename Value>
int ReflectionDumpField(Key& key, Value& pod_type, const StringTokenizer& tok) {
cista::for_each_field(pod_type, [&](auto&& field) {
	//dump_field(field, tok[i++]);
}
```

#### 3.2 类型匹配 ####

dump_field 的实现可以通过标准库函数提供的 is_same 来进行判断，支持一些基础的类型，暂时不支持嵌套类型（但很容易嵌套），具体实现如下

```c++
using namespace std::literals; // for sv
#define DUMP_FILELD(tok, type, field, i, fn)                                   \
    if constexpr (std::is_same<type&, decltype(field)>::value) {               \
        field = tok[i].fn();                                                   \
    }
// clang-format off
//else DUMP_FILELD(tok, std::string, field, i, String)
#define DUMP_FILELD_WRAPPER(tok, field, i)                   \
    do {                                                     \
        DUMP_FILELD(tok, int, field, i, Int32)               \
        else DUMP_FILELD(tok, int, field, i, Int32)          \
        else DUMP_FILELD(tok, int64_t, field, i, Int64)      \
        else DUMP_FILELD(tok, uint64_t, field, i, UInt64)    \
        else DUMP_FILELD(tok, float, field, i, Float)        \
        else DUMP_FILELD(tok, double, field, i, Double)      \
        else DUMP_FILELD(tok, std::string, field, i, String) \
        else DUMP_FILELD(tok, std::string_view, field, i, StringView) \
        else {                                               \
            fmt::print("typename {}, w{} not support\n",     \
                   i,                                        \
                   GetTypeName<decltype(field)>());          \
        }                                                    \
    } while (0)
// clang-format on
```

#### 3.3 完整封装 ####

我们抽象下接口，如下具体的实现将第0个域作为了key，value为其它域。

```cpp
#pragma once
namespace util {
template <typename Key, typename Value>
int ReflectionDumpField(Key& key, Value& pod_type, const StringTokenizer& tok) {
    // key = 0;
    DUMP_FILELD_WRAPPER(tok, key, 0);
    int i = 1;
    cista::for_each_field(pod_type, [&](auto&& field) {
        DUMP_FILELD_WRAPPER(tok, field, i);
        ++i;
    });
    return 0;
}
template <typename Key, typename Value>
bool ReflectionDumpField(Key&             key,
                         Value&           pod_type,
                         const char*      line,
                         size_t           len,
                         std::string_view seperator_list = "\t"sv) {
    StringTokenizer tok;
    std::string_view text_str(line, len);
    tok.CharsTokenize(text_str, seperator_list, false);
    return ReflectionDumpField(key, pod_type, tok);
}
} // util
#undef DUMP_FILELD
#undef DUMP_FILELD_WRAPPER
```

#### 3.4 支持有限层级的嵌套 ####

上述方案仅仅对基础的build-in类型及String支持，如果在 struct 中嵌套struct呢？限于笔者对Cista的了解，下面只提供一些实现的思路。

在3.2中的类型判断中，我们可以把struct归为else之类。这时，我们只需要将对应的字符串域看作一个新的需要dump 的Struct域即可，但此时需要与首层不同的分隔符切分，递归的调用ReflectionDumpField 即可。

## 4. 总结 ##

本文通过利用Cista中对结构体的反射，实现了行文本到基础类型的映射，避免了业务的硬编码，减少了出错的可能，具有一定的创新性。

实现的代价为支持有限的POD类型，能够有限地扩展到嵌套struct，在dump时有if判断，可能会影响效率。



