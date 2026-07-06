---
title: "Workshop overview"
date: 2026-07-04
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---



In this workshop, we deploy an end-to-end **Private-by-Default AWS Workload Platform**.

This is not a traditional public web application and it does not provide a user-facing interface. Instead, the platform models a secure internal processing environment that organizations can use to process sensitive workloads such as transaction validation, compliance checks, audit evidence generation, scheduled reporting, customer data verification, and other internal business jobs.

The objective of the project is not to build a website, but to demonstrate how sensitive workloads can be processed securely in a private AWS environment while maintaining monitoring, alerting, auditability, encryption, and infrastructure governance.

For readers coming from a web development background, the platform can be understood using the following mapping:

| Web Application Concept | Platform Equivalent |
|---|---|
| User submits a form | Business job message |
| API endpoint | Amazon SQS Queue |
| Backend service | EC2 Private Worker |
| Background scheduler | Amazon EventBridge Scheduler |
| Application database | Amazon RDS PostgreSQL |
| Error handling | SQS Dead Letter Queue |
| Admin notification | CloudWatch Alarm + SNS Email |
| Application logs | CloudWatch Logs |
| Security layer | IAM, Security Groups, VPC Endpoints |
| Audit records | CloudTrail, AWS Config, Flow Logs |

## Business problem

Many organizations process sensitive internal data that should not be exposed to the public Internet.

Examples include:

- Customer data validation
- Financial transaction verification
- Compliance checking
- Scheduled reporting
- Internal audit evidence generation
- Healthcare or insurance batch processing

In many environments, engineers accidentally expose systems by using:

- Public EC2 instances
- Public databases
- SSH access from the Internet
- Excessive IAM permissions
- Unencrypted storage

This project demonstrates a more secure alternative based on a private-by-default architecture.

## High-level business flow

```text
Business Job
        │
        ▼
Amazon EventBridge Scheduler
        │
        ▼
Amazon SQS Processing Queue
        │
        ▼
EC2 Private Worker
        │
        ▼
Amazon RDS PostgreSQL
        │
        ├────────► CloudWatch Logs
        │
        └────────► CloudWatch Metrics
                          │
                          ▼
                  CloudWatch Alarm
                          │
                          ▼
                       SNS Email
```

Failed messages are redirected into a Dead Letter Queue (DLQ) for investigation and recovery.

## Security principles

The platform follows several security principles:

### Private-by-default networking

- Worker instances are deployed inside private subnets.
- Databases are deployed inside private subnets.
- No public database endpoint exists.
- No public SSH access exists.
- No Internet Gateway dependency for workload operations.

### Session Manager instead of SSH

Administrators connect through AWS Systems Manager Session Manager.

Benefits:

- No SSH key management
- No open inbound ports
- Full audit visibility

### Encryption

Sensitive resources use encryption at rest:

- RDS encryption
- CloudWatch Logs encryption
- S3 encryption
- Parameter Store SecureString
- KMS customer-managed keys

### Least-privilege access

IAM permissions are restricted to required services only.

### Infrastructure governance

Terraform plans are validated before deployment using OPA/Rego policies.

## Architecture diagram

![Final architecture diagram](/images/5-Workshop/private-by-default/00-final-architecture-diagram.png)

{{% notice info %}}
Terraform resource names may still contain technical deployment prefixes such as `mvp` or `stage1`. These are environment identifiers only. The official project name used throughout the report is **Private-by-Default AWS Workload Platform**.
{{% /notice %}}

## AWS services used

The platform uses the following AWS services:

### Networking

- Amazon VPC
- Private Subnets
- Route Tables
- Security Groups
- VPC Endpoints

### Compute

- Amazon EC2
- AWS Systems Manager Session Manager

### Data Layer

- Amazon RDS PostgreSQL
- AWS KMS
- AWS Systems Manager Parameter Store

### Messaging

- Amazon SQS
- Dead Letter Queue
- Amazon SNS
- Amazon EventBridge Scheduler

### Monitoring and Audit

- Amazon CloudWatch
- CloudWatch Alarms
- AWS CloudTrail
- AWS Config
- VPC Flow Logs

### Infrastructure as Code

- Terraform
- OPA/Rego Policy Validation

## Final outcome

After completing this workshop, the reader will be able to:

1. Deploy AWS infrastructure using Terraform.
2. Validate infrastructure using OPA/Rego.
3. Create a secure private network architecture.
4. Deploy a private EC2 worker.
5. Deploy a private PostgreSQL database.
6. Configure VPC Endpoints.
7. Configure monitoring and auditing.
8. Configure SQS and DLQ messaging.
9. Configure SNS email notifications.
10. Validate end-to-end business processing.
11. Collect deployment evidence.
12. Clean up resources to avoid unnecessary AWS charges.

## Evidence collection

The workshop includes a small set of evidence screenshots to demonstrate successful deployment:

- SQS processing queue
- Dead Letter Queue configuration
- Worker processing evidence
- CloudWatch logs
- CloudWatch alarm state
- SNS email notification

These screenshots are not the objective of the project. They are supporting evidence that demonstrates the platform operates correctly.

## Cost optimization

This workshop intentionally uses a minimal architecture suitable for student projects, labs, demonstrations, and proof-of-concept deployments.

Cost optimization techniques include:

- Single EC2 worker
- Single-AZ PostgreSQL deployment
- Minimal storage allocation
- No NAT Gateway
- PrivateLink endpoints only where required
- Resource cleanup after validation

When cleanup is performed correctly, ongoing AWS cost remains very low.

## What comes next?

The following sections provide a complete step-by-step implementation guide:

- Prerequisites
- AWS account preparation
- IAM configuration
- Terraform installation
- Infrastructure deployment
- Policy validation
- Business flow testing
- Evidence collection
- Cost cleanup

By following the workshop from beginning to end, a reader with no prior knowledge of the project should be able to reproduce the complete platform and obtain the same final result.