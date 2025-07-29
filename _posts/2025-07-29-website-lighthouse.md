---
layout: post
title: '网站加速-3-Lighthouse-CLS'
subtitle: ''
date: 2025-07-29
categories: website
cover: ''
tags: website Lighthouse speed-up
---


2025-07-29

# CLS (Cumulative Layout Shift) 优化方案

## 问题描述

原网站存在严重的布局偏移问题，主要表现为：

- Header和Footer在页面加载时高度不稳定
- Main内容区域高度变化导致Footer位置偏移
- 图片和字体加载时造成布局抖动
- 谷歌浏览器性能测试CLS打分较高

## 优化措施

### 1. 布局结构优化 (`src/App.vue`)

- 移除全局Footer组件
- 保留Header的固定高度约束
- 移除Main区域的最小高度约束，让页面内容自然撑开
- 使用Flexbox确保稳定的垂直布局


```
.app-main {
  /* 占满剩余空间 */
  flex: 1;
  display: flex;
  flex-direction: column;
  /* 重要：允许内容收缩 */
  min-height: 0;
}
```

#### 原结构

![优化前](../../../assets/img/17534047485062/%E4%BC%98%E5%8C%96%E5%89%8D.png)


```
    <Header />
    <router-view />
    <Footer />

```


#### 调整后


![优化后](../../../assets/img/17534047485062/%E4%BC%98%E5%8C%96%E5%90%8E.png)


```
   <Header />
   <main class="app-main">
      <router-view />
   </main>

各路由页面

  <PageLayout>
    <div class="container">
        ....
    </div>
  </PageLayout>
  
  
  PageLayout 组件
  
  <template>
  <div class="page-layout">
    <!-- 页面内容区域 -->
    <div class="page-content">
      <slot />
    </div>
    
    <!-- Footer组件 -->
    <Footer class="page-footer" />
  </div>
</template>

```

#### 2. 页面布局组件 (`src/components/PageLayout.vue`)

- 创建统一的页面布局组件
- 使用slot插槽管理页面内容
- 在页面内容下方自动添加Footer
- 确保页面内容有足够的最小高度

#### 3. Header组件优化 (`src/components/Header.vue`)

- 保持明确的高度约束：`min-height: 97px`
- 设置背景色和定位：`background: #fff; position: sticky`
- 响应式高度调整

#### 4. Footer组件优化 (`src/components/Footer.vue`)

- 移除固定高度约束，作为页面内容的一部分
- 保持背景色和样式：`background: #000; width: 100%`
- 内容区域保持最小高度：`min-height: 200px`

#### 5. 布局稳定性CSS (`src/assets/css/layout-stability.css`)

- 全局容器稳定性设置
- 图片和媒体元素稳定性优化
- 字体加载优化
- CSS containment 优化
- 硬件加速启用
- 新增页面布局组件样式

#### 6. JavaScript优化工具 (`src/utils/layout-stability.js`)

- 关键元素尺寸设置（仅Header）
- 图片加载优化
- 布局抖动防护
- 滚动性能优化
- 字体加载优化
- 响应式布局优化

#### 7. HTML模板优化 (`index.html`)

- 关键资源预加载
- 关键字体预加载
- 关键图片预加载
- 内联关键CSS防止布局偏移
- 不重要的资源按需加载或延迟懒加载

## 技术要点

### 页面布局结构

```vue
<template>
  <PageLayout>
    <!-- 页面内容 -->
    <section class="page-content">
      <!-- 具体页面组件 -->
    </section>
  </PageLayout>
</template>
```

### PageLayout组件

```vue
<template>
  <div class="page-layout">
    <div class="page-content">
      <slot />
    </div>
    <Footer class="page-footer" />
  </div>
</template>
```

### Flexbox布局

```css
.page-layout {
  display: flex;
  flex-direction: column;
  min-height: 100%;
}

.page-content {
  flex: 1;
  min-height: 400px;
}

.page-footer {
  flex-shrink: 0;
}
```

### Header固定高度

```css
.app-header {
  min-height: 97px;
  position: sticky;
  top: 0;
  z-index: 1000;
}
```


## 预期效果

1. **CLS分数显著降低**：Footer不再受Main内容影响
2. **加载体验改善**：页面内容自然撑开，减少视觉抖动
3. **性能提升**：减少全局布局计算
4. **响应式稳定性**：不同屏幕尺寸下布局保持一致


## 测试

1. 使用Chrome DevTools的Performance面板测试CLS
2. 使用Lighthouse进行性能审计
3. 在不同设备和网络条件下测试



# 优化验证
 
## 详情页

### 1、优化前

#### 清缓存

![detail1](../../../assets/img/17534047485062/detail1.png)


#### 不清缓存


![detail1](../../../assets/img/17534047485062/detail1-1.png)



### 2、优化后

#### 清缓存

![detail1](../../../assets/img/17534047485062/detail1-2.png)



#### 不清缓存


![detail1](../../../assets/img/17534047485062/detail1-3.png)




## 首页

### 1、优化前

#### 清缓存

![home1](../../../assets/img/17534047485062/home1.png)



#### 不清缓存


![home1](../../../assets/img/17534047485062/home1-1.png)



### 2、优化后


#### 清缓存


![home1](../../../assets/img/17534047485062/home1-2.png)


#### 不清缓存


![home1](../../../assets/img/17534047485062/home1-3.png)


### 对比


![](../../../assets/img/17534047485062/17537811300885.jpg)



# 总结

1. **彻底解决Footer CLS问题**：Footer现在是页面内容的一部分，不会因为Main内容变化而偏移
2. **更灵活的页面布局**：每个页面可以有自己的Footer样式和内容
3. **更好的SEO**：Footer内容与页面内容更紧密关联
4. **减少全局依赖**：减少全局组件的复杂性
5. **更好的维护性**：页面级别的组件更容易维护和调试
