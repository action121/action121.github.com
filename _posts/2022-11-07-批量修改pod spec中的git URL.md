---
layout: post
title: '批量修改pod spec中的git URL'
subtitle: ''
date: 2022-11-07
categories: cocoapods
cover: ''
tags: cocoapods
---


# 批量修改pod spec中的git URL

将cocoapods spec中 https git URL修改成SSH git URL。

例如：

https://gitlab.XXXXXXX.com/md-app/XXXX/XXXX.git

修改成

git@gitlab.XXXXXX.com:md-app/XXXXX.git

## 实现思路

cocoapods spec文件太多，逐个修改工作量太大。

不修改spec文件，pod update时，修改运行时数据。

通过翻阅源码，pre_install 和 post_install 两个public hook api，调用时机已滞后。

需要修改源码。


## 修改cocoapods脚本

1. cocoapods 版本

```
 pod --version
```

2. cocoapods脚本路径

```
/Library/Ruby/Gems/2.6.0/gems
```

根据自己cocoapods实际版本情况，找到相应的代码目录。


3. 修改abstract_external_source.rb。

添加代码见下图

![](../../../assets/img/16677958599881/16677958741556.jpg)

```
require 'active_support/core_ext/string/inflections'
```


```      
def initialize(name, params, podfile_path, can_cache = true)
        @name = name
        @params = params
        @podfile_path = podfile_path
        @can_cache = can_cache
        if !@params[:git].nil?
          git_value = @params[:git].gsub('https://gitlab.btpoc.com/', 'git@gitlab.btpoc.com:')
          @params[:git] = git_value
        end
end
```

## 效果

```
pod update --verbose --no-repo-update
```


![](../../../assets/img/16677958599881/16677965724268.jpg)

## 可能存在的问题&解决方案

![](media/16677958599881/16677971080119.jpg)

通过ssh连上服务器后，一段时间不操作，就会自动中断，并报出以下信息：

```
client_loop: send disconnect: Broken pipe
```

解决方案：

配置`~/.ssh/config`文件，增加以下内容即可：

```
Host *         
   # 断开时重试连接的次数         
   ServerAliveCountMax 5          
   # 自动发送一个空的请求以保持连接，单位秒         
   ServerAliveInterval 60
```
