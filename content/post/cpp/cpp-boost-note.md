---
title: "boost 学习指北"
date: 2019-11-30T21:35:02+08:00
tags:
    - c++17
    - boost
categories:
    - cpp
comment: false
draft: true


---
## 时间处理

## 宏预处理

### 运算 ###

```cpp
#include <boost/preprocessor/arithmetic/div.hpp>
#include <boost/preprocessor/arithmetic/mul.hpp>
#include <boost/preprocessor/arithmetic/inc.hpp>

#define N 15
#define M BOOST_PP_DIV(                          \
          BOOST_PP_MUL( N, BOOST_PP_INC(N) ),    \
          2 )
int m = M;
```

宏的含义为  N * (N + 1) / 2







如下内容主要参考了
[Boost 库 C/C++ Preprocessor 子集](http://sns.hwcrazy.com/boost_1_41_0/libs/preprocessor/doc/index.html)

### BOOST_PP_CAT ###

BOOST_PP_CAT 包含于boost/preprocessor/cat.hpp 中。
BOOST_PP_CAT(a,b) 用来连接两个标识符

```cpp
#include <boost/preprocessor/cat.hpp>
BOOST_PP_CAT(x, BOOST_PP_CAT(y, z)) // 展开为 xyz
```

### BOOST_PP_IF ###

BOOST_PP_IF 包含于 boost/preprocessor/control/if.hpp

BOOST_PP_IF(cond, t, f) 的用法为
cond
确定选择结果的条件。有效值为 0 到 BOOST_PP_LIMIT_MAG.
t
cond 为非零时的展开结果。
f
cond 为 0 时的展开结果。

```cpp
#include <boost/preprocessor/control/if.hpp>

BOOST_PP_IF(10, a, b) // 展开为 a
BOOST_PP_IF(0, a, b) // 展开为 b
```

### BOOST_PP_TUPLE_ELEM ###

BOOST_PP_TUPLE_ELEM 包含于boost/preprocessor/tuple/elem.hpp
BOOST_PP_TUPLE_ELEM(size, i, tuple)  
从 tuple 中取出i的下标元素。

```cpp
#include <boost/preprocessor/tuple/elem.hpp>
#define TUPLE (a, b, c, d)
BOOST_PP_TUPLE_ELEM(4, 0, TUPLE) // 展开为 a
BOOST_PP_TUPLE_ELEM(4, 3, TUPLE) // 展开为 d
```

### BOOST_PP_SEQ_FOR_EACH ###

BOOST_PP_SEQ_FOR_EACH 包含于 boost/preprocessor/seq/for_each.hpp 中。
BOOST_PP_SEQ_FOR_EACH(func, data, seq) ，其中：
func 为自己定义的一个宏
data 为一个常量
seq 为一个序列
这个宏会将序列中的参数依次按照指定的宏 func 展开。

```cpp

#include <boost/preprocessor/seq/for_each.hpp>

#define SEQ (w)(x)(y)(z)

#define MACRO(r, data, elem) elem::GetInstance()
// expands to w::GetInstance() x::GetInstance() y::GetInstance() z::GetInstance()
BOOST_PP_SEQ_FOR_EACH(MACRO, _, SEQ)
```

可以用g++ -E -P src/boost_macro.cpp 进行验证

### BOOST_PP_SEQ_FOR_EACH_I ###

BOOST_PP_SEQ_FOR_EACH_I 跟 BOOST_PP_SEQ_FOR_EACH 基本是一样的。
就是对MACRO的参数要求变为四个。
即 macro(r, data, i, elem) ，将SEQ展开的时候，会将i（index）传递给macro，index从0开始。

```cpp
#include <boost/preprocessor/cat.hpp>
#include <boost/preprocessor/seq/for_each_i.hpp>
#define SEQ (a)(b)(c)(d)
#define MACRO(r, data, i, elem) BOOST_PP_CAT(elem, BOOST_PP_CAT(data, i))
BOOST_PP_SEQ_FOR_EACH_I(MACRO, _, SEQ) // 展开为 a_0 b_1 c_2 d_3

```



### BOOST_PP_REPEAT ###

系统中有些时间的类型转换，调用 snprintf比较耗时，于是想到用系统静态区来生成，只要保留变量的生成周期即可。

```cpp
    static std::string_view ShortConvertToString(uint8_t value) {
        using namespace std::string_view_literals;
        static const std::string_view kTable[] = {
#define DECL_CASE(z, n, text) std::string_view(#n),
            BOOST_PP_REPEAT(255, DECL_CASE, X)
#undef DECL_CASE
                "none"sv};
        return kTable[value];
    }
```





```cpp
#函数注册展开
#define RANKER_FILE_SEQ ((m_ftrl_model, ProcessMFTRLModelFile))                         \
                        ((m_ftrl_config, ProcessCtrlConfigData))                        \
                        ((fillrate_real_time, ProcessFillRateRealTimeFile))             \
                        ((fillrate_real_time_new, ProcessFillRateRealTimeNewFile))      \
                        ((fillrate_real_time_test_imp, ProcessFillRateRealTimeFile))    \
                        ((fillrate_real_time_test, ProcessFillRateRealTimeNewFile))     \
                        ((hb_realtime_control, ProcessHBRealTimeFile))                  \
                        ((m_tc_cpm_rate, ProcessMTcCpmRateFile))                        \
                        ((m_delay_ins_24iO3i, ProcessAppAdtypePlatformDevCc24hinsO3hinsFile))

#define LoadFileMacro(r, map, elem) \
    map.emplace(BOOST_PP_STRINGIZE(BOOST_PP_TUPLE_ELEM(BOOST_PP_TUPLE_SIZE(elem), 0, elem)),    \
                std::bind(&DataCenter::BOOST_PP_TUPLE_ELEM(BOOST_PP_TUPLE_SIZE(elem), 1, elem), \
                          std::placeholders::_1, std::placeholders::_2));
    BOOST_PP_SEQ_FOR_EACH(LoadFileMacro, load_register_map_, RANKER_FILE_SEQ);

# 函数实现自动展开
#define ExpandInterfaceFunMacro(r, data, elem)  \
    std::shared_ptr<BOOST_PP_TUPLE_ELEM(BOOST_PP_TUPLE_SIZE(elem), 3, elem)>                \
        DataCenter::BOOST_PP_TUPLE_ELEM(BOOST_PP_TUPLE_SIZE(elem), 2, elem) () {            \
            return GetFromObject<BOOST_PP_TUPLE_ELEM(BOOST_PP_TUPLE_SIZE(elem), 3, elem),   \
                                 BOOST_PP_TUPLE_ELEM(BOOST_PP_TUPLE_SIZE(elem), 4, elem)> ( \
                                 BOOST_PP_STRINGIZE(BOOST_PP_TUPLE_ELEM(BOOST_PP_TUPLE_SIZE(elem), 0, elem)));  \
        }
BOOST_PP_SEQ_FOR_EACH(ExpandInterfaceFunMacro, _, RANKER_FILE_SEQ);
#undef ExpandInterfaceFunMacro


```



## boost-log

## magic_get

[magic_get](https://github.com/apolukhin/magic_get)
[C++14实现编译期反射--剖析magic_get中的magic](http://purecpp.org/detail?id=1074)
