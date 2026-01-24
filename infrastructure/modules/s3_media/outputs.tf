output "s3_media_bucket_name" {
    description = "The name of the S3 Media Bucket"
    value       = aws_s3_bucket.s3_media.id
  
}