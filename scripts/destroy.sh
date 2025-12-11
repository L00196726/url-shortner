#!/usr/bin/env bash
set -e

TF_DIR="infra/terraform"
HEALTH_TIMEOUT=60 # Wait 60secs for health OK

echo "Starting deploy"

cd $TF_DIR

echo "Terraform init..."
terraform init -upgrade -input=false

echo "Terraform validate..."
terraform validate

echo "Terraform plan..."
terraform plan -out=tfplan -input=false

echo "Terraform destroy..."
terraform destroy -auto-approve
