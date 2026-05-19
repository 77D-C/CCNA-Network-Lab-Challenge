terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "Lab"
      Project     = "ZeroTouchObservability"
      ManagedBy   = "Terraform"
      Owner       = "DC"
    }
  }
}


# --- 1. Find the latest Ubuntu 22.04 AMI ---
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# --- 2. Security Group ---
resource "aws_security_group" "web_sg" {
  name        = "allow_web_access"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- 3. The SSH Key Pair ---
resource "aws_key_pair" "deployer" {
  key_name   = "ansible-key"
  public_key = file("/home/dc/.ssh/ansible_key.pub")
}

# --- 4. The Web Server (Merged Block) ---
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sleep 30
              sudo apt-get update -y
              sudo apt-get install -y nginx
              echo "<h1>SRE Lab: Automation Successful!</h1>" | sudo tee /var/www/html/index.html
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  tags = {
    Name = "Nginx-Web-Server"
    Role = "Web"
  }
}

# --- 5. Output ---
output "web_server_public_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.web_server.public_ip
}