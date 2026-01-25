variable "AWS_REGION" {
    description = "Aws region"
    default = "eu-west-1"
  
}

variable "github_repo_url" {
    description="Github repo"
    type = string
    default = "https://github.com/shaunniee/aws-three-tier-blog-platform.git"
  
}

variable "github_oauth_token" {
  description = "GitHub OAuth token for CodePipeline"
  type        = string
  sensitive   = true
}