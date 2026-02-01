variable "name_prefix" {
    description = "Prefix for naming resources"
    type        = string
  
}

variable "tags" {
    description = "A map of tags to assign to resources"
    type        = map(string)
    default     = {}
  
}
variable "frontend_bucket" {
  description = "The name of the frontend S3 hosting bucket"
  type        = string
}

variable "frontend_oai_iam_arn" {
  description = "The IAM ARN of the CloudFront Origin Access Identity"
  type        = string
}

