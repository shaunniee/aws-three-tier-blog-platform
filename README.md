# AWS THREE TIER BLOG

This project demonstrates how to design and implement a production-grade three-tier web application on AWS, starting from VPC planning and ending with automated infrastructure and observability.

# VPC Build Requirements

This VPC is designed to support a production-style 3-tier AWS architecture with:
- Public access via ALB and Bastion host
- Private application and database tiers
- Secure outbound internet access via NAT
- DNS-based service discovery for AWS managed services

---

## 1. VPC Configuration

| Item | Value |
|----|----|
| VPC CIDR | 10.0.0.0/16 |
| Region | eu-west-1 |
| DNS Support | Enabled |
| DNS Hostnames | Enabled |
| Tenancy | Default |

---

## 2. Availability Zones

| AZ | Purpose |
|----|-------|
| eu-west-1a | High availability |
| eu-west-1b | High availability |

---

## 3. Subnet Design

### Subnet Allocation

| Subnet Name | AZ | CIDR | Type |
|----|----|----|----|
| blogapp-sub-pub-1 | eu-west-1a | 10.0.1.0/24 | Public |
| blogapp-sub-pub-2 | eu-west-1b | 10.0.2.0/24 | Public |
| blogapp-sub-app-1 | eu-west-1a | 10.0.11.0/24 | Private |
| blogapp-sub-app-2 | eu-west-1b | 10.0.12.0/24 | Private |
| blogapp-sub-db-1 | eu-west-1a | 10.0.21.0/24 | Private |
| blogapp-sub-db-2 | eu-west-1b | 10.0.22.0/24 | Private |

**Subnet Rules**
- Public subnets route to Internet Gateway
- Private subnets have no direct internet access
- Database subnets are fully isolated

---

## 4. Internet Gateway

| Item | Value |
|----|----|
| IGW | Attached to VPC |
| Used By | Public subnets only |

---

## 5. NAT Gateway

| Item | Value |
|----|----|
| NAT Gateways | 1 (cost-optimized) |
| Location | Public Subnet (eu-west-1a) |
| Elastic IP | Required |

**Purpose**
- Allows private subnets to access the internet for updates and AWS APIs
- Prevents inbound internet access

---

## 6. Route Tables

### Public Route Table

| Destination | Target |
|----|----|
| 10.0.0.0/16 | Local |
| 0.0.0.0/0 | Internet Gateway |

Associated with:
- blogapp-sub-pub-1
- blogapp-sub-pub-2

---

### Private App Route Table

| Destination | Target |
|----|----|
| 10.0.0.0/16 | Local |
| 0.0.0.0/0 | NAT Gateway |

Associated with:
- blogapp-sub-app-1
- blogapp-sub-app-2

---

### Private DB Route Table

| Destination | Target |
|----|----|
| 10.0.0.0/16 | Local |

Associated with:
- blogapp-sub-db-1
- blogapp-sub-db-2

---

## 7. Network ACLs (NACLs)

> Default NACL is replaced with custom NACLs for clarity.

### Public Subnet NACL

**Inbound Rules**

| Rule # | Type | Protocol | Port | Source | Action |
|----|----|----|----|----|----|
| 100 | HTTP | TCP | 80 | 0.0.0.0/0 | ALLOW |
| 110 | HTTPS | TCP | 443 | 0.0.0.0/0 | ALLOW |
| 120 | SSH | TCP | 22 | Admin IP | ALLOW |
| 140 | Ephemeral | TCP | 1024-65535 | 0.0.0.0/0 | ALLOW |

**Outbound Rules**

| Rule # | Type | Protocol | Port | Destination | Action |
|----|----|----|----|----|----|
| 100 | All Traffic | ALL | ALL | 0.0.0.0/0 | ALLOW |

---

### Private App Subnet NACL

**Inbound Rules**

| Rule # | Type | Protocol | Port | Source | Action |
|----|----|----|----|----|----|
| 100 | App Traffic | TCP | 8080 | Public Subnet CIDR | ALLOW |
| 110 | SSH | TCP | 22 | Bastion Subnet CIDR | ALLOW |
| 140 | Ephemeral | TCP | 1024-65535 | 0.0.0.0/0 | ALLOW |

**Outbound Rules**

| Rule # | Type | Protocol | Port | Destination | Action |
|----|----|----|----|----|----|
| 100 | DB Traffic | TCP | 5432 | DB Subnet CIDR | ALLOW |
| 110 | HTTPS | TCP | 443 | 0.0.0.0/0 | ALLOW |
| 140 | Ephemeral | TCP | 1024-65535 | 0.0.0.0/0 | ALLOW |

---

### Private DB Subnet NACL

**Inbound Rules**

| Rule # | Type | Protocol | Port | Source | Action |
|----|----|----|----|----|----|
| 100 | DB Traffic | TCP | 5432 | App Subnet CIDR | ALLOW |
| 140 | Ephemeral | TCP | 1024-65535 | App Subnet CIDR | ALLOW |

**Outbound Rules**

| Rule # | Type | Protocol | Port | Destination | Action |
|----|----|----|----|----|----|
| 140 | Ephemeral | TCP | 1024-65535 | App Subnet CIDR | ALLOW |

---

## 8. Security Groups

### Bastion Security Group

| Direction | Protocol | Port | Source/Destination |
|----|----|----|----|
| Inbound | TCP | 22 | Admin IP |
| Outbound | ALL | ALL | 0.0.0.0/0 |

---
### ALB secuirty group

| Direction | Protocol | Port | Source/Destination |
|----|----|----|----|
| Inbound | TCP | 80 | 0.0.0.0/0 |
| Inbound | TCP | 443 | 0.0.0.0/0 |
| Outbound | TCP | 8080 | EC2 Security Group |

---

### Application EC2 Security Group

| Direction | Protocol | Port | Source/Destination |
|----|----|----|----|
| Inbound | TCP | 8080 | ALB Security Group |
| Inbound | TCP | 22 | Bastion Security Group |
| Outbound | TCP | 5432 | DB Security Group |
| Outbound | TCP | 443 | 0.0.0.0/0 |

---

### Database Security Group

| Direction | Protocol | Port | Source/Destination |
|----|----|----|----|
| Inbound | TCP | 5432 | Application Security Group |
| Outbound | ALL | ALL | Application Security Group |

---

## 9. VPC Endpoints (Optional but Recommended)

| Service | Type |
|----|----|
| S3 | Gateway Endpoint |
| Secrets Manager | Interface Endpoint |
| CloudWatch Logs | Interface Endpoint |

---

