variable "AWS_REGION" {
    description = "Aws region"
    default = "eu-west-1"
  
}

variable "github_repo_url" {
    description="Github repo"
    type = string
    default = "https://github.com/shaunniee/aws-three-tier-blog-platform.git"
  
}

variable "codepipeline_artifact_bucket" {
    description = "artifact bucket"
    type = string
  
}
variable "asg_name" {
    type = string
  
}