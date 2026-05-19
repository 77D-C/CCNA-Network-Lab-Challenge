# AWS Automated Web Infrastructure Deployment

This sub-project handles the automated provisioning and configuration management of a public-facing Nginx web server on AWS. The objective was to eliminate manual console configurations and replace them with a unified, repeatable Infrastructure as Code (IaC) execution model.

## Core Architecture
* **Provisioning Engine:** Terraform (HashiCorp HCL)
* **Configuration Management:** Ansible (YAML Playbooks)
* **Target Operating System:** Ubuntu Server 22.04 LTS via AWS EC2
* **Control Node Environment:** Windows Subsystem for Linux (WSL2 / Ubuntu)

## System Configuration Details

### 1. Infrastructure Provisioning (Terraform)
The `main.tf` script manages the lifecycle of the cloud infrastructure, isolating resources inside the default VPC while enforcing strict security perimeter routing.
* **Security Group Rules:** Configured to ingress port 80 (HTTP) for public web traffic and port 22 (SSH) restricted to administrative control node traffic. Outbound egress traffic is globally open (0.0.0.0/0) to allow system updates.
* **Key-Pair Association:** Integrates a locally generated OpenSSH public key to bootstrap the instance with secure administrative access.

### 2. Post-Provisioning Configuration (Ansible)
Once the underlying infrastructure signals healthy status, the Ansible control loop executes `setup_nginx.yml` across the inventory.
* **Package Automation:** Updates apt caches and installs the Nginx web server binary.
* **State Enforcement:** Configures systemd to guarantee the web server process auto-starts on system boots.
* **Dynamic Variable Injection:** Utilizes Jinja2 templating mechanics to fetch host metadata (like the public IPv4) and write it dynamically into a customized, responsive CSS-animated landing page.

## Hurdles Overcome & Technical Solutions

### Problem: Environmental State Desynchronization
When transferring project files across the Windows-to-WSL runtime environments, the Terraform state file decoupled from live AWS deployments. Running a standard application cycle threatened to tear down active servers or conflict with existing security blocks.
* **Solution:** Used `terraform import` to trace the active EC2 instance metadata directly back into the local HCL declarative resource blocks, successfully synchronizing state without requiring infrastructure destruction or causing downtime.

### Problem: Automated SSH Handshake Blocks
In a pure automation pipeline, waiting for manual prompt confirmations (the "Are you sure you want to continue connecting?" warning) breaks non-interactive execution loops.
* **Solution:** Injected an immediate environment override via `ANSIBLE_HOST_KEY_CHECKING=False` directly into the execution command string, allowing Ansible to dynamically connect to newly deployed, rotating cloud IP addresses seamlessly.

## Execution Blueprint

### Initialization and Provisioning
```
terraform init
terraform plan
terraform apply -auto-approve


ANSIBLE_HOST_KEY_CHECKING=False
 ansible-playbook -i inventory.ini setup_nginx.yml
```
Technical Note: Why ANSIBLE_HOST_KEY_CHECKING=False?

When connecting to a newly provisioned AWS instance for the first time, SSH naturally pauses execution to prompt the user to manually accept the remote host's security fingerprint. Because this lab runs on a non-interactive automation loop, this security prompt would cause the deployment script to hang and fail.
Prepending ANSIBLE_HOST_KEY_CHECKING=False bypasses this manual handshake verification check, allowing Ansible to immediately log in, establish its secure channel, and deploy the Nginx server configuration entirely hands-free.

## Pipeline Optimization: Dynamic Local DNS Resolution

### The Challenge
In a typical development lifecycle, destroying and recreating cloud infrastructure results in randomized public IPv4 addresses. Manually editing the Ansible configuration file (`inventory.ini`) after every single orchestration cycle introduces human intervention into what should be an automated, non-interactive pipeline.

### The Solution: Decoupled Local DNS Orchestration
To solve this, this repository implements a decoupled multi-tool execution wrapper via `deploy.sh`. 

Instead of hardcoding shifting IPs, the inventory targets a static, localized domain alias (`srelab.local`). The pipeline automates the data handoff behind the scenes:

1. **State Extraction:** Terraform provisions the network interfaces and outputs the live cloud IP string dynamically.
2. **Local Nameserver Override:** The shell runner programmatically purges expired pointers and writes the fresh IP directly into the local control node system dictionary (`/etc/hosts`) using streamlined stream editing (`sed`).
3. **Decoupled Execution:** Ansible reads the persistent inventory file, and the operating system naturally resolves `srelab.local` straight to the active AWS target.

This architectural pattern guarantees that the code remains generic, environment-agnostic, and entirely modular for version control.
