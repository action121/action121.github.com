---
layout: post
title: '分布式系统架构中各个组件的分工和协作关系'
subtitle: '分布式 集群 协作'
date: 2025-12-24
categories: 分布式系统 架构
cover: ''
tags: 分布式系统
toc: true
mermaid: true  # Force Mermaid loading
---


## 组件分工说明

### 1. **Java服务（核心应用层）**
- **职责**：业务逻辑处理、API接口提供、数据处理
- **作用**：整个系统的核心，处理业务请求和响应

### 2. **集群（Cluster）**
- **职责**：高可用、负载均衡、横向扩展
- **作用**：部署多个Java服务实例，保证服务稳定性和性能

### 3. **Kafka（消息队列）**
- **职责**：异步消息处理、事件流、系统解耦
- **作用**：
  - 处理高并发写入
  - 异步任务处理
  - 微服务间通信
  - 日志收集

### 4. **MongoDB（NoSQL数据库）**
- **职责**：非关系型数据存储
- **作用**：
  - 存储文档型数据
  - 处理高并发读写
  - 存储日志、缓存数据

### 5. **MySQL（关系型数据库）**
- **职责**：关系型数据存储
- **作用**：
  - 存储业务核心数据
  - 保证事务一致性
  - 复杂查询支持

### 6. **Apollo（配置中心）**
- **职责**：配置管理、动态配置
- **作用**：
  - 集中管理配置
  - 动态更新配置无需重启
  - 多环境配置管理

### 7. **Redis（缓存）**
- **职责**：缓存、会话存储
- **作用**：
  - 减轻数据库压力
  - 提升读取性能
  - 分布式锁
  - 会话共享

### 8. **Docker（容器化）**
- **职责**：应用容器化、环境标准化
- **作用**：
  - 快速部署
  - 环境一致性
  - 资源隔离

## 协作流程图

```mermaid
graph TB
    subgraph "客户端层"
        Client[客户端/浏览器]
    end
    
    subgraph "负载均衡层"
        LB[负载均衡器<br/>Nginx/Gateway]
    end
    
    subgraph "应用集群层 - Docker容器"
        Java1[Java服务实例1]
        Java2[Java服务实例2]
        Java3[Java服务实例N]
    end
    
    subgraph "配置中心"
        Apollo[Apollo配置中心<br/>统一配置管理]
    end
    
    subgraph "缓存层"
        Redis[Redis<br/>缓存/会话/分布式锁]
    end
    
    subgraph "消息队列"
        Kafka[Kafka<br/>消息队列/事件流]
    end
    
    subgraph "数据存储层"
        MySQL[(MySQL<br/>关系型数据)]
        MongoDB[(MongoDB<br/>文档型数据)]
    end
    
    Client -->|HTTP请求| LB
    LB -->|分发请求| Java1
    LB -->|分发请求| Java2
    LB -->|分发请求| Java3
    
    Apollo -.->|拉取配置| Java1
    Apollo -.->|拉取配置| Java2
    Apollo -.->|拉取配置| Java3
    
    Java1 <-->|读写缓存| Redis
    Java2 <-->|读写缓存| Redis
    Java3 <-->|读写缓存| Redis
    
    Java1 -->|生产消息| Kafka
    Java2 -->|生产消息| Kafka
    Java3 -->|生产消息| Kafka
    
    Kafka -->|消费消息| Java1
    Kafka -->|消费消息| Java2
    Kafka -->|消费消息| Java3
    
    Java1 <-->|查询/写入| MySQL
    Java2 <-->|查询/写入| MySQL
    Java3 <-->|查询/写入| MySQL
    
    Java1 <-->|查询/写入| MongoDB
    Java2 <-->|查询/写入| MongoDB
    Java3 <-->|查询/写入| MongoDB
    
    style Client fill:#e1f5ff
    style LB fill:#fff4e1
    style Java1 fill:#e8f5e9
    style Java2 fill:#e8f5e9
    style Java3 fill:#e8f5e9
    style Apollo fill:#f3e5f5
    style Redis fill:#ffebee
    style Kafka fill:#fff3e0
    style MySQL fill:#e3f2fd
    style MongoDB fill:#e8f5e9
```

## 典型请求处理流程

```mermaid
sequenceDiagram
    participant C as 客户端
    participant LB as 负载均衡
    participant J as Java服务
    participant A as Apollo
    participant R as Redis
    participant K as Kafka
    participant My as MySQL
    participant Mo as MongoDB
    
    Note over J,A: 启动阶段
    J->>A: 拉取配置信息
    A-->>J: 返回配置
    
    Note over C,Mo: 同步请求处理
    C->>LB: 发送HTTP请求
    LB->>J: 转发到实例
    J->>R: 检查缓存
    alt 缓存命中
        R-->>J:  返回缓存数据
        J-->>C: 返回响应
    else 缓存未命中
        J->>My: 查询数据库
        My-->>J: 返回数据
        J->>R: 更新缓存
        J-->>C: 返回响应
    end
    
    Note over J,Mo: 异步消息处理
    J->>K: 发送异步消息
    J-->>C: 立即返回
    K->>J: 消费者处理消息
    J->>Mo:  写入日志/数据
```

## 核心协作关系

### 📊 **数据流转**
1. **热数据**：Redis缓存 → 快速响应
2. **冷数据**：MySQL/MongoDB → 持久化存储
3. **异步数据**：Kafka → 削峰填谷

### 🔄 **服务协作**
1. Java服务启动 → Apollo获取配置
2. 请求到达 → 负载均衡分发
3. 优先查询Redis → 未命中查DB → 回写缓存
4. 重要操作 → 写入MySQL（事务）
5. 日志/事件 → 发送Kafka → 异步消费 → MongoDB存储

### 🐳 **部署层面**
- 所有服务通过Docker容器化部署
- 集群模式保证高可用
- 配置统一由Apollo管理
