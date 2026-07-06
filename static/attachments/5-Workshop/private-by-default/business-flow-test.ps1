# business-flow-test.ps1
# Run on Windows PowerShell after Terraform apply is complete.
cd D:\mvp_private_by_default_architecture\infra\envs\mvp
$QueueUrl = terraform output -raw m9_processing_queue_url
$AlarmName = terraform output -raw m9_dlq_alarm_name
$InstanceId = terraform output -raw worker_instance_id
aws sqs send-message --profile mvp --region us-east-1 --queue-url $QueueUrl --message-body '{ "job_id": "demo-job-001", "job_type": "csv_validation", "source": "manual_test", "file_name": "customer.csv" }'
aws cloudwatch set-alarm-state --profile mvp --region us-east-1 --alarm-name $AlarmName --state-value ALARM --state-reason "Manual test for M9 DLQ alarm to SNS email notification"
