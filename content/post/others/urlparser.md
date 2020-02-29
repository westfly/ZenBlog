---
title: "php 和 python 中的 urlparse"
date: 2016-11-30T21:35:02+08:00
tags:
    - python
    - php
categories:
    - lang
comment: false
draft: true

---

## PHP 无法显示

在php中有个解析url的函数，[parse_url](http://php.net/manual/zh/function.parse-url.php)。
在使用时，发现对于某些url，无法获取path路径

```php
<?php
function url_normalize($url)
{
    $url_array = parse_url($url);
    // avoid null url
    if (isset($url_array["scheme"]))
    {
        // trim last \
        $path="";
        if (isset($url_array["path"]))
        {
            $path=$url_array["path"];
        }
        $nurl = sprintf("%s://%s%s", $url_array["scheme"],
                        $url_array["host"], rtrim($path, "/"));
        printf("%s\n%s\t%s\t%s\n", $url, $nurl, $url_array["host"], $path);
    }
}
foreach($argv as $key => $value)
{
    if (strrchr($value, ".php") == ".php")
    {
        continue;
    }
    url_normalize($value);
}
?>
```

代码示例如上，调用

```shell
php url_normalize.php 'http://wap1.cclongxb.com/szqpz/21.html#sgjj2SJ-b?2szpzbwdmc-0009#7'
```

得到的path为空,php的版本为5.3.3

感觉如果有#和?字符存在的话，会有问题，我不太想深究原因，因为php并非我主要的开发语言。
于是转换到python中去，相同的代码如下

```python
import urlparse
def url_normalize(url):
    o=urlparse.urlparse(url);
    nurl="%s://%s%s" %(o.scheme, o.netloc, o.path)
    return nurl;
import sys
print url_normalize(sys.argv[1])
```

得到不含query和锚#的url
<http://wap1.cclongxb.com/szqpz/21.html>
fix掉，被python折磨的编码问题，不复存在的感觉真好。
