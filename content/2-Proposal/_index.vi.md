---
title: "Project proposal"
date: 2026-07-04
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# Private-by-Default AWS Workload Platform
## Nền tảng xử lý job dữ liệu nội bộ an toàn trên AWS


## 1. Tóm tắt điều hành

**Private-by-Default AWS Workload Platform** là một kiến trúc tham chiếu trên AWS dành cho các doanh nghiệp cần xử lý dữ liệu nội bộ nhạy cảm trong môi trường mạng riêng. Hệ thống không expose worker hoặc database trực tiếp ra Internet, không dùng SSH public và không yêu cầu public application URL.

Project mô phỏng một nền tảng xử lý job dữ liệu cho các bối cảnh như ngân hàng, bảo hiểm, y tế, logistics hoặc audit/compliance. Đây là các hệ thống thường có nhu cầu xử lý batch job, validate dữ liệu, tạo bằng chứng audit hoặc chạy tác vụ định kỳ nhưng vẫn phải đảm bảo network isolation, encryption, monitoring, alerting và audit evidence.

Input của hệ thống là **business processing jobs**, ví dụ job kiểm tra batch giao dịch, validate dữ liệu khách hàng, xử lý file CSV định kỳ hoặc tạo bằng chứng audit. Trong môi trường workshop, input có thể được tạo thủ công bằng cách gửi message vào Amazon SQS. Trong môi trường doanh nghiệp thực tế, input có thể được tạo tự động từ hệ thống nội bộ hoặc EventBridge Scheduler.

Luồng chính của hệ thống:

~~~text
EventBridge Scheduler / Internal Producer
→ Amazon SQS Processing Queue
→ EC2 Private Worker in private subnet
→ Amazon RDS PostgreSQL and processing evidence
→ CloudWatch Logs / Metrics
~~~

Luồng lỗi và cảnh báo:

~~~text
Failed Job Message
→ SQS Dead Letter Queue
→ CloudWatch Alarm
→ SNS Topic
→ Operator Email
~~~

Trong phạm vi workshop, hệ thống triển khai một EC2 Private Worker để tối ưu chi phí. Kiến trúc vẫn có thể mở rộng lên nhiều worker vì SQS cho phép nhiều consumer xử lý job song song.

## 2. Tuyên bố vấn đề

Không phải mọi workload doanh nghiệp đều là public web application. Nhiều hệ thống quan trọng là worker nội bộ, batch job, data processing job hoặc audit job. Khi triển khai nhanh trên cloud, các lỗi thường gặp là EC2 có public IPv4 không cần thiết, database có nguy cơ public access, SSH/RDP được mở từ Internet, secret được lưu chưa đúng cách, thiếu log/audit evidence và không có policy gate để chặn cấu hình hạ tầng không an toàn trước khi deploy.

Vấn đề chính của project không chỉ là “làm sao chạy được worker”, mà là:

~~~text
Làm sao đảm bảo worker chạy private-by-default,
database không public,
quản trị không cần SSH,
dữ liệu được mã hóa,
job lỗi được đưa vào DLQ,
operator nhận được cảnh báo,
và sau khi deploy có evidence để review.
~~~

## 3. Giải pháp đề xuất

Giải pháp sử dụng Terraform để triển khai một private workload platform trên AWS. Terraform tạo VPC riêng, private subnets, security groups, VPC Endpoints, EC2 Private Worker, SQS Processing Queue, Dead Letter Queue, EventBridge Scheduler, RDS PostgreSQL private database tier, KMS encryption, CloudWatch Alarms, SNS Email, CloudTrail, AWS Config, VPC Flow Logs và S3 Evidence Bucket.

Trước khi apply hạ tầng, Terraform plan được export sang JSON và kiểm tra bằng OPA/Rego. Policy gate có nhiệm vụ chặn các cấu hình không phù hợp như EC2 public IP, SSH key pair, public RDS, RDS không mã hóa, thiếu KMS hoặc route public không mong muốn.

Điểm quan trọng là DLQ không gửi email trực tiếp. CloudWatch Alarm theo dõi metric của DLQ, ví dụ `ApproximateNumberOfMessagesVisible`. Khi DLQ có message hoặc alarm được test thủ công, CloudWatch chuyển sang trạng thái ALARM và kích hoạt SNS gửi email cho operator.

## 4. Kiến trúc giải pháp

Kiến trúc được chia thành bốn lớp chính.

**Deployment Control Plane** nằm ngoài workload boundary. Developer sử dụng VS Code, AWS CLI SSO profile, Terraform và OPA/Rego để tạo plan, kiểm tra policy và deploy hạ tầng.

**Private Workload Plane** nằm trong VPC riêng. EC2 Worker chạy trong private app subnet, không có public IP, không dùng SSH key pair và không cần Bastion Host. Worker truy cập AWS services thông qua VPC Endpoints/PrivateLink.

**Data and Messaging Plane** gồm Amazon SQS, Dead Letter Queue và Amazon RDS PostgreSQL. SQS tách producer và consumer để workload xử lý bất đồng bộ. DLQ giữ failed messages để điều tra hoặc redrive. RDS PostgreSQL là private database tier, tắt public access và bật encryption.

**Operations and Evidence Plane** gồm CloudWatch, SNS, CloudTrail, AWS Config, VPC Flow Logs và S3 Evidence Bucket. Lớp này cung cấp monitoring, alerting và audit evidence sau triển khai.

## 5. Dịch vụ AWS sử dụng

| Dịch vụ | Vai trò trong kiến trúc |
|---|---|
| Amazon VPC | Mạng riêng cho workload. |
| Private Subnets | Chạy EC2 Worker và RDS không expose Internet. |
| Security Groups | Giới hạn luồng mạng cần thiết, không mở SSH/RDP public. |
| VPC Endpoints / PrivateLink | Cho EC2 private gọi AWS APIs mà không cần NAT Gateway. |
| Amazon EC2 | Private Worker xử lý job từ SQS. |
| Amazon SQS | Hàng đợi nhận business processing jobs. |
| SQS Dead Letter Queue | Lưu message lỗi sau nhiều lần xử lý thất bại. |
| EventBridge Scheduler | Tạo job định kỳ và gửi vào SQS. |
| Amazon RDS PostgreSQL | Private database tier cho dữ liệu/kết quả xử lý. |
| AWS Systems Manager Session Manager | Quản trị EC2 private không cần SSH. |
| AWS KMS | Mã hóa RDS, EBS, S3, CloudWatch Logs và SSM SecureString. |
| SSM Parameter Store | Lưu database password dạng SecureString. |
| Amazon CloudWatch | Metrics, alarms và operational evidence. |
| Amazon SNS | Gửi email cảnh báo khi Alarm kích hoạt. |
| AWS CloudTrail | Ghi audit trail cho AWS API activity. |
| AWS Config | Ghi nhận trạng thái cấu hình tài nguyên. |
| VPC Flow Logs | Ghi metadata traffic trong VPC. |
| Amazon S3 | Lưu log/evidence bucket. |
| Terraform | Infrastructure as Code. |
| OPA/Rego | Policy-as-Code gate trước khi deploy. |

## 6. Lý do không chọn Lambda + Serverless làm hướng chính

Lambda và serverless phù hợp với các tác vụ ngắn, stateless, event-driven và cần scale nhanh theo request. Tuy nhiên, workload trong project này mô phỏng các job dữ liệu nội bộ có thể chạy lâu hơn, cần kiểm soát runtime, dependency, network path và cách quản trị private.

EC2 Private Worker kết hợp SQS phù hợp hơn với mục tiêu project vì nó thể hiện rõ private compute trong VPC, chứng minh quản trị EC2 không cần SSH nhờ Session Manager, cho phép kiểm soát OS/runtime/dependency tốt hơn và làm rõ các infrastructure controls như security group, IMDSv2, encrypted EBS, VPC Endpoint và IAM role.

Serverless vẫn có thể là hướng mở rộng sau này cho các tác vụ ngắn hoặc API edge layer. Project này ưu tiên chứng minh private-by-default infrastructure và workload processing path trước.

## 7. Thiết kế bảo mật

Project áp dụng các kiểm soát bảo mật sau:

- EC2 Worker không có public IPv4.
- Không dùng SSH key pair và không mở SSH/RDP từ Internet.
- Quản trị EC2 qua AWS Systems Manager Session Manager.
- RDS PostgreSQL tắt public access và nằm trong private DB subnets.
- RDS, EBS, S3, SSM SecureString và CloudWatch Logs được mã hóa bằng KMS.
- Worker gọi AWS APIs qua VPC Endpoints.
- IAM role dùng theo nguyên tắc least privilege.
- OPA/Rego policy gate kiểm tra Terraform plan trước khi apply.
- CloudTrail, AWS Config và VPC Flow Logs tạo audit evidence sau triển khai.

## 8. Ước tính ngân sách chạy 24/7 trong 1 tháng

Ước tính dưới đây dùng giả định chạy **24/7 trong 730 giờ/tháng**, region **US East (N. Virginia)**, cấu hình workshop mặc định, traffic thấp, không tính thuế và không phụ thuộc vào Free Tier. Đây là câu trả lời cho câu hỏi thực tế: nếu hệ thống chạy liên tục một tháng thì khoảng bao nhiêu tiền.

| Thành phần | Giả định | Ước tính/tháng |
|---|---:|---:|
| EC2 Private Worker | 1 × t3.micro Linux, 730 giờ | ~7.6 USD |
| EC2 EBS root volume | 8 GB | ~0.7 USD |
| RDS PostgreSQL | 1 × db.t3.micro Single-AZ, 730 giờ | ~12.5 USD |
| RDS storage | 20 GB general purpose SSD | ~2.3 USD |
| VPC Interface Endpoints | 8 endpoints × 1 AZ × 730 giờ × ~0.01 USD/giờ | ~58.4 USD |
| AWS KMS | 2 customer-managed keys | ~2.0 USD |
| CloudWatch | Alarms, small logs, default metrics | ~1–3 USD |
| SQS, SNS, EventBridge Scheduler | Low-traffic workload | <1 USD |
| S3 Evidence Bucket + CloudTrail logs | Small storage volume | <1 USD |
| AWS Config | Small number of resources and changes | ~1–3 USD |

**Tổng ước tính cho cấu hình tối ưu chi phí:** khoảng **85–95 USD/tháng** nếu giữ hạ tầng chạy 24/7.

Nếu bật **RDS Multi-AZ** để khớp hoàn toàn với database tier primary/standby trong diagram, chi phí database sẽ tăng. Khi đó tổng chi phí nên được ước tính khoảng **105–125 USD/tháng**, tùy instance class, storage, backup, log volume và số lượng endpoint thực tế.

Trong workshop triển khai thực tế, chi phí phát sinh thấp hơn nhiều vì hạ tầng chỉ được tạo tạm thời, kiểm thử, thu thập evidence và cleanup bằng Terraform. Billing dashboard thực tế có thể chỉ forecast vài USD nếu người triển khai destroy tài nguyên sau khi hoàn thành.

## 9. Giá trị mang lại

Với chi phí ước tính khoảng **85–95 USD/tháng** cho một pilot chạy 24/7, nền tảng này không chỉ là một demo hạ tầng. Nó tạo ra một baseline có thể tái sử dụng cho nhiều workload nội bộ cần xử lý dữ liệu nhạy cảm trong môi trường private.

Giá trị chính gồm:

- Giảm rủi ro public exposure cho worker và database.
- Chuẩn hóa cách deploy internal worker bằng Infrastructure as Code.
- Chặn cấu hình hạ tầng không an toàn bằng Policy as Code trước khi apply.
- Có failure handling rõ ràng qua SQS DLQ.
- Có alerting qua CloudWatch Alarm và SNS Email.
- Có audit evidence qua CloudTrail, AWS Config, VPC Flow Logs và S3.
- Có thể tái sử dụng làm baseline cho nhiều job xử lý dữ liệu nội bộ khác.

Đối với các team xử lý dữ liệu nhạy cảm, chi phí này có thể được xem như chi phí nền tảng để giảm rủi ro vận hành, tăng audit readiness và rút ngắn thời gian triển khai các workload nội bộ mới. So với rủi ro cấu hình public sai, thiếu bằng chứng audit hoặc không phát hiện job lỗi, mức chi phí này là hợp lý cho một secure internal workload platform quy mô pilot.

## 10. Rủi ro và hướng giảm thiểu

| Rủi ro | Ảnh hưởng | Hướng giảm thiểu |
|---|---|---|
| Quên cleanup tài nguyên | Phát sinh chi phí | Bắt buộc chạy `terraform destroy` sau khi lấy evidence. |
| SSO token hết hạn | Không chạy được AWS CLI/Terraform | Dùng `aws sso login --profile mvp --no-browser`. |
| IAM thiếu quyền | Terraform apply lỗi AccessDenied | Dùng permission set riêng cho Terraform operator. |
| Người review không hiểu vì không có UI | Hiểu nhầm là chỉ dựng AWS services | Workshop giải thích rõ đây là internal backend job-processing platform. |
| RDS Single-AZ trong workshop | Không khớp hoàn toàn HA diagram | Giải thích đây là cost-optimized path; Multi-AZ là optional. |

## 11. Kết quả kỳ vọng

Sau khi hoàn thành project, người triển khai có thể chứng minh một workload AWS có input, processing, output, failure handling, alerting, security control, audit evidence và cleanup plan rõ ràng. Kết quả không chỉ là một tập hợp AWS services, mà là một nền tảng xử lý job nội bộ có thể triển khai lại, kiểm tra lại và mở rộng cho các tình huống doanh nghiệp cần private-by-default.
