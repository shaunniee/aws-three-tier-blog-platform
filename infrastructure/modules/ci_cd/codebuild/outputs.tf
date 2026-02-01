output "codebuild_proj_name" {
    description = "code build proj name"
    value = aws_codebuild_project.backend_build.arn
  
}
output "codebuild_frontend_proj_name" {
    description = "code build proj name"
    value = aws_codebuild_project.frontend_build.arn
  
}