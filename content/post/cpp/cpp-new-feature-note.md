---
title: "cpp 新特性学习笔记"
date: 2019-11-30T21:35:02+08:00
tags:
    - c++17
    - c++11
    - c++14
categories:
    - cpp
comment: false
draft: true

---
根据
[聊聊C++11](https://www.bilibili.com/video/av7701532)的内容整理而来
的特性，也会补充些C++14、C++17的相关内容，文章会根据自己的学习过程会定期做些内容的更新。

## 1. initializer_list ##

```cpp
// c++03
vector<int> a;
int array [] = {1, 2, 3}
for(int i = 0; i < 3; ++i) {
    a.push_back(arry[i]);
}

// c++11
#include <initializer_list>
vector<int> v = {1, 2, 3}
```

在初始化时可以避免重复写代码。

## 2. Uniform Initialziation ##

cpp在语言的层面为类对象的初始化与普通数组以及POD的初始化方法提供了统一的桥梁，极大的改善了写模板。

搜索函数时有最高的优先级，用户可以自定义

```cpp
#include <initializer_list>
class Dog {
    Dog(const initializer_list<int>& vec);
    Dog(int age);
};
```

initializer_list 还可以作为参数传递，用于[替代vector类型的参数](https://stackoverflow.com/questions/14414832/why-use-initializer-list-instead-of-vector-in-parameters)，能够在原地构造参数。

```cpp
#include <algorithm>
#include <initializer_list>
#include <vector>
int sum(const std::vector<int>& array) {
    int total = 0;
    std::for_each(array.begin(), array.end(), [&](const int& el) { total += el; });
    return total;
}
int sum(std::initializer_list<int> array) {
    int total = 0;
    std::for_each(std::begin(array),
                  std::end(array), [&](const int& el) { total += el; });
    return total;
}
```

针对可以用for的比较方便。在某些情况下，需要对initializer_list 解包，但 initializer_list  并
没有跟 vector 一样提供 at 函数，可以通过[如下方式](https://stackoverflow.com/questions/17787394/why-doesnt-stdinitializer-list-provide-a-subscript-operator)绕过去，
有需要的朋友可以参考下。

```cpp
// the class _init_list_with_square_brackets provides [] for initializer_list
template<class T>
struct _init_list_with_square_brackets {
    const std::initializer_list<T>& list;
    _init_list_with_square_brackets(const std::initializer_list<T>& _list): list(_list) {}
    T operator[](unsigned int index) {
        return *(list.begin() + index);
    }
};

// a function, with the short name _ (underscore) for creating
// the _init_list_with_square_brackets out of a "regular" std::initializer_list
template<class T>
_init_list_with_square_brackets<T> _(const std::initializer_list<T>& list) {
    return _init_list_with_square_brackets<T>(list);
}
void f(std::initializer_list<int> list) {
    cout << _(list)[2]; // subscript-like syntax for std::initializer_list!
}
```

## 3. auto ##

auto 在很早以前就已经进入了 C++， 但是他始终作为一个存储类型 的指示符存在， 与 register 并存。 在传统 C++ 中 ， 如果一个变量没有声明为 register变量， 将自动被视为一个 auto 变量。 而随着register 被弃用 ， 对 auto 的语义变更也就非常自然了 。

可以用如下语法糖进行遍历容器

```cpp
vector<int> v = {1, 2, 3}
for(auto it = v.begin(); it != v.end(); ++it) {
}
```

auto避免了需要写冗长类型的麻烦，用过vector迭代器的肯定知道我在说什么。
后面还有auto的方法会加以补充。

## 4. foreach ##

foreach 严格来说还是一种语法糖，从其它语言（python）中借鉴而来，具体如下

```cpp
for(int el : v) {
    // copy
}
for(auto & el : v) {
    ++el
}
// c++17 TODO
for(auto key, value : map) {

}
// 或者采用 algorithm + lambda 表达式
std::for_each(array.begin(), array.end(), [](const T& el) {
});
```

## 5. nullptr ##

nullptr的为了解决如下链接时冲突的问题，在C++11之后的代码中，严格来说，没有NULL。nullptr会提供更安全的检查。

```cpp
void for(int i);
void for(char* ptr);
foo(NULL) //ambiguity
for(nullptr) // c++11
```

## 6. enum class ##

解决各个enum变量可比较（被拉平为整形），可能带来的风险，为了代码更安全而引入的特性。

```cpp
enum class Apple  {Green, Red};
enum class Orange {Green, Red};
auto a = Apple::Green;
auto o = Orange::Green;
if (a == o) // compiler fails, no defining opertor ==
```

但是依然如下强转的方式输出

```cpp
#include <iostream>
template<typename T>
std::ostream& operator<<(typename std::enable_if<std::is_enum<T>::value, std::ostream>::type& stream, const T& e)
{
    return stream << static_cast<typename
    std::underlying_type<T>::type>(e);
}
```

## 7. static assert ##

static_assert 提供编译期的断言，对平台的移植方面会有较强的作用

```cpp
static_assert(sizeof(int) == 4);
```

## 8. delegation Constructor ##

即构造函数可以相互调用，类似于Java中的Super语义，以增加代码的复用。

```cpp
class Dog {
 public:
    Dog() {}
    Dog(int a) : Dog() {
        other();
    }
};
```

## 9. override (for vritual funciton) ##

避免 inavertently（不经意间的）在子类中创建新的函数
用于给编译器一个参考，并不是必须的，写新代码的时候，建议加上。

```cpp
class Dog {
 public:
    virtual void Bark(int a);       //
};
class RedDog : public Dog {
    virtual void Bark(float a) override; // no funciton to override
    virtual void Bark(double a ); // create new funciton
};
```

## 10. final ##

既可用在函数，和可用在类上，从Java中借鉴而来，表示该类不可再被继承或函数不能被重载。

```cpp
class Dog final { //no class derived from Dog
    virtual void Bark() final; // no class can override
};
```

## 11. Compiler Generate Default Constructor ##

```cpp
class Dog {
    Dog() == default; // compiler generator code
};
Dog toy;
```

声明一个Empty类，编译器会生成什么？

在C++03中，默认下会生成(也有教程上说，只有在有必要时会生成，如何验证？)

```cpp
class Empty {
    Empty();
    Empty(const Empty& rhs);
    Empty& operator=(const Empty &rhs)
    ~Empty();
};
```

C++11之后添加了Move语义，所以多了如下 [移动构造函数](https://zh.cppreference.com/w/cpp/language/move_constructor)。

```cpp
class Empty {
    Empty(Empty&& rhs);
    Empty& operator=(Empty&& rhs)
}
```

TODO : 生成的时机和相互屏蔽的规则

## 12. delete Constructor ##

```cpp
class Dog {
    Dog(int a) {};
    Dog(double) = delete; // 禁止从double隐式转为int
    Dog& opertor=(const Dog&) = delete; //禁止赋值
};
```

## 13. constexpr ##

在编译期间可以计算的常量表达式

```cpp
constexpr int cubed(int x) {return x*x*x}
int y = cubed(191); // computed at compile time
```

从 C++14 开始， constexptr 函数可以在内 部使用 局部变量、 循环和分支等简单语句，例如下面的代码在 C++11 的标准下是不能够通过编译

```cpp
constexpr int fibonacci( const int n) {
 if( n == 1) return 1;
 if( n == 2) return 1;
 return fibonacci( n- 1) +fibonacci( n- 2) ;
}
```

## 14. New String Literals ##

提供更好的国际化（UTF-8）支持。

```cpp
char*       a = u8"string" // UTF-8 string
char16_t*   b = u"string"
char32_t*   c = U"string"
char*       d = R"string \\" // raw string
```

## 15. lamda function ##

Lambda 表达式是 C++11 中最重要的新特性之一。本质上来说，通过“语法糖”的方式提供了一种匿名函数的特性。

从函数式编程中借鉴而来，熟悉stl的人应该记得std::mem_fn等函数的使用方式是多么的trick，没有统一的方式。

其基本语法为

```js
[捕获列表](参数列表) mutable(可选) 异常属性 -> 返回类型 {
// 函数体
}
```

捕获列表，其实可以理解为参数的一种类型。默认情况下，lambda表达式内部不能使用函数体外部的变量，捕获列表起到传递外部数据的作用。C/C++中参数涉及到值传递、引用（左值|右值）传递，如下分情况讨论

### 15.1.值捕获 ###

与参数传值类似，值捕获的前期是变量可以拷贝，不同之处则在于，被捕获的变量在 lambda 表达式被创建时拷贝，而非调用时才拷贝。这意味着，如果在调用前值被修改，lambda中保存的依然是修改前的值。

```cpp
void learn_lambda_func_1() {
    int value_1 = 1;
    auto copy_value_1 = [value_1] {
        return value_1;
    };
    value_1 = 100;
    // stored_value_1 == 1 被绑定为之前的值
    auto stored_value_1 = copy_value_1();
}
```

### 15.2. 引用捕获 ###

与引用传参类似，引用捕获保存的是引用，相当于指针，值会发生变化。

```cpp
void learn_lambda_func_2() {
    int value_2 = 1;
    auto copy_value_2 = [&value_2] {
        return value_2;
    };
    value_2 = 100;
    // stored_value_2 == 100 相当于拷贝为指针(地址)
    auto stored_value_2 = copy_value_2();
}
```

### 15.3. 隐式捕获 ###

在捕获列表中写一个 & 或 = 向编译器声明采用引用捕获或者值捕获，以避免手工撰写。
如下是四种最为常见的捕获

* [] 空捕获列表
* [name1, name2, ...] 捕获一系列变量
* [&] 引用捕获, 让编译器自行推导捕获列表
* [=] 值捕获, 让编译器执行推导应用列表

**注意**: 值和引用捕获在C++11中只能捕获左值，在C++14可以捕获右值（如何理解呢？）

一般的代码举例

```cpp

auto f = [](int x, int y) {return x + y;}
f(3,4)
map(f, vector);
```

## 16. 自定字符常量 ##

常量有如下四种

1. 整形 4l 4UL
2. 浮点 4.5f
3. 字符 'z'
4. 字符串 "string"

为常量提供符号重载，通过例子看，作用不大（希望被打脸）。

```cpp
constexpr double operator"" _cm (double x) {return x*10;}
constexpr double operator"" _mm(double x) {return x;}

double height = 3.4_cm;
cout<<3.4_cm/3_mm<<endl;

```

## 17. shared_ptr ##

shared_ptr是智能指针的一种，用于资源管理（RAII）。

```cpp
class Dog {
    Dog(std::string&& name);
};

shared_ptr<Dog> p = std::make_shared<Dog>("name");
shared_ptr<Dog> p2 = std::make_shared<Dog>("name",
                    [](Dog* p) {
                        cout<<"custom deleting..."<<endl;
                        delete p;
                    });
p1=p2; //
p1=nullptr; // 对象释放
p1.reset(); // 对象释放
Dog* d = p1.get(); //获取裸指针


```

## 18. decltype ##

**decltype** 是为了解决auto只能对变量进行类型推导。用法跟**sizeof** 很类似，在模板推导中有大量的应用。

```cpp
template<typename R, typename T, typename U>
R add(T x, U y) {
    return x+y
}
//C++11中的尾递归，用auto来锚定解析
template<typename T, typename U>
auto add(T x, U y) -> decltype(x+y) {
    return x+y;
}
// C++14 更加简单和自然
template<typename T, typename U>
auto add(T x, U y) {
    return x+y
}
```

## 19. using ##

### 19.1 [类型别名模板] ###

模板是用来产生类型的，但在传统中typedef 为类型定义一个新的名称

```cpp
template<typename T, typename U>
class SuckType;
typedef SuckType<std::vector, std::string> NewType; // 不合法
using NewType=SuckType<std::vector, std::string>; // 合法

typedef int (*sql_fn)(std::string *);
using sql_fn = int(*)(std::string *); //更加直观

```

### 19.2 继承构造 ###

```cpp
class Base {
public:
    int value1;
    int value2;
    Base() {
        value1 = 1;
    }
    Base(int value) : Base() {//构造函数
    value2 = 2;
    }
};
class Subclass : public Base {
public:
    using Base::Base; // 继承构造
};
```

## 20 函数对象 ##

### 20.1 std::funciton ###

C++11 std::function 是一种通用、多态的函数封装， 它的实例可以对任何可以调用的目标实体进行存储、复制和调用操作， 它也是对 C++中 现有的可调用实体的一种类型安全的包裹（ 相对来说， 函数指针的调用不是类型安全的） ， 换句话说， 就是函数的容器 。

```cpp
int foo( int para) {
    return para;
}
std::function<int( int) > func = foo;
std::cout << func( 10) << std::endl;

```

### 20.2 std::bind ###

std::bind 是用来绑定函数调用的参数的，它解决的需求是我们有时候可
能并不一定能够一次性获得调用某个函数的全部参数，通过这个函数，我们可以将部分调用参数提前绑定到函数身上成为一个新的对象

```cpp
int foo( int a, int b, int c) {
 return a+b+c;
}
auto bindFoo = std::bind( foo, std::placeholders::_1, 1, 2) ;
std::cout << bindFoo(1)<< std::endl;
```

需要注意的是在异步编程时，可能需要注意bind变量的生命周期。

## 21. 模板增强 ##

### 21.1 外部模板 ###

### 21.2 默认模板参数 ###

避免每次指定参数

```cpp
template<typename T = int, typename U = int>
auto add( T x, U y) - > decltype( x+y) {
 return x+y
}
```

### 21.3 变长模板参数 ###

传统的C中参数和参数之间存放是连续的，只要知道第一个参数的地址和类型，以及其他参数的类型。
如printf的声明

```cpp
int printf(const char* format, ...);
```

变长的使用方式模板为

```cpp
#include <stdarg.h>
int sum(int count, ...)
{
 va_list vlist;
 va_start (vlist, count);
 while(...)
 {
  ...
        f = va_arg (vlist, type);
  ...
 }
 va_end (vlist);
}
```

在 C++11 之前，无论是类模板还是函数模板，都只能按其指定的样子，接受一组固定数量的模板参数；
而 C++11 加入了新的表示方法，允许任意个数、任意类别的模板参数，同时也不需要再定义时将参数的个数固定。

```cpp
template<typename... Ts>
class Magic;
template<typename Require, typename... Args>
class RequireMagic;

template<typename ...Element> class tuple;

tuple<int, string> a;  // use it like this
```

在模板参数 Element 左边出现省略号 ... ，就是表示 Element 是一个模板参数包（template type parameter pack）。parameter pack（参数包）是新引入 C++ 中的概念，比如在这个例子中，Element 表示是一连串任意的参数打成的一个包。

具体的使用方式

```cpp
// 递归展开参数
template<class T>
void Print(T t) {
    std::cout<< t<< std::endl;
}
template<class T, class...Args>
void Print(T head, Args... left) {
    std::cout << head <<std::endl;
    Print(left...);
}
// type_traits

// from https://stackoverflow.com/questions/6245735/pretty-print-stdtuple
template <typename Type, unsigned N, unsigned Last>
struct tuple_printer {
  static void print(std::ostream &out, const Type &value) {
    out << std::get<N>(value) << ", ";
    tuple_printer<Type, N + 1, Last>::print(out, value);
  }
};

template <typename Type, unsigned N>
struct tuple_printer<Type, N, N> {
  static void print(std::ostream &out, const Type &value) {
    out << std::get<N>(value);
  }
};
template <class... Args> void PrintAsTuple(Args... args) {
  // std::forward 避免拷贝
  tuple_printer<std::tuple<Args...>, 0, sizeof...(Args) - 1>::print(
      std::cout, std::make_tuple(std::forward<Args>(args)...));
}
```

针对如上的情况，C++14 引入了 index_sequence

```cpp
// g++72 make_tuple.cpp --std=c++1z
template<class TupType, size_t... I>
void Print(std::ostream &out, const TupType& tup, std::index_sequence<I...>) {
    // ... 参考下文的fold 折叠表达式
    (..., (out << std::get<I>(tup) << ":"));
}

template <class... Args>
void PrintAsIndexTuple(Args... args) {
 std::cout << std::endl;
    Print(std::cout, std::make_tuple(std::forward<Args>(args)...),
    std::make_index_sequence<sizeof...(Args)>());
 std::cout << std::endl;
}

```

### 21.4 fold 折叠表达式 ###

[折叠表达式](https://zh.cppreference.com/w/cpp/language/fold)
有四种形式

( 形参包 op ... ) (1)
( ... op 形参包 ) (2)
( 形参包 op ... op 初值 ) (3)
( 初值 op ... op 形参包 ) (4)

1) 一元右折叠 (E op ...) 成为 (E1 op (... op (EN-1 op EN)))
2) 一元左折叠 (... op E) 成为 (((E1 op E2) op ...) op EN)
3) 二元右折叠 (E op ... op I) 成为 (E1 op (... op (EN−1 op (EN op I))))
4) 二元左折叠 (I op ... op E) 成为 ((((I op E1) op E2) op ...) op EN)

```cpp
template<typename ...Args>
int sum(Args&&... args) {
    constexpr int base = 10;
    return (args + ... + base); // OK 只会增加一次
}
```

### 21.5 sizeof... operator ###

```cpp
template<typename... Ts>
constexpr auto make_array(Ts&&... ts)
    -> std::array<std::common_type_t<Ts...>,sizeof...(ts)>
{
    return { std::forward<Ts>(ts)... };
}


```

## 22 完美转发 ##

## 23 多线程 ##

## 24 总结 ##
