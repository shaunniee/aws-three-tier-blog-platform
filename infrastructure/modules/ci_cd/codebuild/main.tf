resource "aws_iam_role" "codebuild_role" {
  name = "blog-backend-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect = "Allow", Principal = { Service = "codebuild.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["ecr:*","logs:*","autoscaling:StartInstanceRefresh","autoscaling:DescribeAutoScalingGroups"], Resource = "*" }
    ]
  })
}

data "aws_caller_identity" "current" {}


resource "aws_codebuild_project" "backend_build" {
  name         = "blog-backend-build"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type            = "GITHUB"
    location        = var.github_repo_url
    git_clone_depth = 1
    buildspec       = "backend/buildspec.yml"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
     environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }
    
    environment_variable {
      name  = "AWS_REGION"
      value = var.AWS_REGION
    }
  }

  artifacts { type = "NO_ARTIFACTS" }
}