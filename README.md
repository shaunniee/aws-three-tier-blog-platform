# Three-Tier Blog Application on AWS

This repository contains a production-ready, modular, and secure three-tier blog application deployed entirely on **Amazon Web Services (AWS)**. The infrastructure is managed using Terraform, the frontend is built with React (Vite), and the backend is a Node.js (Express) REST API. The architecture is designed for scalability, high availability, and security, following AWS and DevOps best practices.

---

## Table of Contents

- [AWS Architecture Overview](#aws-architecture-overview)
- [Detailed VPC & Networking Design](#detailed-vpc--networking-design)
- [Repository Structure](#repository-structure)
- [Infrastructure Modules](#infrastructure-modules)
- [AWS Security Features](#aws-security-features)
- [Prerequisites](#prerequisites)
- [Deployment Guide](#deployment-guide)
- [Environment Variables & AWS Secrets Management](#environment-variables--aws-secrets-management)
- [Authentication & Authorization (AWS Cognito)](#authentication--authorization-aws-cognito)
- [File Uploads & Media Handling (Amazon S3)](#file-uploads--media-handling-amazon-s3)
- [CI/CD Pipeline (AWS CodePipeline & CodeBuild)](#cicd-pipeline-aws-codepipeline--codebuild)
- [Monitoring & Logging (AWS CloudWatch)](#monitoring--logging-aws-cloudwatch)
- [Cleaning Up AWS Resources](#cleaning-up-aws-resources)
- [Troubleshooting](#troubleshooting)
- [References](#references)
- [License](#license)

---

## AWS Architecture Overview

**Frontend:**  
- React SPA built with Vite.
- Hosted on **Amazon S3** with static website hosting.
- Served globally via **Amazon CloudFront** CDN with Origin Access Identity (OAI) for secure S3 access.

**Backend:**  
- Node.js/Express REST API.
- Containerized and deployed on **Amazon EC2 Auto Scaling Group** behind an **Application Load Balancer (ALB)**.
- **Amazon API Gateway** proxies requests to the backend for additional security and flexibility.

**Database:**  
- **Amazon RDS (PostgreSQL)** deployed in private subnets for high availability and security.

**Authentication:**  
- **AWS Cognito User Pool** for user registration, login, and JWT-based authentication.

**Media Storage:**  
- **Amazon S3** bucket for user-uploaded media, with access via signed URLs.

**Networking:**  
- Custom **VPC** with public, application, and database subnets across multiple Availability Zones.
- **NAT Gateway** for outbound internet access from private subnets.
- **Bastion host** for secure SSH access to private resources.
- Strict **security groups** and **NACLs**.

**CI/CD:**  
- **AWS CodePipeline** and **CodeBuild** for automated build, test, and deployment from GitHub.

---

## Detailed VPC & Networking Design

### VPC & Subnets

- **VPC CIDR:** `10.0.0.0/16`
- **Public Subnets:** `10.0.1.0/24`, `10.0.2.0/24` (for ALB, NAT Gateway, Bastion)
- **Application Subnets:** `10.0.11.0/24`, `10.0.12.0/24` (for EC2 ASG)
- **Database Subnets:** `10.0.21.0/24`, `10.0.22.0/24` (for RDS, no public IP)

### Route Tables

- **Public Route Table:**  
  - `0.0.0.0/0` → Internet Gateway  
  - Associated with public subnets.
- **Private App Route Table:**  
  - `0.0.0.0/0` → NAT Gateway  
  - Associated with application subnets.
- **Private DB Route Table:**  
  - No direct internet route  
  - Associated with database subnets.

### Network ACLs (NACLs)

- **Public Subnets NACL:**  
  - Inbound: Allow 80, 443, 22 from `0.0.0.0/0`  
  - Outbound: Allow all
- **App Subnets NACL:**  
  - Inbound: Allow 80, 443 from ALB SG, ephemeral ports from public subnets  
  - Outbound: Allow 5432 to DB subnets, 443 to S3, ephemeral ports to public subnets
- **DB Subnets NACL:**  
  - Inbound: Allow 5432 from app subnets  
  - Outbound: Allow ephemeral ports to app subnets

### Security Groups

- **ALB SG:**  
  - Inbound: 80/443 from `0.0.0.0/0`  
  - Outbound: 80/443 to backend SG
- **Backend EC2 SG:**  
  - Inbound: 80/443 from ALB SG  
  - Outbound: 5432 to RDS SG, 443 to S3, 0.0.0.0/0 for updates
- **RDS SG:**  
  - Inbound: 5432 from backend SG  
  - Outbound: 0.0.0.0/0 (for updates, can be restricted)
- **Bastion SG:**  
  - Inbound: 22 from trusted admin IP  
  - Outbound: 0.0.0.0/0

### VPC Traffic Flow

1. **User → CloudFront → S3 (Frontend):**  
   - HTTPS traffic from user to CloudFront, then to S3 bucket (OAI-secured).
2. **User → CloudFront → API Gateway → ALB → EC2 (Backend):**  
   - HTTPS traffic from user to CloudFront, routed to API Gateway, then to ALB, then to EC2 instances in app subnets.
3. **EC2 → RDS:**  
   - Backend EC2 instances connect to RDS PostgreSQL in private subnets via port 5432.
4. **EC2 → S3 (Media):**  
   - EC2 instances access S3 media bucket via VPC endpoint (private, no internet).
5. **Bastion → EC2/RDS:**  
   - Admin connects via SSH to Bastion in public subnet, then can SSH to EC2 or connect to RDS (if allowed).
6. **App/DB Subnets → Internet:**  
   - Outbound internet access via NAT Gateway for updates, package installs, etc.

---

## Repository Structure

```
.
├── backend/         # Node.js Express API source code
├── frontend/        # React (Vite) SPA source code
├── infrastructure/  # Terraform root module and configuration
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   └── modules/
│       ├── api_gateway/
│       ├── auth/
│       ├── backend/
│       ├── bastion/
│       ├── ci_cd/
│       ├── db/
│       ├── frontend/
│       ├── iam/
│       ├── network/
│       ├── s3_media/
│       └── ssm/
├── README.md
```

---

## Infrastructure Modules

- **network/**: VPC, subnets (public, app, db), route tables, NAT, IGW, NACLs, security groups.
- **bastion/**: Bastion host for SSH access, restricted by security group and NACL.
- **db/**: RDS PostgreSQL instance, subnet group, parameter group, security group.
- **backend/**: ALB, EC2 Auto Scaling Group, ECR repository, IAM instance profile, user data for Dockerized app.
- **frontend/**: S3 static hosting, CloudFront distribution, OAI for secure S3 access.
- **s3_media/**: S3 bucket for media, VPC endpoint, encryption, public access block.
- **auth/**: Cognito user pool, client, domain for authentication.
- **api_gateway/**: HTTP API Gateway, CORS, integration with backend ALB.
- **ssm/**: SSM Parameter Store for sharing configuration and secrets.
- **ci_cd/**: CodePipeline, CodeBuild, S3 artifact bucket, IAM roles for CI/CD.
- **iam/**: S3 bucket policies, CloudFront OAI permissions.

---

## AWS Security Features

- **Network Isolation:** Private subnets for backend and database tiers.
- **Bastion Host:** Only way to SSH into private resources, access restricted by IP.
- **NACLs & Security Groups:** Layered security for all resources.
- **S3 Public Access Block:** All S3 buckets block public access by default.
- **IAM Least Privilege:** Fine-grained IAM roles and policies for all services.
- **Secrets Management:** All sensitive data stored in **AWS SSM Parameter Store** or **AWS Secrets Manager**.
- **HTTPS Everywhere:** CloudFront and ALB enforce HTTPS for all traffic.
- **Audit Logging:** **AWS CloudTrail** and S3 access logs can be enabled for compliance.

---

## Prerequisites

- [Terraform](https://www.terraform.io/) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/)
- Node.js >= 18.x, npm >= 9.x
- Docker (for local backend development and container builds)
- AWS account with sufficient permissions (admin recommended for initial setup)
- GitHub repository for CI/CD integration

---

## Deployment Guide

### 1. Infrastructure Provisioning (Terraform)

```sh
cd infrastructure
terraform init
terraform plan
terraform apply
```

- Review the plan before applying.
- Terraform will output resource endpoints (ALB DNS, CloudFront URL, Cognito IDs, S3 bucket names, etc.).
- All secrets and configuration parameters are stored in **AWS SSM Parameter Store**.

### 2. Backend Deployment (Node.js/Express)

- **CI/CD:** AWS CodePipeline and CodeBuild automatically build and deploy the backend from GitHub.
- **Manual (for development):**
  ```sh
  cd backend
  npm install
  # Build and run Docker container locally
  docker build -t blog-backend .
  docker run --env-file .env -p 8080:8080 blog-backend
  ```
- **Environment variables** are loaded from SSM in production.

### 3. Frontend Deployment (React/Vite)

- **CI/CD:** AWS CodePipeline and CodeBuild automatically build and deploy the frontend from GitHub.
- **Manual (for development):**
  ```sh
  cd frontend
  npm install
  npm run dev
  ```
- **Production build:**
  ```sh
  npm run build
  # Upload build/ directory to S3 (handled by CI/CD in production)
  ```

---

## Environment Variables & AWS Secrets Management

- **Backend:** Reads database credentials, Cognito IDs, S3 bucket names, and other secrets from **AWS SSM Parameter Store** at startup.
- **Frontend:** Uses Vite environment variables, injected by CodeBuild from SSM during build.
- **Never commit secrets to source control.** All sensitive values are managed via SSM or Secrets Manager.

---

## Authentication & Authorization (AWS Cognito)

- **User Management:** AWS Cognito User Pool for registration, login, password reset, and multi-factor authentication (optional).
- **Frontend:** Integrates with Cognito Hosted UI for OAuth2 flows.
- **Backend:** Validates JWT tokens from Cognito for all protected API routes.
- **Role-Based Access:** Extendable via Cognito groups and custom claims.

---

## File Uploads & Media Handling (Amazon S3)

- **Media Storage:** Authenticated users can upload files via the backend API.
- **Backend:** Generates pre-signed S3 URLs for secure, time-limited uploads and downloads.
- **S3 Bucket:** Media bucket is private, with access only via signed URLs and VPC endpoint.

---

## CI/CD Pipeline (AWS CodePipeline & CodeBuild)

- **Source:** GitHub repository triggers pipeline on push/PR.
- **Build:** CodeBuild builds Docker images for backend, static assets for frontend.
- **Deploy:** Backend Docker image pushed to ECR, deployed to EC2 ASG; frontend assets uploaded to S3 and invalidated in CloudFront.
- **Artifacts:** Stored in a dedicated S3 bucket for traceability.

---

## Monitoring & Logging (AWS CloudWatch)

- **Application Logs:** Backend logs to **CloudWatch Logs**.
- **Infrastructure Logs:** VPC flow logs, ALB access logs, S3 access logs (optional).
- **Alerts:** Can be configured via CloudWatch Alarms for CPU, memory, error rates, etc.
- **Audit:** **AWS CloudTrail** records all API activity.

---

## Cleaning Up AWS Resources

To destroy all resources and avoid ongoing AWS charges:

```sh
cd infrastructure
terraform destroy
```

---

## Troubleshooting

- **Terraform Errors:** Check AWS credentials, region, and permissions.
- **CI/CD Failures:** Review CodeBuild/CodePipeline logs in AWS Console.
- **Application Issues:** Check CloudWatch Logs for backend and frontend errors.
- **Networking Issues:** Verify security group and NACL rules, VPC subnet associations.

---

## References

- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform Modules](https://www.terraform.io/language/modules)
- [React + Vite Documentation](https://vitejs.dev/guide/)
- [Node.js Express Documentation](https://expressjs.com/)
- [AWS Cognito Documentation](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-identity-pools.html)
- [AWS CodePipeline Documentation](https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html)
- [AWS CloudWatch Documentation](https://docs.aws.amazon.com/cloudwatch/)

---

## License

MIT License

---

