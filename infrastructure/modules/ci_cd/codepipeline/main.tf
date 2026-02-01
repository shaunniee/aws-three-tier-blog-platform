
resource "aws_iam_role" "codepipeline_role" {
  name = "blog-backend-codepipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect = "Allow", Principal = { Service = "codepipeline.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  role = aws_iam_role.codepipeline_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["codebuild:BatchGetBuilds","codebuild:StartBuild"], Resource = var.codebuild_proj_name },
      { Effect = "Allow", Action = ["s3:GetObject","s3:GetObjectVersion","s3:PutObject"], Resource = "*" }
    ]
  })
}



resource "aws_codepipeline" "backend_pipeline" {
  name     = "blog-backend-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    type     = "S3"
    location = var.codepipeline_artifact_bucket
  }

  stage {
    name = "Source"
    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
  Owner      = "shaunniee"
  Repo       = "aws-three-tier-blog-platform"
  Branch     = "main"
  OAuthToken = var.github_oauth_token
}
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Docker_Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = []
      version          = "1"
      configuration = {
        ProjectName = var.codebuild_proj_name
      }
    }
  }

  stage {
  name = "Build_Frontend"
  action {
    name             = "Build_Frontend"
    category         = "Build"
    owner            = "AWS"
    provider         = "CodeBuild"
    version          = "1"
    input_artifacts  = ["source_output"]
    output_artifacts = []
    configuration = {
      ProjectName = var.codebuild_frontend_proj_name
    }
  }
}
}