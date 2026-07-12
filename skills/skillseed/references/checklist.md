# skill 发布前自检清单 (checklist)

本文件在 skillseed 步骤 6 加载。逐项核对, 不合格的当场修。自包含, 不依赖其他 reference。

## name
- [ ] ≤64 字符
- [ ] 仅小写字母、数字、连字符 (`^[a-z0-9-]+$`)
- [ ] 不含 `anthropic` 或 `claude`
- [ ] 优先 gerund 形式 (如 processing-pdfs)

## description
- [ ] ≤1024 字符
- [ ] 第三人称 (无 "I/we"; "you" 仅在 "Use when you..." 短语中可接受)
- [ ] 同时说明 WHAT it does + WHEN to use it
- [ ] 关键用例 / 关键词在前 (从末尾截断)
- [ ] 中文 (本工厂策略)
- [ ] description + when_to_use 合计 ≤1536 字符

## SKILL.md
- [ ] <500 行
- [ ] frontmatter 是合法 YAML
- [ ] 只使用已知字段 (无拼写错误)
- [ ] 正文语言符合维护策略 (本工厂用中文)
- [ ] 包含 References 索引, 注明每个 reference 的内容与加载时机

## references
- [ ] 只有一层深度: 没有任何 reference 指示加载另一个 reference
- [ ] 超过 100 行的 reference 顶部有目录 (TOC)
- [ ] 所有路径用正斜杠 (含 Windows)
- [ ] SKILL.md 中提到的每个 reference 文件实际存在
- [ ] 无 A→B→C 链式引用

## 渐进式披露
- [ ] SKILL.md 不臃肿 (重内容移入 references)
- [ ] 每个 reference 有单一明确职责

## discovery / 安装
- [ ] skill 位于受识别路径 (`~/.<tool>/skills/<name>/`、`<project>/.<tool>/skills/<name>/`、或 plugin)
- [ ] 若为首次创建顶层 skills 目录, 已提醒用户重启对应工具

## 客观校验 (机械项, 不靠估算)
- [ ] `bash scripts/validate-skill.sh <name>` 通过 (exit 0)
- [ ] name 正则/长度、description 字符数、SKILL.md 行数、frontmatter、references 一层深度、>100 行 TOC、正斜杠、引用文件存在 —— 全部由脚本客观判定

## 打磨 (可选但推荐)
- [ ] 已为 description 写 3 个 should-trigger + 3 个 should-not-trigger 示例并推理验证
- [ ] description 能区分相近但不应触发的请求
