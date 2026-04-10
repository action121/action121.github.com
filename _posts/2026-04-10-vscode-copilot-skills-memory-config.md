---
layout: post
title: 'VS Code + GitHub Copilot 技能与记忆配置'
subtitle: '在 macOS 上配置 Copilot 技能 Markdown 和记忆 Markdown，以 Claude Sonnet 为例'
date: 2026-04-10
categories: tools
cover: ''
tags: vscode github-copilot claude AI tools
---

2026-04-10

## 概述

GitHub Copilot Agent 模式支持通过 Markdown 文件定义**自定义指令（技能）**和**持久上下文（记忆）**，让 AI 助手更贴合你的开发习惯。

本文以 macOS + VS Code + Claude Sonnet 为例，介绍如何配置。

---

## 一、技能 Markdown（Skills / 自定义指令）

### 1. 仓库级别指令（推荐）

在项目根目录创建：

```
.github/copilot-instructions.md
```

示例内容：

```markdown
# 项目开发规范

## 技术栈
- 语言：Swift / Objective-C
- 构建：CocoaPods
- CI/CD：GitHub Actions

## 代码风格
- 使用 Swift 时遵循 Swift API Design Guidelines
- 注释使用中文

## 响应规范
- 代码示例需包含错误处理
- 回答优先使用中文
```

Copilot 会自动加载该文件，所有对话（包括 Claude Sonnet）都会遵循这些指令。

### 2. 工作区级别（多项目场景）

在 `.vscode/settings.json` 中配置内联指令：

```json
{
  "github.copilot.chat.codeGeneration.instructions": [
    {
      "file": ".github/copilot-instructions.md"
    }
  ]
}
```

---

## 二、记忆 Markdown（Memory）

VS Code Copilot 的**记忆功能**让 Agent 在会话间记住你的偏好。

### 方式 1：在 Chat 中手动触发

在 Copilot Chat 输入框中：

```
#memory 我偏好用中文回答，代码注释也用中文，使用 Swift 6 并发模型
```

Copilot 会将其存储为持久记忆（保存在用户全局配置中）。

### 方式 2：查看和管理记忆

- macOS 快捷键打开命令面板：`⌘ + Shift + P`
- 输入：`Copilot: Edit Memory`
- 可以看到并编辑 `copilot-memory.md` 文件

该文件通常位于：

```
~/Library/Application Support/Code/User/copilot-memory.md
```

示例 `copilot-memory.md` 内容：

```markdown
# 个人偏好

## 语言
- 始终用中文回复
- 代码注释用中文

## 编程习惯
- iOS/macOS 开发，主要用 Swift
- 偏好函数式编程风格
- 测试框架使用 XCTest

## 项目背景
- 当前维护一个个人技术博客（Jekyll 静态站）
```

---

## 三、选择 Claude Sonnet 作为 Agent 模型

1. 打开 VS Code，点击左侧聊天图标（或 `⌃ + ⌘ + I`）
2. 在 Copilot Chat 顶部的**模型选择器**下拉菜单中选择 `Claude Sonnet`（如 Claude Sonnet 4.5）
3. 点击右上角的 **Agent 模式**（小机器人图标）或输入 `@workspace`

结合技能 + 记忆使用 Claude Sonnet 的完整流程：

```
用户（macOS VS Code）
    └── Copilot Chat（Agent 模式）
         ├── 模型：Claude Sonnet 4.5
         ├── 读取：.github/copilot-instructions.md（技能/项目规范）
         ├── 读取：copilot-memory.md（个人记忆偏好）
         └── 执行：代码生成、文件编辑、终端命令等
```

---

## 四、优先级总结

| 配置文件 | 作用范围 | 适用场景 |
|---|---|---|
| `.github/copilot-instructions.md` | 仓库级 | 团队共享、项目规范 |
| `.vscode/settings.json` | 工作区级 | 本地个性化设置 |
| `copilot-memory.md` | 用户全局级 | 跨项目个人偏好 |

> **提示**：在 macOS 上，确保 VS Code 的 GitHub Copilot 扩展版本是最新的（`⌘ + Shift + X` 搜索 `GitHub Copilot` 检查更新），记忆功能和 Claude Sonnet 模型需要较新版本才支持。
