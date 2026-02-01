output "cf_id" {
  description = "The ID of the CloudFront Distribution"
  value = aws_cloudfront_distribution.frontend_cdn.id
}

output "cf_public_dns" {
  description = "The public DNS of the CloudFront Distribution"
  value = aws_cloudfront_distribution.frontend_cdn.domain_name

}

output "cf_oai_iam_arn" {
  description = "The Origin Access Identity for CloudFront to access S3"
  value       = aws_cloudfront_origin_access_identity.frontend_oai.iam_arn
}
output "cloudfront_arn" {
  description = "The ARN of the CloudFront Distribution"
  value       = aws_cloudfront_distribution.frontend_cdn.arn
}