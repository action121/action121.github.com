
---
layout: post
title: '网站加速-文件传输-2'
subtitle: ''
date: 2025-07-22
categories: website
cover: ''
tags: website css speed-up
---


2025-07-22

# css文件瘦身

许多css样式实际没有使用，可以删除。

减少文件体积，可以加速下载，也能提升解析效率。

## 解决思路

需要CSS Tree Shaking，即“未使用的 CSS 选择器剔除”。

### 1、使用 PurgeCSS（推荐）

PurgeCSS 可以扫描HTML、JS、Vue 文件，自动移除未用到的 CSS 选择器。

#### 基本用法

1、安装：

```
npm install purgecss -g
```

2、运行（举例）：

```
 purgecss --css public/static/css/content.min.css --content \"src/**/*.vue\" \"public/index.html\" --output public/static/css/cleaned/
```

--css 指定要清理的 CSS 文件

--content 指定所有可能用到 class 的源码文件（支持 glob）

--output 输出目录

可以对每个 CSS 文件都这样处理。


#### 注意事项

如果有动态生成 class（如 :class="isActive ? 'foo' : 'bar'"），要用 PurgeCSS 的 safelist 配置保留。

处理后建议手动测试页面，防止误删。


### 2、 在构建工具中集成（如 Vite、Webpack）

Vite、Webpack 都有 PurgeCSS 或类似插件，可以自动在生产构建时清理无用 CSS。

例如 Vite + vite-plugin-purgecss。

### 3、 在线工具/手动分析

有些在线工具（如 uncss、purifycss）也能做类似事情，但不如 PurgeCSS 灵活。



## 方案1的实践


### 1、 准备脚本，自动批量清理所有 CSS 文件

```

import { execSync } from 'child_process';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const cssDir = path.join(__dirname, 'public/static/css');
const outDir = path.join(cssDir, 'cleaned');
const contentGlobs = [
  'src/**/*.vue',
  'src/**/*.js',
  'src/**/*.ts',
  'public/index.html'
];

if (!fs.existsSync(outDir)) fs.mkdirSync(outDir);

let totalBefore = 0;
let totalAfter = 0;

fs.readdirSync(cssDir)
  .filter(f => f.endsWith('.css'))
  .forEach(cssFile => {
    const cssPath = path.join(cssDir, cssFile);
    const outPath = path.join(outDir, cssFile);
    const beforeSize = fs.statSync(cssPath).size;
    totalBefore += beforeSize;
    const cmd = [
      'purgecss',
      `--css "${cssPath}"`,
      contentGlobs.map(g => `--content "${g}"`).join(' '),
      `--output "${outDir}"`
    ].join(' ');
    console.log('Running:', cmd);
    execSync(cmd, { stdio: 'inherit' });
    const afterSize = fs.existsSync(outPath) ? fs.statSync(outPath).size : 0;
    totalAfter += afterSize;
    const percent = beforeSize === 0 ? 0 : (((beforeSize - afterSize) / beforeSize) * 100).toFixed(2);
    console.log(`【${cssFile}】 缩减前: ${(beforeSize/1024).toFixed(2)} KB，缩减后: ${(afterSize/1024).toFixed(2)} KB，减少: ${percent}%`);
  });

const totalPercent = totalBefore === 0 ? 0 : (((totalBefore - totalAfter) / totalBefore) * 100).toFixed(2);
console.log(`\n【总体积】缩减前: ${(totalBefore/1024).toFixed(2)} KB，缩减后: ${(totalAfter/1024).toFixed(2)} KB，总减少: ${totalPercent}%`);

console.log('PurgeCSS 批量清理完成，结果在 public/static/css/cleaned 目录下。'); 

```


### 2、用法

将上面脚本保存为 purgecss-batch.js。

在项目根目录运行：

```
node purgecss-batch.js
```

清理后的 CSS 文件会在 public/static/css/cleaned/ 目录下。

### 3、替换引用

检查 index.html 或入口文件，把原来的 CSS 路径改为 cleaned 目录下的新文件，测试页面功能和样式。

### 4、动态 class safelist（可选）

如果有动态生成的 class，可以在命令中加 --safelist 参数，或用 PurgeCSS 配置文件（如 purgecss.config.js）来指定 safelist。

### 5、还原/回滚

清理是“非破坏性”的，原文件不会被覆盖，随时可以回滚。


### 6、瘦身结果

#### 体积

![](../../../assets/img/17531753840274/17531759185761.jpg)



![](../../../assets/img/17531753840274/17531754111907.jpg)



### 网络时长

#### 未瘦身

![](../../../assets/img/17531753840274/17531788568533.jpg)


#### 瘦身

![](media/17531753840274/17531789754807.jpg)


#### 对比

![](../../../assets/img/17531753840274/17531792158054.jpg)


## 小结

本次对项目中的 CSS 文件进行了瘦身优化。

从对比数据可以看出，所有主要样式文件的体积和加载时间均有明显下降。

总体积从 119 kB 降至 52 kB，减少了约 56.3%。

总加载时间从 3893 ms 降至 1349 ms，缩短了约 65.3%。

其中，content.min.css、news.min.css 等文件的优化效果尤为显著，体积和加载时间均大幅下降。

通过本次优化，有效减小了静态资源体积，提升了页面加载速度和用户体验，为后续性能优化打下了良好基础。