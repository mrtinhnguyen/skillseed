---
name: processing-pdfs
description: 从 PDF 文档（尤其发票、收据、报表）中提取表格和文字，输出结构化数据。当用户需要解析 PDF 内容、提取 PDF 表格、读取 PDF 文字、或处理发票/收据数据时使用。触发词："提取 PDF"、"解析 PDF"、"PDF 表格"、"读取 PDF"、"解析发票"、"extract PDF"。
argument-hint: [pdf-path]
---

# processing-pdfs

从 PDF 提取表格和文字内容, 输出结构化数据 (CSV / JSON / Markdown)。聚焦发票、收据、报表类 PDF。

## 何时使用

当用户想: 从 PDF 提取表格、读取 PDF 文字、解析发票/收据、把 PDF 内容转成结构化数据时。

## 工作流

### 1. 确认目标
- PDF 文件路径 (或用户已打开的文件)
- 要提取什么: 表格 / 纯文字 / 两者
- 输出格式: CSV / JSON / Markdown / 直接展示

### 2. 选工具
**加载 `references/extraction-tools.md`** 选工具。速记:
- **表格**: pdfplumber —— 表格提取最稳
- **文字**: PyMuPDF (fitz) —— 比 pdfplumber 快数倍
- **扫描件 / 图片 PDF**: 需 OCR (pytesseract + pdf2image)

### 3. 提取
- 先探查 PDF: 页数、是否含可选中的文字 (还是扫描件)
- 表格: `pdfplumber.open(path).pages[i].extract_tables()`
- 文字: `page.extract_text()` 或 PyMuPDF `page.get_text()`
- 发票特有: 字段对齐 (发票号、金额、日期、商品明细) 常需按坐标或正则定位

### 4. 结构化输出
- 表格 → CSV 或 Markdown 表
- 发票字段 → JSON (键值对)
- 多页 → 合并或分页输出, 注明页码

### 5. 校验
- 抽查 1-2 页对照原文, 确认无遗漏 / 错位
- 表格列对齐正确, 数字无串行
- 扫描件 OCR 结果须人工复核

## References 索引

| 文件 | 内容 | 何时加载 |
|------|------|----------|
| `references/extraction-tools.md` | PDF 提取工具用法速查 (pdfplumber / PyMuPDF / OCR) + 发票字段定位技巧 | 步骤 2 选工具时 |

## 重要约束
- 优先用 pdfplumber 提取表格 (最稳); 纯文字用 PyMuPDF 更快
- 扫描件 (extract_text 返回空) 必须走 OCR, 不要硬用 extract_text
- 输出前对照原文抽查, 避免静默错位
- 路径用正斜杠 (含 Windows)
