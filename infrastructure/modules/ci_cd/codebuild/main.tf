# IAM Role for CodeBuild

resource "aws_iam_role" "codebuild_role" {
  name = "blog-backend-codebuild-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{ Effect = "Allow", Principal = { Service = "codebuild.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}

# IAM Policy for CodeBuild Role
resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect  = "Allow",
        Action  = [
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage"
        ],
        Resource = "arn:aws:ecr:${var.aws_region}:${var.aws_account_id}:blog-backend/*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = [
          "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/codebuild/*",
          "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/codebuild/*:log-stream:*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "autoscaling:StartInstanceRefresh",
          "autoscaling:DescribeAutoScalingGroups"
        ],
        Resource = "arn:aws:autoscaling:${var.aws_region}:${var.aws_account_id}:autoScalingGroup:*:autoScalingGroupName/${var.asg_name}"
      }
    ]
  })
}

# IAM Policy for Frontend CodeBuild Role
resource "aws_iam_role_policy" "frontend_codebuild_policy" {
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        Resource = [
          var.s3_arn,
          "${var.s3_arn}/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = ["cloudfront:CreateInvalidation"],
        Resource = var.cloudfront_arn
      }
    ]
  })
}
# IAM Policy for CodeBuild Role to access Artifacts and SSM Parameters
resource "aws_iam_role_policy" "codebuild_artifacts_access" {
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
        Resource = "arn:aws:s3:::${var.codepipeline_artifact_bucket}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = [
          "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/${var.name_prefix}/*"
        ]
      }

    ]
  })
}



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
      value = var.aws_account_id
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }
    environment_variable {
      name  = "ASG_NAME"
      value = var.asg_name
    }
  }

  artifacts { type = "NO_ARTIFACTS" }
}

resource "aws_codebuild_project" "frontend_build" {
  name         = "blog-frontend-build"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "CODEPIPELINE" # using pipeline artifact
    buildspec = "frontend/buildspec.yml"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "FRONTEND_BUCKET"
      value = var.s3_hosting_bucket
    }

    environment_variable {
      name  = "CLOUDFRONT_ID"
      value = var.cf_id
    }
    environment_variable {
      name  = "VITE_API_BASE_URL"
      type  = "PARAMETER_STORE"
      value = "/${var.name_prefix}/alb/dns"
    }
    environment_variable {
      name  = "VITE_COGNITO_USER_POOL_ID"
      type  = "PARAMETER_STORE"
      value = "/${var.name_prefix}/cognito/user_pool_id"
    }
    environment_variable {
      name  = "VITE_COGNITO_CLIENT_ID"
      type  = "PARAMETER_STORE"
      value = "/${var.name_prefix}/cognito/app_client_id"
    }

    environment_variable {
      name  = "VITE_COGNITO_DOMAIN"
      type  = "PARAMETER_STORE"
      value = "/${var.name_prefix}/cognito/domain"
    }
    environment_variable {
      name  = "VITE_CALLBACK_URL"
      type  = "PARAMETER_STORE"
      value = "/${var.name_prefix}/cloudfront/public_dns"
    }


  }

  artifacts { type = "CODEPIPELINE" }
}