# PDF 提取工具速查 (extraction-tools)

本文件在 processing-pdfs 步骤 2 加载。PDF 提取的工具选择与用法速查。自包含, 不依赖其他 reference。

## 目录
1. [工具选型决策](#1-工具选型决策)
2. [pdfplumber — 表格提取首选](#2-pdfplumber--表格提取首选)
3. [PyMuPDF (fitz) — 文字提取最快](#3-pymupdf-fitz--文字提取最快)
4. [扫描件 OCR](#4-扫描件-ocr)
5. [发票字段定位技巧](#5-发票字段定位技巧)

## 1. 工具选型决策

| 场景 | 工具 | 理由 |
|------|------|------|
| 数字原生 PDF 表格 | pdfplumber | 基于线条 / 文本对齐, 表格最稳 |
| 数字原生 PDF 纯文字 | PyMuPDF (fitz) | 比 pdfplumber 快数倍 |
| 扫描件 / 图片 PDF | pytesseract + pdf2image | 需 OCR |
| 混合 (表格 + 文字) | pdfplumber | 一套搞定 |

判断是否扫描件: `pdfplumber.open(path).pages[0].extract_text()` 返回空或乱码 → 多半是扫描件, 走 OCR。

## 2. pdfplumber — 表格提取首选

安装: `pip install pdfplumber`

```python
import pdfplumber

with pdfplumber.open("invoice.pdf") as pdf:
    for page in pdf.pages:
        tables = page.extract_tables()   # list of table; 每表是二维列表
        for table in tables:
            for row in table:
                print(row)
        text = page.extract_text()
```

线条不明显 (无框线表格) 时调参数:
```python
page.extract_table(table_settings={
    "vertical_strategy": "text",     # 默认 "lines"; 无竖线时改 "text"
    "horizontal_strategy": "text",
})
```

## 3. PyMuPDF (fitz) — 文字提取最快

安装: `pip install pymupdf`

```python
import fitz  # PyMuPDF

doc = fitz.open("invoice.pdf")
for page in doc:
    text = page.get_text()                          # 纯文字, 比 pdfplumber 快
    blocks = page.get_text("dict")["blocks"]        # 带坐标的文字块 (字段定位用)
```

## 4. 扫描件 OCR

安装: `pip install pytesseract pdf2image` (系统还需装 tesseract 和 poppler)

```python
from pdf2image import convert_from_path
import pytesseract

images = convert_from_path("scan.pdf")
for img in images:
    text = pytesseract.image_to_string(img, lang="chi_sim+eng")   # 中文 + 英文
```

注意: OCR 准确率低于原生提取, 结果须人工复核。

## 5. 发票字段定位技巧

发票字段 (发票号、金额、日期、商品明细) 常需精确定位:

- **正则匹配**: 先 `extract_text()`, 再用正则找 `发票号码.*?(\d+)`、`价税合计.*?([\d.]+)`
- **坐标定位**: 用 `page.get_text("words")` 拿每个词的 bbox, 按坐标对齐 (适合固定版式发票)
- **表格优先**: 商品明细通常是表格, 先 `extract_tables()` 拿结构化行, 再映射字段

中文发票常见字段: 发票号码、开票日期、购买方、销售方、商品名称、规格、数量、单价、金额、税率、税额、价税合计。
