# Hướng dẫn viết description (description-guide)

Tệp này tải ở bước 3 của skillseed. Description quyết định skill có được kích hoạt đúng lúc — viết tốt description quan trọng hơn viết tốt phần thân.

## 1. Vì sao description quan trọng nhất
- Khi khởi động chỉ có `name` + `description` vào ngữ cảnh; agent dựa vào đó quyết định khi nào gọi skill.
- Description trong danh sách có thể bị **cắt từ cuối** (hết ngân sách ký tự).
- Không có description hoặc description mơ hồ → skill hầu như không tự kích hoạt (chỉ gọi tay `/name`).

## 2. Công thức
**Ngôi thứ ba + WHAT (làm gì) + WHEN (khi nào) + từ khóa đặt trước**

- Ngôi thứ ba: "Soạn thảo công văn…" thay vì "Tôi có thể giúp bạn…" / "Bạn có thể dùng…"
- WHAT: skill làm cụ thể gì (động từ đầu, rõ đầu vào/đầu ra)
- WHEN: tình huống nào (người dùng hay nói thế nào)
- Từ khóa đặt trước: use case quan trọng nhất lên đầu (tránh bị cắt mất)

## 3. Chiến lược từ khóa
- Liệt kê từ người dùng **thực sự hay nói**: "công văn", "tờ trình", "báo cáo" thay vì "hỗ trợ văn bản hành chính tổng hợp"
- Đặt từ khóa ở đầu description và cuối (danh sách `Kích hoạt khi:`)
- Tránh từ chung chung: "trợ giúp", "tiện ích", "nhiều tác vụ" — không có thông tin
- **Chiến lược repo này:** description bằng tiếng Việt, khớp ngôn ngữ người dùng; từ khóa ở đầu và danh sách `Kích hoạt khi:`

### Từ khóa gợi ý cho skill hành chính
- Tham mưu: "tham mưu", "đề xuất phương án", "phân tích", "so sánh phương án"
- Công văn: "công văn", "công văn đi", "phúc đáp", "giấy mời", "thông báo"
- Báo cáo: "báo cáo", "tổng kết", "báo cáo định kỳ", "báo cáo chuyên đề"
- Kế hoạch: "kế hoạch", "kế hoạch năm", "kế hoạch công tác", "phân công nhiệm vụ"

## 4. Kiểm tra kích hoạt (should / should-not)
Sau khi có bản nháp description, **bắt buộc** làm bước này:

1. Viết **3 câu should-trigger**: yêu cầu thật nên kích hoạt skill
2. Viết **3 câu should-not-trigger**: gần giống nhưng **không** nên kích hoạt (ranh giới dễ nhầm)
3. Suy luận từng câu: "Với description này, agent có kích hoạt không? Có đúng không?"
4. should-trigger không kích hoạt → thiếu từ khóa; should-not bị kích hoạt → description quá rộng → chỉnh lại

Đây là pre-eval nhẹ. Eval hàng loạt dùng plugin skill-creator chính thức.

### Ví dụ ranh giới — skill soạn công văn
| Loại | Câu mẫu |
|------|---------|
| Should-trigger | "Soạn công văn đề nghị cấp trên hỗ trợ kinh phí" |
| Should-trigger | "Chỉnh lại dự thảo công văn phúc đáp theo NĐ 30" |
| Should-not-trigger | "Dịch công văn sang tiếng Anh" (skill dịch thuật, không phải soạn hành chính) |
| Should-not-trigger | "Viết email nội bộ cho đồng nghiệp" (không phải văn bản hành chính) |

## 5. Quản lý độ dài
- description ≤1024 ký tự
- description + when_to_use ≤1536 ký tự
- Chức năng cốt lõi đặt trước, đảm bảo sau khi cắt vẫn nhận ra được

## 6. Ví dụ tốt / xấu

> Ví dụ dưới đây dùng bối cảnh cơ quan nhà nước; cấu trúc áp dụng cho mọi loại skill.

### Ví dụ 1 — workflow (soạn công văn)

**Tốt:**
> Soạn thảo và chỉnh sửa công văn hành chính (đi, phúc đáp, giấy mời) theo Nghị định 30/2020/NĐ-CP và văn phong hành chính. Dùng khi người dùng cần soạn, sửa hoặc rà soát công văn, giấy mời, thông báo. Kích hoạt khi: "công văn", "soạn công văn", "phúc đáp", "giấy mời", "Nghị định 30".

**Kém:**
> Skill này giúp bạn viết công văn rất hay. Rất mạnh và hỗ trợ nhiều loại văn bản. Bạn sẽ thích.

Sai ở: ngôi thứ hai; không có "when"; không có từ khóa; khoe rỗng.

### Ví dụ 2 — reference (quy chuẩn văn bản)

**Tốt:**
> Tra cứu quy chuẩn thể thức văn bản hành chính — cấu trúc công văn, tờ trình, báo cáo, kế hoạch; trích yếu; nơi nhận; ký duyệt. Dùng khi người dùng hỏi về format, thể thức, quy định soạn văn bản hành chính. Đọc TRƯỚC khi trả lời câu hỏi về NĐ 30 hoặc mẫu văn bản nhà nước.

**Kém:**
> Biết về văn bản. Tốt cho cán bộ.

Sai ở: quá ngắn; không từ khóa; không "when" rõ.

### Ví dụ 3 — tool (validate văn bản)

**Tốt:**
> Chạy script kiểm tra thể thức văn bản (frontmatter, độ dài, mục bắt buộc) trước khi trình ký. Dùng khi người dùng muốn validate, kiểm tra cấu trúc dự thảo văn bản. Kích hoạt khi: "kiểm tra văn bản", "validate", "rà soát thể thức".

**Kém:**
> Một script copy tệp. Chạy khi bạn muốn.

Sai ở: mơ hồ; không từ khóa; không "when" cụ thể.
