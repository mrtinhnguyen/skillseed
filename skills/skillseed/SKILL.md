---
name: skillseed
description: 端到端脚手架并编写 Agent Skills（基于开放标准, 兼容 Claude Code、Codex、Cursor 等）—— 生成符合规范的 SKILL.md（含 frontmatter）, 组织渐进式披露的 references, 用 should/should-not 触发示例打磨触发描述, 跑合规自检 (含客观校验脚本), 并通过安装脚本部署到各工具。当用户想创建新 skill、编写或脚手架 SKILL.md、设计或打磨 skill 的描述与触发关键词、选择 skill 模板、按格式规则校验 skill、或把 skill 安装到 Claude Code / Codex / Cursor 时使用。触发词："创建 skill"、"新 skill"、"Claude skill"、"Codex skill"、"Cursor skill"、"脚手架 SKILL.md"、"安装 skill"。
argument-hint: [skill-name] [one-line description]
---

# skillseed

帮你从零创建符合规范的 Agent Skills (Claude Code / Codex / Cursor 通用): 脚手架 + 写作教练 + 合规自检 (含客观校验) + 跨工具安装。

## 何时使用本 skill

当用户想: 创建新 skill、脚手架 SKILL.md、打磨触发描述、选模板、做格式自检、或把 skill 安装到 Claude Code / Codex / Cursor 等工具的 skills 目录时。

## 交互风格

**最少对话 + 生成初稿 + 迭代**: 先问 2-3 个关键问题定方向, 然后直接生成完整骨架和内容初稿, 再按反馈迭代。

如果调用时带了参数 (`/skillseed <name> "<一句话描述>"`), 跳过提问, 直接进入步骤 3。

## 经验库 (进化机制)

本 skill 维护**两个**经验文件:
- `references/lessons.md` —— 当前精简经验。**调用本 skill 时先读它**参考过往经验。
- `references/lessons-archive.md` —— 原始全量档案 (归纳时归档, 只追加不删)。

步骤 8 往 lessons.md 追加新经验; 超阈值时自动归纳 (合并重复 + 提炼模式, 原始归档到 archive)。

## 工作流

### 1. 澄清意图
问 2-3 个问题 (若参数已给出答案则跳过):
- 这个 skill **做什么**? (一句话)
- **谁在什么场景**下会触发它? (用户会说的关键词)
- (可选) 它接收什么输入、产出什么?

### 2. 选类型
在 workflow / reference / tool / hybrid 中选一个。**现在加载 `references/templates.md`** 选对应骨架。
判据: workflow=分步流程; reference=知识库查阅; tool=包装一个脚本/工具。

### 3. 打磨 description (最重要的一步, 多花一轮)
**现在加载 `references/description-guide.md`**。按公式写: **第三人称 + WHAT it does + WHEN to use it + 关键词前置** (中文)。

然后做**触发校验** (本 skill 区别于原生生成的核心价值):
- 写 3 个 **should-trigger** 输入 (应当触发本 skill 的用户请求)
- 写 3 个 **should-not-trigger** 输入 (相近但不应触发的请求)
- 逐个推理: "给定此 description, agent 会不会触发?" 据此修正 description

### 4. 生成骨架
在 `skills/<name>/` 下创建目录 + `SKILL.md` + 所需 `references/`。
如对任何 frontmatter 字段或格式规则不确定, **加载 `references/skill-anatomy.md`**。
用步骤 3 定稿的 description 填入 frontmatter。

### 5. 填充初稿
写 SKILL.md 正文 (中文) 和 references。遵守:
- SKILL.md <500 行 (本 skill 类目标 <150 行)
- references **只允许一层深度**: 不得让一个 reference 指示加载另一个 reference
- 超过 100 行的 reference 顶部加目录 (TOC)
- 路径一律用正斜杠 (含 Windows)
- 在 SKILL.md 中注明每个 reference 的内容与加载时机

### 6. 自检 (语义 + 客观)
**加载 `references/checklist.md`** 逐项核对语义项; 然后跑客观校验:
```
bash scripts/validate-skill.sh <name>
```
机械项 (name 正则/长度、description 字符数、SKILL.md 行数、frontmatter、references 一层深度、>100 行 TOC、反斜杠、引用文件存在) 由脚本客观判定, 不靠估算。不合格的当场修, 直到脚本 PASS (exit 0)。

### 7. (可选) 安装
用安装脚本把 skill 部署到目标工具:
```
bash scripts/install-skill.sh <name> --tool <claude|codex|cursor> --project   # --project=项目级, --user=全局
```
**首次安装新 skill 到某工具需重启该工具才能被发现**; 之后对已存在 SKILL.md 的编辑会被实时检测。

### 8. 记录经验 + 自动归纳 (进化)
创建完 skill 后, 反思本次过程。若学到**通用**经验 (非本次特例):
1. **追加**一条到 `references/lessons.md` 末尾 (格式: `## <简短标题>` + 场景 + 经验 + 可选"建议改规范")
2. **归纳** —— 当 lessons.md 超过 **20 条**时:
   - 把 lessons.md 现有全部条目**追加**到 `references/lessons-archive.md` (保全原始)
   - 归纳: 合并重复/相似条目, 提炼 2-3 条共通模式
   - **重写** lessons.md: 头部说明 (不变) + 归纳后的精简条目 (≤10 条) + 顶部标注"最近归纳: N 条 → M 条"

护栏:
- archive 只追加不删; lessons.md 仅在归纳时整体重写
- 经验要具体可操作; 与已有条目重复则不追加
- **不改其他 reference** (checklist / templates / etc 不动); 建议改规范只记"建议", 不自动执行

## References 索引

按需加载, 不要一开始就全读:

| 文件 | 内容 | 何时加载 |
|------|------|----------|
| `references/lessons.md` | 经验库 (当前精简版, 越用越丰富) | 调用开头读; 步骤 8 追加/归纳 |
| `references/lessons-archive.md` | 经验原始全量档案 (归纳时归档) | 步骤 8 归纳时写 (不常读) |
| `references/templates.md` | 3 种 skill 骨架 (workflow / reference / tool) | 步骤 2 |
| `references/description-guide.md` | 触发描述写作指南 + 好坏示例 | 步骤 3 |
| `references/skill-anatomy.md` | 完整格式规范: frontmatter 字段、name 规则、discovery (多工具路径)、progressive disclosure | 步骤 4-5 按需 (字段/规则不确定时) |
| `references/checklist.md` | 发布前自检清单 (语义项) | 步骤 6 |

## 重要约束
- description 用**中文**, 第三人称; 正文用**中文**
- references **不得互相指示加载** (一层深度)
- 路径用**正斜杠**
- SKILL.md **<500 行**
- 生成的 skill 遵循开放标准, 跨工具通用 (Claude Code / Codex / Cursor)
- 经验库 (`lessons.md` 当前版 + `lessons-archive.md` 原始档案) 是运行时状态, 重装保留 (见 install-skill.sh), 不随 canonical 源覆盖
- 步骤 6 机械项必须 `validate-skill.sh` PASS, 不靠估算

## 与官方 skill-creator 插件的关系
本 skill (`skillseed`) 负责**脚手架 + 自检 + 跨工具安装**; 官方插件 (`/plugin install skill-creator@claude-plugins-official`) 负责 Claude Code 内的 **eval/iterate**。两者不同名, 可同时安装、互不覆盖。建议在此脚手架后, 用官方插件做评估迭代。

> 注: `context: fork` 有意不设 —— 需在主对话中与用户迭代, 不能 fork 到子代理。
