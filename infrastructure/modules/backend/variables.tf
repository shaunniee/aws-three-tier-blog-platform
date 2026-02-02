variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
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

variable "s3_arn" {
  description = "The ARN of the S3 Media Bucket"
  type        = string
}

variable "db_secret_arn" {
  description = "The ARN of the RDS DB Secret"
  type        = string

}
variable "cog_user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  type        = string
}

variable "enable_backend" {
  description = "Enable EC2 userdata for backend"
  type        = bool
  default     = false
  
}