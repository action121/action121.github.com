---
layout: post
title: 'Xcode 15 & iOS 17 适配'
subtitle: ''
date: 2023-07-03
categories: 技术 Xcode 编译 iOS 17
cover: ''
tags: 技术 Xcode 编译 iOS17 Xcode15
---

## Xcode 版本

Xcode 15-beta2

## 1. 编译冲突

### 1.1  Observation

三方RxSwift库里的Observable和系统Observation 库新增的 Observable协议有冲突

#### 1.1.1 现象

![](../../../assets/img/16883502071308/16883519807133.png)


![](../../../assets/img/16883502071308/16883520412186.jpg)


系统Observation 库新增 Observable协议

```
public protocol Observable {
}
```

![](../../../assets/img/16883502071308/16883502485245.jpg)

#### 1.1.2 解决方案

方案1. 使用RxSwift的Observable时，指定命名空间

 ```
 RxSwift.Observable
```
![](../../../assets/img/16883502071308/16883521129436.png)

方案2. 设置别名指定命名空间下的类名

```
public typealias Observable = RxSwift.Observable
```


### 1.2 ImageResource

三方库Kingfisher的ImageResource和系统库DeveloperToolsSupport的ImageResource冲突

#### 1.2.1 现象

```
'ImageResource' is ambiguous for type lookup in this context
```

![](../../../assets/img/16883502071308/16883642116376.png)


![](../../../assets/img/16883502071308/16883635763532.png)

#### 1.2.2 解决方案

[https://developer.apple.com/forums/thread/20066](https://developer.apple.com/forums/thread/20066)

方案1：设置别名指定命名空间下的类名

```
public typealias ImageResource = Kingfisher.ImageResource
```

![](../../../assets/img/16883502071308/16883636716650.png)

方案2：直接用传参做类型推断

![](../../../assets/img/16883502071308/16883645183013.png)


## 2. Xcode编译策略调整
 
### 2.1 return 后面的代码编译策略调整
 
 xcode 15，return 后面的代码会作为return的参数处理。
 
 下面的报错只是作为参数处理时，校验错误的一种。
 
 核心是rerun后面的代码会被编译执行。
 
 需要处理return后面跟有代码的场景。
 
#### 2.1.1 现象
 
 ![](../../../assets/img/16883502071308/16883709020032.jpg)


#### 2.1.2 解决方案
  
 问题核心是基于作用域的概念，return作用域内后面没有代码就行，几种适配方案：

 方案1. 删除return后面的代码

 方案2. return后面加分号

 方案3. return 放在一个显式作用域内 。如 花括号、预编译宏等

 
 
#### 2.1.3 拓展demo
 
![](../../../assets/img/16883502071308/16883515618209.jpg)

![](../../../assets/img/16883502071308/16883610260442.jpg)

![](../../../assets/img/16883502071308/16883610834625.jpg)

![](../../../assets/img/16883502071308/16883515998179.jpg)

## 3. 编译link问题

### 3.1 现象

```
clang: error: unable to execute command: Segmentation fault: 11
clang: error: linker command failed due to signal (use -v to see invocation)
```

![](../../../assets/img/16883502071308/16883523569100.jpg)

### 3.2 解决方案

[https://developer.apple.com/forums/thread/731089](https://developer.apple.com/forums/thread/731089)

在 `Project->target->Build Settings->Other linker Flags` 路径下，添加 `-ld64`

![](../../../assets/img/16883502071308/16883710418424.jpg)


