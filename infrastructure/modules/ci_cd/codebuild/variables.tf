
variable "github_repo_url" {
  description = "Github repo"
  type        = string
  default     = ""

}

variable "codepipeline_artifact_bucket" {
  description = "artifact bucket"
  type        = string

}
variable "asg_name" {
  description = "The name of the Auto Scaling Group"
  type = string

}

variable "s3_arn" {
  description = "The ARN of the S3 Media Bucket"
  type = string

}

variable "cf_id" {
  description = "The ID of the CloudFront Distribution"
  type = string

}
variable "s3_hosting_bucket" {
  description = "The name of the S3 Hosting Bucket"
  type = string

}
variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string

}
variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  
}
variable "cloudfront_arn" {
  description = "The ARN of the CloudFront Distribution"
  type        = string
}