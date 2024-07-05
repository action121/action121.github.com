---
layout: post
title: '鸿蒙 HarmonyOS 编译相关 打包机 Jenkins'
subtitle: ''
date: 2024-07-05
categories: 鸿蒙 HarmonyOS 编译相关 打包机 Jenkins
cover: ''
tags: 技术 编译 鸿蒙 HarmonyOS
---

# 鸿蒙HarmonyOS编译相关

2024-07-05

开发工具 DevEco-Studio.app 图例：

![](../../../assets/img/17201671959440/17201672384244.jpg)


# 打包机核心编译脚本

通过如下脚本，可以搭配自动化工具（如Jenkins）进行打包

## DEBUG BUILD APP

```
/Applications/DevEco-Studio.app/Contents/tools/node/bin/node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js --mode project -p product=default -p buildMode=debug assembleApp --analyze=normal --parallel --incremental --daemon
```


## RELEASE BUILD APP

```
 /Applications/DevEco-Studio.app/Contents/tools/node/bin/node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js --mode project -p product=default -p buildMode=release assembleApp --analyze=normal --parallel --incremental --daemon
```


## DEBUG 

``` 
/Applications/DevEco-Studio.app/Contents/tools/node/bin/node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js --mode module -p module=entry@default,Hsplibrary@default -p product=default -p buildMode=debug -p requiredDeviceType=phone assembleHap assembleHsp --analyze=normal --parallel --incremental --daemon
```


## CLEAN PROJECT

```
/Applications/DevEco-Studio.app/Contents/tools/node/bin/node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js -p product=default clean --analyze=normal --parallel --incremental --daemon
```

## REBUILD PROJECT

``` 
/Applications/DevEco-Studio.app/Contents/tools/node/bin/node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js clean --mode module -p product=default -p buildMode=debug assembleHap --analyze=normal --parallel --incremental --daemon
```