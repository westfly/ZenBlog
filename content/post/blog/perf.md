perf

使用`perf record`命令可以`profile`应用程序 （编译程序要使用`-g`，推荐使用`-g -O2`

```makefile
perf record -p pid
```

默认情况下，信息会存在`perf.data`文件里，使用`perf report`命令可以解析这个文件.

`perf record`时可以加`--call-graph dwarf`选项：

```
--call-graph
 Setup and enable call-graph (stack chain/backtrace) recording, implies -g.
 Default is "fp".
```





对于采用`--call-graph dwarf`选项生成的`perf.data`做出的[火焰图](https://github.com/brendangregg/FlameGraph)



`perf trace`有类似于`strace`功能



[KDAB/hotspot: The Linux perf GUI for performance analysis. (github.com)](https://github.com/KDAB/hotspot)

