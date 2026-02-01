variable "bucket_regional_domain_name" {
  description = "The regional domain name of the S3 Hosting Bucket"
  type = string
}
variable "frontend_bucket" {
  description = "The name of the S3 Hosting Bucket"
  type = string
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