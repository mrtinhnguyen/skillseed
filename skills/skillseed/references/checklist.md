# Checklist trước khi phát hành skill (checklist)

Tệp này tải ở bước 6 skillseed. Rà từng mục, sửa ngay nếu không đạt. Tự chứa, không phụ thuộc reference khác.

## name
- [ ] ≤64 ký tự
- [ ] Chỉ chữ thường, số, dấu gạch ngang (`^[a-z0-9-]+$`)
- [ ] Không chứa `anthropic` hoặc `claude`
- [ ] Ưu tiên dạng gerund (vd. `soan-cong-van`, `processing-pdfs`)

## description
- [ ] ≤1024 ký tự
- [ ] Ngôi thứ ba (không "tôi/chúng tôi"; "bạn" chỉ chấp nhận trong cụm "Dùng khi bạn…")
- [ ] Nêu rõ WHAT (làm gì) + WHEN (khi nào)
- [ ] Use case / từ khóa quan trọng đặt trước (tránh bị cắt cuối)
- [ ] Tiếng Việt (chiến lược repo này)
- [ ] description + when_to_use ≤1536 ký tự

## SKILL.md
- [ ] <500 dòng
- [ ] frontmatter là YAML hợp lệ
- [ ] Chỉ dùng trường đã biết (không sai chính tả)
- [ ] Ngôn ngữ thân bài theo chiến lược repo (tiếng Việt)
- [ ] Có chỉ mục References, ghi nội dung và thời điểm tải từng reference

## references
- [ ] Chỉ một tầng: không reference nào chỉ tải reference khác
- [ ] Reference >100 dòng có mục lục (TOC) ở đầu
- [ ] Mọi đường dẫn dùng dấu `/` (kể cả Windows)
- [ ] Mọi tệp reference được nhắc trong SKILL.md đều tồn tại
- [ ] Không có chuỗi tham chiếu A→B→C

## Tiết lộ dần (progressive disclosure)
- [ ] SKILL.md không phình to (nội dung nặng chuyển sang references)
- [ ] Mỗi reference một trách nhiệm rõ ràng

## Discovery / cài đặt
- [ ] Skill nằm đường dẫn được nhận diện (`~/.<tool>/skills/<name>/`, `<project>/.<tool>/skills/<name>/`, hoặc plugin)
- [ ] Nếu lần đầu tạo thư mục skills gốc, đã nhắc người dùng khởi động lại công cụ

## Kiểm tra khách quan (mục cơ học, không ước lượng)
- [ ] `bash scripts/validate-skill.sh <tên>` PASS (exit 0)
- [ ] name, độ dài description, số dòng SKILL.md, frontmatter, một tầng references, TOC >100 dòng, dấu `/`, tệp tồn tại — do script quyết định

## Mài description (tuỳ chọn nhưng nên làm)
- [ ] Đã viết 3 should-trigger + 3 should-not-trigger và suy luận kiểm tra
- [ ] Description phân biệt được yêu cầu gần giống nhưng không nên kích hoạt

## Skill hành chính (bổ sung khi áp dụng)
- [ ] Từ khóa kích hoạt gồm loại văn bản/quy trình cụ thể (công văn, tờ trình, báo cáo, kế hoạch…)
- [ ] Có checklist thẩm định hoặc ràng buộc "không bịa căn cứ pháp lý"
- [ ] Văn phong và thuật ngữ nhất quán trong toàn skill
