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
