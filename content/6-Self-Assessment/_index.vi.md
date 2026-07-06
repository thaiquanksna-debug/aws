---
title: "Tự đánh giá"
weight: 6
chapter: false
pre: "<b>6. </b>"
slug: "6-self-rating"
---


Trong thời gian thực tập từ **17/04/2026 đến 10/07/2026**, tôi tập trung theo hướng **Cloud Operations / Application Deployment Engineer**. Nội dung học và thực hành được triển khai theo worklog 12 tuần, bắt đầu từ môi trường thực tập, Hugo, AWS Console, Free Tier, Billing, IAM, EC2, VPC, RDS, Auto Scaling, CloudWatch, sau đó chuyển sang tài liệu hóa workshop, hoàn thiện proposal, sửa AWS diagram và triển khai project cuối kỳ.

Ban đầu, tôi còn thiếu kinh nghiệm thao tác trên AWS Console và chưa quen với việc vừa làm lab vừa ghi lại bằng chứng, lỗi gặp phải và kết quả kiểm tra. Tôi cũng chưa có thói quen quản lý chi phí, cleanup tài nguyên và kiểm tra lại security group/route table sau khi triển khai. Sau quá trình thực tập, tôi đã hiểu rõ hơn cách vận hành một workload AWS cơ bản: triển khai máy chủ, kết nối database, theo dõi log/metric, kiểm tra health check, quản lý chi phí và tài liệu hóa quá trình thực hiện.

Thông qua quá trình thực tập, tôi đã cải thiện các nhóm kỹ năng chính:

- **Kỹ thuật triển khai:** AWS Console, EC2, key pair, security group, user data, RDS integration, Auto Scaling Group, Launch Template, CloudWatch và cleanup tài nguyên.
- **Vận hành:** Biết kiểm tra trạng thái instance, log ứng dụng, alarm cơ bản, health check và lỗi kết nối giữa EC2, RDS và network layer.
- **Tài liệu hóa:** Ghi worklog theo tuần, chuẩn hóa nội dung Hugo song ngữ, mapping nguồn học từ AWS Study Group và AWS Docs.
- **Làm việc nhóm:** Phối hợp với bạn cùng nhóm trong 2 tuần cuối để hoàn thiện proposal, sửa diagram bị sai và triển khai project theo cùng một hướng.

Tôi nhận thấy bản thân vẫn cần cải thiện khả năng phân tích kiến trúc ở mức tổng thể và cần luyện thêm cách giải thích lý do chọn từng dịch vụ AWS. Tuy nhiên, quá trình thực tập đã giúp tôi tự tin hơn khi triển khai, kiểm thử và tài liệu hóa một workshop/project AWS theo yêu cầu thực tế.

---

## Bảng đánh giá theo tiêu chí

| STT | Tiêu chí | Mô tả | Tốt | Khá | Trung bình |
|---|---|---|---|---|---|
| 1 | Kiến thức và kỹ năng chuyên môn | Hiểu và thực hành EC2, RDS, VPC, ASG, CloudWatch, Billing và Hugo workshop | ✅ | ☐ | ☐ |
| 2 | Khả năng học hỏi | Tiếp thu nhanh qua lab, tài liệu AWS và quá trình sửa lỗi khi triển khai | ✅ | ☐ | ☐ |
| 3 | Chủ động | Chủ động thực hiện lab và ghi nhận lỗi, nhưng cần chủ động hơn ở phần thiết kế kiến trúc | ☐ | ✅ | ☐ |
| 4 | Tinh thần trách nhiệm | Hoàn thành worklog, tài liệu workshop và phần triển khai đúng tiến độ | ✅ | ☐ | ☐ |
| 5 | Kỷ luật | Có ý thức quản lý chi phí, cleanup tài nguyên và tuân thủ tiến độ thực tập | ✅ | ☐ | ☐ |
| 6 | Tính cầu tiến | Sẵn sàng sửa lỗi, cập nhật nội dung Hugo và điều chỉnh theo feedback | ✅ | ☐ | ☐ |
| 7 | Giao tiếp | Trao đổi được tiến độ và lỗi gặp phải, nhưng cần trình bày kỹ thuật mạch lạc hơn | ☐ | ✅ | ☐ |
| 8 | Hợp tác nhóm | Làm việc hiệu quả với bạn cùng nhóm trong phần proposal, diagram và project cuối kỳ | ✅ | ☐ | ☐ |
| 9 | Ứng xử chuyên nghiệp | Tôn trọng yêu cầu nộp bài, nguồn tài liệu và quy trình triển khai an toàn | ✅ | ☐ | ☐ |
| 10 | Tư duy giải quyết vấn đề | Biết kiểm tra lỗi vận hành, nhưng cần nâng cao phân tích root cause ở mức kiến trúc | ☐ | ✅ | ☐ |
| 11 | Đóng góp vào dự án/tổ chức | Đóng góp vào triển khai, kiểm thử, cleanup, tài liệu hóa và bằng chứng vận hành | ✅ | ☐ | ☐ |
| 12 | Tổng thể | Hoàn thành tốt quá trình thực tập theo hướng Cloud Operations / Application Deployment | ✅ | ☐ | ☐ |

---

## Cần cải thiện

- Cần học sâu hơn về thiết kế kiến trúc tổng thể để giải thích được vai trò của từng service trong diagram.
- Cần luyện thêm Terraform/CloudFormation để tự động hóa triển khai thay vì phụ thuộc nhiều vào AWS Console.
- Cần cải thiện kỹ năng phân tích root cause khi gặp lỗi về network, IAM permission hoặc database connection.
- Cần trình bày kỹ thuật mạch lạc hơn khi mô tả luồng triển khai và vận hành workload.
- Cần tiếp tục rèn thói quen ghi evidence đầy đủ: screenshot, log, metric, alarm và kết quả kiểm thử.
