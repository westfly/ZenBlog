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



## 核心语言特性 ##

### 1. Structured Binddings ###

结构化绑定

```
结构化绑定

```

### 2. if | switch ###

```cpp
if (satus s = check(); s != status::OK) {
	return s;
} else {
    dbg(s)
}
```

s 的生命周期在else中可见。



### Inline Variables   ###



### Aggregate Extensions   ###



```cpp
struct Data {
    std::string name;
    double value;
};
Data x{"test1", 6.778};

struct MoreData : Data {
	bool done;
};
MoreData y{{"test1", 6.778}, false};
```





### Lambda Extensions   ###



## 其它点 ##

### 命名空间 ###

```cpp
namespace A::B::C {
...
}
//which is equivalent to:
namespace A {
    namespace B {
        namespace C {
        ...
        }
    }
}
```

##  ##

## 官方库增强 ##

### std::optional ###

```cpp
#include <optional>
#include <string>
std::optional<int> oi = asInt(s);
if (oi.has_value()) {
	std::cout << "convert '" << s << "' to int: " << oi.value() << "\n";
}
```

| Operation          | Effect                                                       |
| ------------------ | ------------------------------------------------------------ |
| constructors       | Create an optional object (might call constructor for contained type) |
| make_optional<>()  | Create an optional object (passing value(s) to initialize it) |
| destructor         | Destroys an optional object                                  |
| =                  | Assign a new value                                           |
| emplace()          | Assign a new value to the contained type                     |
| reset()            | Destroys any value (makes the object empty)                  |
| has_value()        | Returns whether the object has a value                       |
| conversion to bool | Returns whether the object has a value                       |
| *                  | Value access (undefined behavior if no value)                |



### std::variant   ###

C++版本的union，比较土

```cpp
namespace std {
template<typename T>
constexpr bool is_const_v = is_const<T>::value;
}
```

[]()







