---
title: "cmake 学习笔记"
date: 2020-03-07T21:35:02+08:00
tags:
    - cmake
categories:
    - cpp
comment: false
draft: false

---



[cmake-examples](https://github.com/ttroy50/cmake-examples) 的学习笔记，但会根据平时的使用情况酌情有所增删。



## 1. 基础 ##

### 1.1 安装 ###

cmake 直接从[官网下载](https://cmake.org/download/) ，有各个平台的预编译包发布。我是在Windows下使用WSL，因为Ubuntu的版本比较老，所以将Linux下最新的TAR包解压到windowns下的Portable目录即可使用。

### 1.2  运行 ###

CMakeLists.txt 是 cmake 命令

```cmake
cmake_minimum_required(VERSION 3.5)
project (hello_cmake)
add_executable(hello_cmake main.cpp)
```

可以通过如下方式可以运行

```shell
mkdir build
cd build && cmake ../
make && ../hello_cmake
```

1. 建立build的目录的原因是，cmake会生成很多中间的临时文件，避免污染源码目录 
2. ../ 表示在上一级目录中，查找CMakeLists.txt（文件名是固定，不可修改）文件。

### 1.3 内置变量 ###

CMake的关于文件的内置变量用于屏蔽各个编译地址的差异，可以根据注释酌情使用。

| Variable                 | Info                                                         |
| ------------------------ | ------------------------------------------------------------ |
| CMAKE_SOURCE_DIR         | The root source directory                                    |
| CMAKE_CURRENT_SOURCE_DIR | The current source directory if using sub-projects and directories. |
| PROJECT_SOURCE_DIR       | The source directory of the current cmake project.           |
| CMAKE_BINARY_DIR         | The root binary / build directory. This is the directory where you ran the cmake command. |
| CMAKE_CURRENT_BINARY_DIR | The build directory you are currently in.                    |
| PROJECT_BINARY_DIR       | The build directory for the current project.                 |

### 1.4  链接库和链接头文件 ###

相当于给GCC添加 -I 选项

```cmake
target_include_directories(${PROJECT_NAME} PRIVATE
	${PROJECT_SOURCE_DIR}/include
)
```

生成静态库和使用静态库

```cmake
add_library(hello_library STATIC
    src/Hello.cpp
)
target_link_libraries( hello_binary PRIVATE
	hello_library
)
```

生成 libhello_library.so 只需要将修饰符变为 SHARED即可，其它不用变

```cmake
add_library(hello_library SHARED
    src/Hello.cpp
)
add_library(hello::library ALIAS hello_library)
target_link_libraries( hello_binary PRIVATE
	hello::library
)
```



| 修饰符    | 含义                                                         |
| --------- | ------------------------------------------------------------ |
| INTERFACE | the directory is added to the include directories for any targets that link this library. |
| PRIVATE   | the directory is added to this target’s include directories  |
| PUBLIC    | As above, it is included in this library and also any targets that link this library. |



### 1.5 编译类型 ###

指定编译的类型为 Debug 或 Release 模式，一般会用RelWithDebInfo 方便线上有问题时启用GDB调试。

```shell
cmake ../ -DCMAKE_BUILD_TYPE=Release
```

| 编译选项       | 含义                                          |
| -------------- | --------------------------------------------- |
| Release        | Adds the `-O3 -DNDEBUG` flags to the compiler |
| Debug          | Adds the `-g` flag                            |
| MinSizeRel     | Adds `-Os -DNDEBUG`                           |
| RelWithDebInfo | Adds `-O2 -g -DNDEBUG` flags                  |

cmake  默认没有编译选项，你可以通过如下脚本设置默认的编译选项为`RelWithDebInfo`
```cmake
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message("Setting build type to 'RelWithDebInfo' as none was specified.")
  set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
    "MinSizeRel" "RelWithDebInfo")
endif()
```

### 1.6 编译器参数 ###

增加编译器参数的相关选项

```cmake
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DEX2" CACHE STRING "Set C++ Compiler Flags" FORCE)
target_compile_definitions(cmake_examples_compile_flags PRIVATE EX3)
# CMAKE_C_FLAGS & CMAKE_LINKER_FLAGS
```

### 1.7 选择编译器 ###

可以通过覆盖 cmake 的参数

```shell
clang_bin=$(which clang)
clang_cxx_bin=$(which clang++)
#CMAKE_LINKER
cmake .. -DCMAKE_C_COMPILER=$clang_bin \
	 -DCMAKE_CXX_COMPILER=$clang_cxx_bin
```

还可以设置 CC & CXX 的环境变量

```bash
clang_bin=$(which clang)
clang_cxx_bin=$(which clang++)
export CC=$clang_bin
export CXX=$clang_cxx_bin
```

### 1.8  编译引擎 ###

cmake 默认生成 Makefile，还可以生成其它引擎的，可以通过 cmake --help 查看

```
Generators

The following generators are available on this platform (* marks default):
* Unix Makefiles               = Generates standard UNIX makefiles.
  Green Hills MULTI            = Generates Green Hills MULTI files
                                 (experimental, work-in-progress).
  Ninja                        = Generates build.ninja files.
  Watcom WMake                 = Generates Watcom WMake makefiles.
  CodeBlocks - Ninja           = Generates CodeBlocks project files.
  CodeBlocks - Unix Makefiles  = Generates CodeBlocks project files.
  CodeLite - Ninja             = Generates CodeLite project files.
  CodeLite - Unix Makefiles    = Generates CodeLite project files.
  Sublime Text 2 - Ninja       = Generates Sublime Text 2 project files.
  Sublime Text 2 - Unix Makefiles
                               = Generates Sublime Text 2 project files.
  Kate - Ninja                 = Generates Kate project files.
  Kate - Unix Makefiles        = Generates Kate project files.
  Eclipse CDT4 - Ninja         = Generates Eclipse CDT 4.0 project files.
  Eclipse CDT4 - Unix Makefiles= Generates Eclipse CDT 4.0 project files.
```

如下是选用 **nijia** 的方法

```shell
cmake .. -G Ninja && nijia & nijia install
```



### 1.9  C 标准 ###

如下是检测并选择C标准的模板

```cmake
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)

# check results and add flag
if(COMPILER_SUPPORTS_CXX11)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
elseif(COMPILER_SUPPORTS_CXX0X)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
else()
    message(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Please use a different C++ compiler.")
endif()
```

设置  [CMAKE_CXX_STANDARD](https://cmake.org/cmake/help/v3.1/variable/CMAKE_CXX_STANDARD.html)  变量，编译系统全局使用。



```cmake
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED OFF)

message("List of compile features: ${CMAKE_CXX_COMPILE_FEATURES}")
target_compile_features(hello_cpp11 PUBLIC cxx_auto_type)
```

C++有类似的参数

```cmake
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
```



## 2. 高级 ##

### 2.1 函数 ###

CMake通过函数支持模块复用，如find_package就是函数，具体使用如下

```cmake
function (argument_tester arg)
    message(STATUS "ARGN: ${ARGN}")
    message(STATUS "ARGC: ${ARGC}")
    message(STATUS "ARGV: ${ARGV}")
    message(STATUS "ARGV0: ${ARGV0}")
    list(LENGTH ARGV argv_len)
    message(STATUS "length of ARGV: ${argv_len}")
    set(i 0)
    while( i LESS ${argv_len})
        list(GET ARGV ${i} argv_value)
        message(STATUS "argv${i}: ${argv_value}")
        math(EXPR i "${i} + 1")
    endwhile()
endfunction ()
argument_tester(arg0 arg1 arg2 arg3)
```

运行结果

```
-- ARGN: arg1;arg2;arg3
-- ARGC: 4
-- ARGV: arg0;arg1;arg2;arg3
-- ARGV0: arg0
-- ARGV1: arg1
-- length of ARGV: 4
-- argv0: arg0
-- argv1: arg1
-- argv2: arg2
-- argv3: arg3
```

ARGC变量表示传递给函数的参数个数。

ARGV0, ARGV1, ARGV2代表传递给函数的实际参数。 

ARGN 代表超出最后一个预期参数的参数列表，例如，函数原型声明时，只接受一个参数，那么调用函数时传递给函数的参数列表中，从第二个参数（如果有的话）开始就会保存到 ARGN

```cmake
target_sources
target_link_libraries("${test_target_name}" leveldb)
```



### 2.2 宏 ###

宏与函数差不多，就是字符串替换，如下是简单的实例

```cmake
macro(add_test_library name libname)
    set(target_name test_${name})
    add_executable(
        ${target_name}
        test/test_${name}.cpp
    )
    target_link_libraries(
        ${target_name} PRIVATE
        ${libname}
    )
endmacro(add_test_library)
add_test_library(spdlog spdlog)
```

给定宏的名称，参数列表，我们可以遍历宏，链接多个lib

```cmake
macro(add_test_proc name)
    set(target_name ${name}_test)
    add_executable(
        ${target_name}
        test/${name}_test.cpp
    )
    #message(STATUS "this is args:${ARGV},ARGN=${ARGN}")
    set(libname_list "${ARGN}")
    foreach(libname IN LISTS libname_list)
        target_link_libraries(
            ${target_name} PRIVATE
            ${libname}
        )
    endforeach()
endmacro(add_test_proc)
add_test_proc(retriever_test Python3::Python cppzmq-static dbg-macro spdlog::spdlog)
```

宏和函数都不支持**return** ，需要传参出去，可以通过形参输入传出

```cmake
macro(ocv_xxx return_hello_world)
  set(return_hello_world "Hello_World")
endmacro()
```



### 2.3 测试 ###

```cmake
enable_testing()
add_test(NAME "${test_target_name}" COMMAND "${test_target_name}")
```



### 2.4 选项 ###

选项参数类似于C++中GFlags参数选项，提供默认值，也可以通过cmake指令中 -D 参数进行覆盖。

```cmake
option(LEVELDB_BUILD_TESTS "Build LevelDB's unit tests" ON)
find_package(Threads REQUIRED)
target_link_libraries(leveldb Threads::Threads)
```



### 2.5 子工程 ###

主要是 add_subdirectory 指令。

```cmake
macro(add_test_library name libname)
    add_subdirectory(${name} EXCLUDE_FROM_ALL)
    set(target_name test_${name})
    add_executable(
        ${target_name}
        test/test_${name}.cpp
    )
    target_link_libraries(
        ${target_name} PRIVATE
        ${libname}::${libname}
    )
endmacro(add_test_library)
add_test_library(spdlog spdlog)
```



### 2.6 代码生成 ###

#### 2.6.1 配置文件生成 ####

通过configure_file 指令生成文件

```cmake
set (BUILD_VERSION "3.23.1“)
configure_file(ver.h.in ${PROJECT_BINARY_DIR}/ver.h)

# configure the path.h.in file.
# This file can only use the @VARIABLE@ syntax in the file
configure_file(path.h.in ${PROJECT_BINARY_DIR}/path.h @ONLY)
```

path.in.in & ver.h.in 中可以通过 {} 或 @@ 语法引用CMake的变量，CMake会做字符串替换

```cpp
const char* ver = "${BUILD_VERSION}";
const char* path = "@CMAKE_SOURCE_DIR@";
```

#### 2.6.2 protobuf 生成 ####

```cmake
# find the protobuf compiler and libraries
find_package(Protobuf REQUIRED)
# Generate the .h and .cxx files
PROTOBUF_GENERATE_CPP(PROTO_SRCS PROTO_HDRS AddressBook.proto)
# Add an executable
add_executable(protobuf_example
    main.cpp
    ${PROTO_SRCS}
    ${PROTO_HDRS}
)
target_include_directories(protobuf_example
    PUBLIC
    ${PROTOBUF_INCLUDE_DIRS}
    ${CMAKE_CURRENT_BINARY_DIR}
)
# link the exe against the libraries
target_link_libraries(protobuf_example
    PUBLIC
    ${PROTOBUF_LIBRARIES}
)
```

####  ####

主要是通过 find_package 获取相关的路径。

- `PROTOBUF_FOUND` - If Protocol Buffers is installed
- `PROTOBUF_INCLUDE_DIRS` - The protobuf header files
- `PROTOBUF_LIBRARIES` - The protobuf library

#### 2.6.3 thrift 生成 ####



```cmake
add_custom_command(
    output ${PROJECT_BINARY_DIR}/gen/thrift/cpp/xdl/xdl_types.h
           ${PROJECT_BINARY_DIR}/gen/thrift/cpp/xdl/xdl_types.cpp
           ${PROJECT_BINARY_DIR}/gen/thrift/cpp/xdl/xdl_constants.h
           ${PROJECT_BINARY_DIR}/gen/thrift/cpp/xdl/xdl_constants.cpp
    # 生成异步的客户端
    command thrift::thrift -gen cpp:cob_style
            -out ${PROJECT_BINARY_DIR}/gen/thrift/cpp/xdl
            ${PROJECT_SOURCE_DIR}/src/proto/xdl.thrift
    depends ${PROJECT_SOURCE_DIR}/src/proto/xdl.thrift
 )
 add_executable(HelloWorldClientThrift
    src/HelloWorldClientThrift.cpp
    ${PROJECT_BINARY_DIR}/gen/thrift/cpp/xdl/xdl_types.h
    ${PROJECT_BINARY_DIR}/gen/thrift/cpp/xdl/xdl_types.cpp
    ${PROJECT_BINARY_DIR}/gen/thrift/cpp/xdl/xdl_constants.h
    ${PROJECT_BINARY_DIR}/gen/thrift/cpp/xdl/xdl_constants.cpp
    ${PROJECT_BINARY_DIR}/gen/thrift/cpp/xdl/HelloWorldService.cpp
)
target_link_libraries(HelloWorldClientThrift PRIVATE
	thrift::libthriftnb
	thrift::libthrift
	Threads::Threads
)
target_include_directories(HelloWorldClientThrift PRIVATE
	${PROJECT_BINARY_DIR}/gen/thrift/cpp/xdl
)
```



引用是



### 2.7 常用函数 ###

#### 2.7.1 get_filename_component ####

```cmake
get_filename_component(target_name "${CMAKE_CURRENT_SOURCE_DIR}" NAME)
```

赋值到target_name 的变量名中了。



#### 2.7.2 find_package ####

#### 2.7.3 add_dependencies ####

#### 2.7.4 add_custom_command ####

#### 2.7.5 mark_as_advanced ####

### 2.8   include ###

类似于C语言中include指令，将其它cmake文件“粘贴”到主CMakefile中。具体语法为

```cmake
include(<file|module> [OPTIONAL] [RESULT_VARIABLE <VAR>] [NO_POLICY_SCOPE])
```

可以是include其它cmake文件，或者include 其它的model

```cmake
#file
include(spdlog.cmake)
#Model
include(FetchContent)
include(CMakeParseArguments)
```

#### 2.9 install ####

install用于指定在安装时运行的规则。它可以用来安装很多内容，可以包括目标二进制、动态库、静态库以及文件、目录、脚本等

```cmake
install(TARGETS <target>... [...])
install({FILES | PROGRAMS} <file>... [...])
install(DIRECTORY <dir>... [...])
install(SCRIPT <file> [...])
install(CODE <code> [...])
install(EXPORT <export-name> [...])
```



```shell
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
```

定义的目标文件，即可执行二进制、动态库、静态库：

| 目标文件       | 内容                    | 安装目录变量                | 默认安装文件夹 |
| -------------- | ----------------------- | --------------------------- | -------------- |
| ARCHIVE        | 静态库                  | ${CMAKE_INSTALL_LIBDIR}     | lib            |
| LIBRARY        | 动态库                  | ${CMAKE_INSTALL_LIBDIR}     | lib            |
| RUNTIME        | 可执行二进制文件        | ${CMAKE_INSTALL_BINDIR}     | bin            |
| PUBLIC_HEADER  | 与库关联的PUBLIC头文件  | ${CMAKE_INSTALL_INCLUDEDIR} | include        |
| PRIVATE_HEADER | 与库关联的PRIVATE头文件 | ${CMAKE_INSTALL_INCLUDEDIR} | include        |

###  ###







## 3. 杂项 ##

