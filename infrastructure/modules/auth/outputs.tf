output "cognito_user_pool_id" {
    description = "The ID of the Cognito User Pool"
    value       = aws_cognito_user_pool.user_pool.id
  
}

output "cognito_client_id" {
    description = "The ID of the Cognito User Pool Client"
    value       = aws_cognito_user_pool_client.user_pool_client.id
  
}

output "cog_user_pool_arn" {
    description = "The ARN of the Cognito User Pool"
    value       = aws_cognito_user_pool.user_pool.arn
  
}
output "cognito_domain" {
    description = "The domain of the Cognito User Pool"
    value       = aws_cognito_user_pool_domain.blog_domain.domain
  
}