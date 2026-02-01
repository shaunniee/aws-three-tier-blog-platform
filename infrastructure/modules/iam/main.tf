# IAM Policy to allow CloudFront OAI to access S3 Bucket

resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = var.frontend_bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "${var.frontend_oai_iam_arn}"
        },
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::${var.frontend_bucket}/*"
      }
    ]
  })
}
