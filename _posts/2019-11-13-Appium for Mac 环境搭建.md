---
layout: post
title: 'Appium for Mac 环境搭建'
subtitle: 'Appium for Mac 环境搭建'
date: 2019-11-13
categories: iOS自动化测试
cover: ''
tags: 自动化测试
---

# Appium for Mac 环境搭建

实验环境 :

MacBook Pro (15-inch, 2019)

iPhone 11  iOS 13.2 未越狱

macOS Catalina 10.15.1

Xcode Version 11.2 (11B52)

实验时间：
2019-11-13

此文档记录环境配置过程的辛酸。

随着时间推移及环境变化，不代表此文档记录的步骤还能成功。

坚持还是能成功的，我这最后一步和真机死活调试不起来，就在准备放弃的时候，竟然成功了！！！！！

## 安装node

本机版本 v12.9.0

```
brew install node

通过这种方法安装的node是最新版本
```

![](../../../assets/img/15736268059952/15736269034705.jpg)

## 安装Xcode

Xcode Version 11.2 (11B52)

步骤，略

## 安装依赖库

```
brew update
brew install libimobiledevice --HEAD
#libimobiledevice中并不包含ipa的安装命令，所以还需要安装
brew install ideviceinstaller

sudo npm install -g ios-deploy --unsafe-perm=true  #如果是iOS10以上的系统才需要安装
```



如果没有安装 `libimobiledevice`，会导致Appium无法连接到iOS的设备，所以必须要安装。

手机连接到电脑，查看ideviceinstaller环境是否正常

![](../../../assets/img/15736268059952/15736343036530.jpg)

如果要在iOS10+的系统上使用appium，则需要安装`ios-deploy`

安装过程如果遇到下图的错误

![](../../../assets/img/15736268059952/15736297692536.jpg)


解决办法:
[https://github.com/ios-control/ios-deploy/issues/346](https://github.com/ios-control/ios-deploy/issues/346)

![-w820](../../../assets/img/15736268059952/15736299148780.jpg)


如果还是失败，换brew来安装。我用这方式可耻的失败了。

![](../../../assets/img/15736268059952/15736966060282.jpg)

换brew来安装
```
brew install ios-deploy
```

## 安装appium最新版本

[github release版本下载](https://github.com/appium/appium-desktop/releases)

注意：要下载dmg，不要下载XXXX-mac.zip，我这zip解压后,APP打不开。

![-w1404](../../../assets/img/15736268059952/15736290768532.jpg)



![-w650](../../../assets/img/15736268059952/15736293250739.jpg)

## 安装JDK

为安卓做准备，如果只是用在iOS端，可以不用考虑安卓的环境。

[oracle官网下载地址](https://www.oracle.com/technetwork/java/javase/downloads/jdk10-downloads-4416644.html)

![-w1214](../../../assets/img/15736268059952/15736271461328.jpg)


## 安装Android SDK

如果只是用在iOS端，可以不用考虑安卓的环境。

很多资料都推荐使用brew安装，但是实践后发现SDK文件为空，所以使用Android studio来安装
[下载Android studio](https://developer.android.com/studio/)

如果打开Android studio报错，直接cancel到下一步即可。

![-w897](../../../assets/img/15736268059952/15736287890013.jpg)



![-w801](../../../assets/img/15736268059952/15736289948024.jpg)




![-w1027](../../../assets/img/15736268059952/15736289714429.jpg)

## 配置Android环境变量
在~/.zshrc或者~/.bash_profile文件中添加path


```
export ANDROID_HOME=~/Library/Android/sdk/
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_192.jdk/Contents/Home #jdk安装路径   
export PATH=~/bin:$PATH:/usr/local/bin:$ANDROID_HOME/platform-tools/:$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

```
注意 JAVA_HOME的实际路径，去自己本地路径查看确认。

## 安装appium-doctor


```

npm install appium-doctor -g

```

![](../../../assets/img/15736268059952/15736268841667.jpg)

安装后执行`appium-doctor --ios` 可以查看与iOS相关配置是否完整，
 或者 `appium-doctor`指令，查看包含安卓的相关配置是否完整。
如果有哪一项是打叉的，则进行安装就可以了。

![](../../../assets/img/15736268059952/15736320858133.jpg)

按上图提示，挨个解决

**安装opencv4nodejs时依赖cmake**

### 安装cmake
```
brew install cmake
```
### 安装opencv4nodejs
```
npm i -g opencv4nodejs
```
### 安装ffmpeg

下载地址 [https://ffmpeg.zeranoe.com/](https://ffmpeg.zeranoe.com/)

![-w1397](../../../assets/img/15736268059952/15736412982190.jpg)

下载完成后，将二进制可执行文件拷贝到`/usr/local/bin`目录

![-w1110](../../../assets/img/15736268059952/15736413643971.jpg)



### 安装mjpeg-consumer

```
npm install mjpeg-consumer -g
```
### 安装idb


```
brew tap facebook/fb
brew install idb-companion
pip3.7 install fb-idb
```

注意:
1、安装过程可能需要配置openssl，需要的话，在~/.zshrc或者~/.bash_profile文件中添加配置信息

```
# openssl
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
```
2、pip3.7是我本机的文件名，要看自己机器实际名称是什么，在目录`/usr/local/bin/`里确认


![-w770](../../../assets/img/15736268059952/15736377013917.jpg)

### 安装applesimutils

```
brew tap wix/brew
brew install applesimutils
```

### 安装bundletool.jar

```
brew install bundletool
```

## 更新Appium中的WebDriverAgent


1、到[WebDriverAgent](https://github.com/facebookarchive/WebDriverAgent)下载最新版本的WebDriverAgent
2、进入下载后的WebDriverAgent文件夹
执行 
```
./Scripts/bootstrap.sh
```
3、直接用Xcode打开WebDriverAgent.xcodepro文件

4、配置调试证书

略

5、运行WebDriverAgent

![-w1372](../../../assets/img/15736268059952/15736480846912.jpg)


如果遇到下面问题
![-w1400](../../../assets/img/15736268059952/15736478209761.jpg)

解决方案：


```
1、打开WebDriverAgent.xcodeproj
2、选择 'Targets' -> 'WebDriverAgentRunner'
3、打开 'Build Phases' -> 'Copy frameworks'
4、点击 '+' -> 添加 'RoutingHTTPServer'
```

成功运行后

![-w1400](../../../assets/img/15736268059952/15736493628226.jpg)

在浏览器内输入控制台打印的地址 http://localhost:8100/status

![-w1210](../../../assets/img/15736268059952/15736494102005.jpg)

### 真机Test

如果遇到下面的问题

The test runner encountered an error (Failed to establish communication with the test runner. (Underlying error: Unable to connect to test manager on 00008030-000C2D042230802E. (Underlying error: Could not connect to the device.)))

![-w1400](../../../assets/img/15736268059952/15736980666443.jpg)

解决方案:

```
https://github.com/appium/appium/issues/13017

重启手机
重启电脑
```

![-w851](../../../assets/img/15736268059952/15736988247126.jpg)

![-w1400](../../../assets/img/15736268059952/15736987891520.jpg)


## 打开appium desktop

！！！！！！
**各种版本的appium试过了，各种错误，各种unknown，反复尝试，只有appium 1.15.0可以用**
！！！！！

![-w650](../../../assets/img/15736268059952/15738231180728.jpg)


![](../../../assets/img/15736268059952/15738216054788.jpg)


![-w1080](../../../assets/img/15736268059952/15740452163374.png)


### 编译问题
WebDriverAgent工程的路径在这里：


/Applications/Appium.app/Contents/Resources/app/node_modules/appium/node_modules/appium-xcuitest-driver/WebDriverAgent

不同版本自己去Applications目录里一路找下去。

打开工程，自行解决证书问题，编译通过即可。


### 问题1
![-w650](../../../assets/img/15736268059952/15738219267232.jpg)
拉起了手机里的APP，却卡死在这里

解决：
[https://github.com/appium/appium/issues/9645](https://github.com/appium/appium/issues/9645)
![-w881](../../../assets/img/15736268059952/15738224553674.jpg)


### 问题2


```
[POST http://localhost:8100/session]
```

[https://github.com/appium/appium/issues/9482](https://github.com/appium/appium/issues/9482)
参考这个，我这并没有生效，放弃这个方案，换了个1.14.0版本的appium解决。

### 问题3

Safari浏览器里看不到inspector
http://localhost:8100/inspector
报错

Xcode11 with ios 13 don`t open inspector with appium-desktop.
https://github.com/appium/appium-desktop/issues/1096

我的解决办法：
换了个1.14.0版本的appium解决

### 问题4

Getting Original error: Unable to start WebDriverAgent session because of xcodebuild failure: A new session could not be created. Details: 'capabilities' is mandatory to create a new session

同类问题：
https://github.com/appium/appium-desktop/issues/1104

我的解决办法：
换了个1.14.0版本的appium解决

### 问题XXXX

换appium版本吧

### 结果
随便挑一个手机里的APP，试试这个框架的可用性。
终于见到这个界面了，泪奔

![-w1080](../../../assets/img/15736268059952/15738228948451.jpg)

![-w1080](../../../assets/img/15736268059952/15738225828682.png)

![-w1080](../../../assets/img/15736268059952/15738234771304.png)

![-w1080](../../../assets/img/15736268059952/luckincoffe.gif)


## 非常卡！！！！

inspector几分钟不刷新，手机APP也跟死了一样

# 祝好运