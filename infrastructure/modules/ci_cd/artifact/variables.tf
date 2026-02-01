variable "aws_region" {
  description = "Region"
  type        = string
}
variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}
variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}
variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}