
resource "aws_ecr_repository" "blogapp_backend_repo" {
    name = "blog-backend"

  image_scanning_configuration {
    scan_on_push = true
  }
}

module "s3_artifact" {
  source = "./artifact"
}

module "codebuild" {
  source = "./codebuild"
    codepipeline_artifact_bucket= module.s3_artifact.s3_artifact_name
    asg_name = var.asg_name
    s3_arn=var.s3_arn
    cf_id=var.cf_id
    s3_hosting_bucket= var.s3_hosting_bucket
    
    
}

module "codepipeline" {
  source = "./codepipeline"
  codepipeline_artifact_bucket= module.s3_artifact.s3_artifact_name
  codebuild_proj_name= module.codebuild.codebuild_proj_name
  codebuild_frontend_proj_name= module.codebuild.codebuild_frontend_proj_name
  
  github_oauth_token = var.github_oauth_token

}