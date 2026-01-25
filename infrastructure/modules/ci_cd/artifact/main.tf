# Create S3 bucket for CodePipeline artifacts
resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = "blogapp-codepipeline-artifacts-${var.aws_region}-${random_id.bucket_suffix.hex}"
  tags = {
    Name = "blogapp-codepipeline-artifacts"
  }
}

resource "aws_s3_bucket_acl" "s3_acl" {
  bucket = aws_s3_bucket.codepipeline_artifacts.id
  acl = "private"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.codepipeline_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Random suffix to avoid bucket name collision
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Optional: enforce lifecycle to clean old versions
resource "aws_s3_bucket_lifecycle_configuration" "artifacts_lifecycle" {
  bucket = aws_s3_bucket.codepipeline_artifacts.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}