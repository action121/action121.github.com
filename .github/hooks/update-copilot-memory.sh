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

# 获取 wake-up 快照
echo "[update-copilot-memory] 正在生成 mempalace wake-up 快照..."
WAKEUP_OUTPUT="$(python -m mempalace wake-up 2>/dev/null || mempalace wake-up 2>/dev/null || echo '')"

if [ -z "${WAKEUP_OUTPUT}" ]; then
  echo "[update-copilot-memory] ⚠️  wake-up 输出为空，可能需要先运行 'mempalace init' 和 'mempalace mine'。"
  exit 0
fi

# 将快照用 HTML 注释包裹，注入到 instructions 文件的标记区间
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
# 将新块写入临时文件，避免 awk -v 传递多行字符串时的转义问题
NEW_BLOCK_FILE="$(mktemp)"
cat > "${NEW_BLOCK_FILE}" <<EOF
${START_MARKER}
<!-- 最后更新：${TIMESTAMP} -->
\`\`\`
${WAKEUP_OUTPUT}
\`\`\`
${END_MARKER}
EOF

# 使用 awk 替换两个标记之间的内容（通过文件读取新块，避免 -v 多行转义问题）
awk -v block_file="${NEW_BLOCK_FILE}" '
  /<!-- MEMPALACE_WAKEUP_START -->/ {
    while ((getline line < block_file) > 0) print line
    close(block_file)
    skip=1; next
  }
  /<!-- MEMPALACE_WAKEUP_END -->/ { skip=0; next }
  skip == 0 { print }
' "${INSTRUCTIONS_FILE}" > "${INSTRUCTIONS_FILE}.tmp"

mv "${INSTRUCTIONS_FILE}.tmp" "${INSTRUCTIONS_FILE}"
rm -f "${NEW_BLOCK_FILE}"

echo "[update-copilot-memory] ✅ 已更新 .github/copilot-instructions.md 的 MemPalace 快照区块。"
