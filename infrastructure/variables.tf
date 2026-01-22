variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default = {
    Environment = "development"
    Project     = "Three-Tier Blog App"
  }
}

variable "no_of_azs" {
  description = "Number of availability zones to use"
  type        = number
}

locals {
  name_prefix = "blogapp"
}

variable "subnets" {
  description = "A map of subnet types to subnet IDs"
  type        = map(list(string))
  default = {
    pub = []
    app    = []
    db     = []
  }
}


