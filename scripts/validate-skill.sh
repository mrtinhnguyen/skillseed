#!/usr/bin/env bash
# validate-skill.sh — 客观校验一个 skill 的机械合规项
# 把 checklist 里能机器验证的项变成可执行检查。exit 0=全过, 1=有失败, 2=用法错误。

set -uo pipefail   # 不用 -e: grep -c 无匹配返回 1 要容忍

die() { echo "错误: $*" >&2; exit 2; }

usage() {
  cat <<'EOF'
用法: validate-skill.sh <skill-name-or-path>
客观校验 skill 的机械合规项 (name / description / SKILL.md / references)。

示例:
  validate-skill.sh skillseed
  validate-skill.sh skills/processing-pdfs
  validate-skill.sh /abs/path/to/skill
EOF
}

[[ $# -eq 1 ]] || { usage; exit 2; }
ARG="$1"
[[ "$ARG" == "-h" || "$ARG" == "--help" ]] && { usage; exit 0; }

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if   [[ -d "$ARG" ]]; then              SKILL_DIR="$(cd "$ARG" && pwd)"
elif [[ -d "$REPO_ROOT/skills/$ARG" ]]; then SKILL_DIR="$REPO_ROOT/skills/$ARG"
else die "找不到 skill 目录: $ARG (在 skills/ 下找一下?)"; fi

SKILL_MD="$SKILL_DIR/SKILL.md"
[[ -f "$SKILL_MD" ]] || die "缺 SKILL.md: $SKILL_MD"

PASS=0; FAIL=0
check(){ if [[ "$2" == "1" ]]; then echo "  ✓ $1"; PASS=$((PASS+1)); else echo "  ✗ $1 $3"; FAIL=$((FAIL+1)); fi; }
# count <pattern> <file>: 匹配行数 (无匹配=0), 容忍 grep 退出码
count(){ grep -cE "$1" "$2" 2>/dev/null || true; }

echo "校验: $SKILL_DIR"

# --- frontmatter 字段 ---
NAME=$(awk '/^name:/{sub(/^name:[[:space:]]*/,""); print; exit}' "$SKILL_MD")
DESC=$(awk '/^description:/{sub(/^description:[[:space:]]*/,""); print; exit}' "$SKILL_MD")

echo "[name]"
check "name 非空" "$([[ -n "$NAME" ]] && echo 1 || echo 0)" ""
check "name ≤64 字符 (=${#NAME})" "$([[ ${#NAME} -le 64 && ${#NAME} -gt 0 ]] && echo 1 || echo 0)" ""
check "name 仅 [a-z0-9-]" "$([[ "$NAME" =~ ^[a-z0-9-]+$ ]] && echo 1 || echo 0)" ""
check "name 不含 anthropic/claude" "$([[ ! "$NAME" =~ (anthropic|claude) ]] && echo 1 || echo 0)" ""

echo "[description]"
DESC_LEN=${#DESC}
check "description 非空" "$([[ -n "$DESC" ]] && echo 1 || echo 0)" ""
check "description ≤1024 字符 (=$DESC_LEN)" "$([[ $DESC_LEN -le 1024 && $DESC_LEN -gt 0 ]] && echo 1 || echo 0)" ""

echo "[SKILL.md]"
LINES=$(wc -l < "$SKILL_MD" | tr -d ' ')
check "SKILL.md <500 行 (=$LINES)" "$([[ $LINES -lt 500 ]] && echo 1 || echo 0)" ""
# frontmatter: 首行 --- 且存在第二个 --- (去 \r 防 CRLF)
FF=$(awk 'NR==1{gsub(/\r/,"");if($0=="---")f=1;else exit} f&&NR>1{gsub(/\r/,"");if($0=="---"){print 1;exit}}' "$SKILL_MD")
check "frontmatter 有 --- 包裹" "$([[ "$FF" == "1" ]] && echo 1 || echo 0)" ""
# Windows 盘符路径 (C:\...) —— 不该出现, 应一律正斜杠
BS=$(count '[A-Za-z]:\\' "$SKILL_MD")
check "SKILL.md 无 Windows 盘符路径 (命中 $BS)" "$([[ "$BS" == "0" ]] && echo 1 || echo 0)" ""

echo "[references]"
REF_DIR="$SKILL_DIR/references"
if [[ -d "$REF_DIR" ]]; then
  shopt -s nullglob
  for ref in "$REF_DIR"/*.md; do
    rn=$(basename "$ref")
    rl=$(wc -l < "$ref" | tr -d ' ')
    # 一层深度: reference 不得引用其他 reference (references/xxx.md)
    cross=$(count 'references/[A-Za-z0-9_-]+\.md' "$ref")
    check "$rn 一层深度 (引用其他 reference $cross 次)" "$([[ "$cross" == "0" ]] && echo 1 || echo 0)" ""
    # >100 行须有 TOC
    if [[ $rl -gt 100 ]]; then
      toc=$(count '(## 目录|^[0-9]+\. \[)' "$ref")
      check "$rn >100 行有 TOC ($rl 行)" "$([[ -n "$toc" && "$toc" != "0" ]] && echo 1 || echo 0)" ""
    fi
    # 无盘符路径
    rbs=$(count '[A-Za-z]:\\' "$ref")
    check "$rn 无 Windows 盘符路径" "$([[ "$rbs" == "0" ]] && echo 1 || echo 0)" ""
  done
  # SKILL.md 引用的 reference 文件须实际存在
  for rf in $(grep -oE 'references/[A-Za-z0-9_-]+\.md' "$SKILL_MD" 2>/dev/null | sort -u); do
    check "SKILL.md 引用的 $rf 存在" "$([[ -f "$SKILL_DIR/$rf" ]] && echo 1 || echo 0)" ""
  done
else
  echo "  (无 references 目录, 跳过)"
fi

echo ""
echo "汇总: $PASS 通过, $FAIL 失败"
if [[ $FAIL -eq 0 ]]; then echo "结果: PASS ✓"; exit 0; else echo "结果: FAIL ✗"; exit 1; fi
