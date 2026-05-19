#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

echo "Running terraform apply..."
terraform apply -auto-approve

echo "Getting the new IP address..."
NEW_IP=$(terraform output -raw web_server_public_ip)

echo "Updating the hosts file..."
sudo sed -i '/srelab.local/d' /etc/hosts
echo "$NEW_IP srelab.local" | sudo tee -a /etc/hosts

echo "Waiting 10 seconds..."
sleep 10

echo "Running ansible playbook..."
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini setup_nginx.yml

echo "Done!"
