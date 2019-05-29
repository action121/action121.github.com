---
layout: post
title: 'iPhone APP内直接连WiFi'
subtitle: ''
date: 2019-05-29
categories: WiFi
cover: ''
tags: WIFI
---

iOS 11苹果的新增了Wi-Fi API 。

用户可以在app内直接连接Wi-Fi ，无需再跳转到系统Wi-Fi界面，增强了用户体验。

iOS上想要开发Wi-Fi应用，就必须申请NetworkExtension权限。

申请过的都知道，是很难一次成功的，根据苹果爸爸的拒绝回复，多申请几次就可以了。

这篇文章主要介绍iOS11 Wi-Fi内连接。11一下请参考 [这篇文章](https://www.jianshu.com/p/00f6f4bb7a75)


# 修改工程配置

![-w1052](../../../assets/img/15591100210392/15591102472885.jpg)



# 代码
```css
    if (@available(iOS 11.0, *)) {
        NEHotspotConfiguration *configuration = [[NEHotspotConfiguration alloc] initWithSSID:@"wuxiaomingdeiMac" passphrase:@"xiaoming"isWEP:NO];
        NEHotspotConfigurationManager *manager = [NEHotspotConfigurationManager sharedManager];
        [manager applyConfiguration:configuration completionHandler:^(NSError * _Nullable error) {
            NSLog(@"error:%@",error);
            if (!error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"连接成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            }
        }];
    } else {
        // Fallback on earlier versions
    }
```
以上代码是针对某一特定Wi-Fi测试用的。
若想使用内连接成功连上Wi-Fi，提供的ssid必须是可扫描到的，密码是正确的，Wi-Fi安全级别是psk的。
应用内点击连接按钮，系统会提示你是否连接Wi-Fi ，确认即可连接。
在回调里可进行成功或失败的处理。

# 运行结果

![](../../../assets/img/15591100210392/15591103088839.jpg)



![](../../../assets/img/15591100210392/15591103230821.jpg)

