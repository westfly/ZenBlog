---

title: "利用宏自动生成代码"
date: 2019-11-30T21:35:02+08:00
tags:
    - c++17
    - reflection
categories:
    - cpp
comment: false
draft: true
---

写代码时，需要有偷懒的精神，下面结合具体的场景，给出一些示例

### 字符到Enum的转换 ###

### Boost BOOST_PP_REPEAT宏 ###

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

展开为switch 语句



### Boost   ###



```cpp
#函数注册展开
#define FILE_LIST_SEQ ((lr_model, ProcessLRModelFile))                         \
                      ((dnn_model, ProcessDNNModelFile))                        
#define RegisterMacro(r, map, elem) \
    map.emplace(BOOST_PP_STRINGIZE(BOOST_PP_TUPLE_ELEM(BOOST_PP_TUPLE_SIZE(elem), 0, elem)),    \
                std::bind(&DataCenter::BOOST_PP_TUPLE_ELEM(BOOST_PP_TUPLE_SIZE(elem), 1, elem), \
                          std::placeholders::_1, std::placeholders::_2));
BOOST_PP_SEQ_FOR_EACH(RegisterMacro, load_register_map_, FILE_LIST_SEQ);
```

