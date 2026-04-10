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
<!-- MEMPALACE_WAKEUP_START -->
<!-- 最后更新：2026-04-10 17:24:28 -->
```
Wake-up text (~821 tokens):
==================================================
## L0 — IDENTITY
No identity configured. Create ~/.mempalace/identity.txt

## L1 — ESSENTIAL STORY

[general]
  - --- layout: post title: '批量修改pod spec中的git URL' subtitle: '' date: 2022-11-07 categories: cocoapods cover: '' tags: cocoapods ---   # 批量修改pod spec中的git URL  ## 目标  将cocoapods spec中 https git URL修改成...  (2022-11-07-批量修改pod spec中的git URL.md)
  - mg/16677958599881/16677958741556.jpg)  ``` require 'active_support/core_ext/string/inflections' ```   ```       def initialize(name, params, podfile_path, can_cache = true)         @name = name    ...  (2022-11-07-批量修改pod spec中的git URL.md)
  - 中断，并报出以下信息：  ``` client_loop: send disconnect: Broken pipe ```  解决方案：  配置`~/.ssh/config`文件，增加以下内容即可：  ``` Host *             # 断开时重试连接的次数             ServerAliveCountMax 5              # 自动发送一个空的请求...  (2022-11-07-批量修改pod spec中的git URL.md)
  - --- layout: post title: 'Appium for Mac 环境搭建' subtitle: 'Appium for Mac 环境搭建' date: 2019-11-13 categories: iOS自动化测试 cover: '' tags: 自动化测试 ---  # Appium for Mac 环境搭建  实验环境 :  MacBook Pro (15-inch, 2...  (2019-11-13-Appium for Mac 环境搭建.md)
  - stall ideviceinstaller  sudo npm install -g ios-deploy --unsafe-perm=true  #如果是iOS10以上的系统才需要安装 ```    如果没有安装 `libimobiledevice`，会导致Appium无法连接到iOS的设备，所以必须要安装。  手机连接到电脑，查看ideviceinstaller环境是否正常  ![](...  (2019-11-13-Appium for Mac 环境搭建.md)
  - deploy ```  ## 安装appium最新版本  [github release版本下载](https://github.com/appium/appium-desktop/releases)  注意：要下载dmg，不要下载XXXX-mac.zip，我这zip解压后,APP打不开。  ![-w1404](../../../assets/img/15736268059952/15736...  (2019-11-13-Appium for Mac 环境搭建.md)
  - 开Android studio报错，直接cancel到下一步即可。  ![-w897](../../../assets/img/15736268059952/15736287890013.jpg)    ![-w801](../../../assets/img/15736268059952/15736289948024.jpg)     ![-w1027](../../../assets/i...  (2019-11-13-Appium for Mac 环境搭建.md)
  - ```  npm install appium-doctor -g  ```  ![](../../../assets/img/15736268059952/15736268841667.jpg)  安装后执行`appium-doctor --ios` 可以查看与iOS相关配置是否完整，  或者 `appium-doctor`指令，查看包含安卓的相关配置是否完整。 如果有哪一项是打叉的，则进...  (2019-11-13-Appium for Mac 环境搭建.md)
  - 059952/15736413643971.jpg)    ### 安装mjpeg-consumer  ``` npm install mjpeg-consumer -g ``` ### 安装idb   ``` brew tap facebook/fb brew install idb-companion pip3.7 install fb-idb ```  注意: 1、安装过程可能需要配置...  (2019-11-13-Appium for Mac 环境搭建.md)
  - plesimutils ```  ### 安装bundletool.jar  ``` brew install bundletool ```  ## 更新Appium中的WebDriverAgent   1、到[WebDriverAgent](https://github.com/facebookarchive/WebDriverAgent)下载最新版本的WebDriverAgent  2、...  (2019-11-13-Appium for Mac 环境搭建.md)
  - ../../../assets/img/15736268059952/15736493628226.jpg)  在浏览器内输入控制台打印的地址 http://localhost:8100/status  ![-w1210](../../../assets/img/15736268059952/15736494102005.jpg)  ### 真机Test  如果遇到下面的问题  The te...  (2019-11-13-Appium for Mac 环境搭建.md)
  - 0.jpg)   ## 打开appium desktop  ！！！！！！ **各种版本的appium试过了，各种错误，各种unknown，反复尝试，只有appium 1.15.0可以用** ！！！！！  ![-w650](../../../assets/img/15736268059952/15738231180728.jpg)   ![](../../../assets/img/15736...  (2019-11-13-Appium for Mac 环境搭建.md)
  - ，编译通过即可。   ### 问题1 ![-w650](../../../assets/img/15736268059952/15738219267232.jpg) 拉起了手机里的APP，却卡死在这里  解决： [https://github.com/appium/appium/issues/9645](https://github.com/appium/appium/issues/9645...  (2019-11-13-Appium for Mac 环境搭建.md)
  ... (more in L3 search)
```
<!-- MEMPALACE_WAKEUP_END -->
