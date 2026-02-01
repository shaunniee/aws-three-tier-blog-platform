variable "name_prefix" {
  description = "Prefix for naming the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC where the S3 VPC endpoint will be created"
  type        = string

}

variable "subnet_ids" {
  description = "A map of subnet IDs categorized by type (e.g., app, db)"
  type        = map(list(string))
}

variable "app_rt_id" {
  description = "The ID of the application route table"
  type        = string

}