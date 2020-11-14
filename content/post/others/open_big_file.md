---
title: "用 php 和 python 脚本处理大文件"
date: 2016-11-30T21:35:02+08:00
tags:
    - python
    - php
categories:
    - lang
comment: false
draft: true
---


一般情况下，我们对都需要处理大文件。用脚本处理尤其方便，但有些脚本对大文件的出有些问题，所以我们特殊处理下。

## python

在python中如果不处理编码问题的话，读写问题是很方便的一件事。一般的程序都会告诉你，按行处理的模式为[how-to-read-large-file-line-by-line-in-python](http://stackoverflow.com/questions/8009882/how-to-read-large-file-line-by-line-in-python)

```python
def batch_url_normalize(filename):
    """TODO: Docstring for batch_url_normalize.
    """
    with open(filename) as f:
        for line in f:
            process_line(line.rstrip('\n'))
    pass
```
但这种方法在处理大文件时有效率问题。

这里有一篇 处理文件的测试 [python 大文件以行为单位读取方式比对](http://www.cnblogs.com/aicro/p/3371986.html)

## php

php打开文件[打开文件的几种方法](http://www.cnblogs.com/younglab/archive/2011/11/06/2238034.html)

```php
function batch_url_normalize($filename)
{
    $handle = fopen($filename, "r") or die ("open fail");
    if ($handle) {
        while (!feof($handle)) {
            $buffer = fgets($handle, 40960);
            process_line(trim($buffer));
        }
        fclose($handle);
    }
}
```
