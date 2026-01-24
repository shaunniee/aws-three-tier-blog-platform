variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}


variable "subnet_ids" {
  description = "Subnet IDs for the backend instances"
  type        = map(list(string))
}

variable "app_sg_id" {
  description = "Security Group ID for the backend instances"
  type        = string
}

variable "alb_sg_id" {
  description = "Security Group ID for the ALB"
  type        = string
}

variable "app_user_data" {
  description = "User data script for backend EC2"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    # Update packages
    sudo yum update -y

    # Install nginx
    sudo amazon-linux-extras install -y nginx1
    sudo systemctl enable nginx
    sudo systemctl start nginx
EOF
}
