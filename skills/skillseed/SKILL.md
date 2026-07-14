---
name: skillseed
description: Khởi tạo và viết Agent Skills end-to-end (theo chuẩn mở, tương thích Claude Code, Codex, Cursor…) — tạo SKILL.md đúng quy chuẩn (kèm frontmatter), tổ chức references theo tiết lộ dần, mài description bằng ví dụ should/should-not, chạy tự kiểm tra (kèm script), và cài đặt qua script. Dùng khi cần tạo skill mới cho tham mưu, soạn công văn, kế hoạch, báo cáo hoặc quy trình hành chính nhà nước; viết/scaffold SKILL.md; thiết kế mô tả và từ khóa kích hoạt; chọn mẫu skill; kiểm tra định dạng; hoặc cài skill lên Claude Code / Codex / Cursor. Kích hoạt: "tạo skill", "skill mới", "scaffold SKILL.md", "cài skill", "viết skill công văn", "skill báo cáo".
argument-hint: [tên-skill] [mô-tả-một-dòng]
---

# skillseed

Giúp tạo Agent Skills đúng chuẩn (Claude Code / Codex / Cursor): khởi tạo + huấn luyện viết + tự kiểm tra (kèm validate) + cài đặt đa công cụ.

**Định hướng ưu tiên:** skill phục vụ cơ quan nhà nước — tham mưu, soạn thảo công văn, kế hoạch, báo cáo và các quy trình hành chính tương tự.

## Khi nào dùng skill này

Khi người dùng muốn: tạo skill mới, scaffold SKILL.md, mài mô tả kích hoạt, chọn mẫu, tự kiểm tra định dạng, hoặc cài skill vào thư mục skills của Claude Code / Codex / Cursor.

## Phong cách tương tác

**Ít hỏi + sinh bản nháp + lặp:** hỏi 2–3 câu then chốt, rồi sinh khung và nội dung đầy đủ, chỉnh theo phản hồi.

Nếu gọi kèm tham số (`/skillseed <tên> "<mô tả một dòng>"`), bỏ qua bước hỏi, vào thẳng bước 3.

## Kho kinh nghiệm (cơ chế tiến hóa)

Skill này duy trì **hai** tệp kinh nghiệm:
- `references/lessons.md` — kinh nghiệm rút gọn hiện tại. **Đọc khi bắt đầu** gọi skill này.
- `references/lessons-archive.md` — lưu trữ đầy đủ (khi tổng hợp thì ghi thêm, không xóa).

Bước 8 ghi kinh nghiệm mới vào lessons.md; vượt ngưỡng thì tự tổng hợp (gộp trùng + rút mẫu, bản gốc lưu archive).

## Quy trình

### 1. Làm rõ ý định
Hỏi 2–3 câu (nếu tham số đã trả lời thì bỏ qua):
- Skill **làm gì**? (một câu)
- **Ai, trong tình huống nào** sẽ kích hoạt? (từ khóa người dùng hay nói)
- (Tuỳ chọn) Nhận đầu vào gì, xuất ra gì?

Với skill hành chính, ưu tiên hỏi thêm: loại văn bản/quy trình (công văn, tờ trình, báo cáo, kế hoạch…), cấp cơ quan, mức độ chuẩn hoá (NĐ 30, mẫu nội bộ…).

### 2. Chọn loại
Chọn workflow / reference / tool / hybrid. **Tải `references/templates.md`** để chọn khung.
Tiêu chí: workflow = quy trình từng bước; reference = tra cứu kiến thức; tool = bọc script/công cụ.

### 3. Mài description (bước quan trọng nhất)
**Tải `references/description-guide.md`**. Viết theo công thức: **ngôi thứ ba + WHAT + WHEN + từ khóa đặt trước** (tiếng Việt).

Sau đó **kiểm tra kích hoạt** (giá trị cốt lõi của skillseed):
- Viết 3 câu **should-trigger** (yêu cầu nên kích hoạt skill)
- Viết 3 câu **should-not-trigger** (gần giống nhưng không nên kích hoạt)
- Suy luận từng câu: "Với description này, agent có kích hoạt không?" → chỉnh description

### 4. Tạo khung
Tạo thư mục `skills/<tên>/` + `SKILL.md` + `references/` cần thiết.
Nếu không chắc frontmatter hoặc quy tắc định dạng, **tải `references/skill-anatomy.md`**.
Điền description đã chốt vào frontmatter.

### 5. Viết bản nháp
Viết SKILL.md và references **bằng tiếng Việt**. Tuân thủ:
- SKILL.md <500 dòng (skill meta mục tiêu <150 dòng)
- references **chỉ một tầng**: không để reference này chỉ tải reference khác
- reference >100 dòng: thêm mục lục (TOC) ở đầu
- Đường dẫn dùng dấu `/` (kể cả Windows)
- Trong SKILL.md ghi rõ nội dung và thời điểm tải từng reference

Skill hành chính: ưu tiên mẫu văn bản, checklist thẩm định, quy tắc văn phong trong references; SKILL.md giữ quy trình gọn.

### 6. Tự kiểm tra (ngữ nghĩa + khách quan)
**Tải `references/checklist.md`** rà từng mục ngữ nghĩa; sau đó chạy validate:
```
bash scripts/validate-skill.sh <tên>
```
Các mục cơ học (name, độ dài description, số dòng SKILL.md, frontmatter, một tầng references, TOC >100 dòng, dấu `/`, tệp tồn tại) do script quyết định. Sửa đến khi PASS (exit 0).

### 7. (Tuỳ chọn) Cài đặt
```
bash scripts/install-skill.sh <tên> --tool <claude|codex|cursor> --project   # --project=cấp dự án, --user=toàn cục
```
**Lần đầu cài skill mới vào công cụ cần khởi động lại**; sau đó sửa SKILL.md được phát hiện theo thời gian thực.

### 8. Ghi kinh nghiệm + tự tổng hợp
Sau khi tạo xong skill, rút kinh nghiệm chung (không phải trường hợp một lần):
1. **Thêm** một mục vào cuối `references/lessons.md` (định dạng: `## <tiêu đề ngắn>` + tình huống + kinh nghiệm + tuỳ chọn "đề xuất sửa quy chuẩn")
2. **Tổng hợp** — khi lessons.md vượt **20 mục**:
   - **Ghi thêm** toàn bộ mục hiện tại vào `references/lessons-archive.md`
   - Gộp mục trùng/tương tự, rút 2–3 mẫu chung
   - **Viết lại** lessons.md: phần đầu (giữ nguyên) + mục rút gọn (≤10) + ghi "Tổng hợp gần nhất: N mục → M mục"

Rào chắn:
- archive chỉ thêm, không xóa; lessons.md chỉ viết lại khi tổng hợp
- Kinh nghiệm phải cụ thể, có thể làm được; trùng mục cũ thì không thêm
- **Không sửa reference khác** (checklist / templates / …); đề xuất sửa quy chuẩn chỉ ghi "đề xuất", không tự thực hiện

## Chỉ mục References

Tải theo nhu cầu, không đọc hết ngay từ đầu:

| Tệp | Nội dung | Khi nào tải |
|-----|----------|-------------|
| `references/lessons.md` | Kho kinh nghiệm (rút gọn, càng dùng càng phong phú) | Đầu mỗi lần gọi; bước 8 ghi/tổng hợp |
| `references/lessons-archive.md` | Lưu trữ đầy đủ (khi tổng hợp) | Bước 8 ghi (hiếm khi đọc) |
| `references/templates.md` | 4 khung skill (workflow / reference / tool / hành chính) | Bước 2 |
| `references/description-guide.md` | Hướng dẫn viết description + ví dụ tốt/xấu | Bước 3 |
| `references/skill-anatomy.md` | Quy chuẩn đầy đủ: frontmatter, name, discovery, tiết lộ dần | Bước 4–5 khi cần |
| `references/checklist.md` | Checklist trước khi phát hành (mục ngữ nghĩa) | Bước 6 |

## Ràng buộc quan trọng

- description và nội dung dùng **tiếng Việt**, ngôi thứ ba
- references **không chỉ nhau tải lần lượt** (một tầng)
- Đường dẫn dùng **dấu /**
- SKILL.md **<500 dòng**
- Skill sinh ra theo chuẩn mở, dùng được đa công cụ (Claude Code / Codex / Cursor)
- Kho kinh nghiệm là trạng thái runtime, cài lại vẫn giữ (install-skill.sh), không ghi đè từ canonical
- Bước 6: mục cơ học phải `validate-skill.sh` PASS

## Quan hệ với plugin skill-creator chính thức

Skill này (`skillseed`) lo **khởi tạo + tự kiểm tra + cài đa công cụ**; plugin chính thức (`/plugin install skill-creator@claude-plugins-official`) lo **eval/lặp** trong Claude Code. Có thể cài song song. Nên dùng plugin chính thức để đánh giá sau khi scaffold xong.

> Lưu ý: cố ý không đặt `context: fork` — cần lặp với người dùng trong hội thoại chính, không fork sang sub-agent.
