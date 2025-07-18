---
layout: post
title: '网站加速-文件传输-1'
subtitle: ''
date: 2025-07-18
categories: website
cover: ''
tags: website gzip speed-up
---


2025-07-18

## 1. 目标

减少网络传输文件的体积，降低下载时长。

首页开屏时长稳定在2秒左右。

## 2.Nginx开启gzip

![](../../../assets/img/17528017520216/17528068026258.jpg)


```

gzip on;
gzip_disable "msie6";
gzip_vary on;
gzip_proxied any;
gzip_comp_level 6;
gzip_buffers 16 8k;
gzip_http_version 1.1;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml+rss text/javascript;

```

### 相关配置的作用及释义

1、 gzip on;

作用：开启 gzip 压缩功能。

解释：让 Nginx 对符合条件的响应内容进行压缩，减少数据传输量。

2、 gzip_disable "msie6";

作用：对 IE6 浏览器禁用 gzip。

解释：因为 IE6 对 gzip 支持不佳，容易导致页面显示异常，所以对其禁用压缩。

3、 gzip_vary on;

作用：在响应头中添加 Vary: Accept-Encoding。

解释：便于代理和缓存服务器根据请求的 Accept-Encoding 区分压缩和未压缩的缓存版本，避免内容错乱。

4、 gzip_proxied any;

作用：允许对所有代理请求进行 gzip 压缩。

解释：即使请求经过代理服务器（如反向代理或负载均衡），只要代理允许，就对响应进行压缩。

5、 gzip_comp_level 6;

作用：设置 gzip 压缩等级。

解释：1-9 数值，越大压缩率越高但CPU消耗越大，6为常用的折中选择。

6、 gzip_buffers 16 8k;

作用：设置压缩数据的缓冲区。

解释：分配 16 个 8KB 的缓冲区，存放 Nginx 压缩后的数据。缓冲区大小影响性能和内存占用。

7、 gzip_http_version 1.1;

作用：只对 HTTP/1.1 及以上版本启用 gzip。

解释：因为 HTTP/1.0 对 gzip 支持有限，通常只为 1.1 及以上版本压缩响应。

8、 gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

作用：指定哪些 MIME 类型的响应内容可以被 gzip 压缩。

解释：只有指定类型的内容才会被压缩，比如文本、CSS、JSON、JS、XML 等。


## 3. 采样

### 范围

采集首页和车辆详情页。

详情页跟首页的差异仅是具体页面的js: Home.js 和 CarModelDetail.js。

其它js资源一致，总体效果一致。此处不再贴详情页的数据。

js、css等文件均涉及，为保持统计简洁，此处用js数据做示意。

### 环境

数据采集，两种模式环境均相同：

断开VPN、相同电脑、相同网络环境、相同谷歌浏览器、采集前均清理缓存、均多次采样。


### 未启用gizp

![](../../../assets/img/17528017520216/gzip_nouse.png)


### 启用gzip

![](../../../assets/img/17528017520216/gzip_use.png)


## 4. 对比

![](../../../assets/img/17528017520216/17528062559127.jpg)


## 5. 结论

### 1.体积大幅下降

启用 gzip 后，所有 JS 文件的体积均明显减少，整体体积从 1345.3 KB 降至 431.7 KB，降幅高达 67.91%。

这意味着同样的页面内容，传输数据量大大减少，有效节省了带宽资源。

### 2.下载时长显著缩短

启用 gzip 后，绝大多数 JS 文件的下载时长也大幅缩短，总下载时长从 21230 ms 降至 8978 ms，降幅达到 57.71%。

这将直接提升用户的页面加载速度和访问体验。

### 3.个别文件时长略有上升

极少数小文件（如 LazyVideo-Cve9qXp7.js、CareSlider-B_pxOM-G.js）下载时长略有上升。

通过多次对比，发现与网络波动、浏览器调度或测试环境有关，但对整体影响极小。

### 4. 压缩效果与文件大小相关

压缩比最大的通常是体积较大的 JS 文件（如 TweenMax.min.js、video.es-CSAeoWrf.js 等），压缩后体积和时长均大幅下降，说明 gzip 对大文件的优化效果更为显著。

## 6.续

由于import('video.js')编译出来的video比较大，而许多功能是项目用不到的。

现采用预编译自定义删减版videojs，用静态资源集成。

基于以上验证步骤，集成 video.core.novtt.min.js 后，对比如下

![videojs_mini](../../../assets/img/17528017520216/videojs_mini.png)



![](../../../assets/img/17528017520216/17528194689609.jpg)

## 7. 最后

浏览器首次打开首页，页面开屏基本稳定在2秒左右。

浏览器首次加载渲染完毕，基于一系列包括使用CDN调度资源文件、Redis缓存等加速手段，以后再刷新加载，页面可以达到秒开状态，瞬间展示。

注： 

需要继续分析、优化、加速。

需要关注网络波动、工程迭代、定期优化加速、防止劣化。