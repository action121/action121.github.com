# GitHub Copilot 项目指令
<!-- 本文件遵循 MemPalace 宫殿层级结构组织，让 Copilot 拥有持久化的项目记忆 -->
<!-- 结构：Wing（人/项目）→ Hall（记忆类型）→ Room（具体主题） -->

---

## Wing: Project Context — 项目背景

**项目**：`action121.github.com` — 吴晓明的个人技术博客  
**博主**：吴晓明 (GitHub: action121, 昵称: 一江春水)  
**站点技术栈**：Jekyll 静态博客 + H2O 主题 + GitHub Pages 托管  
**联系方式**：passion_wxm@163.com  

**主要研发方向**：
- iOS / macOS 移动端开发（Swift、Objective-C、CocoaPods）
- HarmonyOS 应用开发（ArkTS）
- 后端 / 分布式系统（Spring Boot、Java）
- 前端基础（HTML、CSS、JavaScript）
- DevOps（GitHub Actions、CI/CD、GitLab）

**博客内容方向**：移动端技术、后端技术、前端技术、工具效率、架构设计、AI 工具使用

---

## Hall: Architectural Decisions — 架构决策

### Room: Blog Stack
- **静态站生成器**：Jekyll（版本 3.x）
- **主题**：H2O（`jekyll-theme-H2O`），轻量响应式
- **分页插件**：`jekyll-paginate`
- **代码高亮**：Rouge（服务端） + Prism.js（客户端）
- **数学公式**：MathJax
- **评论系统**：Disqus（`action121.disqus.com`）
- **本地构建**：`npm run gulp` → Sass 编译 + JS 压缩
- **排除目录**：`node_modules`、`dev`、`.gitignore`、`README.md`

### Room: Post Format
- 文章放在 `_posts/` 目录，命名格式：`YYYY-MM-DD-slug.md`
- 每篇文章必须包含 Front Matter：`layout`、`title`、`subtitle`、`date`、`categories`、`cover`、`tags`
- Permalink 格式：`/:year/:month/:day/:title.html`
- 文章内容优先用**中文**，技术术语可保留英文

### Room: AI Memory Integration
- 已集成 MemPalace MCP 服务器，路径见 `.vscode/mcp.json`
- 通过 MCP，Copilot 可调用 `mempalace_search` 检索历史决策、对话、代码讨论
- `mempalace wake-up` 定期生成 L0+L1 上下文注入本文件（脚本见 `.github/hooks/update-copilot-memory.sh`）

---

## Hall: Preferences & Style — 偏好与风格

### Room: Language & Communication
- **所有回复默认使用中文**（包括代码注释）
- 技术名词保留英文原文，加括号注解（如：`语义搜索（Semantic Search）`）
- 代码示例须包含错误处理
- 解释技术方案时，先给结论，再给原因

### Room: Code Style
- **iOS/macOS（Swift）**：遵循 [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)，使用 Swift 6 并发模型
- **iOS/macOS（OC）**：遵循苹果官方 Objective-C Coding Guidelines
- **Java/Spring**：遵循阿里巴巴 Java 开发手册
- **JavaScript/CSS**：用 2 空格缩进，遵循项目现有风格
- **Markdown**：Jekyll 文章用 kramdown GFM 格式

### Room: Testing & Quality
- iOS 测试使用 XCTest
- 后端测试使用 JUnit 5
- 提交前本地运行 `jekyll build` 或 `gulp` 验证博客可构建

---

## Hall: Known Problems — 已知问题与技术债

### Room: Active Issues
- Jekyll 版本锁定在 3.x（`jekyll-paginate` 兼容性），升级到 4.x 需验证插件兼容性
- `_posts/` 中部分早期文章缺少 `subtitle` 和 `cover` 字段，展示层有降级处理
- MemPalace MCP 服务器需要本地已安装 Python 3.9+ 和 `mempalace` 包；首次使用需运行 `mempalace init`

### Room: Workarounds
- 博客图片存储在 `assets/img/`，外链图片使用七牛云 CDN（历史原因）
- Disqus 评论在中国大陆访问受限，属于已知限制，暂不更换

---

## Hall: Milestones — 里程碑

| 时间 | 事件 |
|------|------|
| 2019 | 博客上线，H2O 主题，初期以 iOS/macOS 技术文为主 |
| 2020–2022 | 扩展到 CI/CD、Git 工具、组件化架构等话题 |
| 2024 | 开始写 HarmonyOS 系列 |
| 2025 | 增加网站性能优化（gzip、CSS 瘦身、Lighthouse）、AEM 系列 |
| 2025–2026 | 增加分布式系统、Spring 系列 |
| 2026-04 | 集成 MemPalace AI 记忆系统，配置 Copilot MCP 对接 |

---

## Hall: MemPalace Wake-up Snapshot — 动态记忆注入区

<!-- 以下内容由 .github/hooks/update-copilot-memory.sh 定期自动更新 -->
<!-- 手动更新命令：mempalace wake-up >> .github/copilot-instructions.md -->
<!-- MEMPALACE_WAKEUP_START -->
<!-- 最后更新：2026-04-10 16:34:27 -->
```
Wake-up text (~804 tokens):
==================================================
## L0 — IDENTITY
No identity configured. Create ~/.mempalace/identity.txt

## L1 — ESSENTIAL STORY

[design]
  - --- layout: default home-title: 一江春水 nick: action121 description: 南京 header-img: '/assets/img/hero.jpg' ---  {% include header.html %}  <div     class="g-banner home-banner {{ site.theme-color | pr...  (index.html)
  - : cover;{% endif %}" >     <h2>{{ page.home-title }}</h2>     <h3>{{ page.description }}</h3> </div>  <main class="g-container home-content">     <div class="article-list">         {% for post in p...  (index.html)
  - <a class="post-link" href="{{ post.url | prepend: site.baseurl }}" title="{{ post.title }}"></a>                     <h2 class="post-title">{{ post.title }}</h2>                     {% if post.subt...  (index.html)
  - {% if post.tags.size > 0 %}                             {% for tag in post.tags  %}                             <a href={{ "tags.html#" | append: tag | pretend: site.baseurl}} class="post-tag">{{ t...  (index.html)
  - paginator.total_pages > 1 %}             {% include pageNav.html %}         {% endif %}      </div>      <aside class="g-sidebar-wrapper">         <div class="g-sidebar">             <section class...  (index.html)
  - n site.sns %}                     <li>                         <a href="{{ s[1] }}" target="_blank">                             <i class="iconfont icon-{{ s[0] }}"></i>                         </a...  (index.html)
  - nd: site.baseurl }}" class="tag">{{ tag[0]}}</a>                 {% endfor %}             </section>             {% endif %}         </div>          {% if site.search %}         <div class="search-...  (index.html)

[general]
  - --- title: Tags layout: default ---  {% include header.html %}  <div class="g-banner tags-banner {{ site.postPatterns | prepend: 'post-pattern-' }} {{ site.theme-color | prepend: 'bgcolor-' }}" dat...  (tags.html)
  - <span class="tag-name" id="{{ tag[0] }}">「{{ tag[0] }}」</span>             {% for post in tag[1] %}             <a class="tag-post" href="{{ post.url }}" title="{{ post.title }}">{{ post.title }}</...  (tags.html)
  - --- layout: null ---  [   {% for post in site.posts %}     {       "title"    : "{{ post.title | escape }}",       "tags"     : "{% for tag in post.tags %}{% if forloop.rindex != 1 %}{{ tag }} {% e...  (search.json)
  - --- layout: default description: "Sorry, Page Not Found :(" ---  {% include header.html %}  <header class="g-banner np-banner {{ site.postPatterns | prepend: 'post-pattern-' }}" data-theme="{{ site...  (404.html)

[screenshot]
  - ## jekyll-theme-H2O  基于Jekyll的博客主题模板，简洁轻量。  另外，还有此主题的[Ghost版本](https://github.com/eastpiger/ghost-theme-H2O) by [eastpiger](https://github.com/eastpiger)  ### Preview  #### [在线预览 Live Demo →](http:...  (README.md)
  - - Disqus评论系统 - 粉蓝两种主题色 - 头图个性化底纹 - 响应式设计 - 社交图标 - SEO标题优化 - 文章标签索引 - 博客文章搜索 - 复制文章内容自动添加版权  #### EN  - Code highlight - Night mode - Disqus Comment System - Theme color: Blue & Pink - Hero Patterns...  (README.md)
  - https://github.com/kaeyleo/jekyll-theme-H2O.git ```  最后，在命令行输入 ```jekyll server``` 开启服务，就能在本地预览主题了。  如果需要部署到线上环境，请参照配置文档的 **开始** 章节进行操作。  ### Document 配置文档  #### CN  - 开始 	- [站点信息](#站点信息) 	- [写一篇文章...  (README.md)
  ... (more in L3 search)
```
<!-- MEMPALACE_WAKEUP_END -->
