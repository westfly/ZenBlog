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

最近在项目中



```cpp
#include <pybind11/pybind11.h>
namespace py = pybind11;
int add(int i, int j) {
    return i + j;
}
PYBIND11_MODULE(example, m) {
    m.doc() = "pybind11 plugin"; // optional module docstring
    m.def("add", &add, "A function which adds two numbers");
}
```

pybind11 纯粹是头文件，直接包含即可。

* PYBIND11_MODULE 宏创建的函数会在 python import 的时候执行。
* example 是模块的名称
* m 的类型为 py::model
* py::model.def 绑定add 函数到python中

编译和运行

```shell
c++ -O3 -Wall -shared -std=c++11 \
	-fPIC $(python3 -m pybind11 --includes) \
	example.cpp -o example.$(python3-config --extension-suffix)
```

在linux下会生成 example.so，可以在python中，动态 import

```python
python
import example;
example.add(1,2);
```

参数可以是 C 语言中可以表示的类型。

















