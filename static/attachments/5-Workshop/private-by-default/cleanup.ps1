# cleanup.ps1
# Run this when the workshop is finished to avoid AWS cost.
cd D:\mvp_private_by_default_architecture
aws sso login --profile mvp --no-browser
cd D:\mvp_private_by_default_architecture\infra\envs\mvp
terraform plan -destroy -out destroy.binary
terraform apply destroy.binary
