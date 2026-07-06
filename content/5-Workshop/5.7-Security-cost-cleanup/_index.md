---
title: "Security, cost control, and cleanup"
date: 2026-07-04
weight: 7
chapter: false
pre: " <b> 5.7. </b> "
---

# Security controls implemented

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

The main cost drivers are RDS, EC2, VPC Interface Endpoints, KMS, CloudWatch Alarms, and S3. Do not leave the environment running after the report screenshots are complete.

A quick estimate for keeping the default configuration running 24/7 for one month in `us-east-1` is approximately **85–95 USD/month**. If RDS Multi-AZ is enabled to match the primary/standby database tier in the diagram, reserve approximately **105–125 USD/month**. This estimate excludes tax, does not rely on the Free Tier, and should be validated with AWS Pricing Calculator before real operation.

# Optional: enable RDS Multi-AZ to match the database tier in the diagram

The diagram has two RDS icons. The correct interpretation is **RDS PostgreSQL primary/standby** across private DB subnets. The default workshop path uses a cost-controlled configuration. Run this optional step only when the database tier must match the diagram exactly or when you want to simulate a production HA pattern.

Run in Windows PowerShell:

~~~powershell
cd D:\mvp_private_by_default_architecture
code infra\modules\database\main.tf
~~~

In `infra\modules\database\main.tf`, find:

~~~hcl
multi_az = false
~~~

Change it to:

~~~hcl
multi_az = true
~~~

Then open the OPA policy:

~~~powershell
code policy\terraform\database_invariants.rego
~~~

Find the rule that blocks Multi-AZ for cost control:

~~~rego
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_db_instance"
  after := rc.change.after
  after.multi_az == true
  msg := sprintf("Stage 1 uses Single-AZ RDS for cost control: %s", [rc.address])
}
~~~

Replace it with the rule that requires Multi-AZ for the primary/standby architecture:

~~~rego
deny contains msg if {
  rc := input.resource_changes[_]
  rc.type == "aws_db_instance"
  after := rc.change.after
  after.multi_az != true
  msg := sprintf("RDS instance must use Multi-AZ for primary/standby HA: %s", [rc.address])
}
~~~

Deploy again:

~~~powershell
cd D:\mvp_private_by_default_architecture\infra\envs\mvp
terraform fmt -recursive
terraform validate
terraform plan -out tfplan.binary
terraform show -json tfplan.binary > tfplan.json
opa eval -f pretty -d ..\..\..\policy\terraform -i tfplan.json "data.terraform.deny"
terraform apply tfplan.binary
~~~

Expected OPA result must still be:

~~~text
[]
~~~

Cost note: Multi-AZ RDS costs more than Single-AZ and takes longer to create or update. For a fast demo, keep Single-AZ. For a proposal/diagram-aligned HA database tier, enable Multi-AZ.


# Cleanup

Run in Windows PowerShell:

~~~powershell
cd D:\mvp_private_by_default_architecture
aws sso login --profile mvp --no-browser
cd D:\mvp_private_by_default_architecture\infra\envs\mvp
terraform plan -destroy -out destroy.binary
terraform apply destroy.binary
~~~

When Terraform asks for confirmation, type:

~~~text
yes
~~~

Expected result:

~~~text
Destroy complete!
~~~

# Post-cleanup check

Open AWS Console and verify that EC2 worker, RDS database, SQS queues, VPC Endpoints, SNS topic, EventBridge schedule, and CloudWatch Alarm were removed. KMS keys may remain in scheduled deletion state for the configured deletion window.
# Workshop conclusion

This workshop demonstrated the complete implementation lifecycle of the Private-by-Default AWS Workload Platform.

The deployment process included infrastructure provisioning with Terraform, policy validation with OPA/Rego, workload deployment into private AWS networking, business-flow validation through EventBridge Scheduler and Amazon SQS, operational monitoring with CloudWatch and SNS, evidence collection, and final resource cleanup.

The resulting platform operates without Internet Gateway, NAT Gateway, bastion hosts, or public IP addresses while still maintaining administrative access through AWS Systems Manager Session Manager and AWS Private Endpoints.

The implementation validates that secure, auditable, and operationally manageable workloads can be deployed on AWS using a private-by-default architecture.