# Skill 骨架模板 (templates)

本文件在 skillseed 步骤 2 加载。按 skill 类型选骨架, 复制后填充。自包含, 不依赖其他 reference。

## 如何选型
- **workflow 型**: 分步流程驱动 (如 code-review, deploy)。适合"按步骤做某事"。
- **reference 型**: 知识库驱动 (如 claude-api)。适合"查阅某领域知识后回答"。
- **tool 型**: 包装脚本/工具 (如 dataviz, install-skill)。适合"调用某个工具完成动作"。
- **hybrid 型**: 以上组合。先以主类型为骨架, 再嵌入其他类型的章节。

## Template A — workflow 型

```
---
name: <gerund-or-noun>
description: <中文: WHAT + WHEN + Triggers on: ...>
argument-hint: [optional]
---
# <Title>

一句话定位。

## 何时使用
<2-3 行: 触发场景>

## 工作流
1. <步骤>
2. <步骤>

## References 索引
| 文件 | 内容 | 何时加载 |
|------|------|----------|
| `references/<file>.md` | <内容> | <步骤 X> |

## 重要约束
- <约束>
```

## Template B — reference 型

```
---
name: <noun>
description: <中文: "Reference for X. Use when...">
---
# <Title>

一句话定位。

## 何时使用
<何时查阅本参考>

## Reference 索引
| 文件 | 内容 | 何时加载 |
|------|------|----------|
| `references/<topic>.md` | <范围> | <何时> |

## 快速指南
<最常见问题的薄层答案; 主体在 references>
```

## Template C — tool 型

```
---
name: <verb-noun>
description: <中文: 工具做什么 + WHEN + Triggers on: ...>
allowed-tools: Bash, Read
---
# <Title>

一句话定位。

## 何时使用
<何时运行本工具>

## 工作原理
<bundled 脚本/工具做什么, 不展开实现>

## 用法
<调用方式、参数、输出格式>
```

---

提醒: description 字段用中文、第三人称、what+when, 在工作流步骤 3 中打磨 (此处不展开)。
