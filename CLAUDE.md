# SkillSeed

Đây là **kho Agent Skills**: theo chuẩn mở Agent Skills; skill sinh ra tương thích Claude Code, Codex, Cursor và công cụ tương tự.

## Quy ước chính
- Nguồn canonical của mọi skill nằm trong `skills/<tên>/` để phát triển và quản lý phiên bản.
- Dùng `/skillseed` để tạo skill mới (sinh vào `skills/<tên>/` và tự kiểm tra).
- Dùng `scripts/install-skill.sh <tên> --tool <claude|codex|cursor> --project|--user` để cài skill vào đường dẫn mà công cụ quét được.

## Phát triển skillseed
- Nguồn tại `skills/skillseed/`.
- Sau khi sửa phải cài lại mới có hiệu lực: `bash scripts/install-skill.sh skillseed --tool claude --project`.
- Lần đầu cài cần khởi động lại công cụ; cài lại sau đó có hiệu lực ngay (copy thuần, không symlink).
- Kho kinh nghiệm `lessons.md` là trạng thái runtime, cài lại vẫn giữ (install-skill.sh); không nằm trong canonical.

## Chiến lược ngôn ngữ
- frontmatter `description` dùng **tiếng Việt**; thân bài và references dùng **tiếng Việt**.
- **Định hướng ưu tiên:** skill phục vụ cơ quan nhà nước (tham mưu, công văn, kế hoạch, báo cáo…).
- references chỉ một tầng (không chỉ nhau tải); đường dẫn dùng dấu `/`; SKILL.md <500 dòng.

Xem thêm README.md.
