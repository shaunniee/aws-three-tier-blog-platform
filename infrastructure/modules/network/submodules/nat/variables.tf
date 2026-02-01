variable "public_subnet_id" {
  description = "Public subnet ID for NAT gateway"
  type        = string
}
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
}
