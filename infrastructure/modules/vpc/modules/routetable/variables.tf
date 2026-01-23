variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}

variable "igw_id" {
  description = "The ID of the Internet Gateway"
  type        = string
}

variable "nat_gw_id" {
  description = "The ID of the NAT Gateway"
  type        = string
}

variable "subnet_ids" {
  description = "Map of subnet IDs"
  type        = map(list(string))
}