

为GDB增加STL调试支持 





```
wget http://www.yolinux.com/TUTORIALS/src/dbinit_stl_views-1.03.txt
cat $ >> ~/.gdbinit
```

http://www.yolinux.com/TUTORIALS/src/dbinit_stl_views-1.03.txt



或者gdb 后，source一下



加载之

```shell
pmap variable------------>打印variable这个map的定义和map里面的个数
pmap variable int  int (就是单纯的两个int) ------------>打印pmap的元素和map的个数

pmap variable int int 20------------>打印索引是20的map的值 和map的个数

pmap variable int int 20 200------->打印索引是20 值是200的map值和map的个数
```



参考资料

https://sourceware.org/gdb/wiki/STLSupport