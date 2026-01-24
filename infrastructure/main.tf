

module "vpc" {
  source    = "./modules/vpc"
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
  source         = "./modules/bastion"
  bastion_sg_id = module.vpc.sg_bastion_id
  subnet_ids     = module.vpc.subnet_ids
  name_prefix    = local.name_prefix
}

module "backend" {
  source          = "./modules/backend"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.subnet_ids
  app_sg_id      = module.vpc.sg_asg_id
  alb_sg_id      = module.vpc.sg_alb_id
  name_prefix     = local.name_prefix
  tags           = var.tags
}

module "database_rds" {
  source         = "./modules/db"
  subnet_ids     = module.vpc.subnet_ids
  db_sg_id      = module.vpc.sg_db_id
  name_prefix    = local.name_prefix
}

module "s3_media_bucket" {
  source      = "./modules/s3_media"
  name_prefix = var.name_prefix
  tags        = var.tags
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.subnet_ids
  app_rt_id   = module.vpc.app_rt_id
}

module "auth" {
  source      = "./modules/auth"
  name_prefix = var.name_prefix
  tags        = var.tags
}


module "ssm" {
  source      = "./modules/ssm"
  db_endpoint = module.database_rds.db_instance_endpoint
  db_port     = module.database_rds.db_port
  db_name     = module.database_rds.db_name
  db_username = module.database_rds.db_username
  s3_media_bucket_name = module.s3_media_bucket.s3_media_bucket_name
  db_secret_arn = module.database_rds.db_secret_arn
  cognito_user_pool_id = module.auth.cognito_user_pool_id
  cognito_client_id = module.auth.cognito_client_id
  

}