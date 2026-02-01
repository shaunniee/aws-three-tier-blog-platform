output "s3_regional_domain" {
    value = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
  
}

output "s3_arn" {
    description = "s3 arn"
    value = aws_s3_bucket.frontend_bucket.arn
}

output "s3_hosting_bucket" {
    value = aws_s3_bucket.frontend_bucket.bucket
  
}

output "cf_public_dns" {
    value = module.cloudfront.cf_public_dns
  
}