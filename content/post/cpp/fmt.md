

fmt



```cpp
#include <stdio.h>
#include <vector>
int main()
{
    printf("Hello, World!\n");
    std::vector<int> a = {1,33,4,4,3,3,3,3,33,3,3,3};
    printf("%d\t%d\n", a.size(), a.capacity());
    std::vector<int> b = std::move(a);
    printf("%d\t%d\n", a.size(), a.capacity());
    return 0;
}
```



