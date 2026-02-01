output "s3_artifact_name" {
    description = "Artifact"
    value=aws_s3_bucket.codepipeline_artifacts.bucket
  
}