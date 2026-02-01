module "s3_hosting" {
    source = "./s3_hosting"
  
}

module "cf" {
    source = "./cloudfront"
    bucket_regional_domain_name= module.s3_hosting.s3_regional_domain
}