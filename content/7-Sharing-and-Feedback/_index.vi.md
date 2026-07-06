---
title: "Chia sẻ, đóng góp ý kiến"
date: 2026-07-04
weight: 7
chapter: false
pre: " <b> 7. </b> "
---

# Chia sẻ, đóng góp ý kiến

## 1. Đánh giá chung

Sau quá trình thực tập tại FCJ, em có cơ hội tiếp cận nhiều kiến thức thực tế liên quan đến AWS, Cloud Computing, DevOps, Infrastructure as Code và quy trình triển khai một hệ thống trên môi trường cloud. Đây là giai đoạn giúp em chuyển từ việc chỉ học lý thuyết sang thực hành triển khai, kiểm thử, debug và viết tài liệu cho một project hoàn chỉnh.

Trong thời gian thực tập, em không chỉ học thêm về các dịch vụ AWS mà còn hiểu rõ hơn cách tư duy khi thiết kế kiến trúc hệ thống: cần xác định input, processing flow, output, failure handling, monitoring, alerting, cost optimization và cleanup. Những nội dung này giúp em nhìn một hệ thống cloud không chỉ như tập hợp các service riêng lẻ, mà là một workload có mục tiêu vận hành rõ ràng.

Project cá nhân của em là **Private-by-Default AWS Workload Platform**, tập trung vào việc xây dựng một workload xử lý job nội bộ trên AWS trong môi trường private. Project sử dụng Terraform để triển khai hạ tầng, OPA/Rego để kiểm tra policy trước khi deploy, EC2 Private Worker để xử lý job từ SQS, RDS PostgreSQL cho database tier, CloudWatch/SNS cho cảnh báo, và các dịch vụ audit như CloudTrail, AWS Config, VPC Flow Logs và S3 Evidence Bucket.

Qua project này, em hiểu rõ hơn về security-by-design, network isolation, least privilege IAM, VPC Endpoints, SSM Session Manager, KMS encryption, monitoring, alerting và tầm quan trọng của việc tạo evidence sau khi triển khai.

## 2. Môi trường làm việc

Môi trường làm việc tại FCJ thân thiện, cởi mở và phù hợp với thực tập sinh. Các anh chị trong team và các bạn cùng nhóm luôn sẵn sàng hỗ trợ khi em gặp khó khăn, kể cả với những câu hỏi cơ bản. Điều này giúp em bớt áp lực trong giai đoạn đầu, đặc biệt khi phải tiếp cận nhiều công nghệ mới cùng lúc.

Việc được tham gia các workshop AWS và làm project thực tế giúp em hiểu rõ hơn quy trình học, làm, kiểm thử và trình bày một sản phẩm kỹ thuật. Thay vì chỉ đọc tài liệu hoặc xem lý thuyết, em được tự tay triển khai, gặp lỗi, debug và hoàn thiện project. Đây là trải nghiệm rất quan trọng đối với sinh viên ngành Công nghệ thông tin.

## 3. Sự hỗ trợ của mentor và team admin

Team admin hỗ trợ tốt về mặt tài liệu, hướng dẫn workshop, thông báo timeline và tạo điều kiện để thực tập sinh làm việc thuận lợi. Các tài liệu workshop nhìn chung được viết rõ ràng, có hướng dẫn từng bước và có link tham khảo để người học có thể tự tìm hiểu thêm.

Mentor và các anh chị trong team cũng hỗ trợ em trong quá trình định hướng project, góp ý kiến trúc, cách trình bày diagram, cách xác định business flow và cách tạo evidence. Những góp ý này giúp em nhận ra rằng một project cloud không chỉ cần deploy được, mà còn phải giải thích được vì sao kiến trúc đó có giá trị, hệ thống xử lý input gì, output là gì, lỗi được xử lý ra sao và người vận hành kiểm tra bằng chứng như thế nào.

Một số workshop có thể chưa được cập nhật hoàn toàn theo version mới nhất của AWS hoặc tool liên quan. Tuy nhiên, em xem đây cũng là một phần của quá trình học thực tế, vì trong môi trường làm việc thật, tài liệu, giao diện dịch vụ cloud và best practices có thể thay đổi. Việc tự tìm hiểu, đối chiếu tài liệu chính thức và fix lỗi giúp em hiểu sâu hơn thay vì chỉ làm theo hướng dẫn một cách máy móc.

## 4. Sự phù hợp giữa công việc và chuyên ngành học

Công việc và nội dung thực tập phù hợp với chuyên ngành Công nghệ thông tin mà em đang học. Những kiến thức nền tảng ở trường như mạng máy tính, cơ sở dữ liệu, lập trình backend, frontend và quy trình phát triển phần mềm đều được áp dụng vào các bài workshop và project.

Ngoài ra, kỳ thực tập giúp em mở rộng sang nhiều mảng mà trước đây em chỉ mới biết ở mức lý thuyết hoặc chưa có cơ hội thực hành sâu.

**Cloud Computing và DevOps:** Trước đây em chỉ biết cloud computing ở mức khái niệm. Sau kỳ thực tập, em đã có cơ hội triển khai hạ tầng thật trên AWS, làm việc với VPC, subnet, route table, security group, IAM, EC2, RDS, S3, CloudWatch và các dịch vụ liên quan. Em cũng hiểu hơn về cách quản lý hạ tầng bằng Terraform thay vì thao tác thủ công hoàn toàn trên AWS Console.

**Infrastructure as Code và Policy as Code:** Qua project cá nhân, em học được cách viết Terraform để tạo hạ tầng có thể tái sử dụng, kiểm soát thay đổi bằng `terraform plan`, và dùng OPA/Rego để kiểm tra policy trước khi deploy. Đây là kiến thức rất thực tế vì giúp giảm rủi ro cấu hình sai, đặc biệt với các hệ thống yêu cầu bảo mật như workload nội bộ hoặc hệ thống xử lý dữ liệu nhạy cảm.

**Kiến trúc hệ thống và message queue:** Em hiểu rõ hơn vai trò của message queue trong việc tách rời producer và worker. Trong project, EventBridge Scheduler tạo job định kỳ, SQS lưu job, EC2 Private Worker poll job để xử lý, DLQ giữ failed messages và CloudWatch/SNS gửi cảnh báo khi có lỗi. Luồng này giúp em hiểu cách thiết kế hệ thống bất đồng bộ, có khả năng retry, failure handling và monitoring rõ ràng.

**Kiểm soát triển khai:** Em học được tư duy kiểm soát triển khai theo từng bước: chuẩn bị môi trường, viết code hạ tầng, chạy `terraform validate`, tạo plan, kiểm tra policy, apply, validate kết quả và cleanup. Quy trình này giúp em hiểu rằng deploy hệ thống cloud cần có kiểm soát, không chỉ chạy lệnh để tạo service.

## 5. Cơ hội học hỏi và phát triển kỹ năng

Trong quá trình thực tập, em học được nhiều kỹ năng kỹ thuật và kỹ năng mềm.

### Kỹ năng kỹ thuật

- AWS services: EC2, VPC, RDS, S3, IAM, CloudWatch, CloudTrail, AWS Config, SQS, SNS, EventBridge Scheduler, KMS, Systems Manager.
- DevOps: Terraform, Infrastructure as Code, policy validation, deployment workflow, cleanup để tránh phát sinh chi phí.
- Security: private subnet, security group, no public IP, no SSH inbound, SSM Session Manager, IAM least privilege, KMS encryption, VPC Endpoints.
- Database: PostgreSQL trên Amazon RDS, private database tier, encryption, subnet group và security group access control.
- Monitoring và audit: CloudWatch Alarm, SNS Email, VPC Flow Logs, CloudTrail, AWS Config và evidence collection.
- Troubleshooting: đọc lỗi AWS CLI, Terraform, IAM AccessDenied, SSO token expired, stale Terraform plan, sai cú pháp giữa PowerShell và Linux shell.

Đặc biệt, em nhận ra rằng khả năng debug là một phần rất quan trọng khi làm cloud. Có những lỗi không đến từ code ứng dụng mà đến từ IAM permission, network path, endpoint, region, profile hoặc sự khác nhau giữa lệnh PowerShell và Linux shell. Việc tự sửa các lỗi này giúp em hiểu hệ thống sâu hơn.

### Kỹ năng mềm

- Làm việc nhóm: biết cách phối hợp với các thành viên, chia task, trao đổi khi gặp lỗi và tiếp nhận góp ý.
- Giao tiếp kỹ thuật: biết cách giải thích project, trình bày kiến trúc, mô tả business flow và viết báo cáo.
- Tự học: biết cách đọc tài liệu, tra lỗi, thử nghiệm, kiểm chứng và ghi lại evidence.
- Quản lý thời gian: biết chia nhỏ project thành từng giai đoạn, ưu tiên phần quan trọng trước và cleanup tài nguyên sau khi hoàn thành.
- Tư duy phản biện: biết đặt câu hỏi “hệ thống này dùng để làm gì?”, “input là gì?”, “output là gì?”, “khi lỗi thì xử lý ra sao?”, “bằng chứng vận hành nằm ở đâu?”.

Những kỹ năng này giúp em tự tin hơn khi tiếp cận các project cloud hoặc DevOps sau này.

## 6. Văn hóa và tinh thần đồng đội

Văn hóa làm việc tại FCJ tích cực và có tinh thần hỗ trợ lẫn nhau. Khi có thành viên gặp khó khăn, mọi người sẵn sàng giải thích, chia sẻ tài liệu hoặc gợi ý cách tiếp cận vấn đề. Điều này rất có ý nghĩa với em vì nền tảng cloud computing của em trước kỳ thực tập chưa thật sự vững.

Em cũng học được rằng trong môi trường kỹ thuật, việc đặt câu hỏi đúng rất quan trọng. Ban đầu em còn ngại hỏi vì sợ câu hỏi cơ bản, nhưng sau đó em nhận ra rằng nếu không hỏi sớm thì có thể hiểu sai yêu cầu hoặc đi sai hướng. Đây là bài học quan trọng trong giao tiếp khi làm việc nhóm.

## 7. Chính sách và phúc lợi cho thực tập sinh

Công ty tạo điều kiện tốt cho thực tập sinh thông qua workshop, tài liệu hướng dẫn, mentor hỗ trợ và timeline thực hành rõ ràng. Việc được tiếp cận workshop AWS theo từng chủ đề giúp em có lộ trình học cụ thể hơn, thay vì tự học rời rạc.

Một điểm em đánh giá cao là chương trình không chỉ dừng ở việc học service riêng lẻ, mà còn khuyến khích thực tập sinh làm project có kiến trúc, có proposal, có triển khai, có evidence và có báo cáo. Điều này giúp em hiểu quy trình làm một sản phẩm kỹ thuật hoàn chỉnh hơn.

Nếu có thể mở rộng thêm trong tương lai, em mong chương trình có thêm một số workshop nâng cao như Kubernetes, AWS Lambda, Amazon Bedrock, CI/CD nâng cao, security automation hoặc cost optimization chuyên sâu. Ngoài ra, các buổi tech talk hoặc sharing session từ các anh chị có kinh nghiệm thực tế cũng sẽ rất hữu ích cho thực tập sinh.

## 8. Điều em hài lòng nhất trong thời gian thực tập

Điều em hài lòng nhất là sự tiến bộ rõ rệt về kỹ năng và tư duy kỹ thuật. Ban đầu, em chưa tự tin vì mỗi công nghệ chỉ biết một ít và chưa từng triển khai một hệ thống cloud hoàn chỉnh. Sau kỳ thực tập, em có thể tự tay xây dựng một project từ kiến trúc, Terraform code, policy validation, triển khai AWS services, kiểm thử business flow, tạo evidence và viết báo cáo.

Project **Private-by-Default AWS Workload Platform** giúp em hiểu rằng một hệ thống cloud tốt không chỉ cần chạy được, mà còn cần bảo mật, dễ kiểm tra, có cảnh báo khi lỗi, có log/audit trail và có kế hoạch cleanup để tránh phát sinh chi phí. Đây là thay đổi lớn trong cách em nhìn nhận một project kỹ thuật.

## 9. Điều em nghĩ có thể cải thiện cho thực tập sinh sau

Nhìn chung, chương trình thực tập đã được tổ chức tốt và đáp ứng được nhu cầu học hỏi của thực tập sinh. Tuy nhiên, em có một góp ý nhỏ về việc quản lý thông báo trên các kênh trao đổi.

Trong quá trình thực tập, có một số thời điểm thông báo giữa các nhóm hoặc các kênh chưa được đồng bộ hoàn toàn, khiến em hơi hoang mang về deadline, yêu cầu hoặc thay đổi liên quan đến chương trình. Một phần nguyên nhân cũng đến từ bản thân em vì chưa đọc kỹ toàn bộ nội dung trước khi bắt đầu và còn ngại đặt câu hỏi với admin, master hoặc mentor khi chưa rõ.

Vì vậy, em đề xuất có thể ghim các thông báo quan trọng và mới nhất lên đầu kênh chat của chương trình. Các thông tin như deadline, meeting schedule, yêu cầu nộp bài, thay đổi format báo cáo hoặc checklist quan trọng nên được gom lại ở một nơi cố định. Điều này sẽ giúp thực tập sinh dễ theo dõi hơn và hạn chế việc thông tin bị trôi trong các cuộc thảo luận hằng ngày.

## 10. Nếu giới thiệu cho bạn bè, em có khuyên họ thực tập tại FCJ không?

Có. Em sẽ khuyên bạn bè tham gia chương trình thực tập tại FCJ vì đây là môi trường tốt để học kỹ năng thực tế, đặc biệt với những bạn muốn tiếp cận AWS, Cloud Computing, DevOps và cách triển khai hệ thống thật.

Lý do chính là chương trình giúp thực tập sinh học được kiến thức thực tế thay vì chỉ dừng ở lý thuyết, được thực hành với AWS services và quy trình triển khai thật, có mentor/admin/team hỗ trợ khi gặp khó khăn, có cơ hội làm project end-to-end từ thiết kế đến báo cáo, và xây dựng được nền tảng cloud vững hơn để áp dụng vào các project khác.

Tuy nhiên, em cũng sẽ nhắc các bạn rằng cần chủ động học hỏi, đọc kỹ tài liệu, ghi chú lỗi gặp phải và không ngại hỏi khi chưa hiểu. Chương trình có nhiều nội dung mới, nên nếu không chủ động thì rất dễ bị quá tải hoặc hiểu sai yêu cầu.

## 11. Đề xuất và mong muốn

Hiện tại, em không có đề xuất lớn cần thay đổi. Theo trải nghiệm cá nhân của em, chương trình FCJ đã được tổ chức khá đầy đủ và hợp lý. Có workshop theo lộ trình, có mentor hỗ trợ, có tài liệu hướng dẫn, có checklist và có cơ hội thực hành trên bài toán thực tế.

Trong tương lai, em mong có thêm cơ hội tiếp tục làm việc với các project phức tạp hơn, học sâu hơn về AWS architecture, security, DevOps và automation, tham gia các buổi sharing hoặc tech talk chuyên sâu, đóng góp vào việc cải thiện workshop hoặc hỗ trợ các bạn intern sau, và xây dựng network với các anh chị mentor, admin cũng như các bạn cùng định hướng cloud.

## 12. Lời cảm ơn

Em rất biết ơn FCJ đã tạo cơ hội để em học hỏi và phát triển trong kỳ thực tập. Những kiến thức và kinh nghiệm em nhận được trong thời gian này là hành trang quan trọng cho quá trình học tập và định hướng nghề nghiệp sau này.

Em cảm ơn team FCJ, mentor, admin và các bạn trong nhóm đã đồng hành, hỗ trợ và góp ý trong suốt thời gian thực tập. Đây là một trải nghiệm có giá trị với em, không chỉ về mặt kỹ thuật mà còn về cách làm việc, cách giao tiếp và cách hoàn thiện một project thực tế.

Những chia sẻ trên là đánh giá chân thực dựa trên trải nghiệm cá nhân của em trong quá trình thực tập.
