#!/bin/bash
set -e

echo "[+] Running Terraform..."
cd terraform
terraform apply -auto-approve

echo "[+] Fetching DNS hostnames..."
uat_host=$(terraform output -raw uat_dns_record)
prod_host=$(terraform output -raw prod_dns_record)
cd ..

echo "[+] Waiting for SSH on UAT ($uat_host)..."
until nc -z "$uat_host" 22; do
  echo -n "  ...waiting for SSH to be ready"
  sleep 5
done
echo -e "\n[+] SSH is ready on UAT."

echo "[+] Waiting for SSH on PROD ($prod_host)..."
until nc -z "$prod_host" 22; do
  echo -n "  ...waiting for SSH to be ready"
  sleep 5
done
echo -e "\n[+] SSH is ready on PROD."

echo "[+] Running Ansible playbook (site.yml)..."
ansible-playbook -i ansible/inventory/hosts.ini ansible/site.yml