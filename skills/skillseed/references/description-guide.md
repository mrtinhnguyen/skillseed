# 触发描述写作指南 (description-guide)

本文件在 skillseed 步骤 3 加载。description 是 skill 能否被正确触发的决定性因素 —— 写好它, 比写好正文更重要。

## 1. 为什么 description 最重要
- 启动时只有 `name` + `description` 进入上下文, Claude 据此判断何时调用 skill。
- description 在 listing 中从**末尾截断** (字符预算溢出时, 最少被调用的 skill 先被截)。
- 没有 description 或 description 模糊, skill 几乎不会被自动触发 (只能手动 `/name`)。

## 2. 公式
**第三人称 + WHAT it does + WHEN to use it + 关键词前置**

- 第三人称: "Processes Excel files..." 而非 "I can help you..." / "You can use this..."
- WHAT: 这个 skill 具体做什么 (动词开头, 具体到输入输出)
- WHEN: 什么场景下用 (用户会怎么说)
- 关键词前置: 最重要的用例放最前面 (防截断)

## 3. 关键词策略
- 列出用户**真正会说的词**: "chart", "graph", "plot" 而非 "visualization solution"
- 关键词放 description 前部和末尾的 `Triggers on:` 列表
- 避免泛词: "helper", "utility", "various tasks" 无信息量
- 本工厂策略: description 用中文, 与用户语言一致; 关键词放前部和 `Triggers on:` 列表

## 4. 触发校验法 (should / should-not)
写完 description 草稿后, 强制做这一步 (本 skill 的核心增值):

1. 写 **3 个 should-trigger 输入**: 应当触发本 skill 的真实用户请求
2. 写 **3 个 should-not-trigger 输入**: 相近但**不应**触发的请求 (最容易误触发的边界)
3. 逐个推理: "给定此 description, Claude 会不会触发? 该触发吗?"
4. 若 should-trigger 不触发 → description 关键词不够; 若 should-not 触发了 → description 范围太宽。据此修正。

这是轻量级 pre-eval。真正的批量 eval 用官方 skill-creator 插件。

## 5. 长度管理
- description ≤1024 字符
- description + when_to_use 合计 ≤1536 字符
- 核心功能放最前, 确保 truncated 后仍可识别

## 6. 好坏示例

> 以下示例取自真实 skill (英文), 仅供结构参考; 本工厂策略用中文写 description。

### 示例 1 — workflow 型

**好:**
> Creates charts and data visualizations — picks the right chart type, builds a consistent palette, and writes plotting code in any library. Use whenever the user asks to create a chart, graph, plot, dashboard, or visualize data, in any medium. Triggers on: "chart", "graph", "plot", "data viz", "dashboard", "visualize".

**坏:**
> This skill helps you make nice-looking charts. It is very powerful and supports many libraries. You will love it.

差在哪: 第二人称; 无 "when"; 无触发关键词; 空洞自夸。

### 示例 2 — reference 型

**好:**
> Reference for the Claude API and Anthropic SDK — model IDs, pricing, parameters, streaming, tool use, MCP, caching, and token counting. Use when the user asks about Claude/Anthropic API usage, model selection, pricing, or SDK behavior. Read BEFORE answering any question that names Claude or Anthropic.

**坏:**
> Knows about APIs. Good for developers.

差在哪: 太短; 无触发词; 无明确 "when"; 无关键词。

### 示例 3 — tool 型

**好:**
> Installs Claude Code skills from the SkillSeed factory to ~/.claude/skills/ or a project's .claude/skills/. Use when the user wants to install, distribute, or deploy a skill they authored. Triggers on: "install skill", "deploy skill", "add skill to project".

**坏:**
> A script that copies files. Run it when you want.

差在哪: 模糊; 无关键词; 无具体 "when"。

这些模式取自真实 skill (dataviz, claude-api 等) 的 description 习语。
