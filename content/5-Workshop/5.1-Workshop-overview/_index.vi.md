---
title: "Tổng quan Workshop"
date: 2026-07-04
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---


## Chúng ta đang xây dựng gì?

Trong workshop này, chúng ta triển khai hoàn chỉnh một **Nền tảng Xử lý Tác vụ Nội bộ An toàn trên AWS (Secure Internal Job Processing Platform on AWS)**.

Đây không phải là một ứng dụng web công khai và cũng không có giao diện người dùng (UI) dành cho khách hàng. Dự án mô phỏng một nền tảng hạ tầng backend mà doanh nghiệp có thể sử dụng để xử lý các tác vụ dữ liệu nội bộ nhạy cảm như:

- Kiểm tra và xác thực file CSV khách hàng
- Kiểm tra batch giao dịch
- Tạo bằng chứng phục vụ kiểm toán (audit evidence)
- Xử lý tác vụ tuân thủ định kỳ
- Các workload dữ liệu nội bộ khác

Đối với các lập trình viên web, có thể hình dung hệ thống này theo cách tương đương sau:

| Khái niệm trong ứng dụng Web | Thành phần tương ứng trong dự án |
|---|---|
| Người dùng gửi form | Một business job được gửi vào SQS |
| HTTP API Endpoint | SQS Processing Queue |
| Backend Service | EC2 Private Worker |
| Cron Job / Background Job | EventBridge Scheduler |
| Database ứng dụng | Amazon RDS PostgreSQL |
| Xử lý lỗi | SQS Dead Letter Queue |
| Thông báo quản trị | CloudWatch Alarm + SNS Email |
| Application Logs | CloudWatch Logs |
| Security Guardrails | OPA/Rego, IAM, Security Groups, VPC Endpoints |
| Audit Trail | CloudTrail, AWS Config, VPC Flow Logs, S3 Evidence Bucket |

Luồng nghiệp vụ chính của hệ thống:

```text
Business Job hoặc Scheduled Task
→ EventBridge Scheduler hoặc gửi thủ công vào SQS
→ Amazon SQS Processing Queue
→ EC2 Private Worker trong Private Subnet
→ Xử lý dữ liệu và ghi kết quả vào Amazon RDS PostgreSQL
→ CloudWatch Logs, DLQ và SNS Email nếu xảy ra lỗi
```

Ý tưởng bảo mật cốt lõi của kiến trúc là **Private-by-Default**.

Worker và Database không được công khai ra Internet.

Hệ thống không sử dụng:

- Public SSH
- Public Database Endpoint
- Public Application URL

Toàn bộ việc quản trị EC2 được thực hiện thông qua AWS Systems Manager Session Manager.

![Final architecture diagram](/images/5-Workshop/private-by-default/00-final-architecture-diagram.png)

{{% notice info %}}
Trong Terraform code và tên các tài nguyên AWS có thể vẫn xuất hiện các tiền tố như `mvp` hoặc `stage1` vì đây là các định danh môi trường kỹ thuật được sử dụng trong quá trình triển khai.

Tên chính thức của dự án trong báo cáo là:

**Private-by-Default AWS Workload Platform**
{{% /notice %}}

## Bài toán thực tế mà dự án giải quyết

Nhiều doanh nghiệp hiện nay cần xử lý dữ liệu nội bộ nhạy cảm nhưng vẫn muốn tận dụng lợi ích của điện toán đám mây.

Ví dụ:

- Ngân hàng xử lý batch giao dịch
- Công ty bảo hiểm xác thực hồ sơ khách hàng
- Bệnh viện xử lý dữ liệu bệnh án
- Doanh nghiệp logistics xử lý dữ liệu vận chuyển

Trong các trường hợp này, việc đặt Worker hoặc Database công khai trên Internet làm tăng đáng kể bề mặt tấn công và rủi ro bảo mật.

Dự án này giải quyết bài toán đó bằng cách:

- Đặt Worker trong Private Subnet
- Đặt PostgreSQL trong Private Subnet
- Sử dụng VPC Endpoints thay cho Internet Gateway
- Sử dụng Session Manager thay cho SSH
- Mã hóa dữ liệu bằng AWS KMS
- Áp dụng nguyên tắc Least Privilege thông qua IAM
- Giám sát bằng CloudWatch
- Ghi nhận audit evidence bằng CloudTrail và AWS Config
- Kiểm soát thay đổi hạ tầng bằng Terraform và OPA/Rego

Kiến trúc này cho phép xử lý dữ liệu nội bộ trong môi trường mạng riêng nhưng vẫn duy trì khả năng quan sát (observability), khả năng kiểm toán (auditability) và khả năng vận hành (operability).

## Luồng dữ liệu đầu vào (Input)

Dữ liệu đầu vào của hệ thống là các business processing jobs.

Ví dụ:

- Validate dữ liệu CSV
- Kiểm tra batch giao dịch
- Xử lý tác vụ compliance
- Tạo audit evidence
- Đồng bộ dữ liệu nội bộ

Trong môi trường demo của workshop, dữ liệu đầu vào được tạo theo hai cách:

### Cách 1: Gửi thủ công vào SQS

Người vận hành gửi message trực tiếp vào Amazon SQS Processing Queue.

```text
Operator
→ Amazon SQS
→ Worker
```

### Cách 2: EventBridge Scheduler

EventBridge Scheduler định kỳ tạo message và gửi vào SQS.

```text
EventBridge Scheduler
→ Amazon SQS
→ Worker
```

Trong môi trường thực tế, dữ liệu đầu vào có thể đến từ:

- Internal APIs
- ERP Systems
- CRM Systems
- Batch Files
- Data Pipelines
- Event-driven Applications

## Luồng xử lý (Processing)

Sau khi nhận được message từ SQS:

1. Worker poll message từ Processing Queue
2. Worker xử lý business logic
3. Worker ghi log vào CloudWatch Logs
4. Worker ghi kết quả vào PostgreSQL
5. Worker xác nhận hoàn thành message

Nếu quá trình xử lý thất bại:

1. Message được retry
2. Sau khi vượt ngưỡng retry
3. Message được chuyển sang Dead Letter Queue (DLQ)
4. CloudWatch Alarm được kích hoạt
5. SNS gửi email cảnh báo

Luồng lỗi:

```text
SQS Processing Queue
→ Worker Failure
→ Retry
→ Dead Letter Queue
→ CloudWatch Alarm
→ SNS Email Notification
```

## Luồng đầu ra (Output)

Sau khi xử lý thành công:

### Kết quả nghiệp vụ

Kết quả được lưu vào:

- Amazon RDS PostgreSQL

### Dữ liệu giám sát

Logs và metrics được lưu trong:

- Amazon CloudWatch Logs
- Amazon CloudWatch Metrics

### Dữ liệu kiểm toán

Audit evidence được lưu thông qua:

- AWS CloudTrail
- AWS Config
- VPC Flow Logs
- S3 Evidence Bucket

### Cảnh báo vận hành

Khi có lỗi hoặc bất thường:

- CloudWatch Alarm được kích hoạt
- SNS gửi email cho người vận hành

## Các thành phần bảo mật chính

Kiến trúc này sử dụng nhiều lớp bảo vệ khác nhau:

### Network Isolation

- VPC riêng biệt
- Private Subnets
- Security Groups
- VPC Endpoints

### Identity and Access Management

- IAM Roles
- IAM Policies
- Least Privilege Access

### Encryption

- AWS KMS
- Encryption at Rest
- Encryption in Transit

### Secure Administration

- AWS Systems Manager Session Manager
- Không sử dụng SSH Public Access

### Audit and Compliance

- CloudTrail
- AWS Config
- VPC Flow Logs

### Policy as Code

- Terraform
- OPA/Rego Policy Validation

## Kết quả cuối cùng

Sau khi hoàn thành workshop, người thực hiện sẽ có một hệ thống AWS đang hoạt động và chứng minh được các yêu cầu sau:

1. Terraform triển khai toàn bộ hạ tầng AWS từ đầu đến cuối.
2. OPA/Rego kiểm tra Terraform Plan trước khi triển khai.
3. Amazon SQS nhận và lưu business jobs.
4. EC2 Private Worker nhận và xử lý jobs từ SQS.
5. Worker và PostgreSQL không bị public ra Internet.
6. Các tác vụ lỗi được cô lập trong Dead Letter Queue.
7. CloudWatch Alarm có thể gửi SNS Email Notification.
8. Audit evidence được tạo và lưu trữ.
9. Hệ thống có thể được dọn dẹp hoàn toàn để tránh phát sinh chi phí AWS không cần thiết.

## Vai trò của phần Evidence

Các ảnh chụp màn hình trong mục 5.6 đóng vai trò là bằng chứng triển khai và vận hành.

Mục tiêu chính của workshop không phải là trình diễn giao diện AWS Console mà là chứng minh:

- Hạ tầng đã được triển khai thành công
- Luồng nghiệp vụ hoạt động đúng
- Cơ chế bảo mật được áp dụng
- Cảnh báo được gửi thành công
- Audit evidence được tạo ra

Do đó workshop tập trung vào:

1. Chuẩn bị môi trường
2. Sinh source code
3. Triển khai hạ tầng
4. Kiểm tra luồng nghiệp vụ
5. Thu thập bằng chứng
6. Tối ưu chi phí
7. Dọn dẹp tài nguyên AWS

để người đọc có thể tái tạo toàn bộ hệ thống một cách nhanh chóng và chính xác.