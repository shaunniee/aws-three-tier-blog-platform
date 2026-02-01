# 1. IAM Role
resource "aws_iam_role" "ec2_backend_role" {
  name = "${var.name_prefix}-backend-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-backend-ec2-role"
  })
}

# 2. Attach SSM Managed Policy
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_backend_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# 3. Inline policy for secrets, S3, Cognito, logs, ECR
resource "aws_iam_role_policy" "ec2_backend_inline" {
  name = "${var.name_prefix}-backend-access-policy"
  role = aws_iam_role.ec2_backend_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Secrets Manager (RDS)
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue"],
        Resource = "${var.db_secret_arn}*"
      },
      # S3 (optional)
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
        Resource = ["${var.s3_arn}/*"]
      },
      # Cognito (optional)
      {
        Effect = "Allow",
        Action = [
          "cognito-idp:AdminGetUser",
          "cognito-idp:AdminConfirmSignUp",
          "cognito-idp:ListUsers",
          "cognito-idp:DescribeUserPool",
          "cognito-idp:DescribeUserPoolClient"
        ],
        Resource = [
          "${var.cog_user_pool_arn}",
          "${var.cog_user_pool_arn}/client/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ],
        Resource = [
          "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/${var.name_prefix}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = "*"
      },

    ]
  })
}

# 4. Instance Profile (attach role to EC2)
resource "aws_iam_instance_profile" "ec2_backend_profile" {
  name = "${var.name_prefix}-backend-ec2-instance-profile"
  role = aws_iam_role.ec2_backend_role.name
  tags = merge(var.tags, {
    Name = "${var.name_prefix}-backend-ec2-instance-profile"
  })
}