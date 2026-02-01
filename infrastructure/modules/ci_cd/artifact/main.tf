
# Random suffix to avoid bucket name collision
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create S3 bucket for CodePipeline artifacts
resource "aws_s3_bucket" "codepipeline_artifacts" {
  force_destroy = true
  bucket = "blogapp-codepipeline-artifacts-${var.aws_region}-${random_id.bucket_suffix.hex}"
  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-codepipeline-artifacts"
    Environment = "CI/CD"
  })
}


resource "aws_s3_bucket_public_access_block" "codepipeline_artifacts_public_access" {
  bucket = aws_s3_bucket.codepipeline_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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