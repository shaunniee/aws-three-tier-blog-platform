variable "db_endpoint" {
  description = "Database endpoint"
  type        = string
}
variable "db_port" {
  description = "Database port"
  type        = number
}
variable "db_name" {
  description = "Database name"
  type        = string
}
variable "db_username" {
    description = "Database username"
    type        = string
  
}
variable "s3_media_bucket_name" {
    description = "S3 Media Bucket Name"
    type        = string
}

variable "db_secret_arn" {
    description = "The ARN of the RDS DB instance secret"
    type        = string
  
}

variable "cognito_client_id" {
    description = "The ID of the Cognito User Pool Client"
    type        = string
  
}
variable "cognito_user_pool_id" {
    description = "The ID of the Cognito User Pool"
    type        = string
  
}