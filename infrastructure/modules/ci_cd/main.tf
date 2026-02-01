
# artifact S3 Module
module "s3_artifact" {
  source = "./artifact"
  name_prefix = var.name_prefix
  tags        = var.tags
  aws_region = var.aws_region
  aws_account_id = var.aws_account_id
}

# CodeBuild Module
module "codebuild" {
  source                       = "./codebuild"
  codepipeline_artifact_bucket = module.s3_artifact.s3_artifact_name
  asg_name                     = var.asg_name
  s3_arn                       = var.s3_arn
  cf_id                        = var.cf_id
  s3_hosting_bucket            = var.s3_hosting_bucket
  name_prefix                  = var.name_prefix
  aws_account_id               = var.aws_account_id
  aws_region                   = var.aws_region
  cloudfront_arn               = var.cloudfront_arn
}

# CodePipeline Module
module "codepipeline" {
  source                       = "./codepipeline"
  codepipeline_artifact_bucket = module.s3_artifact.s3_artifact_name
  s3_artifact_arn              = module.s3_artifact.a3_artifact_arn
  codebuild_proj_name          = module.codebuild.codebuild_proj_name
  codebuild_frontend_proj_name = module.codebuild.codebuild_frontend_proj_name
  github_oauth_token = var.github_oauth_token
}