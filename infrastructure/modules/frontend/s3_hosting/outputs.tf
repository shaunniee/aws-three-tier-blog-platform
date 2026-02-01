output "s3_regional_domain" {
  description = "The regional domain name of the S3 Hosting Bucket"
  value = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
}

output "s3_arn" {
  description = "The ARN of the S3 Hosting Bucket"
  value       = aws_s3_bucket.frontend_bucket.arn
}

output "s3_hosting_bucket" {
  description = "The name of the S3 Hosting Bucket"
  value = aws_s3_bucket.frontend_bucket.bucket
}

