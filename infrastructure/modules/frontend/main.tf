module "s3_hosting" {
  source = "./s3_hosting"
  name_prefix = var.name_prefix
  tags        = var.tags
}

module "cf" {
  source                      = "./cloudfront"
  bucket_regional_domain_name = module.s3_hosting.s3_regional_domain
  frontend_bucket             = module.s3_hosting.s3_hosting_bucket
  name_prefix                 = var.name_prefix
  tags                        = var.tags
}