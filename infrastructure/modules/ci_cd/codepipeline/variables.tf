variable "codepipeline_artifact_bucket" {
  description = "s3_artifact_bucket"
  type        = string

}

variable "github_oauth_token" {
  description = "GitHub OAuth token for CodePipeline"
  type        = string
  sensitive   = true
}
variable "codebuild_proj_name" {
  description = "Codebuild proj name"
  type        = string

}
variable "codebuild_frontend_proj_name" {
  description = "Codebuild frontend proj name"
  type        = string

}
variable "s3_artifact_arn" {
  description = "The ARN of the S3 Artifact Bucket"
  type        = string
}