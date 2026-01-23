variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "admin_ip" {
  description = "List of trusted IP ranges allowed to access the bastion host"
  type        = string
  default     = "0.0.0.0/0"
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
}