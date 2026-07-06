# quick-commands.ps1
# Run from Windows PowerShell after the source tree exists.
cd D:\mvp_private_by_default_architecture
aws sso login --profile mvp --no-browser
aws sts get-caller-identity --profile mvp
cd D:\mvp_private_by_default_architecture\infra\envs\mvp
terraform init
terraform fmt -recursive ..\..\modules
terraform fmt -recursive .
terraform validate
terraform plan -out tfplan.binary
terraform show -json tfplan.binary > ..\..\..\evidence\m9\final-plan.json
cd D:\mvp_private_by_default_architecture
opa eval --format pretty --data policy\terraform --input evidence\m9\final-plan.json "data.terraform.deny" > evidence\m9\final-opa.txt
Get-Content evidence\m9\final-opa.txt
