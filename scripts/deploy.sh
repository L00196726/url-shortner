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

echo "Terraform apply..."
terraform apply -auto-approve tfplan

PUBLIC_IP=$(terraform output -raw instance_public_ip)
HEALTH_URL="http://${PUBLIC_IP}:5000/health"

echo

echo "Waiting for instance to pass health check"

# Retry loop
SECONDS_WAITED=0
until curl -s --max-time 2 "${HEALTH_URL}" | grep -q '"status":"ok"' ; do
    if [ $SECONDS_WAITED -ge $HEALTH_TIMEOUT ]; then
        echo "ERROR: Health check FAILED after ${HEALTH_TIMEOUT}s"
        exit 1
    fi
    
    echo "Waiting for health check..."
    sleep 10
    SECONDS_WAITED=$((SECONDS_WAITED+10))
done

echo "Health endpoint returned OK after ${SECONDS_WAITED}s"