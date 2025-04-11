#!/bin/bash
set -euo pipefail

# List of supported providers
SUPPORTED_PROVIDERS=("aws" "azure" "gcp" "oci")

# Check if provider is passed
if [[ $# -ne 1 ]]; then
  echo "Missing cloud provider parameter."
  echo
  echo "Usage:   ./run.sh {provider}"
  echo "Example: ./run.sh oci"
  echo
  echo "Supported providers:"
  for p in "${SUPPORTED_PROVIDERS[@]}"; do
    echo "  - $p"
  done
  exit 1
fi

CLOUD_PROVIDER="$1"

# Validate provider
if [[ ! " ${SUPPORTED_PROVIDERS[*]} " =~ " ${CLOUD_PROVIDER} " ]]; then
  echo "Invalid cloud provider: '$CLOUD_PROVIDER'"
  echo "Allowed values: ${SUPPORTED_PROVIDERS[*]}"
  exit 1
fi

TF_DIR="terraform/$CLOUD_PROVIDER"
ANSIBLE_INVENTORY="ansible/inventory/${CLOUD_PROVIDER}.ini"
UAT_PLAYBOOK="ansible/uat.yml"
PROD_PLAYBOOK="ansible/prod.yml"

echo "Starting deployment for cloud provider: $CLOUD_PROVIDER"
echo "Running Terraform from: $TF_DIR"

# Terraform Apply
cd "$TF_DIR"
terraform init
terraform apply -auto-approve
cd - > /dev/null

# Fetch DNS hostnames
uat_host=$(terraform -chdir="$TF_DIR" output -raw uat_dns_record)
prod_host=$(terraform -chdir="$TF_DIR" output -raw prod_dns_record)

# Function to wait for SSH
wait_for_ssh() {
  local host=$1
  local label=$2
  local max_attempts=30

  echo "Waiting for SSH on $label ($host)..."
  for i in $(seq 1 $max_attempts); do
    if nc -z "$host" 22; then
      echo "SSH is ready on $label"
      return 0
    fi
    echo "  Attempt $i/$max_attempts: still waiting"
    sleep 5
  done

  echo "ERROR: Timeout waiting for SSH on $label"
  exit 1
}

wait_for_ssh "$uat_host" "UAT"
wait_for_ssh "$prod_host" "PROD"

# Run Ansible
echo "Running Ansible UAT Playbook..."
ansible-playbook -i "$ANSIBLE_INVENTORY" "$UAT_PLAYBOOK" \
  --extra-vars "cloud_provider=${CLOUD_PROVIDER}"

echo "Running Ansible PROD Playbook..."
ansible-playbook -i "$ANSIBLE_INVENTORY" "$PROD_PLAYBOOK" \
  --extra-vars "cloud_provider=${CLOUD_PROVIDER}"

echo "Deployment complete for: $CLOUD_PROVIDER"