#!/bin/bash
set -e

# Update packages
yum update -y

# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Install AWS CLI v2 if not already installed
if ! command -v aws &> /dev/null
then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    unzip /tmp/awscliv2.zip -d /tmp
    /tmp/aws/install
fi

# Login to ECR
aws ecr get-login-password --region ${AWS_REGION} | \
docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Pull latest Docker image
docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/blog-backend:latest

# Remove old container if exists
docker rm -f blog-backend || true

# Run container
docker run -d \
  --name blog-backend \
  --restart unless-stopped \
  -p 80:80 \
  -e AWS_REGION=${AWS_REGION} \
  ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/blog-backend:latest