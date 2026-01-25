variable "codepipeline_artifact_bucket" {
    description = "s3_artifact_bucket"
    type = string
  
}

variable "github_oauth_token" {
  description = "GitHub OAuth token for CodePipeline"
  type        = string
  sensitive   = true
}
variable "codebuild_proj_name" {
    description = "Codebuild proj name"
    type = string
  
}