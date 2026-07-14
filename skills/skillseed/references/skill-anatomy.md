# Quy chuẩn định dạng skill (skill-anatomy)

Tài liệu tham chiếu đầy đủ về định dạng skill. Skillseed tải ở bước 4–5 khi không chắc frontmatter hoặc quy tắc. Tự chứa, không phụ thuộc reference khác.

## Mục lục
1. [Skill là gì + vòng đời tải](#1-skill-là-gì--vòng-đời-tải)
2. [Đường dẫn discovery](#2-đường-dẫn-discovery)
3. [Bảng trường frontmatter](#3-bảng-trường-frontmatter)
4. [Quy tắc name](#4-quy-tắc-name)
5. [Quy tắc description](#5-quy-tắc-description)
6. [Thân SKILL.md](#6-thân-skillmd)
7. [Quy tắc tiết lộ dần](#7-quy-tắc-tiết-lộ-dần)
8. [Lỗi thường gặp](#8-lỗi-thường-gặp)

## 1. Skill là gì + vòng đời tải

Một skill = một thư mục + một `SKILL.md` (+ tuỳ chọn references / scripts / assets).

Vòng đời tải (tiết lộ dần):
- **Khi khởi động**: chỉ `name` + `description` của mọi skill vào ngữ cảnh (trong ngân sách ký tự, ~1% cửa sổ ngữ cảnh).
- **Khi gọi**: người dùng `/name` hoặc agent coi là liên quan → mới tải toàn bộ thân SKILL.md.
- **Theo nhu cầu**: references chỉ vào ngữ cảnh **khi agent chủ động đọc**.

Vì vậy: description quyết định có được kích hoạt; thân SKILL.md quyết định làm gì sau khi kích hoạt; references cung cấp chi tiết.

## 2. Đường dẫn discovery

Agent Skills là chuẩn mở (agentskills.io); định dạng SKILL.md **dùng chung đa công cụ**; khác nhau chủ yếu **đường cài**:

| Công cụ | Toàn cục (`--user`) | Dự án (`--project`) |
|---------|---------------------|---------------------|
| Claude Code | `~/.claude/skills/<name>/` | `<project>/.claude/skills/<name>/` |
| Codex | `~/.agents/skills/<name>/` | `<project>/.agents/skills/<name>/` |
| Cursor | `~/.cursor/skills/<name>/` | `<project>/.cursor/skills/<name>/` |
| Khác (Gemini CLI…) | `~/.<tool>/skills/` theo từng công cụ | `<project>/.<tool>/skills/` |

> Đường dẫn theo tài liệu công khai (2026), có thể đổi theo phiên bản; không chắc dùng `install-skill.sh --target <path>`.

**Quy tắc chung:**
- Định dạng SKILL.md nhất quán (name + description + cấu trúc thư mục + tiết lộ dần); một skill cài nhiều công cụ.
- Trường mở rộng Claude Code (`allowed-tools` / `context` / `hooks`…) công cụ khác bỏ qua, không ảnh hưởng dùng cơ bản.
- **Ưu tiên** (trùng tên): thường toàn cục < dự án; Claude Code thêm doanh nghiệp > cá nhân > dự án > plugin.
- **Thư mục lồng** (Claude Code): khi đọc/ghi thư mục con, `.claude/skills/` của thư mục đó dùng được; trùng tên hiển thị dạng `/apps/web:deploy`.
- **Phát hiện thay đổi**: sửa SKILL.md đã tồn tại → có hiệu lực trong phiên; **lần đầu tạo thư mục skills gốc cần khởi động lại** công cụ.
- Gỡ lỗi (Claude Code): `/doctor` xem description bị cắt; `--debug` xem lỗi parse frontmatter.

## 3. Bảng trường frontmatter

YAML ở đầu SKILL.md. `name` và `description` bắt buộc theo chuẩn Agent Skills; còn lại là mở rộng Claude Code (tuỳ chọn).

| Trường | Bắt buộc | Kiểu/ràng buộc | Tác dụng |
|--------|----------|----------------|----------|
| `name` | Có | ≤64 ký tự, `^[a-z0-9-]+$`, cấm anthropic/claude, ưu tiên gerund | Tên skill |
| `description` | Có | ≤1024 ký tự, ngôi thứ ba, what+when, từ khóa trước, tiếng Việt | Cơ sở kích hoạt (quan trọng nhất) |
| `when_to_use` | Không | văn bản | Ngữ cảnh kích hoạt thêm, nối sau description; tổng ≤1536 ký tự |
| `argument-hint` | Không | chuỗi | Gợi ý tự hoàn thành, vd. `[số-văn-bản]` |
| `arguments` | Không | danh sách cách nhau bởi khoảng trắng hoặc YAML | Tham số vị trí, dùng thay `$name` |
| `disable-model-invocation` | Không | bool, mặc định false | true = agent không tự tải (chỉ `/name` tay) |
| `user-invocable` | Không | bool, mặc định true | false = ẩn khỏi menu `/` (chỉ nền) |
| `allowed-tools` | Không | danh sách | Công cụ được dùng không cần xác nhận khi skill active |
| `disallowed-tools` | Không | tương tự | Công cụ bị loại khỏi pool khi skill active |
| `model` | Không | id model hoặc `inherit` | Ghi đè model cho lượt skill |
| `effort` | Không | low/medium/high/xhigh/max | Ghi đè mức suy luận |
| `context` | Không | `fork` | fork = chạy trong sub-agent cách ly |
| `agent` | Không | loại sub-agent | Dùng với context: fork |
| `hooks` | Không | cấu hình hooks | Gắn hooks vào vòng đời skill |
| `paths` | Không | danh sách glob | Giới hạn phạm vi tự kích hoạt theo đường dẫn |
| `shell` | Không | bash(mặc định)/powershell | Shell cho khối `` !`cmd` `` |

## 4. Quy tắc name
- ≤64 ký tự
- Chỉ `[a-z0-9-]`: regex `^[a-z0-9-]+$`
- Cấm `anthropic`, `claude`
- Ưu tiên **gerund**: `soan-cong-van`, `processing-pdfs`
- Chấp nhận cụm danh từ (`lap-ke-hoach`) hoặc động-tân (`process-pdfs`)
- Tránh: `helper`, `utils`, `tools`, `documents`, `data`, `files`

## 5. Quy tắc description
- ≤1024 ký tự
- **Ngôi thứ ba** (inject vào system prompt)
- Nêu **WHAT** + **WHEN**
- Từ khóa/use case **đặt trước** (danh sách có thể bị cắt cuối)
- **Tiếng Việt** (chiến lược repo: kích hoạt và thân bài đều tiếng Việt)
- `description` + `when_to_use` ≤1536 ký tự
- Cuối có thể thêm `Kích hoạt khi: "kw1", "kw2", ...`

Cách viết chi tiết và ví dụ tốt/xấu: tải trong quy trình SKILL.md bước 3, không lặp ở đây.

## 6. Thân SKILL.md
- **<500 dòng** (sau khi gọi, toàn bộ ở lại ngữ cảnh — mỗi dòng đều tốn token lặp)
- Cấu trúc gợi ý: tiêu đề + một câu định vị → Khi nào dùng → Quy trình/thân → Chỉ mục References → Ràng buộc
- Chỉ viết ngữ cảnh agent chưa biết; giả định agent đủ thông minh
- Thuật ngữ nhất quán
- Tránh thông tin theo thời gian (phiên bản, ngày hết hạn)
- Quy trình phức tạp có thể có checklist để agent theo dõi

## 7. Quy tắc tiết lộ dần
- SKILL.md là điểm vào duy nhất, luôn tải trước
- **References chỉ một tầng**: cấm A tham chiếu B, B tham chiếu C. Mỗi reference là lá, chỉ SKILL.md chỉ khi nào tải.
- Trong SKILL.md **ghi rõ** nội dung và thời điểm tải từng reference (bảng Chỉ mục References)
- Reference >100 dòng: **TOC ở đầu**
- Đường dẫn **luôn dấu `/`** (Windows cũng vậy)
- Sau khi skill được gọi, nội dung ở lại phiên — viết "làm gì", không giảng "vì sao/cách làm chi tiết" nếu đã có reference

## 8. Lỗi thường gặp
- Description ngôi thứ hai ("Bạn có thể dùng…") → dùng ngôi thứ ba
- name có hoa hoặc gạch dưới → chỉ `[a-z0-9-]`
- name chứa `claude`/`anthropic` → bị từ chối
- References chỉ nhau tải → vi phạm một tầng, agent có thể bỏ sót
- Đường dẫn dùng `\` trên Windows → luôn `/`
- SKILL.md quá dài (>500 dòng) → tách sang references
- Reference >100 dòng thiếu TOC
- Description thiếu "when" hoặc từ khóa → khó discovery
- frontmatter YAML sai → Claude Code load metadata rỗng, `/name` vẫn dùng được nhưng không match description
