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





```cpp
#include <vector>
#include <string>
#include <stdio.h>
int main(int argc, const char *argv[])
{
    using namespace std;
    vector<string> vs;
    for (int i = 0; i < 4; i++) {
       vs.push_back("a");
    }
    for (int i = 0; i < 4; i++) {
       printf("%d\t%p\n", i, &vs[i]);
    }
    for (int i = 0; i < 4; i++) {
       vs[i].append("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
    }
    for (int i = 0; i < 4; i++) {
       printf("%d\t%p\n", i, &vs[i]);
    }
    return 0;
}
```

地址不会变更，string的扩容是安全的。