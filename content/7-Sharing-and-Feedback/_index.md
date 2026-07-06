---
title: "Sharing and Feedback"
date: 2026-07-04
weight: 7
chapter: false
pre: " <b> 7. </b> "
---

# Sharing and Feedback

## 1. Overall evaluation

After my internship at FCJ, I had the opportunity to learn practical knowledge related to AWS, Cloud Computing, DevOps, Infrastructure as Code, and cloud deployment workflow. This internship helped me move from mainly learning theory to actually deploying, testing, troubleshooting, and documenting a complete technical project.

During the internship, I not only learned more about AWS services, but also developed a clearer engineering mindset for system design. I learned to identify input, processing flow, output, failure handling, monitoring, alerting, cost optimization, and cleanup. These concepts helped me see a cloud system not just as a group of separate services, but as a workload with a clear operational purpose.

My personal project was **Private-by-Default AWS Workload Platform**, which focused on building an internal job processing workload on AWS in a private environment. The project used Terraform for infrastructure deployment, OPA/Rego for policy validation before deployment, EC2 Private Worker for processing jobs from SQS, RDS PostgreSQL for the database tier, CloudWatch/SNS for alerting, and audit services such as CloudTrail, AWS Config, VPC Flow Logs, and an S3 Evidence Bucket.

Through this project, I gained a deeper understanding of security-by-design, network isolation, IAM least privilege, VPC Endpoints, SSM Session Manager, KMS encryption, monitoring, alerting, and the importance of creating evidence after deployment.

## 2. Working environment

The working environment at FCJ was friendly, open, and suitable for interns. Team members and peers were willing to provide support when I encountered difficulties, including basic questions. This helped reduce pressure in the early stage, especially when I had to learn many new technologies at the same time.

Participating in AWS workshops and working on a practical project helped me better understand the process of learning, building, testing, and presenting a technical product. Instead of only reading documentation or studying theory, I had to deploy the system, encounter errors, debug them, and complete the project. This was an important experience for an Information Technology student.

## 3. Support from mentors and admin team

The admin team provided good support through learning materials, workshop instructions, timeline announcements, and general guidance. The workshop documents were generally clear, step-by-step, and included reference links for further learning.

Mentors and senior members also supported me in project direction, architecture feedback, diagram presentation, business flow definition, and evidence collection. Their feedback helped me realize that a cloud project should not only deploy successfully. It should also explain why the architecture is valuable, what input the system processes, what output it produces, how failures are handled, and how operators can review evidence.

Some workshops may not have been fully updated to the latest AWS interface or tool version. However, I see this as part of real-world learning because cloud service interfaces, documentation, and best practices change over time. Researching official documentation and fixing issues helped me understand more deeply instead of only following instructions mechanically.

## 4. Relevance to my academic major

The internship work was relevant to my Information Technology major. Foundational knowledge from university, such as computer networking, databases, backend development, frontend development, and software development processes, was applied in workshops and project work.

The internship also helped me expand into areas that I had only known theoretically before.

**Cloud Computing and DevOps:** Before the internship, I only understood cloud computing at a conceptual level. During the internship, I deployed actual AWS infrastructure and worked with VPC, subnets, route tables, security groups, IAM, EC2, RDS, S3, CloudWatch, and related services. I also learned how Terraform can manage infrastructure more consistently than manual console operations.

**Infrastructure as Code and Policy as Code:** Through my personal project, I learned how to write Terraform for reusable infrastructure, control changes with `terraform plan`, and use OPA/Rego to validate policies before deployment. This is practical knowledge because it reduces configuration risk, especially for internal workloads or sensitive data processing systems.

**System architecture and message queue:** I gained a clearer understanding of the role of a message queue in decoupling producers and workers. In my project, EventBridge Scheduler creates scheduled jobs, SQS stores jobs, EC2 Private Worker polls jobs for processing, DLQ stores failed messages, and CloudWatch/SNS sends alerts when failures occur. This flow helped me understand asynchronous system design with retry behavior, failure handling, and monitoring.

**Deployment control:** I learned a controlled deployment workflow: prepare the local environment, write infrastructure code, run `terraform validate`, generate a plan, check policy, apply the deployment, validate the result, and clean up resources. This process helped me understand that cloud deployment needs governance and verification, not just commands that create services.

## 5. Learning opportunities and skill development

During the internship, I developed both technical skills and soft skills.

### Technical skills

- AWS services: EC2, VPC, RDS, S3, IAM, CloudWatch, CloudTrail, AWS Config, SQS, SNS, EventBridge Scheduler, KMS, Systems Manager.
- DevOps: Terraform, Infrastructure as Code, policy validation, deployment workflow, and cleanup to avoid unnecessary cost.
- Security: private subnets, security groups, no public IP, no inbound SSH, SSM Session Manager, IAM least privilege, KMS encryption, and VPC Endpoints.
- Database: PostgreSQL on Amazon RDS, private database tier, encryption, subnet group, and security group access control.
- Monitoring and audit: CloudWatch Alarm, SNS Email, VPC Flow Logs, CloudTrail, AWS Config, and evidence collection.
- Troubleshooting: reading AWS CLI errors, Terraform errors, IAM AccessDenied errors, expired SSO token, stale Terraform plan, and syntax differences between PowerShell and Linux shell.

I especially realized that debugging is a major part of cloud work. Some errors do not come from application code, but from IAM permissions, network paths, endpoints, regions, profiles, or the difference between PowerShell commands and Linux shell commands. Fixing these issues helped me understand the system more deeply.

### Soft skills

- Teamwork: coordinating with team members, dividing tasks, discussing errors, and receiving feedback.
- Technical communication: explaining the project, presenting architecture, describing business flow, and writing reports.
- Self-learning: reading documentation, researching errors, testing solutions, validating results, and recording evidence.
- Time management: breaking a large project into smaller phases, prioritizing important parts, and cleaning up resources after completion.
- Critical thinking: asking questions such as “What is this system for?”, “What is the input?”, “What is the output?”, “How are failures handled?”, and “Where is the operational evidence?”.

These skills make me more confident when approaching future cloud or DevOps projects.

## 6. Culture and teamwork

The working culture at FCJ was positive and supportive. When a member encountered difficulties, others were willing to explain, share documents, or suggest approaches. This was meaningful to me because my cloud computing foundation was not strong before the internship.

I also learned that asking the right questions is important in a technical environment. At first, I hesitated to ask questions because I was afraid they might be too basic. Later, I realized that not asking early can lead to misunderstanding requirements or going in the wrong direction. This is an important lesson in team communication.

## 7. Policies and benefits for interns

The company provides good conditions for interns through workshops, learning materials, mentor support, and a clear practice timeline. Having AWS workshops organized by topic gave me a more structured learning path instead of learning scattered materials on my own.

One point I appreciate is that the program does not stop at learning individual services. It also encourages interns to build a project with architecture, proposal, deployment, evidence, and reporting. This helped me understand the process of building a complete technical product.

In the future, I hope the program can include more advanced workshops such as Kubernetes, AWS Lambda, Amazon Bedrock, advanced CI/CD, security automation, or in-depth cost optimization. Tech talks or sharing sessions from experienced engineers would also be very useful for interns.

## 8. What I was most satisfied with during the internship

What I was most satisfied with was the clear improvement in my technical skills and engineering mindset. At the beginning, I was not very confident because I only knew a little about each technology and had not deployed a complete cloud system before. After the internship, I was able to build a project from architecture design, Terraform code, policy validation, AWS deployment, business flow testing, evidence collection, and report writing.

The **Private-by-Default AWS Workload Platform** project helped me understand that a good cloud system should not only run successfully. It should also be secure, verifiable, observable, able to alert operators when failures occur, provide logs and audit trails, and include a cleanup plan to avoid unnecessary cost.

## 9. What could be improved for future interns

Overall, the internship program was well organized and met the learning needs of interns. However, I have one small suggestion regarding communication and announcement management.

During the internship, there were times when announcements across groups or channels were not fully synchronized. This made me slightly confused about deadlines, requirements, or changes related to the program. Part of the reason also came from myself because I did not read all the initial materials carefully enough and hesitated to ask the admin team, master, or mentor when something was unclear.

Therefore, I suggest pinning the most important and latest announcements at the top of the program communication channel. Information such as deadlines, meeting schedules, submission requirements, report format changes, or important checklists should be collected in one fixed place. This would help interns follow updates more easily and reduce the chance of important information being buried in daily discussions.

## 10. Would I recommend FCJ internship to my friends?

Yes. I would recommend the FCJ internship program to friends who want to learn practical skills, especially those who want to work with AWS, Cloud Computing, DevOps, and real system deployment.

The main reasons are that interns can learn practical knowledge instead of only theory, practice with AWS services and real deployment workflows, receive support from mentors/admins/teammates, build an end-to-end project from design to reporting, and build a stronger cloud foundation for future projects.

However, I would also remind them that they need to be proactive, read materials carefully, record errors, and ask questions when they do not understand something. The program includes many new topics, so without proactivity, it can be easy to feel overloaded or misunderstand requirements.

## 11. Suggestions and expectations

At this point, I do not have any major suggestions for change. Based on my personal experience, the FCJ program is already well structured and reasonable. It includes a learning roadmap, mentor support, documentation, checklists, and opportunities to practice with real technical problems.

In the future, I hope to work on more complex projects, learn more deeply about AWS architecture, security, DevOps, and automation, join technical sharing sessions or tech talks, contribute to improving workshops or supporting future interns, and build a network with mentors, admins, and peers who are also interested in cloud computing.

## 12. Appreciation

I am grateful to FCJ for giving me the opportunity to learn and grow during this internship. The knowledge and experience I gained during this period will be valuable for my future studies and career direction.

I would like to thank the FCJ team, mentors, admins, and teammates for supporting and giving feedback throughout the internship. This was a meaningful experience for me, not only technically but also in terms of working style, communication, and completing a real project.

The reflections above are based on my honest personal experience during the internship.
