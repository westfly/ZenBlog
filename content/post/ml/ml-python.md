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

## 1. 安装 ##

| 管理工具  | 场景                                 |
| --------- | ------------------------------------ |
| pip       | Python 包和依赖关系管理工具          |
| pip-tools | 保证 Python 包依赖关系更新的一组工具 |
| pipenv    | Python 官方推荐的新一代包管理工具    |
| poetry    | 全取代 setup.py 的包管理工具         |
| poetry    | 可完全取代 setup.py 的包管理工具     |
| conda     | 跨平台，Python 二进制包管理工具      |
| Curdling  | Python 包的命令行工具                |
| wheel     | Python 分发的新标准，意在取代 eggs   |

本文以anaconda为蓝本介绍。

1.1 anaconda

Anaconda具有如下特点：

- 开源
- 安装过程简单
- 高性能使用Python和R语言
- 免费的社区支持

其特点的实现主要基于Anaconda拥有的：

- Conda包
- 环境管理器
- 1,000+开源库

下载 [anaconda](https://www.anaconda.com/download/#windows)，安装好后，修改更新源为国内的镜像

```shell
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --set show_channel_urls yes
```

conda 是 Anaconda 下用于包管理和环境管理的工具，功能上类似 pip 和 vitualenv 的组合。安 装成功后 conda 会默认加入到环境变量中，因此可直接在命令行窗口运行命令 conda conda 的环境管理与 virtualenv 是基本上是类似的操作。 

```shell
# 查看帮助
conda -h
# 基于python3.6版本创建一个名字为python36的环境
conda create --name python37 python=3.7
# 激活此环境 
activate python37
source activate python36 # linux/mac 
# 再来检查python版本，显示是 3.7
python -V 
# 退出当前环境 
deactivate python37 
# 删除该环境 
conda remove -n python37 --all 
# 或者 
conda env remove -n python37 
# 查看所以安装的环境
conda info -e
```

如上的操作，也可以从GUI操作，但是响应速度有些慢。

### 1.2 安装pytorch ###

到[pytorch](https://www.pytorch.org)的官网上，获取安装 pytorch 的命令，安装不含cuda的包

```shell
pip install torch==1.5.0+cpu torchvision==0.6.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
```

可以通过如下命令，查看是否安装成功

```shell
conda list |grep torch
torch                     1.5.0+cpu                pypi_0    pypi
torchvision               0.6.0+cpu                pypi_0    pypi
wincertstore              0.2                      py37_0    defaults
```

### 1.3  Jupyter ###

Jupyter Notebook本身是默认使用一种Anaconda中root目录下的Python环境的，如果想使用其它的虚拟环境，还需要通过插件来实现，也就是nb_conda插件

```shell
conda install nb_conda
```



## 2. 简明教程 ##

### 2.1 Python接口教程 ###

python 版本按照官方的教程，一步步走即可，在使用前，请用pyenv升级python的版本

```shell
export 'PYENV_VERSION=3.7.7'
pyenv global 3.7.7
pip install --upgrade pip
pip install torch torchvision
```

Tensor（张量）



### 2.2  libtorch ###

参考 [C++](https://pytorch.org/docs/stable/cpp_index.html) 教程，

```cpp
#include <torch/script.h> // One-stop header.
#include <iostream>
#include <memory>
int main(int argc, const char* argv[]) {
  if (argc != 2) {
    std::cerr << "usage: example-app <path-to-exported-script-module>\n";
    return -1;
  }
  // Deserialize the ScriptModule from a file using torch::jit::load().
  std::shared_ptr<torch::jit::script::Module> module = torch::jit::load(argv[1]);
  assert(module != nullptr);
  // Create a vector of inputs.
  std::vector<torch::jit::IValue> inputs;
  inputs.push_back(torch::ones({1, 3, 224, 224}));
  // Execute the model and turn its output into a tensor.
  auto output = module->forward(inputs).toTensor();
  std::cout << output.slice(/*dim=*/1, /*start=*/0, /*end=*/5) << '\n';
}
```

torch::jit::script::Module 是一个通用的模块，有个 forward 的接口，进行计算。

https://pytorch.org/tutorials/advanced/cpp_export.html

| 模块               | 功能                                                         |
| ------------------ | ------------------------------------------------------------ |
| **ATen**           | The foundational tensor and mathematical operation library on which all else is built |
| **Autograd**       | Augments ATen with automatic differentiation;                |
| **C++ Frontend**   | High level constructs for training and evaluation of machine learning models; |
| **TorchScript**    | An interface to the TorchScript JIT compiler and interpreter; |
| **C++ Extensions** | A means of extending the Python API with custom C++ and CUDA routines. |







[Loading a TorchScript Model in C++](https://pytorch.org/tutorials/advanced/cpp_export.html)

提供了两种方式，一种是计算类型的方式，然后到处module。

```python
import torch
import torchvision
# An instance of your model.
model = torchvision.models.resnet18()
# An example input you would normally provide to your model's forward() method.
example = torch.rand(1, 3, 224, 224)
# Use torch.jit.trace to generate a torch.jit.ScriptModule via tracing.
traced_script_module = torch.jit.trace(model, example)
traced_script_module.save("traced_resnet_model.pt")
```

一种是继承类型的方法，都可以save

```python
class MyModule(torch.nn.Module):
    def __init__(self, N, M):
        super(MyModule, self).__init__()
        self.weight = torch.nn.Parameter(torch.rand(N, M))
    def forward(self, input):
        if input.sum() > 0:
          output = self.weight.mv(input)
        else:
          output = self.weight + input
        return output
my_module = MyModule(10,20)
sm = torch.jit.script(my_module)
sm.save("my_module_model.pt")
```



```cpp
torch::jit::script::Module module;
try {
    // Deserialize the ScriptModule from a file using torch::jit::load().
    module = torch::jit::load(model_name);
} catch (const c10::Error &e) {
    std::cerr << "error loading the model\n";
    return -1;
}
std::cout << "load " << model_name << " OK\n";
std::vector<torch::jit::IValue> inputs;
inputs.push_back(torch::ones({1, 3, 224, 224}));
// Execute the model and turn its output into a tensor.
at::Tensor output = module.forward(inputs).toTensor();
```

通过 torch::jit::load 加载模型的数据，转换为Model。

`torch::jit::IValue` 作为Module的输入和输出参数（类型被擦除），Forword 返回类型为`torch::jit::IValue`，  调用toTensor 转为 Tensor



[The Torch Script Reference](https://pytorch.org/docs/master/jit.html)

[The PyTorch C++ API documentation](https://pytorch.org/cppdocs)

[The PyTorch Python API documentation](https://pytorch.org/docs/)





## 3. 高级教程 ##

### 3.0 追踪图 ###

```python
import torch
def compute(x, y, z):
    return x.matmul(y) + torch.relu(z)

inputs = [torch.randn(4, 8), torch.randn(8, 5), torch.randn(4, 5)]
trace = torch.jit.trace(compute, inputs)
print(trace.graph)
```



新建文件 graph.py  ，不能只在stdin测试（为啥？）

```python
import torch
@torch.jit.script
def compute_auto(x, y, z):
    return x.matmul(y) + torch.relu(z)

print(compute_auto.graph)
```

输出为

```python
graph(%x.1 : Tensor,
      %y.1 : Tensor,
      %z.1 : Tensor):
  %8 : int = prim::Constant[value=1]()
  %5 : Tensor = aten::matmul(%x.1, %y.1) # pytorch/graph.py:4:11
  %7 : Tensor = aten::relu(%z.1) 		# pytorch/graph.py:4:25
  %9 : Tensor = aten::add(%5, %7, %8) # pytorch/graph.py:4:11
  return (%9)
```

@torch.jit.script 能够自动生成



### 3.1 自定义运算符 ###

1. 定义接口实现

```cpp
// 1. 定义接口实现
torch::Tensor warp_perspective(torch::Tensor image, torch::Tensor warp) {
     return image.matmul(warp) + torch::relu(warp);
}
// 2. 注册
static auto registry =
  torch::RegisterOperators("my_ops::warp_perspective", &warp_perspective);
```

这里的RegisterOperators有一系列的操作符，可以级联，类似于pybind11中的def。

2. 在cmake中，让op.cpp编译为 so

```cmake
# Define our library target
add_library(warp_perspective SHARED op.cpp)
# Enable C++11
target_compile_features(warp_perspective PRIVATE cxx_range_for)
# Link against LibTorch
target_link_libraries(warp_perspective "${TORCH_LIBRARIES}")
```

3. 编译为 libwarp_perspective.so 可以动态的加载到Python中

```python
import torch
torch.ops.load_library("build/libwarp_perspective.so")
print(torch.ops.my_ops.warp_perspective)
#call
torch.ops.my_ops.warp_perspective(torch.randn(3, 3), torch.rand(3, 3))
```



我们还可以将其保存为

```python
import torch
torch.ops.load_library("build/libwarp_perspective.so")
@torch.jit.script
def compute(x, y):
  x = torch.ops.my_ops.warp_perspective(x, y)
  return x.matmul(y) + z
compute.save("example.pt")
```

然后再通过C++代码加载即可。

加载有两种方法

一种是

上面的示例中嵌入了一个关键细节：`warp_perspective`链接行的`-Wl,--no-as-needed`前缀。 这是必需的，因为我们实际上不会在应用程序代码中从`warp_perspective`共享库中调用任何函数。 我们只需要运行全局`RegisterOperators`对象的构造函数即可。 麻烦的是，这使链接器感到困惑，并使其认为可以完全跳过针对库的链接。

经过测试，通过dlopen加载so也是可行 。





### 3.2 自定义类扩展 ###

定义一个简单的 C ++类，该类在成员变量中保持持久状态

```cpp
#include <string>
#include <torch/script.h>
#include <vector>

template <class T>
struct MyStackClass : torch::CustomClassHolder {
  std::vector<T> stack_;
  MyStackClass(std::vector<T> init) : stack_(init.begin(), init.end()) {}

  void push(T x) { stack_.push_back(x); }
  T pop() {
    auto val = stack_.back();
    stack_.pop_back();
    return val;
  }

  c10::intrusive_ptr<MyStackClass> clone() const {
    return c10::make_intrusive<MyStackClass>(stack_);
  }

  void merge(const c10::intrusive_ptr<MyStackClass> &c) {
    for (auto &elem : c->stack_) {
      push(elem);
    }
  }
  int64_t size(const c10::intrusive_ptr<MyStackClass> &self) {
    return self->stack_.size();
  }
};

static auto testStack =
    torch::class_<MyStackClass<std::string>>("myclasses", "MyStackClass")
        .def(torch::init<std::vector<std::string>>())
        .def("push", &MyStackClass<std::string>::push)
        .def("pop", &MyStackClass<std::string>::pop)
        .def("top",
             [](const c10::intrusive_ptr<MyStackClass<std::string>> &self) {
               return self->stack_.back();
             })
        .def("clone", &MyStackClass<std::string>::clone)
        .def("merge", &MyStackClass<std::string>::merge)
        .def("size", &MyStackClass<std::string>::size)
        .def("sizen",
             [](const c10::intrusive_ptr<MyStackClass<std::string>> &self) {
               return (int64_t)self->stack_.size();
             });
```

myclasses 是注册的命令空间，必须是一个合法的命名空间名称，否则会报错

保存为pystack.cpp，然后通过cmake编译为so文件

```cmake
set(Torch_DIR libtorch/share/cmake/Torch)
find_package(Torch REQUIRED)
add_library(pystack SHARED
    tests/ml/ranking/pystack.cpp
)
target_link_libraries(pystack
    "${TORCH_LIBRARIES}"
)
```



在python中使用

```python
import torch
torch.classes.load_library("build/libpystack.so")
print(torch.classes.loaded_libraries)
s = torch.classes.myclasses.MyStackClass(["foo", "bar"])
s.size(s)
s.sizen()
s.push("pushed")
assert s.pop() == "pushed"
```

注意两个size的调用方式。

我们也可以将其保存到 `ScriptModule`文件。

```python
import torch
torch.classes.load_library('build/libpystack.so')
class Foo(torch.nn.Module):
    def __init__(self):
        super().__init__()

    def forward(self, s : str) -> str:
        stack = torch.classes.Stack(["hi", "mom"])
        return stack.pop() + s

scripted_foo = torch.jit.script(Foo())
print(scripted_foo.graph)
scripted_foo.save('pytorch/foo.pt')
```



然后在通过 `ScriptModule`模块加载

```c++
int load_model_forward(const std::string& model_name) {
    torch::jit::script::Module module;
    try {
        // Deserialize the ScriptModule from a file using torch::jit::load().
        module = torch::jit::load(model_name);
    } catch (const c10::Error &e) {
        std::cerr << "error loading the model\n";
        return -1;
    }
    std::vector<c10::IValue> inputs = {"foobarbaz"};
    auto output = module.forward(inputs).toString();
    std::cout << output->string() << std::endl;
    return 0;
}
```

同样需要注意的是，在cmake中，建议启用参数，保证so强制被链接加载

```gcc
 -Wl,--no-as-needed
```



我们需要把自定义绑定 C ++类的`ScriptModule`保存为类属性

```python
import torch
torch.classes.load_library('build/libpystack.so')
class Foo(torch.nn.Module):
  def __init__(self):
      super().__init__()
      self.stack = torch.classes.myclasses.MyStackClass(["just", "testing"])
  def forward(self, s : str) -> str:
      return self.stack.pop() + s
scripted_foo = torch.jit.script(Foo())
scripted_foo.save('pytorch/foo.pt')
```

执行时，则会出现错误

```
RuntimeError: Cannot serialize custom bound C++ class __torch__.torch.classes.myclasses.MyStackClass. Please define serialization methods via def_pickle() for this class
```

原因是 TorchScript 无法自动找出 C ++类中保存的信息。 您必须手动指定。 这样做的方法是使用`class_`上的特殊`def_pickle`方法在类上定义`__getstate__`和`__setstate__`方法。

```c++
.def("clone", &MyStackClass<std::string>::clone)
.def_pickle(
    // __getstate__
    [](const c10::intrusive_ptr<MyStackClass<std::string>>& self) {
        return self->stack_;
    },
    //__setstate__
    [](std::vector<std::string> state) {
        return c10::make_intrusive<MyStackClass<std::string>>(std::move(state));
    });
```



在C++中使用，直接链接到代码库中就好。

```c++
class TORCH_API CustomClassHolder : public c10::intrusive_ptr_target {};
namespace jit {
using ::torch::CustomClassHolder;
};

```

[IValue](https://pytorch.org/cppdocs/api/structc10_1_1_i_value.html#structc10_1_1_i_value) (Interpreter Value) is a tagged union over the types supported by the TorchScript interpreter.

IValues contain their values as an `IValue::Payload`, which holds primitive types (`int64_t`, `bool`, `double`, `Device`), as values and all other types as a `c10::intrusive_ptr`



### 3.3 C++ 前端接口 ###

[使用 PyTorch C++ 前端](https://zhuanlan.zhihu.com/p/55999895)

C ++是一种较低级的语言，它在此领域提供了更多选择。 这增加了复杂性。

```cpp
struct Net : torch::nn::Module { };

void a(Net net) { }
void b(Net& net) { }
void c(Net* net) { }
```

所以为了跟Python类似，所以通过shared_ptr来管理内存，并提供了 *TORCH_MODULE* 宏来包裹。

```cpp
struct LinearImpl : torch::nn::Module {
  LinearImpl(int64_t in, int64_t out);
  Tensor forward(const Tensor& input);
  Tensor weight, bias;
};

TORCH_MODULE(Linear);
```

宏`TORCH_MODULE`定义了实际的`Linear`类。 这个“生成的”类实际上是`std::shared_ptr<LinearImpl>` 的包装。 它是一个包装器，而不是简单的 typedef。最终结果是所有权模型非常类似于 Python API。 引用语义成为默认语义，但是没有额外输入`std::shared_ptr`或`std::make_shared`。

```cpp
struct NetImpl : torch::nn::Module {
  Net(int64_t N, int64_t M, int def)
      : linear(register_module("linear", torch::nn::Linear(N, M))) {}
  Net(int64_t N, int64_t M) {
    linear = register_module("linear", torch::nn::Linear(N, M));
  }
  torch::nn::Linear linear{nullptr}; // construct an empty holder
};
TORCH_MODULE(Net);
void a(Net net) {
    
}
```



这种情况下，默认的 Net 实际上是一个nullptr，我们通过如上的register_module 宏来reset该对象。

[nn](https://pytorch.org/cppdocs/api/namespace_torch__nn.html)



### 3.4 序列化 ###

pt实际上是一个zip包

```shell
example/
├── code
│   ├── __torch__.py
│   └── __torch__.py.debug_pkl
├── constants.pkl
├── data.pkl
└── version
```



## 4. cmake 集成 ##

```cmake
execute_process(
    COMMAND python3 -c "import sysconfig; print(sysconfig.get_paths()['purelib'], end='');"
    RESULT_VARIABLE RES
    OUTPUT_VARIABLE PYTHON_LIBRARY
    ERROR_QUIET
)
execute_process(
    COMMAND python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc(), end='')"
    RESULT_VARIABLE RES
    OUTPUT_VARIABLE PYTHON_INCLUDE_DIR
    ERROR_QUIET
)
message("${PYTHON_LIBRARY} @@@@ ${PYTHON_INCLUDE_DIR}")
set(Torch_DIR ${PYTHON_LIBRARY}/torch/share/cmake/Torch)
find_package(Torch REQUIRED)
```

这段代码，主要是为了获取Python的编译目录

```

```



## 参考资料 ##

[Anaconda介绍、安装及使用教程](https://zhuanlan.zhihu.com/p/32925500)

[Jupyter Notebook介绍、安装及使用教程](https://zhuanlan.zhihu.com/p/33105153)

https://github.com/pytorch/pytorch

https://pytorch.org/tutorials/index.html

https://pytorch.apachecn.org/docs/1.4/

https://github.com/zergtant/pytorch-handbook

