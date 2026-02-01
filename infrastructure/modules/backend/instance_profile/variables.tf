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

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string 
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}