下载breakpad源码[https://github.com/google/breakpad](https://github.com/google/breakpad)，在Linux环境下编译。
 编译时，我这里遇到错误，缺少 src/third_party/lss/linux_syscall_support.h
 去github上搜索下载这个文件（原Google的git连接已经失效），[https://github.com/webrtcmirrors/vendor_linux-syscall-support](https://github.com/webrtcmirrors/vendor_linux-syscall-support)，我用的是这个。注意很多是针对MIPS的，并不适用。

https://chromium.googlesource.com/breakpad/breakpad/+/master/docs/linux_starter_guide.md

简单的产出了minicore文件。

https://www.chromium.org/developers/decoding-crash-dumps

https://github.com/mozilla-services/socorro 服务端

https://spin.atomicobject.com/2013/01/13/exceptions-stack-traces-c/





![img](https://images2015.cnblogs.com/blog/1012444/201611/1012444-20161118132103482-2030701003.png)

![img](https://upload-images.jianshu.io/upload_images/1784193-686f5ee1644fda90.png?imageMogr2/auto-orient/strip|imageView2/2/w/481/format/webp)

具体参数：

- descripter，minidump文件写入的目录
- filter，可选，在写minidump文件之前，会先调用filter回调。根据它返回true/false来决定是否需要写minidump文件。
- callback, 可选，在写minidump文件之后调用的回调函数
- callback_context,
- install_handler, 如果为ture，不管怎样当未捕捉异常被抛出时都会写入minidump文件，如果为false则必须明确调用了 `WriteMinidump` 才会写入minidump 文件
- server_fd, 如果为-1，则使用同线程模式（in-precess），如果有一个有效的值，则使用跨线程模式（out-of-process)





https://stackoverflow.com/questions/12049692/how-can-i-get-all-the-memory-of-the-coredump-with-google-breakpad