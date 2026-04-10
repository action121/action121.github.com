#!/usr/bin/env bash
# .github/hooks/update-copilot-memory.sh
#
# 用途：将 MemPalace wake-up 快照注入 .github/copilot-instructions.md
#       让 GitHub Copilot 在每次对话前自动携带最新的项目记忆摘要（L0+L1，约 170 token）
#
# 使用方法：
#   chmod +x .github/hooks/update-copilot-memory.sh
#   ./.github/hooks/update-copilot-memory.sh
#
# 建议加入 pre-commit hook 或 cron 定期执行：
#   # crontab -e 中添加（每天上午 9 点更新）：
#   0 9 * * * cd ~/projects/action121.github.com && ./.github/hooks/update-copilot-memory.sh
#
# 依赖：
#   - Python 3.9+
#   - mempalace 已安装（pip install mempalace）
#   - mempalace 已初始化（mempalace init）

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INSTRUCTIONS_FILE="${REPO_ROOT}/.github/copilot-instructions.md"

START_MARKER="<!-- MEMPALACE_WAKEUP_START -->"
END_MARKER="<!-- MEMPALACE_WAKEUP_END -->"

# 检查 mempalace 是否已安装
if ! command -v mempalace &>/dev/null && ! python -m mempalace --version &>/dev/null 2>&1; then
  echo "[update-copilot-memory] ⚠️  mempalace 未安装，跳过。运行 'pip install mempalace' 安装。"
  exit 0
fi

# 先扫描 _posts 目录，将新文章入库（新文章总是在此目录更新）
echo "[update-copilot-memory] 正在扫描 _posts 目录入库（mempalace mine）..."
mempalace mine "${REPO_ROOT}/_posts" 2>/dev/null || true

# 获取 wake-up 快照
echo "[update-copilot-memory] 正在生成 mempalace wake-up 快照..."
WAKEUP_OUTPUT="$(python -m mempalace wake-up 2>/dev/null || mempalace wake-up 2>/dev/null || echo '')"

if [ -z "${WAKEUP_OUTPUT}" ]; then
  echo "[update-copilot-memory] ⚠️  wake-up 输出为空，可能需要先运行 'mempalace init' 和 'mempalace mine'。"
  exit 0
fi

# 将快照用 HTML 注释包裹，注入到 instructions 文件的标记区间
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
# 用 printf '%s\n' 逐行写入临时文件，完全避免 heredoc 对反引号、$() 等的意外解释
NEW_BLOCK_FILE="$(mktemp)"
printf '%s\n' "${START_MARKER}"                  > "${NEW_BLOCK_FILE}"
printf '%s\n' "<!-- 最后更新：${TIMESTAMP} -->" >> "${NEW_BLOCK_FILE}"
printf '%s\n' '```'                              >> "${NEW_BLOCK_FILE}"
printf '%s\n' "${WAKEUP_OUTPUT}"                 >> "${NEW_BLOCK_FILE}"
printf '%s\n' '```'                              >> "${NEW_BLOCK_FILE}"
printf '%s\n' "${END_MARKER}"                    >> "${NEW_BLOCK_FILE}"

# 找到 START 标记的行号，保留其前的所有行，追加新块
# 不依赖 END 标记匹配，避免 END 之后的垃圾内容被保留
START_LINE=$(grep -n "${START_MARKER}" "${INSTRUCTIONS_FILE}" | head -1 | cut -d: -f1)

if [ -z "${START_LINE}" ]; then
  echo "[update-copilot-memory] ⚠️  未找到 START 标记（<!-- MEMPALACE_WAKEUP_START -->），请检查 ${INSTRUCTIONS_FILE}。"
  rm -f "${NEW_BLOCK_FILE}"
  exit 1
fi

# 截取 START 前的内容 + 新块，旧的 START/内容/END 及之后的任何内容全部丢弃
head -$((START_LINE - 1)) "${INSTRUCTIONS_FILE}" > "${INSTRUCTIONS_FILE}.tmp"
cat "${NEW_BLOCK_FILE}"                          >> "${INSTRUCTIONS_FILE}.tmp"

mv "${INSTRUCTIONS_FILE}.tmp" "${INSTRUCTIONS_FILE}"
rm -f "${NEW_BLOCK_FILE}"

echo "[update-copilot-memory] ✅ 已更新 .github/copilot-instructions.md 的 MemPalace 快照区块。"
