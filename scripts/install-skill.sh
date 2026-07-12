#!/usr/bin/env bash
# install-skill.sh — 把 skills/<name>/ 安装到目标工具的 skills 目录
# Agent Skills 是开放标准, 同一份 skill 可装到 Claude Code / Codex / Cursor 等。
# 用法见 usage。

set -euo pipefail

die() { echo "错误: $*" >&2; exit 1; }

usage() {
  cat <<'EOF'
用法: install-skill.sh <skill-name> [选项]
把 skills/<skill-name>/ 复制到目标工具的 skills 目录 (纯复制, 无符号链接)。

选项:
  --tool <name>      目标工具: claude | codex | cursor (默认 claude)
  --user             安装到该工具的全局 skills 目录 (如 ~/.claude/skills/)
  --project          安装到该工具的项目 skills 目录 (如 .claude/skills/, 默认)
  --target <path>    自定义 skills 根目录 (覆盖 --tool 的默认路径)
  --force            覆盖已存在的目标
  -h, --help         显示本帮助

各工具默认路径 (--user / --project):
  claude   ~/.claude/skills/   |   .claude/skills/
  codex    ~/.agents/skills/   |   .agents/skills/
  cursor   ~/.cursor/skills/   |   .cursor/skills/

示例:
  install-skill.sh my-skill --tool claude --project
  install-skill.sh my-skill --tool codex --user
  install-skill.sh my-skill --tool cursor --project --force
  install-skill.sh my-skill --target /any/skills/root
EOF
}

# --- 参数解析 ---
SKILL_NAME=""
TOOL="claude"
SCOPE=""        # user | project | target
TARGET_ROOT=""
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool)     TOOL="${2:-}"; [[ -n "$TOOL" ]] || die "--tool 需要一个参数 (claude|codex|cursor)"; shift 2 ;;
    --user)     SCOPE="user"; shift ;;
    --project)  SCOPE="project"; shift ;;
    --target)   SCOPE="target"; TARGET_ROOT="${2:-}"; [[ -n "$TARGET_ROOT" ]] || die "--target 需要一个路径参数"; shift 2 ;;
    --force)    FORCE=1; shift ;;
    -h|--help)  usage; exit 0 ;;
    *)          [[ -z "$SKILL_NAME" ]] || die "未知参数或重复的 skill 名: $1"; SKILL_NAME="$1"; shift ;;
  esac
done

[[ -n "$SKILL_NAME" ]] || { usage; exit 1; }
[[ -z "$SCOPE" ]] && SCOPE="project"

# --- tool → 目录名 ---
case "$TOOL" in
  claude) TOOL_DIR=".claude" ;;
  codex)  TOOL_DIR=".agents" ;;
  cursor) TOOL_DIR=".cursor" ;;
  *) die "未知工具: $TOOL (支持: claude | codex | cursor)" ;;
esac

# --- 定位源 ---
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/skills/$SKILL_NAME"
[[ -d "$SRC" ]] || die "源 skill 不存在: $SRC (在 skills/ 下找一下?)"

# --- 定位目标 ---
case "$SCOPE" in
  user)    SKILLS_ROOT="$HOME/$TOOL_DIR/skills" ;;
  project) SKILLS_ROOT="$(pwd)/$TOOL_DIR/skills" ;;
  target)  SKILLS_ROOT="$TARGET_ROOT" ;;
esac
TARGET="$SKILLS_ROOT/$SKILL_NAME"

# --- 检测: skills 根是否首次创建 / 目标是否已存在 ---
FIRST_TIME=0; [[ -d "$SKILLS_ROOT" ]] || FIRST_TIME=1
TARGET_EXISTED=0; [[ -e "$TARGET" ]] && TARGET_EXISTED=1

# 运行时状态文件 (重装 --force 时保留, 不随 canonical 覆盖): 经验库当前版 + 原始档案
RUNTIME_FILES=("references/lessons.md" "references/lessons-archive.md")
PRESERVE_DIR=""
if [[ $TARGET_EXISTED -eq 1 ]]; then
  [[ $FORCE -eq 1 ]] || die "目标已存在: $TARGET (使用 --force 覆盖)"
  PRESERVE_DIR="$(mktemp -d)"
  for rf in "${RUNTIME_FILES[@]}"; do
    if [[ -f "$TARGET/$rf" ]]; then
      mkdir -p "$PRESERVE_DIR/$(dirname "$rf")"
      cp "$TARGET/$rf" "$PRESERVE_DIR/$rf"
    fi
  done
  rm -rf "$TARGET"
fi

# --- 复制 ---
mkdir -p "$SKILLS_ROOT"
cp -r "$SRC" "$TARGET"

# 恢复运行时状态文件 (重装不丢累积经验)
if [[ -n "$PRESERVE_DIR" ]]; then
  for rf in "${RUNTIME_FILES[@]}"; do
    if [[ -f "$PRESERVE_DIR/$rf" ]]; then
      mkdir -p "$(dirname "$TARGET/$rf")"
      cp "$PRESERVE_DIR/$rf" "$TARGET/$rf"
    fi
  done
  rm -rf "$PRESERVE_DIR"
fi

# --- 提示 ---
if [[ $FIRST_TIME -eq 1 ]]; then
  echo "NOTE: 首次创建 $SKILLS_ROOT —— 需重启目标工具 ($TOOL) 才能发现新 skill。"
elif [[ $TARGET_EXISTED -eq 1 ]]; then
  echo "NOTE: 已刷新现有 skill, SKILL.md 变更会被实时检测, 无需重启。"
else
  echo "NOTE: 全新 skill, 需重启目标工具 ($TOOL) 才能被发现; 之后对 SKILL.md 的编辑会被实时检测。"
fi
echo "Installed $SKILL_NAME -> $TARGET"
