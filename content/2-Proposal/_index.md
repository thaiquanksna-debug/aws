---
title: "Project proposal"
date: 2026-07-04
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# Private-by-Default AWS Workload Platform
## Secure Internal Job Processing Platform on AWS


## 1. Executive summary

**Private-by-Default AWS Workload Platform** is a reference architecture on AWS for organizations that need to process sensitive internal data inside a private network. The platform does not expose the worker or database directly to the Internet, does not use public SSH, and does not require a public application URL.

The project models a secure internal job processing platform for use cases such as banking, insurance, healthcare, logistics, and audit/compliance. These workloads often need to run batch jobs, validate data, generate audit evidence, or execute scheduled compliance checks while still enforcing network isolation, encryption, monitoring, alerting, and audit evidence.

The system input is a **business processing job**, such as a transaction batch validation job, customer data validation job, scheduled CSV processing job, or audit evidence generation job. In the workshop, the input can be created manually by sending a message to Amazon SQS. In an enterprise environment, the input can be produced automatically by an internal system or EventBridge Scheduler.

Main processing flow:

~~~text
EventBridge Scheduler / Internal Producer
→ Amazon SQS Processing Queue
→ EC2 Private Worker in private subnet
→ Amazon RDS PostgreSQL and processing evidence
→ CloudWatch Logs / Metrics
~~~

Failure and alerting flow:

~~~text
Failed Job Message
→ SQS Dead Letter Queue
→ CloudWatch Alarm
→ SNS Topic
→ Operator Email
~~~

The workshop deployment uses one EC2 Private Worker to control cost. The architecture can scale to multiple workers because SQS allows multiple consumers to process jobs in parallel.

## 2. Problem statement

Not every enterprise workload is a public web application. Many important systems are internal workers, batch jobs, data processing jobs, or audit jobs. When these workloads are deployed quickly to cloud environments, common risks include unnecessary public IPv4 addresses on EC2, public database exposure, SSH/RDP opened from the Internet, insecure secret storage, incomplete logs or audit evidence, and no policy gate to prevent unsafe infrastructure changes before deployment.

The project is not only about making a worker run. The real question is:

~~~text
How can we keep the worker private by default,
keep the database private,
avoid SSH-based administration,
encrypt data,
route failed jobs to a DLQ,
notify operators by email,
and produce reviewable evidence after deployment?
~~~

## 3. Proposed solution

The solution uses Terraform to deploy a private workload platform on AWS. Terraform creates a dedicated VPC, private subnets, security groups, VPC Endpoints, EC2 Private Worker, SQS Processing Queue, Dead Letter Queue, EventBridge Scheduler, RDS PostgreSQL private database tier, KMS encryption, CloudWatch Alarms, SNS Email, CloudTrail, AWS Config, VPC Flow Logs, and an S3 Evidence Bucket.

Before infrastructure is applied, the Terraform plan is exported to JSON and evaluated with OPA/Rego. The policy gate denies unsafe configurations such as EC2 public IPs, SSH key pairs, public RDS, unencrypted RDS, missing KMS, or unwanted public routes.

The DLQ does not send email directly. CloudWatch Alarm watches the DLQ metric, such as `ApproximateNumberOfMessagesVisible`. When messages appear in the DLQ or when the alarm is manually tested, CloudWatch enters ALARM state and triggers SNS to send an email notification to the operator.

## 4. Solution architecture

The architecture is divided into four planes.

**Deployment Control Plane** exists outside the workload boundary. The developer uses VS Code, AWS CLI SSO profile, Terraform, and OPA/Rego to create plans, evaluate policy, and deploy infrastructure.

**Private Workload Plane** runs inside a dedicated VPC. The EC2 Worker runs in a private app subnet, has no public IP, uses no SSH key pair, and does not require a bastion host. The worker reaches AWS services through VPC Endpoints/PrivateLink.

**Data and Messaging Plane** includes Amazon SQS, Dead Letter Queue, and Amazon RDS PostgreSQL. SQS decouples producer and consumer for asynchronous processing. DLQ stores failed messages for investigation or redrive. RDS PostgreSQL is a private database tier with public access disabled and encryption enabled.

**Operations and Evidence Plane** includes CloudWatch, SNS, CloudTrail, AWS Config, VPC Flow Logs, and S3 Evidence Bucket. This plane provides monitoring, alerting, and post-deployment audit evidence.

## 5. AWS services used

| Service | Role in the architecture |
|---|---|
| Amazon VPC | Dedicated private network for the workload. |
| Private Subnets | Run EC2 Worker and RDS without Internet exposure. |
| Security Groups | Restrict network paths and avoid public SSH/RDP. |
| VPC Endpoints / PrivateLink | Allow private EC2 to call AWS APIs without NAT Gateway. |
| Amazon EC2 | Private Worker that processes jobs from SQS. |
| Amazon SQS | Queue for business processing jobs. |
| SQS Dead Letter Queue | Stores failed messages after repeated processing failures. |
| EventBridge Scheduler | Creates scheduled jobs and sends them to SQS. |
| Amazon RDS PostgreSQL | Private database tier for business data and processing results. |
| AWS Systems Manager Session Manager | Admin access to private EC2 without SSH. |
| AWS KMS | Encryption for RDS, EBS, S3, CloudWatch Logs, and SSM SecureString. |
| SSM Parameter Store | Stores database password as SecureString. |
| Amazon CloudWatch | Metrics, alarms, and operational evidence. |
| Amazon SNS | Sends email alerts when alarms fire. |
| AWS CloudTrail | Records AWS API activity for audit. |
| AWS Config | Records resource configuration state. |
| VPC Flow Logs | Records VPC traffic metadata. |
| Amazon S3 | Stores logs and evidence. |
| Terraform | Infrastructure as Code. |
| OPA/Rego | Policy-as-Code gate before deployment. |

## 6. Why not Lambda + Serverless as the main design

Lambda and serverless are effective for short, stateless, event-driven tasks that need fast request-based scaling. This project models internal data jobs that may run longer, require controlled runtime dependencies, need predictable private network paths, or require private administration.

EC2 Private Worker with SQS fits the project goal better because it demonstrates private compute inside a VPC, proves EC2 administration without SSH using Session Manager, gives stronger control over operating system/runtime/dependencies, and makes infrastructure controls visible: security groups, IMDSv2, encrypted EBS, VPC Endpoints, and IAM roles.

Serverless can still be a future option for short tasks or an API edge layer. This project prioritizes private-by-default infrastructure and a clear workload processing path.

## 7. Security design

The project applies these security controls:

- EC2 Worker has no public IPv4 address.
- No SSH key pair and no public SSH/RDP ingress are used.
- EC2 administration uses AWS Systems Manager Session Manager.
- RDS PostgreSQL has public access disabled and runs in private DB subnets.
- RDS, EBS, S3, SSM SecureString, and CloudWatch Logs are encrypted with KMS.
- Worker calls AWS APIs through VPC Endpoints.
- IAM roles follow least-privilege boundaries.
- OPA/Rego evaluates the Terraform plan before apply.
- CloudTrail, AWS Config, and VPC Flow Logs provide post-deployment evidence.

## 8. One-month 24/7 budget estimate

The estimate below assumes **24/7 operation for 730 hours/month**, **US East (N. Virginia)**, the default workshop configuration, low traffic, no tax, and no dependency on the Free Tier. This answers the practical question: how much does it cost if the system runs continuously for one month?

| Component | Assumption | Estimated monthly cost |
|---|---:|---:|
| EC2 Private Worker | 1 × t3.micro Linux, 730 hours | ~7.6 USD |
| EC2 EBS root volume | 8 GB | ~0.7 USD |
| RDS PostgreSQL | 1 × db.t3.micro Single-AZ, 730 hours | ~12.5 USD |
| RDS storage | 20 GB general purpose SSD | ~2.3 USD |
| VPC Interface Endpoints | 8 endpoints × 1 AZ × 730 hours × ~0.01 USD/hour | ~58.4 USD |
| AWS KMS | 2 customer-managed keys | ~2.0 USD |
| CloudWatch | Alarms, small logs, default metrics | ~1–3 USD |
| SQS, SNS, EventBridge Scheduler | Low-traffic workload | <1 USD |
| S3 Evidence Bucket + CloudTrail logs | Small storage volume | <1 USD |
| AWS Config | Small number of resources and changes | ~1–3 USD |

**Estimated total for the cost-controlled deployment:** approximately **85–95 USD/month** if the infrastructure is kept running 24/7.

If **RDS Multi-AZ** is enabled to fully match the primary/standby database tier in the diagram, the database cost increases. In that case, the total should be estimated at approximately **105–125 USD/month**, depending on instance class, storage, backup, log volume, and actual endpoint count.

During the actual workshop, the cost can be much lower because the infrastructure is deployed temporarily, validated, documented, and destroyed with Terraform. The AWS Billing dashboard may show only a few dollars of forecasted cost if resources are cleaned up after the demo.

## 9. Business value

For an estimated **85–95 USD/month** in 24/7 pilot mode, this platform is more than an infrastructure demo. It creates a reusable baseline for internal workloads that need to process sensitive data inside a private environment.

The main value includes:

- Lower risk of accidental public exposure for workers and databases.
- Standardized deployment for internal workers using Infrastructure as Code.
- Policy-as-Code checks before infrastructure changes are applied.
- Clear failure handling through SQS DLQ.
- Alerting through CloudWatch Alarm and SNS Email.
- Audit evidence through CloudTrail, AWS Config, VPC Flow Logs, and S3.
- Reusability as a baseline for future internal data-processing jobs.

For teams handling sensitive internal data, this monthly cost can be treated as a platform cost for reducing operational risk, improving audit readiness, and accelerating delivery of future internal workloads. Compared with the potential cost of accidental public exposure, missing audit evidence, or undetected failed jobs, the cost is reasonable for a secure internal workload platform at pilot scale.

## 10. Risk assessment

| Risk | Impact | Mitigation |
|---|---|---|
| Resources are not cleaned up | Unexpected cost | Require `terraform destroy` after evidence collection. |
| SSO token expires | AWS CLI/Terraform commands fail | Use `aws sso login --profile mvp --no-browser`. |
| IAM permission is missing | Terraform apply fails with AccessDenied | Use a dedicated Terraform operator permission set. |
| Reviewer expects a UI | The project may be misunderstood as “just AWS services” | Explain that this is an internal backend job-processing platform. |
| Workshop uses Single-AZ RDS | It does not fully match the HA database diagram | Explain this as the cost-optimized path; Multi-AZ is optional. |

## 11. Expected outcomes

After completion, the project demonstrates an AWS workload with clear input, processing, output, failure handling, alerting, security controls, audit evidence, and cleanup plan. The result is not just a collection of AWS services, but a repeatable secure internal job-processing platform that can be reviewed, redeployed, and extended for enterprise private-by-default use cases.
