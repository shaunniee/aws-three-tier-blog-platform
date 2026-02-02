# Get current AWS account ID
data "aws_caller_identity" "current" {}


module "network" {
  source    = "./modules/network"
  no_of_azs = 2
  vpc_cidr  = "10.0.0.0/16"
  subnets = {
    pub = ["10.0.1.0/24", "10.0.2.0/24"]
    app = ["10.0.11.0/24", "10.0.12.0/24"]
    db  = ["10.0.21.0/24", "10.0.22.0/24"]
  }
  name_prefix = local.name_prefix
  tags        = var.tags
}

module "bastion" {
  source        = "./modules/bastion"
  bastion_sg_id = module.network.sg_bastion_id
  subnet_ids    = module.network.subnet_ids
  name_prefix   = local.name_prefix
  tags          = var.tags
}

module "frontend" {
  source = "./modules/frontend"
  name_prefix = local.name_prefix
  tags        = var.tags
}

module "backend" {
  source            = "./modules/backend"
  aws_account_id    = data.aws_caller_identity.current.account_id
  aws_region        = var.aws_region
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.subnet_ids
  app_sg_id         = module.network.sg_asg_id
  alb_sg_id         = module.network.sg_alb_id
  s3_arn            = module.s3_media_bucket.s3_bucket_arn
  db_secret_arn     = module.database_rds.db_secret_arn
  cog_user_pool_arn = module.auth.cog_user_pool_arn
  name_prefix       = local.name_prefix
  tags              = var.tags
  enable_backend    = var.enable_backend

}

module "api_gateway" {
  source          = "./modules/api_gateway"
  backend_alb_dns = module.backend.alb_public_dns
  cf_public_dns   = module.frontend.cf_public_dns
  name_prefix     = local.name_prefix
  tags            = var.tags
}

module "database_rds" {
  source      = "./modules/db"
  subnet_ids  = module.network.subnet_ids
  db_sg_id    = module.network.sg_db_id
  name_prefix = local.name_prefix
}

module "s3_media_bucket" {
  source      = "./modules/s3_media"
  name_prefix = var.name_prefix
  tags        = var.tags
  vpc_id      = module.network.vpc_id
  subnet_ids  = module.network.subnet_ids
  app_rt_id   = module.network.app_rt_id
}

module "auth" {
  source        = "./modules/auth"
  cf_public_dns = module.frontend.cf_public_dns
  name_prefix   = var.name_prefix
  tags          = var.tags
}

module "ci_cd" {
  source             = "./modules/ci_cd"
  name_prefix        = local.name_prefix
  tags               = var.tags
  aws_region        = var.aws_region
  aws_account_id    = data.aws_caller_identity.current.account_id
  github_oauth_token = var.github_oauth_token
  asg_name           = module.backend.asg_name
  s3_arn             = module.frontend.s3_arn
  cf_id              = module.frontend.cf_id
  s3_hosting_bucket  = module.frontend.s3_hosting_bucket
  cloudfront_arn     = module.frontend.cloudfront_arn
  github_repo_url = var.github_repo_url
  
}

module "ssm" {
  source               = "./modules/ssm"
  name_prefix          = local.name_prefix
  db_endpoint          = module.database_rds.db_instance_endpoint
  db_port              = module.database_rds.db_port
  db_name              = module.database_rds.db_name
  db_username          = module.database_rds.db_username
  s3_media_bucket_name = module.s3_media_bucket.s3_media_bucket_name
  db_secret_arn        = module.database_rds.db_secret_arn
  cognito_user_pool_id = module.auth.cognito_user_pool_id
  cognito_client_id    = module.auth.cognito_client_id
  cognito_domain       = "https://${module.auth.cognito_domain}.auth.${var.aws_region}.amazoncognito.com"
  alb_dns              = module.api_gateway.api_gateway_url
  cf_public_dns        = module.frontend.cf_public_dns
}

module "iam" {
  source      = "./modules/iam"
  name_prefix = local.name_prefix
  tags        = var.tags
  frontend_bucket = module.frontend.s3_hosting_bucket
  frontend_oai_iam_arn = module.frontend.cf_oai_iam_arn
}