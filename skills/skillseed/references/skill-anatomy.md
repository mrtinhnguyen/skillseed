# Skill 格式规范 (skill-anatomy)

本文件是 Claude Code skill 的完整格式规范参考。skillseed 在步骤 4-5 对 frontmatter 字段或格式规则不确定时加载本文件。自包含, 不依赖其他 reference。

## 目录
1. [Skill 是什么 + 加载生命周期](#1-skill-是什么--加载生命周期)
2. [Discovery 路径](#2-discovery-路径)
3. [Frontmatter 字段全表](#3-frontmatter-字段全表)
4. [name 规则](#4-name-规则)
5. [description 规则](#5-description-规则)
6. [SKILL.md body](#6-skillmd-body)
7. [Progressive disclosure 规则](#7-progressive-disclosure-规则)
8. [常见陷阱](#8-常见陷阱)

## 1. Skill 是什么 + 加载生命周期

一个 skill = 一个目录 + 一份 `SKILL.md` (+ 可选的 references / scripts / assets)。

加载生命周期 (渐进式披露):
- **启动时**: 仅所有 skill 的 `name` + `description` 进入上下文 (在一个字符预算内, 约为模型上下文窗口的 1%)。
- **调用时**: 用户输入 `/name` 或 Claude 判定相关时, 完整 SKILL.md body 才加载。
- **按需**: references 等支持文件**仅当 Claude 主动读取时**才进上下文。

因此: description 决定能否被触发; SKILL.md body 决定被调用后做什么; references 按需提供细节。

## 2. Discovery 路径

Agent Skills 是开放标准 (agentskills.io), SKILL.md 格式**跨工具通用**; 各工具只是**安装路径不同**:

| 工具 | 全局 (`--user`) | 项目 (`--project`) |
|------|-----------------|-------------------|
| Claude Code | `~/.claude/skills/<name>/` | `<project>/.claude/skills/<name>/` |
| Codex | `~/.agents/skills/<name>/` | `<project>/.agents/skills/<name>/` |
| Cursor | `~/.cursor/skills/<name>/` | `<project>/.cursor/skills/<name>/` |
| 其他 (Gemini CLI 等) | 各工具的 `~/.<tool>/skills/` 约定 | `<project>/.<tool>/skills/` |

> 路径基于各工具公开文档 (2026), 可能随版本变化; 不确定时用 `install-skill.sh --target <path>` 指定。

**通用规则**:
- SKILL.md 格式本身跨工具一致 (name + description + 目录结构 + 渐进式披露), 同一份 skill 可装到多个工具。
- Claude Code 扩展字段 (`allowed-tools` / `context` / `hooks` 等) 其他工具会忽略, 不影响基础可用性。
- **优先级** (同名 skill): 各工具一般是 全局 < 项目 (项目覆盖全局); Claude Code 另有 企业 > 个人 > 项目 > 插件。
- **嵌套目录** (Claude Code): 在子目录读写文件时, 该子目录的 `.claude/skills/` 按需可用; 同名嵌套 skill 显示为目录限定名 (如 `/apps/web:deploy`)。
- **实时变更检测**: 编辑已存在的 SKILL.md, 当前会话内即时生效; 但**首次创建顶层 skills 目录需重启**对应工具才能被发现。
- 排查 (Claude Code): `/doctor` 查看哪些 description 被截短; `--debug` 看 frontmatter 解析错误。

## 3. Frontmatter 字段全表

SKILL.md 顶部 YAML frontmatter。`name` 与 `description` 按 Agent Skills 标准为必填; 其余为 Claude Code 扩展 (可选)。

| 字段 | 必填 | 类型/约束 | 作用 |
|------|------|-----------|------|
| `name` | 是 | ≤64 字符, `^[a-z0-9-]+$`, 禁含 anthropic/claude, 优先 gerund | skill 名 |
| `description` | 是 | ≤1024 字符, 第三人称, what+when, 关键词前置, 中文 | 触发依据 (最关键) |
| `when_to_use` | 否 | 文本 | 额外触发上下文, 附在 description 后; 合计 ≤1536 字符 |
| `argument-hint` | 否 | 字符串 | 自动补全提示, 如 `[issue-number]` |
| `arguments` | 否 | 空格分隔或 YAML 列表 | 命名位置参数, 用于 `$name` 替换 |
| `disable-model-invocation` | 否 | bool, 默认 false | true 时禁止 Claude 自动加载 (仅手动 `/name`) |
| `user-invocable` | 否 | bool, 默认 true | false 时从 `/` 菜单隐藏 (仅背景知识) |
| `allowed-tools` | 否 | 空格/逗号分隔或列表 | skill 激活期间免确认可用的工具 (不限工具池) |
| `disallowed-tools` | 否 | 同上 | skill 激活期间从工具池移除的工具 |
| `model` | 否 | 模型 id 或 `inherit` | 本 skill turn 的模型覆盖 |
| `effort` | 否 | low/medium/high/xhigh/max | 推理强度覆盖 |
| `context` | 否 | `fork` | 设为 fork 时在隔离子代理上下文运行 |
| `agent` | 否 | 子代理类型名 | context: fork 时使用的子代理类型 |
| `hooks` | 否 | hooks 配置 | 绑定到本 skill 生命周期的 hooks |
| `paths` | 否 | glob 列表 | 限制 skill 自动激活的路径范围 |
| `shell` | 否 | bash(默认)/powershell | `` !`cmd` `` 代码块用的 shell |

## 4. name 规则
- ≤64 字符
- 仅小写字母、数字、连字符: 正则 `^[a-z0-9-]+$`
- 禁含保留词 `anthropic`、`claude`
- 优先 **gerund** 形式: `processing-pdfs`, `analyzing-spreadsheets`
- 可接受名词短语 (`pdf-processing`) 或动宾 (`process-pdfs`)
- 避免: `helper`, `utils`, `tools`, `documents`, `data`, `files`

## 5. description 规则
- ≤1024 字符
- **第三人称** (注入系统提示, 人称不一致会干扰发现)
- 同时说明 **WHAT it does** + **WHEN to use it**
- 关键用例/关键词**前置** (listing 从末尾截断)
- **中文** (本工厂策略: 触发用中文, 正文用中文)
- `description` + `when_to_use` 合计 ≤1536 字符
- 末尾可附 `Triggers on: "kw1", "kw2", ...` 关键词列表

description 的详细写作法与好坏示例由 SKILL.md 工作流按需加载, 不在本规范展开。

## 6. SKILL.md body
- **<500 行** (被调用后整份留在上下文, 每行都是 recurring token 成本)
- 推荐结构: 标题 + 一句话定位 → 何时使用 → 工作流/正文 → References 索引 → 重要约束
- 只写 Claude 不知道的上下文; 假设 Claude 本身已足够聪明
- 一致术语: 选定一个词, 全文统一
- 避免时效信息 (版本号、会过期的日期)
- 复杂流程可提供可勾选 checklist 供 Claude 跟踪

## 7. Progressive disclosure 规则
- SKILL.md 是唯一入口, 永远先加载
- **references 只允许一层深度**: 禁止 A 引用 B、B 又引用 C。每个 reference 是叶子, 仅由 SKILL.md 指示加载。
- 在 SKILL.md 中**显式注明**每个 reference 的内容与加载时机 (本 skill 的 References 索引表即此)
- 超过 100 行的 reference **顶部加目录 (TOC)**
- 路径**一律正斜杠** (含 Windows, 永远不用反斜杠)
- 一旦 skill 被调用, 其内容留在会话上下文里 —— 每行都是 recurring 成本, 写"做什么"而非"怎么做/为什么"

## 8. 常见陷阱
- description 用第二人称 ("You can use this to...") → 应第三人称
- name 含大写或下划线 → 仅允许 `[a-z0-9-]`
- name 含 `claude`/`anthropic` → 被拒
- references 互相指示加载 → 违反一层深度, Claude 可能漏读嵌套文件
- 路径用反斜杠 (Windows 习惯) → 一律正斜杠
- SKILL.md 过长 (>500 行) → 应拆入 references
- >100 行的 reference 忘加 TOC
- description 无 "when" 或无触发关键词 → 难以被发现
- frontmatter YAML 格式错误 → Claude Code 以空元数据加载, `/name` 仍可用但无 description 可匹配
