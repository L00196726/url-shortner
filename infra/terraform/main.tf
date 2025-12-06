terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# Security group to allow SSH and app port (5000)
resource "aws_security_group" "url_shortener_sg" {
  name        = "url-shortener-sg"
  description = "Allow SSH and HTTP (port 5000) for url-shortener"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App port 5000"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance with user_data installing Docker and running the container
resource "aws_instance" "url_shortener" {
  ami                    = "ami-0acd9fd39de089f9b" # Amazon Linux 2 AMI (eu-west-1)
  instance_type          = "t3.micro"
  key_name               = "ATU"
  vpc_security_group_ids = [aws_security_group.url_shortener_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update system
              yum update -y

              # Install Docker
              amazon-linux-extras install docker -y || yum install -y docker

              systemctl enable docker
              systemctl start docker

              # Add ec2-user to docker group
              usermod -aG docker ec2-user
              EOF

  tags = {
    Name = "url-shortener-ec2"
  }
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.url_shortener.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.url_shortener.public_dns
}