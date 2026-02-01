output "s3_arn" {
  value = module.s3_hosting.s3_arn
}

output "cf_id" {
  value = module.cf.cf_id
}

output "s3_hosting_bucket" {
  value = module.s3_hosting.s3_hosting_bucket
}
output "cf_public_dns" {
  value = module.cf.cf_public_dns
}

output "cf_oai_iam_arn" {
  value = module.cf.cf_oai_iam_arn
}
output "cloudfront_arn" {
  value = module.cf.cloudfront_arn
}