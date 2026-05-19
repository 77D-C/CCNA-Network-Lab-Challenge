#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

# Spin up AWS infrastructure
echo "==> Deploying infra..."
terraform apply -auto-approve

# Grab the new public IP from tf outputs
IP=$(terraform output -raw web_server_public_ip)

# Clean up local linux hosts mapping
echo "==> Updating local /etc/hosts..."
sudo sed -i '/srelab.test/d' /etc/hosts
echo "$IP srelab.test" | sudo tee -a /etc/hosts > /dev/null

# Background Windows host file update to avoid blocking the script
echo "==> Updating Windows hosts file..."
powershell.exe -Command "
    \$p = 'C:\Windows\System32\drivers\etc\hosts';
    \$c = Get-Content \$p | Where-Object { \$_ -notmatch 'srelab.test' };
    \$c + '${IP} srelab.test' | Set-Content \$p
"

# Give AWS network interface time to catch up
echo "==> Waiting 10s for network initialization..."
sleep 10

# Trigger configuration management
echo "==> Running config playbook..."
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini setup_nginx.yml

echo "==> All steps finished successfully."