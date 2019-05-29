---
layout: post
title: '在macOS上搭建Flutter开发环境'
subtitle: '在macOS上搭建Flutter开发环境'
date: 2019-05-29
categories: 工具,Flutter
cover: ''
tags: Flutter
---

# 在macOS上搭建Flutter开发环境

# 前言

不同的电脑，不同的开发人员在搭建开发环境时都可能会遇到不同的问题。
搜索引擎搜出的相关文档重复性较高，本文记录下Flutter环境搭建过程，供日后自己查阅方便。
截止到本文编辑时间，以下步骤经实践可用。

参考 [Flutter中文网](https://flutterchina.club/setup-macos/)

#使用镜像
由于在国内访问Flutter有时可能会受到限制，Flutter官方为中国开发者搭建了临时镜像，大家可以将如下环境变量加入到用户环境变量中：


```css
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```
注意： 此镜像为临时镜像，并不能保证一直可用，读者可以参考详情请参考 [Using Flutter in China](https://github.com/flutter/flutter/wiki/Using-Flutter-in-China) 以获得有关镜像服务器的最新动态。

# 获取Flutter SDK
去flutter官网下载其最新可用的安装包，转到下载页 。

注意，Flutter的渠道版本会不停变动，请以Flutter官网为准。另外，在中国大陆地区，要想正常获取安装包列表或下载安装包，可能需要翻墙，读者也可以去Flutter github项目下去下载安装包，[转到下载页](https://flutter.io/sdk-archive/#macos) 。

解压安装包到你想安装的目录，如：


```css
cd ~/development
unzip ~/Downloads/flutter_macos_v0.5.1-beta.zip
```

我是直接clone master分支代码

```css
 cd /Users/wuxiaoming/Documents/work/Flutter 
 git clone -b master https://github.com/flutter/flutter.git
 ./flutter/bin/flutter --version
```
添加flutter相关工具到path中：


```css
export PATH=`pwd`/flutter/bin:$PATH
```
此代码只能暂时针对当前命令行窗口设置PATH环境变量，要想永久将Flutter添加到PATH中,参考下面**更新环境变量** 部分。

注意： 
由于一些flutter命令需要联网获取数据，上面的PUB_HOSTED_URL和FLUTTER_STORAGE_BASE_URL是google为国内开发者搭建的临时镜像。
详情参考 [Using Flutter in China](https://github.com/flutter/flutter/wiki/Using-Flutter-in-China)

要更新现有版本的Flutter，参阅[升级Flutter](https://flutterchina.club/upgrading/)。



## 更新环境变量
命令行只能更新当前会话的PATH变量, 永久修改此变量的步骤是和特定计算机系统相关的。

1. 确定Flutter SDK的目录，将在步骤3中用到。
2. 打开(或创建) $HOME/.bash_profile
3. 添加以下行并更改`PATH_TO_FLUTTER_GIT_DIRECTORY`为克隆Flutter的git repo的路径:

```css
export PUB_HOSTED_URL=https://pub.flutter-io.cn #国内用户需要设置
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn #国内用户需要设置
export PATH=PATH_TO_FLUTTER_GIT_DIRECTORY/flutter/bin:$PATH
```
注意：`PATH_TO_FLUTTER_GIT_DIRECTORY` 为你flutter的路径，比如“~/document/code”

 
```css
export PATH=~/document/code/flutter/bin:$PATH
```
4.运行 source $HOME/.bash_profile 刷新当前终端窗口.

```css
注意: 如果你使用的是zsh，终端启动时 ~/.bash_profile 将不会被加载，
解决办法就是修改 ~/.zshrc ，在其中添加：source ~/.bash_profile
```
5.通过运行flutter/bin命令验证目录是否在已经在PATH中:


```css
echo $PATH
```
更多详细信息，请参阅[this StackExchange question](https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path).


## 真机调试前置条件

### 安装 Xcode
略
### 安装 [homebrew](http://brew.sh/) （如果已经安装了brew,跳过此步骤）.
打开终端并运行这些命令来安装用于将Flutter应用安装到iOS设备的工具

```css
brew update
brew install --HEAD libimobiledevice
brew install ideviceinstaller ios-deploy cocoapods
pod setup
```
## Flutter开发IDE 
下载并安装 [Visual Studio Code](https://code.visualstudio.com/)

## 运行 flutter doctor
运行以下命令查看是否需要安装其它依赖项来完成安装：


```css
flutter doctor
```
该命令检查您的环境并在终端窗口中显示报告。Dart SDK已经在捆绑在Flutter里了，没有必要单独安装Dart。 仔细检查命令行输出以获取可能需要安装的其他软件或进一步需要执行的任务（以粗体显示）

例如:


```css
[-] Android toolchain - develop for Android devices
    • Android SDK at /Users/obiwan/Library/Android/sdk
    ✗ Android SDK is missing command line tools; download from https://goo.gl/XxQghQ
    • Try re-installing or updating your Android SDK,
      visit https://flutter.io/setup/#android-setup for detailed instructions.
```
一般的错误会是xcode或Android Studio版本太低、或者没有ANDROID_HOME环境变量等，请按照提示解决。

第一次运行一个flutter命令（如flutter doctor）时，它会下载它自己的依赖项并自行编译。以后再运行就会快得多。