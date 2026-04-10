---
layout: post
title: 'MemPalace：迄今基准分最高的本地 AI 记忆系统'
subtitle: '免费、开源、零 API 调用，让 AI 记住你的一切对话'
date: 2026-04-10
categories: tools
cover: ''
tags: AI memory tools claude mcp chromadb
---

2026-04-10

## 一、背景

你与 AI 的每一次对话——每个决策、每次调试、每场架构讨论——都会在会话结束后消失。六个月的日常使用积累了约 1950 万 token，这些内容都随着聊天窗口的关闭而烟消云散，下一次对话你又要从零开始。

[MemPalace](https://github.com/milla-jovovich/mempalace) 提供了一种不同的解法：**存储一切，让它变得可检索**。它不依赖 LLM 对"值不值得记"做判断，而是将原始对话完整保存在本地 ChromaDB，再通过语义搜索找到你需要的内容。

---

## 二、核心思想：记忆宫殿

古希腊演说家用"记忆宫殿"技巧记忆长篇演讲——把每个论点放在想象建筑的房间里，游历建筑即可找到观点。MemPalace 将这一结构映射到 AI 记忆：

| 结构 | 含义 |
|---|---|
| **Wing（翼）** | 一个人或项目，例如 `wing_kai`、`wing_myapp` |
| **Room（房间）** | 翼内的具体话题，例如 `auth-migration`、`graphql-switch` |
| **Hall（走廊）** | 同一翼内连接相关房间的通道（记忆类型） |
| **Tunnel（隧道）** | 跨翼连接同一话题的通道 |
| **Closet（壁橱）** | 指向原始内容的摘要索引 |
| **Drawer（抽屉）** | 原始逐字记录，永不丢失 |

每个翼都有固定的五类走廊（Hall）：

- `hall_facts` — 已做的决定
- `hall_events` — 会话、里程碑、调试记录
- `hall_discoveries` — 新发现、突破
- `hall_preferences` — 习惯、偏好
- `hall_advice` — 建议与解决方案

**结构带来的检索提升**（实测 22,000+ 条记忆）：

```
全部壁橱搜索：        60.9%  R@10
按 Wing 过滤：        73.1%  (+12%)
按 Wing + Hall 过滤： 84.8%  (+24%)
按 Wing + Room 过滤： 94.8%  (+34%)
```

---

## 三、基准成绩

MemPalace 在 LongMemEval 上取得了迄今最高公开成绩：

| 模式 | LongMemEval R@5 | API 调用 |
|---|---|---|
| **原始模式（ChromaDB）** | **96.6%** | 零 |
| 混合 + Haiku 重排 | 100%（500/500）| 约 500 次 |

对比付费系统：

| 系统 | LongMemEval R@5 | 需要 API | 费用 |
|---|---|---|---|
| **MemPalace（混合）** | **100%** | 可选 | 免费 |
| Supermemory ASMR | ~99% | 是 | — |
| **MemPalace（原始）** | **96.6%** | **否** | **免费** |
| Mem0 | ~85% | 是 | $19–249/月 |
| Zep | ~85% | 是 | $25/月起 |

> **注意**：96.6% 来自**原始（raw）模式**，而非 AAAK 压缩模式（AAAK 当前在 LongMemEval 上为 84.2%，仍在迭代中）。

---

## 四、快速上手

### 安装

```bash
pip install mempalace
```

### 初始化与数据导入

```bash
# 初始化（设置项目 / 人员信息）
mempalace init ~/projects/myapp

# 导入项目文件（代码、文档、笔记）
mempalace mine ~/projects/myapp

# 导入对话记录（Claude、ChatGPT、Slack 导出）
mempalace mine ~/chats/ --mode convos

# 导入并自动分类（决策、里程碑、问题、情绪等）
mempalace mine ~/chats/ --mode convos --extract general
```

### 搜索

```bash
mempalace search "为什么我们切换到 GraphQL"
mempalace search "auth 决策" --wing myapp
mempalace search "Clerk 决策" --wing driftwood
```

### 查看状态

```bash
mempalace status
```

---

## 五、接入 AI 工具（MCP）

### Claude Code（推荐）

```bash
claude plugin marketplace add milla-jovovich/mempalace
claude plugin install --scope user mempalace
```

重启后输入 `/skills` 确认 `mempalace` 已出现。

### Claude / ChatGPT / Cursor / Gemini（MCP 兼容工具）

```bash
claude mcp add mempalace -- python -m mempalace.mcp_server
```

连接后 AI 可使用 **19 个 MCP 工具**：

**宫殿读取**

| 工具 | 用途 |
|---|---|
| `mempalace_status` | 宫殿概览 + AAAK 规范 + 记忆协议 |
| `mempalace_list_wings` | 列出所有翼 |
| `mempalace_list_rooms` | 列出翼内房间 |
| `mempalace_get_taxonomy` | 完整 Wing→Room→Count 树 |
| `mempalace_search` | 带过滤器的语义搜索 |
| `mempalace_check_duplicate` | 存入前查重 |
| `mempalace_get_aaak_spec` | AAAK 方言参考 |

**宫殿写入**

| 工具 | 用途 |
|---|---|
| `mempalace_add_drawer` | 存入原始内容 |
| `mempalace_delete_drawer` | 按 ID 删除 |

**知识图谱**

| 工具 | 用途 |
|---|---|
| `mempalace_kg_query` | 实体关系（含时间过滤） |
| `mempalace_kg_add` | 添加事实 |
| `mempalace_kg_invalidate` | 标记事实已失效 |
| `mempalace_kg_timeline` | 实体时间线 |
| `mempalace_kg_stats` | 图谱概览 |

**导航**

| 工具 | 用途 |
|---|---|
| `mempalace_traverse` | 从房间出发跨翼遍历 |
| `mempalace_find_tunnels` | 查找连接两翼的隧道 |
| `mempalace_graph_stats` | 图谱连通性概览 |

**Agent 日记**

| 工具 | 用途 |
|---|---|
| `mempalace_diary_write` | 写入 AAAK 日记条目 |
| `mempalace_diary_read` | 读取近期日记 |

### 本地模型（Llama / Mistral）

```bash
# 生成 ~170 token 的上下文摘要，粘贴进本地模型的 system prompt
mempalace wake-up > context.txt
```

---

## 六、记忆层级

| 层级 | 内容 | 大小 | 时机 |
|---|---|---|---|
| **L0** | 身份信息 | ~50 token | 始终加载 |
| **L1** | 关键事实（团队、项目、偏好）| ~120 token（AAAK）| 始终加载 |
| **L2** | 房间回溯（近期会话、当前项目）| 按需 | 话题出现时 |
| **L3** | 深度搜索（全部壁橱语义查询）| 按需 | 显式询问时 |

AI 唤醒时携带 L0 + L1（~170 token），即知晓你的完整世界。搜索仅在需要时触发。

---

## 七、自动保存钩子（Claude Code）

```json
{
  "hooks": {
    "Stop": [{"matcher": "", "hooks": [{"type": "command", "command": "/path/to/mempalace/hooks/mempal_save_hook.sh"}]}],
    "PreCompact": [{"matcher": "", "hooks": [{"type": "command", "command": "/path/to/mempalace/hooks/mempal_precompact_hook.sh"}]}]
  }
}
```

- **Save Hook**：每 15 条消息触发一次结构化保存（话题、决策、引用、代码变更），同时刷新关键事实层。
- **PreCompact Hook**：上下文压缩前触发，防止窗口缩小时丢失记忆。

---

## 八、成本对比

| 方式 | 年均 token 消耗 | 年均费用 |
|---|---|---|
| 粘贴全部历史 | 1950 万（超出任何上下文窗口） | 不可行 |
| LLM 摘要方案 | ~65 万 | ~$507 |
| **MemPalace 唤醒** | **~170 token** | **~$0.70** |
| **MemPalace + 5 次搜索** | **~13,500 token** | **~$10** |

---

## 九、总结

MemPalace 的核心价值：

1. **96.6% 召回率**，原始模式下零 API 调用，可复现
2. **完全本地**，数据不离机，无订阅费用
3. **宫殿结构**带来 34% 检索提升，而非单纯全文搜索
4. **19 个 MCP 工具**，AI 自动调用，无需手动操作
5. **知识图谱**支持时间维度查询，追溯历史决策

对于日常大量使用 AI 辅助开发的工程师来说，MemPalace 是目前免费方案中性价比最高的持久记忆选择。

> **项目地址**：[https://github.com/milla-jovovich/mempalace](https://github.com/milla-jovovich/mempalace)
