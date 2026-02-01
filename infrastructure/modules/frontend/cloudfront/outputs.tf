output "cf_id" {
    value = aws_cloudfront_distribution.frontend_cdn.id
}

output "cf_public_dns" {
    value = aws_cloudfront_distribution.frontend_cdn.domain_name
  
}