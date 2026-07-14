# Mẫu khung skill (templates)

Tệp này tải ở bước 2 skillseed. Chọn loại skill, copy khung rồi điền. Tự chứa, không phụ thuộc reference khác.

## Mục lục
1. [Cách chọn loại](#cách-chọn-loại)
2. [Template A — workflow](#template-a--workflow)
3. [Template B — reference](#template-b--reference)
4. [Template C — tool](#template-c--tool)
5. [Template D — skill hành chính](#template-d--skill-hành-chính-nhà-nước-khuyến-nghị)

## Cách chọn loại
- **workflow**: quy trình từng bước (vd. soạn công văn, lập kế hoạch). Phù hợp "làm việc theo bước".
- **reference**: tra cứu kiến thức (vd. quy chuẩn NĐ 30, văn phong hành chính). Phù hợp "đọc rồi trả lời".
- **tool**: bọc script/công cụ (vd. validate, chuyển đổi định dạng). Phù hợp "gọi công cụ thực hiện".
- **hybrid**: kết hợp. Lấy loại chính làm khung, nhúng phần loại phụ.
- **hành chính (workflow mở rộng)**: skill phục vụ cơ quan nhà nước — ưu tiên Template D.

## Template A — workflow

```
---
name: <danh-từ-hoặc-động-từ>
description: <tiếng Việt: WHAT + WHEN + Kích hoạt khi: ...>
argument-hint: [tuỳ-chọn]
---
# <Tiêu đề>

Một câu định vị.

## Khi nào dùng
<2–3 dòng: tình huống kích hoạt>

## Quy trình
1. <bước>
2. <bước>

## Chỉ mục References
| Tệp | Nội dung | Khi nào tải |
|-----|----------|-------------|
| `references/<tệp>.md` | <nội dung> | <bước X> |

## Ràng buộc quan trọng
- <ràng buộc>
```

## Template B — reference

```
---
name: <danh-từ>
description: <tiếng Việt: "Tra cứu X. Dùng khi...">
---
# <Tiêu đề>

Một câu định vị.

## Khi nào dùng
<khi nào tra cứu tài liệu này>

## Chỉ mục Reference
| Tệp | Nội dung | Khi nào tải |
|-----|----------|-------------|
| `references/<chủ-đề>.md` | <phạm vi> | <khi nào> |

## Hướng dẫn nhanh
<câu trả lời mỏng cho câu hỏi hay gặp; chi tiết trong references>
```

## Template C — tool

```
---
name: <động-từ-danh-từ>
description: <tiếng Việt: công cụ làm gì + WHEN + Kích hoạt khi: ...>
allowed-tools: Bash, Read
---
# <Tiêu đề>

Một câu định vị.

## Khi nào dùng
<khi nào chạy công cụ>

## Cách hoạt động
<script/công cụ làm gì, không đi sâu implementation>

## Cách dùng
<cách gọi, tham số, định dạng đầu ra>
```

## Template D — skill hành chính nhà nước (khuyến nghị)

Dùng cho skill tham mưu, công văn, kế hoạch, báo cáo.

```
---
name: <soan-cong-van | lap-ke-hoach | ...>
description: <tiếng Việt: WHAT + WHEN + từ khóa hành chính + Kích hoạt khi: ...>
argument-hint: [loại-văn-bản] [tóm-tắt]
---
# <Tiêu đề>

Hỗ trợ cán bộ [cơ quan/đơn vị] trong [tham mưu / soạn văn bản / lập kế hoạch / báo cáo].

## Khi nào dùng
- <tình huống 1>
- <tình huống 2>

## Phong cách tương tác
Ít hỏi → soạn bản nháp đầy đủ → chỉnh theo phản hồi. Luôn dùng tiếng Việt và văn phong hành chính.

## Quy trình
1. Xác định loại văn bản và mục đích
2. Thu thập nội dung cốt lõi (sự việc, căn cứ, đề xuất…)
3. Chọn mẫu và soạn nháp — tải tệp mẫu (xem Chỉ mục References)
4. Thẩm định — tải tệp văn phong hành chính (xem Chỉ mục References)
5. Xuất bản (Markdown / hướng dẫn copy Word)

## Chỉ mục References
| Tệp | Nội dung | Khi nào tải |
|-----|----------|-------------|
| `references/<mau-van-ban>.md` | Khung mẫu văn bản | Bước 3 |
| `references/<van-phong-hanh-chinh>.md` | Quy tắc văn phong, lỗi thường gặp | Bước 4 |
| `references/<can-cu-phap-ly>.md` | (tuỳ chọn) Căn cứ, quy định liên quan | Khi cần trích dẫn |

## Ràng buộc quan trọng
- Không bịa số hiệu văn bản, nghị định — ghi `[cần xác minh]` nếu chưa chắc
- Không thay thế ý kiến pháp lý chính thức
- Giữ trung lập hành chính; nhắc bảo mật nếu nội dung nhạy cảm
```

---

Nhắc: trường description dùng tiếng Việt, ngôi thứ ba, what+when — mài ở bước 3 (không lặp lại ở đây).
