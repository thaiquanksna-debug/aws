---
title: "Bảo mật, tối ưu chi phí và cleanup"
date: 2026-07-04
weight: 7
chapter: false
pre: " <b> 5.7. </b> "
---

# Security controls đã triển khai

~~~text
No public EC2 IP
No SSH key pair
No public SSH/RDP ingress
SSM Session Manager for administration
Private RDS PostgreSQL
RDS storage encrypted with KMS
EC2 root EBS encrypted with KMS
S3 evidence bucket encrypted
VPC Endpoints for private AWS service access
SQS Processing Queue and DLQ
CloudWatch Alarm to SNS Email
CloudTrail, AWS Config, VPC Flow Logs
OPA/Rego gate before Terraform apply
~~~

# Cost controls

~~~text
Default cost path: Single-AZ RDS; optional diagram-aligned path: Multi-AZ primary/standby
One EC2 worker for demo instead of autoscaling fleet
No NAT Gateway
No public load balancer
Short CloudWatch log retention
Terraform destroy after evidence is captured
~~~

Các phần dễ phát sinh phí là RDS, EC2, VPC Interface Endpoints, KMS, CloudWatch Alarms và S3. Không để môi trường chạy sau khi đã chụp đủ ảnh báo cáo.

Ước tính nhanh nếu giữ cấu hình mặc định chạy 24/7 trong 1 tháng tại `us-east-1`: khoảng **85–95 USD/tháng**. Nếu bật RDS Multi-AZ để khớp primary/standby database tier trong diagram, nên dự trù khoảng **105–125 USD/tháng**. Con số này không tính thuế, không dựa vào Free Tier và cần kiểm tra lại bằng AWS Pricing Calculator trước khi vận hành thật.

# Optional: bật RDS Multi-AZ để khớp database tier trong diagram

Diagram có 2 biểu tượng RDS. Cách diễn giải đúng là **RDS PostgreSQL primary/standby** trong private DB subnets. Đường workshop mặc định vẫn dùng cấu hình tiết kiệm chi phí. Chỉ làm bước này khi cần database tier khớp hoàn toàn với diagram hoặc muốn mô phỏng production HA.

Chạy trong Windows PowerShell:

~~~powershell
cd D:\mvp_private_by_default_architecture
code infra\modules\database\main.tf
~~~

Trong file `infra\modules\database\main.tf`, tìm dòng:

~~~hcl
multi_az = false
~~~

Đổi thành:

~~~hcl
multi_az = true
~~~

Sau đó mở file OPA:

~~~powershell
code policy\terraform\database_invariants.rego
~~~

Tìm rule đang chặn Multi-AZ để tiết kiệm chi phí:

~~~rego
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_db_instance"
  after := rc.change.after
  after.multi_az == true
  msg := sprintf("Stage 1 uses Single-AZ RDS for cost control: %s", [rc.address])
}
~~~

Thay bằng rule bắt buộc Multi-AZ cho kiến trúc primary/standby:

~~~rego
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_db_instance"
  after := rc.change.after
  after.multi_az != true
  msg := sprintf("RDS instance must use Multi-AZ for primary/standby HA: %s", [rc.address])
}
~~~

Deploy lại:

~~~powershell
cd D:\mvp_private_by_default_architecture\infra\envs\mvp
terraform fmt -recursive
terraform validate
terraform plan -out tfplan.binary
terraform show -json tfplan.binary > tfplan.json
opa eval -f pretty -d ..\..\..\policy\terraform -i tfplan.json "data.terraform.deny"
terraform apply tfplan.binary
~~~

Kết quả đúng của OPA vẫn phải là:

~~~text
[]
~~~

Lưu ý chi phí: Multi-AZ RDS đắt hơn Single-AZ và thời gian tạo/cập nhật lâu hơn. Nếu chỉ cần demo nhanh, giữ Single-AZ là đủ. Nếu cần proposal/diagram thể hiện HA rõ hơn, bật Multi-AZ.


# Cleanup

Chạy trong Windows PowerShell:

~~~powershell
cd D:\mvp_private_by_default_architecture
aws sso login --profile mvp --no-browser
cd D:\mvp_private_by_default_architecture\infra\envs\mvp
terraform plan -destroy -out destroy.binary
terraform apply destroy.binary
~~~

Khi Terraform hỏi confirm, gõ:

~~~text
yes
~~~

Kết quả đúng:

~~~text
Destroy complete!
~~~

# Kiểm tra sau cleanup

Mở AWS Console và kiểm tra EC2 worker, RDS database, SQS queues, VPC Endpoints, SNS topic, EventBridge schedule và CloudWatch Alarm đã được xóa. KMS keys có thể vẫn ở trạng thái scheduled deletion trong deletion window đã cấu hình.
# Kết luận chương Workshop

Phần Workshop đã trình bày toàn bộ vòng đời triển khai của nền tảng Private-by-Default AWS Workload Platform.

Quá trình triển khai bao gồm xây dựng hạ tầng bằng Terraform, kiểm tra chính sách bằng OPA/Rego, triển khai workload trong môi trường mạng AWS riêng tư, xác thực luồng nghiệp vụ thông qua EventBridge Scheduler và Amazon SQS, giám sát vận hành bằng CloudWatch và SNS, thu thập bằng chứng triển khai và cuối cùng là dọn dẹp tài nguyên.

Hệ thống được triển khai mà không cần Internet Gateway, NAT Gateway, bastion host hoặc Public IP nhưng vẫn duy trì khả năng quản trị thông qua AWS Systems Manager Session Manager và các AWS Private Endpoint.

Kết quả thực nghiệm chứng minh rằng các workload trên AWS có thể được triển khai theo kiến trúc private-by-default, đồng thời vẫn đáp ứng các yêu cầu về bảo mật, khả năng kiểm toán và khả năng vận hành.