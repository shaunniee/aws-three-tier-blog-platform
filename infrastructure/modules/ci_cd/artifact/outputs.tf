output "s3_artifact_name" {
  description = "Artifact"
  value       = aws_s3_bucket.codepipeline_artifacts.bucket
}

output "a3_artifact_arn" {
  description = "Artifact S3 Bucket ARN"
  value       = aws_s3_bucket.codepipeline_artifacts.arn
  
}