





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