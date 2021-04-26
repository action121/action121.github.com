---
layout: post
title: 'cocoapods install加速'
subtitle: ''
date: 2021-03-25
categories: 工程效率
cover: ''
tags: cocoapods,工程效率
---

# 前言

本文重点不在介绍cocoapods各种细枝末节。

本文关注pod install 对branch依赖的加速。

# 1、简单了解一下Podfile库依赖方式

Podfile库依赖方式有如下几种

## 1.1、使用本地路径的依赖

如果项目和 Pod 库同时进行开发，则可以使用 `path` 选项。


```
pod 'AFNetworking', :path => '~/Documents/AFNetworking'
```
## 1.2、使用指定地址的 pod 库-branch

有时可能需要使用最新版本或特别修改过的 Pod。

这种情况下，可以指定 pod 库的地址。

使用依赖库的 master 分支：


```
pod 'AFNetworking', :git => 'https://github.com/gowalla/AFNetworking.git'
```

指定使用依赖库的另一个分支：


```
pod 'AFNetworking', :git => 'https://github.com/gowalla/AFNetworking.git', :branch => 'dev'
```

## 1.3、使用指定地址的 pod 库 - tag

方式1：
```
pod 'AFNetworking',:tag => '0.7.0'
```

方式2：
```
pod 'AFNetworking', :git => 'https://github.com/gowalla/AFNetworking.git', :tag => '0.7.0'
```

## 1.4、指定某次提交


```
pod 'AFNetworking', :git => 'https://github.com/gowalla/AFNetworking.git', :commit => '082f8319af'
```

## 2、遇到的问题

pod install，会基于git指令进行库的下载操作。

第一次下载远程仓库时，默认clone了git的所有提交记录。

如果一个库长期频繁操作，提交大文件等，会导致.git目录持续膨胀。

不注意的情况下有些库整体clone大小可以膨胀到几个G。


这就带来了问题:

1、当项目过大时，git clone时会出现error: RPC failed; HTTP 504 curl 22 The requested URL returned error: 504 Gateway Time-out的问题，如下图
![](../../../assets/img/16165846052897/16194040478168.jpg)

2、git 下载进度非常慢，如果网络不好还会频繁发生超时失败的情况

3、一个大型工程，第一次install整个工程，甚至可能要等待数小时


# 3、分析问题

install慢，有个git clone环节比较关键。

git 加速解决方法很简单，在git clone时加上--depth 1即可。

```
depth用于指定克隆深度，为1即表示只克隆最近一次commit
```

对于以上列出的几种库依赖，cocoapods在git clone时，除了`branch`方式，其它方式都加了--depth 1。

看来瓶颈在branch的支持。

是不是在podfile里对branch的依赖方式加入参数即可控制？

想当然的试了一下:

```
pod 'AFNetworking', :git => 'https://github.com/gowalla/AFNetworking.git', :branch => 'dev'  --depth 1
```

草率了，不生效。

并且破坏了pod的指令规则，pod install流程也被终止了。

尝试找找cocoapods 提供的 hook规范，无解。

似乎僵住了。

# 4、cocoapods源码

换个思路，看看cocoapods的源码，它是怎么支持branch的。


# 4.1、cocoapods-downloader

我当前cocoapods版本源码所在目录

```
/Library/Ruby/Gems/2.6.0/gems/cocoapods-downloader-1.3.0
```

关键代码文件：

```
git.rb
```
不同版本pod可能目录不同，其它版本所在目录与其类似，按需找。


![-w589](../../../assets/img/16165846052897/16167413965602.jpg)


## 4.2、pod源码未做修改的现状

downloader下载代码时，对于branch模式的支持是这样的：



git clone git@code.amh-group.com:iOSYmm/YMMCommonUILib.git /var/folders/37/hc7qt7ys5w103q0jsqcrdgvm0000gn/T/d20210325-27574-1usb092 --template=


![-w1130](../../../assets/img/16165846052897/16166583314487.jpg)


可以看出，没有--depth 1 浅拷贝指令

![-w815](../../../assets/img/16165846052897/16166584011536.jpg)

clone完成后，.git目录大小31.5MB

## 4.3、修改pod源码

尝试修改`git.rb`，对branch的处理加入--depth 1参数

下图圈出的地方注释掉

![-w1099](../../../assets/img/16165846052897/16167413301127.jpg)


修改clone_arguments 方法，下图是修改后的代码

![-w1196](../../../assets/img/16165846052897/16166585577036.jpg)

再看看效果。

pod install时，控制台日志：


```
/usr/bin/git clone git@code.amh-group.com:iOSYmm/YMMCommonUILib.git /var/folders/37/hc7qt7ys5w103q0jsqcrdgvm0000gn/T/d20210325-28146-cpennz --branch develop_20210401
     --depth 1
```


![-w1249](../../../assets/img/16165846052897/16166586129461.jpg)

验证下载的代码体积

![-w726](../../../assets/img/16165846052897/16166587812618.jpg)

clone完成后，.git目录大小1.4MB

## 4.4、验证修改后的git.rb是否影响宿主工程

![-w871](../../../assets/img/16165846052897/16166595164103.jpg)

一切正常。

# 小结

可以通过实验路径“优化”branch依赖方式。

虽然这个实验初见效果，实际生产也正常，但不能盲目相信它。

可能我们在第三层，以为源码作者在第五层，其实他在第九层
