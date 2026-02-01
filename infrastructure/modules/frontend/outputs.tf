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
    value = module.cloudfront.cf_public_dns
  
}