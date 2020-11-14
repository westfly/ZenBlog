### cgo 最小的cgo程序 ###

我理解一个最小的 cgo调用程序。

```go
package main
// #include <stdlib.h>
import "C"
import (
	"fmt"
)
func main() {
	fmt.Println("%v", C.random())
    C.srandom(C.uint(100))
}
```

为啥不用 经典的HelloWorld 程序呢，是因为printf是变长参数，在cgo中还不太支持。

### 自定义方法 ###

除了调用标准库意外，我们还可以自定义方法，如果函数比较小，可以跟go文件写到一起，如下代码示例

```go
package main
// #include <stdlib.h>
// int add(int a, int b) {
//    return a + b;
// }
import "C"
import (
	"fmt"
)
func main() {
	fmt.Println("%v", C.random())
    C.srandom(C.uint(100))
    a := C.int(C.random())
    b := C.int(C.random())
	fmt.Println("%v + %v = %v", a, b, C.add(a, b))

```

1. 注释也支持C++的block方式注释 /* */
2. 必须在注释后，import "C"，这是个虚拟的命名空间，Go中所有引用C的都会置于这个空间下

在这一节介绍中，我们引入了C的类型类型和函数调用。

```
C.uint
C.int
```

### cgo include 包含 ###

当随着实现的复杂后，我们不得不将起抽象到一个文件中，相关的示例代码如下

```go
package main
/*
#include <stdlib.h>
#include "add.h"
*/
import "C"
import (
	"fmt"
)
func main() {
	fmt.Println("%v", C.random())
    C.srandom(C.uint(100))
    a := C.int(C.random())
    b := C.int(C.random())
	fmt.Println("%v + %v = %v", a, b, C.add(a, b))
}
```



我们用

```shell
go build -o test
# go run main.go 
```

go run 提示无法找到 add 的实现，这是 go build 在编译时，自动其 include 了相关的文件。

如果需要编译通过，则需要 cgo 指令了。



### cgo指令 ###

调用外部库需要用到 `#cgo` 伪指令, 他可以指定编译和链接参数，如 CFLAGS, CPPFLAGS, CXXFLAGS, FFLAGS and LDFLAGS。 

CFLAGS 可以配置 C 编译器参数，其中 -I 可以指定头文件目录

LDFLAGS 可以配置引用库的参数，其中 -L 指定引用库的目录，-l 指定库名称。

如果引用的头文件或者库在系统默认的目录下（例如 /usr/include, /usr/local/include 和 /usr/lib, /usr/local/lib）则可以不用指定目录。

`#cgo` 指令中可以添加限制平台的参数，例如只针对 linux 或者 darwin 平台，详情参考 https://golang.org/pkg/go/build/#hdr-Build_Constraints 。同时可以使用 `${SRCDIR}` 代替源代码目录的绝对路径。

如下我们指定 LDFLAGS 和 CFLAGS参数

```
package main

/*
#cgo CFLAGS: -I${SRCDIR}/cgo/include
#cgo LDFLAGS: -L${SRCDIR}/cgo/lib -lop
#include <stdlib.h>
#include "add.h"
*/
import "C"
import (
	"fmt"
)

func main() {
	fmt.Println("%v", C.random())
	C.srandom(C.uint(100))
	a := C.int(C.random())
	b := C.int(C.random())
	fmt.Println("%v + %v = %v", a, b, C.add(a, b))
}

```

这时需要预先把add.c 编译为lib的形式

```makefile
all:
        gcc -c add.c -o /tmp/add.o
        ar rvs lib/libop.a /tmp/add.o
        export GO111MODULE=off
        go build main.go

```

在相当于路径时，我们可以用



## 参数类型 ##

### 基础类型 ###

Go的类型与C的类型并不一样，如下是一个简单的映射表格

| C语言类型              | CGO类型     | Go语言类型 |
| ---------------------- | ----------- | ---------- |
| char                   | C.char      | byte       |
| singed char            | C.schar     | int8       |
| unsigned char          | C.uchar     | uint8      |
| short                  | C.short     | int16      |
| unsigned short         | C.ushort    | uint16     |
| int                    | C.int       | int32      |
| unsigned int           | C.uint      | uint32     |
| long                   | C.long      | int32      |
| unsigned long          | C.ulong     | uint32     |
| long long int          | C.longlong  | int64      |
| unsigned long long int | C.ulonglong | uint64     |
| float                  | C.float     | float32    |
| double                 | C.double    | float64    |
| size_t                 | C.size_t    | uint       |
| int8_t                 | C.int8_t    | int8       |
| uint8_t                | C.uint8_t   | uint8      |
| int16_t                | C.int16_t   | int16      |
| uint16_t               | C.uint16_t  | uint16     |
| int32_t                | C.int32_t   | int32      |
| uint32_t               | C.uint32_t  | uint32     |
| int64_t                | C.int64_t   | int64      |
| uint64_t               | C.uint64_t  | uint64     |







### 结构体 ###

在 C 中定义的结构体，

```c
typedef struct CombineResult {
  uint64_t *indices;
  uint64_t *offsets;
  size_t indices_size;
  size_t offsets_size;
  size_t indices_capacity;
  size_t offsets_capacity;
} CombineResult;
int CombineToIndicesAndOffsets(void *ib, void *cs, CombineResult *result);
```

在Go中引用该结构体，只需要 C.struct_ 前缀即可，enum,union和sizeof也类似。

```go
combine_res := C.struct_CombineResult{}
C.CombineToIndicesAndOffsets(ib, cs, &combine_res)
fmt.Printf("size=%v capacity=%v onesize=%v\n",
		combine_res.offsets_size, combine_res.offsets_capacity, unsafe.Sizeof(combine_res))
```

如有需要引用 struct 成员变量，因为需要1中的逆序类型转换

```go
i := int(combine_res.offsets_capacity) 
func print(i int) {
   fmt.Println("%v", i);
}
print(i)
```

 ***C.struct_xxx***结构体的内存布局按照C语言的通用对齐规则,在32位Go语言环境C语言结构体也按照32位对齐规则,在64位Go语言环境按照64位的对齐规则。对于指定了特殊对齐规则的结构体,无法在CGO中访问。如果结构体的成员名字中碰巧是Go语言的关键字,可以通过在成员名开头添加下划线来访问。

C语言结构体中位字段对应的成员无法在Go语言中访问,如果需要操作位字段成员,需要通过在C语言中定义辅助函数来完成。对应零长数组的成员,无法在Go语言中直接访问数组的元素,但其中零长的数组成员所在位置的偏移量依然可以通过 ***unsafe.Offsetof(a.arr)*** 来访问。

在C语言中,我们无法直接访问Go语言定义的结构体类型。

### 指针类型 ###

指针类型可以直接在普通类型前加星号来表示，比如`*C.char`、`*C.int`等。

比较特殊的是`void *`,它的对应类型是`unsafe.Pointer`。Go中禁止对指针进行算术操作，`unsafe.Pointer`类型可以直接转换成`uintptr`作为数字进行操作，来绕开Go对指针运算的限制。
另外一点就是在判断指针是否为空时可以直接拿指针与`nil`比较，不必与`unsafe.Pointer(uintptr(0))`或其他类型指针零值比较。



### 数组类型 ###

数组类型跟指针比较类似。

```go

func CArrayToGoArray(cArray unsafe.Pointer, size int) (goArray []uint64) {
    p := uintptr(cArray)
    for i :=0; i < size; i++ {
        j := *(*uint64)(unsafe.Pointer(p))
        goArray = append(goArray, j)
        p += unsafe.Sizeof(j)
    }
    return
}
```



### 字符串 ###

由于字符串比较特殊，所以专门有`C.CString`类型对应。注意这个强制类型转换会分配一块空间然后将原字符串拷贝过去，而且这块空间不会被Go的垃圾回收扫描到，所以记得用`C.free`来回收。

但对于无须管理内存的，根据在reflect包中有字符串和切片的定义

```go
type StringHeader struct {
 Data uintptr
 Len  int
}

type SliceHeader struct {
    Data uintptr
    Len  int
    Cap  int
}
```



```go
/*
#include<stdio.h>
typedef struct StringView {
  char *data;
  size_t len;
} StringView;
void OnlyDebug(const StringView *sv) {
	if (sv) {
        int len =  sv->len;
        printf("put %.*s\t %d\n", len, sv->data, len);
    }
}
void BatchArrayDebug(const StringView *arr, int size) {
    for(int i=0;i < size;i++) {
    	OnlyDebug(arr + i);
    }
}
*/
func InitStringViewWithCacheNoAlloc(sv *C.struct_StringView, key string) {
	p := (*reflect.StringHeader)(unsafe.Pointer(&key))
	sv.data = (*C.char)(unsafe.Pointer(p.Data))
	sv.len = C.ulong(len(key))
}

```



我们逆序来转换呢 

不单独分配内存,可以在Go语言中直接访问C语言的内存空间。因为Go语言的字符串是只读的,用户需要自己保证Go字符串在使用期间,底层对应的C字符串内容不会发生变化、内存不会被提前释放掉。

code from https://gongluck.netlify.app/go/cgo_types/

```go
package main

/*
#include <string.h>
char arr[10];
char *s = "Hello";
*/
import "C"
import (
    "fmt"
    "reflect"
    "unsafe"
)

func main() {
    // C array -> Go slice
    var arr0 []byte
    var arr0Hdr = (*reflect.SliceHeader)(unsafe.Pointer(&arr0))
    arr0Hdr.Data = uintptr(unsafe.Pointer(&C.arr[0]))
    arr0Hdr.Len = 10
    arr0Hdr.Cap = 10

    arr1 := (*[31]byte)(unsafe.Pointer(&C.arr[0]))[:10:10]
    fmt.Println(arr1)

    // C string -> Go string
    var s0 string
    var s0Hdr = (*reflect.StringHeader)(unsafe.Pointer(&s0))
    s0Hdr.Data = uintptr(unsafe.Pointer(C.s))
    s0Hdr.Len = int(C.strlen(C.s))

    sLen := int(C.strlen(C.s))
    s1 := string((*[31]byte)(unsafe.Pointer(C.s))[:sLen:sLen])
    fmt.Println(s1)
}
```

### 内存访问限制 ###

在C中

### 调用C++ ###

C++ 的代码目前没法内联在 Go 代码里，只能通过外部库方式引用，同时 cgo 也没办法直接调用 C++ 代码, 类也没法 new, 除了 extern “C” 方式声明的函数。所以 Go 要想调用 C++ 代码，可以通过 C 代码调 C++, 然后通过 Go 调 C 代码来实现。

调用C++ 有两个需要注意的地方

* 需要用 C 的接口包裹一下
* 以lib的形式提供，并且需要连接-lstdc++

## 动态库 ##

动态的方式比较类似，但在部署的时候，需要将对应的so拷贝 LD_LIBRARY_PATH 下。

## cgo原理 ##



在Go中调用C函数，cgo生成的代码调用 `runtime.cgocall(_cgo_Cfunc_f, frame)`，`_cgo_Cfunc_f` 就是GCC编译 出来的代码。 `runtime.cgocall` 会调用 `runtime.asmcgocall(_cgo_Cfunc_f, frame)`。

`runtime.asmcgocall` 会切换到`m->go` 的栈然后执行代码，因为 `g0` 的栈是操作系统分配的栈(大小为8k)，足够 执行C代码。 `_cgo_Cfunc_f` 在frame中执行C函数，然后返回到 `runtime.asmcgocall`。之后再切回调用它的 G的栈。



## C中调用Go ##



```c
typedef struct {
  const char *p;
  ptrdiff_t n;
} GoString;
typedef struct {
  void *data;
  GoInt len;
  GoInt cap;
} GoSlice;
```



可以通过如下

```c++
size_t _GoStringLen(_GoString_ s);
const char *_GoStringPtr(_GoString_ s);
```

### gperf ###

/root/pprof/pprof.drs_server.samples.cpu.003.pb.gz





## 参考文献 ##

https://blog.ihuxu.com/the-note-of-cgo-usage/

https://jiajunhuang.com/articles/2018_06_15-cgo.md.html

https://github.com/golang/go/wiki/cgo
https://golang.org/cmd/cgo/
https://blog.golang.org/c-go-cgo
https://book.douban.com/subject/3652388/
https://golang.org/src/runtime/cgocall.go

https://gongluck.netlify.app/go/cgo_types/

[cgo的指针传递](https://segmentfault.com/a/1190000013590585)

https://chai2010.cn/advanced-go-programming-book/ch2-cgo/ch2-07-memory.html



https://cloud.tencent.com/edu/learning/course-2412-38361