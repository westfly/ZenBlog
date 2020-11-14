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



[ctypes](https://docs.python.org/3/library/ctypes.html)是 python 定义的为实现类型转换的中间层，是纯 python 数据类型与 c 类型通信的桥梁。

ctypes 实现了一系列的类型转换方法，Python的数据类型会包装或直接推算为C类型，作为函数的调用参数；函数的返回值也经过一系列的包装成为Python类型。也就是说，PyObject* <-> C types的转换是由ctypes内部完成的，这和[SWIG](https://github.com/swig/swig)(Simplified Wrapper and Interface Generator)是同一个原理。

```python
import ctypes
import platform

cdll_names = {
            'Darwin' : 'libc.dylib',
            'Linux'  : 'libc.so.6',
            'Windows': 'msvcrt.dll'
        }

clib = ctypes.cdll.LoadLibrary(cdll_names[platform.system()])
clib.printf(ctypes.c_char_p("Hello %d %f\n"), ctypes.c_int(15), ctypes.c_double(2.3))
# c_int(15) 等价于
int_val = ctypes.c_int();
int_val.value = 15
```

### 基本类型 ###



### 指针 ###

基本类型中只包含了 c_char_p 和 c_void_p 两个指针类型。

```c
#include <stddef.h>
int sum(int* array, size_t len) {
    int ret = 0;
    for (size_t i = 0; i < len; i++) {
        ret += array[i];
    }
    return ret;
}
```



```shell
gcc -fPIC -shared sum.c -o sum.so
```



load c 的 lib 后，必须告诉 Python,一个 ctype 函数的形参类型和返回的值的类型, 函数才能正确地在 python 里调用。

ctypes 规定，总是假设返回值为int。

```python
import ctypes
clib = ctypes.cdll.LoadLibrary("sum.so")
clib.sum.argtypes = (ctypes.POINTER(ctypes.c_int), ctypes.c_size_t)
clib.sum.restypes = ctypes.c_int
i = ctypes.c_int(5)
# pointer 必须在 ctypes 类型上使用
print clib.sum(ctypes.pointer(i), 1)
# ctypes 的数组定义就是用 ctypes 中的类型 * 大小
array = (ctypes.c_int * 3)(11, 12, 13)
print clib.sum(array, len(array))
```



### 数组 ###

多维数组

```python
import ctypes
type_int_array_10 = ctypes.c_int * 10
type_int_array_10_10 = type_int_array_10 * 10
my_array = type_int_array_10_10()
my_array[1][2] = 3
```



### 结构体 ###

```python
import ctypes
"""
typedef struct _user {
    int type;
    uint64_t  userid;
    char username[64];
    unsigned int created_at;
} User;
"""
class User(ctypes.Structure):
    _fields_ = [
        ('type', ctypes.c_int),
        ('userid', ctypes.c_uint64),
        ('username', ctypes.c_char * 64),
        ('created_at', ctypes.c_uint),
    ]

print ctypes.POINTER(User)
u = User()
print ctypes.pointer(u)
```



### 函数指针 ###

```python
import ctypes
CMPFUNC = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.POINTER(ctypes.c_int), ctypes.POINTER(ctypes.c_int))
def py_cmp_func(a, b):
	return a[0] - b[0]
p_c_cmp_func = CMPFUNC(py_cmp_func)
```

