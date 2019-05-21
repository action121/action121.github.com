---
layout: post
title: '使用libimobiledevice + ifuse提取iOS沙盒文件'
subtitle: 'libimobiledevice'
date: 2019-05-16
categories: 技术 工具 USB连iPhone
cover: ''
tags: libimobiledevice 
---


# 使用libimobiledevice + ifuse提取iOS沙盒文件

## 简介
 
本教程基于macOS Mojave 10.14.5，至本文编辑时间2019-05-21，指令可用。

libimobiledevice：一个开源包，可以让Linux支持连接iPhone/iPod Touch等iOS设备。

Git仓库: 
<a href='https://github.com/libimobiledevice/libimobiledevice.git' target='_blank'>https://github.com/libimobiledevice/libimobiledevice.git</a>
 

ifuse: 也是一个开源包，可以用来访问iDevice的工具

Git仓库: 
<a href='https://github.com/libimobiledevice/ifuse.git' target='_blank'>https://github.com/libimobiledevice/ifuse.git</a>
 

我们可以利用libimobiledevice与ifuse进行shell封装，辅助实现自动化的测试过程。

这里我们用来提取iOS设备上APP沙盒中的日志文件

 

 

快速直接安装libmobiledevice的方法
MacOS上安装libimobiledevice


```css
sudo brew update
sudo brew install libimobiledevice
#libimobiledevice中并不包含ipa的安装命令，所以还需要安装
sudo brew install ideviceinstaller
Ubuntu下安装libimobiledevice

sudo add-apt-repository ppa:pmcenery/ppa
sudo apt-get update
apt-get install libimobiledevice-utils
sudo apt-get install ideviceinstaller
```
## 常用功能
### 获取设备已安装app的bundleID


```css
ideviceinstaller -l
```
演示:

```css
# wuxiaoming @ ming-2 in ~ [14:42:28] 
$ ideviceinstaller -l
Total: 170 apps
com.18jiasu.bridgess - Bridgess 16
com.omnigroup.OmniPlan3.iOS - OmniPlan 198.6.0.322412
com.hzbank.hzbank.per - 杭州银行 1.0.0
jp.co.canon.bsd.iphone.PIXMA-Print - 佳能打印 2550201902141409
com.apple.TestFlight - TestFlight 6
com.sandstudio.airdroid.iphone - AirDroid 18122702
com.taobao.tmall - 手机天猫 11296587
com.hisense.HsShare3P5 - 海信聚好看 5.2.7.10
com.boanda.flutterRookieBook - Flutter测试 2
com.moji.MojiWeather - 墨迹天气 201904291434
com.tencent.edu - 腾讯课堂 4.1.1.3
com.mike.liveconverter - Live转换器 6
Danale-com.casin.wucasineye - Danale 5.9.6.20190305
com.google.Authenticator - Authenticator 3.0.2102
com.ireadercity.zhwll - 万年历 201905091528
com.baidu.netdisk - 百度网盘 9.6.10.8
com.shiningtrip.wochacha4 - 我查查 95903
net.xmind.brownieapp - XMind 270
com.pps.test - 爱奇艺极速版 20190506133000
```

### 安装ipa包，卸载应用

命令安装一个ipa文件到手机上，如果是企业签名的，非越狱机器也可以直接安装了。

```css
ideviceinstaller -i xxx.ipa
```

命令卸载应用，需要知道此应用的bundleID

```css
ideviceinstaller -U [bundleID]
```
卸载演示:

```css
# wuxiaoming @ ming-2 in ~ [14:42:32] 
$ ideviceinstaller -U com.app.test
Uninstalling 'com.app.test'
 - RemovingApplication (50%)
 - GeneratingApplicationMap (90%)
 - Complete

# wuxiaoming @ ming-2 in ~ [14:44:59] 
$ 
```
安装演示：

```css
# wuxiaoming @ ming-2 in ~/Downloads/PP 下载/应用 [14:53:50] 
$ ideviceinstaller -i ./WiFi万能钥匙-Wi-Fi安全一键连\(正版\).ipa 
Copying './WiFi万能钥匙-Wi-Fi安全一键连(正版).ipa' to device... DONE.
Installing 'com.lantern.wifikey.mobile'
 - CreatingStagingDirectory (5%)
 - ExtractingPackage (15%)
 - InspectingPackage (20%)
 - TakingInstallLock (20%)
 - PreflightingApplication (30%)
 - VerifyingApplication (40%)
 - CreatingContainer (50%)
 - InstallingApplication (60%)
 - PostflightingApplication (70%)
 - SandboxingApplication (80%)
 - GeneratingApplicationMap (90%)
 - Complete

```
 

如果连接了多部手机需要分别安装时，请使用UDID指定：ideviceinstaller -u udid -i *.ipa

 

查看系统日志


```css
idevicesyslog
```
查看当前已连接的设备的UUID

```css
idevice_id --list
```
截图

```css
idevicescreenshot
```
查看设备信息


```css
ideviceinfo
```
获取设备时间

```css
idevicedate
```
设置代理


```css
iproxy
　usage: iproxy LOCAL_TCP_PORT DEVICE_TCP_PORT [UDID]
```

获取设备名称

```css
idevicename
```
查看和操作设备的描述文件


```css
ideviceprovision list
```

调试程序

```css
idevicedebug
```

如果在运行上面指令出现以下错误:


```css
"Could not connect to lockdownd. Exiting."
```
使用以下方式重新安装


```css
brew uninstall ideviceinstaller
brew uninstall libimobiledevice
brew install --HEAD libimobiledevice
brew link --overwrite libimobiledevice
brew install ideviceinstaller
brew link --overwrite ideviceinstaller
```

重新安装过程中如果出现以下错误:


```css
A recent change to libimobiledevice bumped the constraint on libusbmuxd to >= version 1.1.0. The current usbmuxd homebrew package is version 1.0.10.
As a result, homebrew --HEAD installs of libimobiledevice no longer build without a --HEAD install of usbmuxd.
```
使用以下指令升级usbmuxd：


```css
brew update
brew uninstall --ignore-dependencies usbmuxd
brew install --HEAD usbmuxd
brew link --overwrite usbmuxd
```
升级后接着安装libimobiledevice

 

## 挂载文件系统工具：ifuse
### 安装方式


```css
brew cask install osxfuse
brew install ifuse
```
或者通过官网安装

<a href='https://osxfuse.github.io' target='_blank'>https://osxfuse.github.io</a>

安装好后使用ifuse -h会打印详细使用说明

```css
$ ifuse -h
Usage: ifuse MOUNTPOINT [OPTIONS]
Mount directories of an iOS device locally using fuse.

  -o opt,[opt...]	mount options
  -u, --udid UDID	mount specific device by UDID
  -h, --help		print usage information
  -V, --version		print version
  -d, --debug		enable libimobiledevice communication debugging
  --documents APPID	mount 'Documents' folder of app identified by APPID
  --container APPID	mount sandbox root of an app identified by APPID
  --list-apps		list installed apps that have file sharing enabled
  --root		mount root file system (jailbroken device required)

Example:

  $ ifuse /media/iPhone --root

  This mounts the root filesystem of the first attached device on
  this computer in the directory /media/iPhone.

```

### 挂载媒体文件目录
ifuse [挂载点]
所谓的挂载点，就是电脑里创建好的某个目录，用它来做映射盘加载手机的数据
```css
$ cd Documents 
$ mkdir app2
$ ifuse app
```
成功后，app目录变成了OSXFUSE Volume 0(ifuse)
如果用过pp助手等工具，对比一下，是不是似曾相识？

![-w1004](../../../assets/img/15584208286279/15584225216013.jpg)


### 卸载[挂载点]
```css
umount /myapp
```
### 挂载某个应用的Documents目录
ifuse --documents [要挂载的应用的bundleID] [挂载点]



```css
$ ifuse --documents com.zhihu.ios /app
ERROR: InstallationLookupFailed
The App 'com.zhihu.ios' is either not present on the device, or the 'UIFileSharingEnabled' key is not set in its Info.plist. Starting with iOS 8.3 this key is mandatory to allow access to an app's Documents folder.
```
报这个错是因为我们app没有开启文件共享，需要在app的info.plist添加
Application supports iTunes file sharing 设置为 YES

![-w883](../../../assets/img/15584208286279/15584237320234.jpg)

更换成开启了这个share选项的app试试
```css
$ sudo ifuse --documents com.app.test /app
mount_osxfuse: mount point /app is itself on a OSXFUSE volume
$ 
```
如果遇到这个错，挂载点目录更改成全路径试试
```css

$ sudo ifuse --documents com.app.test /Users/wuxiaoming/Documents/app

# wuxiaoming @ ming-2 in ~/Documents [15:21:47] 
```
成功后，app目录变成了OSXFUSE Volume 0(ifuse)
这个myapp就是沙盒目录里自主创建的

![-w908](../../../assets/img/15584208286279/15584234969194.jpg)

使用umount可卸载


```css
umount app
或者
sudo umount /Users/wuxiaoming/Documents/app
```
 

### 挂载某应用的整个沙盒目录

ifuse --container [要挂载的应用的bundleID] [挂载点]

```css
# wuxiaoming @ ming-2 in ~/Documents [15:27:53] 
$ ifuse --container com.app.test /Users/wuxiaoming/Documents/app
```

 成功后，可以看到app对应的整个沙盒目录
 
![-w924](../../../assets/img/15584208286279/15584238628721.jpg)

我们可以通过脚本直接操作沙盒目录了

```css
# wuxiaoming @ ming-2 in ~/Documents [15:30:16] 
$ cd /Users/wuxiaoming/Documents/app 

# wuxiaoming @ ming-2 in ~/Documents/app [15:33:36] 
$ ls
Documents  Library    SystemData tmp
```
