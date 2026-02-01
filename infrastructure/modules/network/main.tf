
module "vpc" {
  source      = "./submodules/vpc"
  vpc_cidr    = var.vpc_cidr
  subnets     = var.subnets
  name_prefix = var.name_prefix
  tags        = var.tags
  no_of_azs   = var.no_of_azs
}

module "igw" {
  source      = "./submodules/igw"
  vpc_id      = module.vpc.vpc_id
  name_prefix = var.name_prefix
  tags        = var.tags
}

module "security_group" {
  source      = "./submodules/security"
  vpc_id      = module.vpc.vpc_id
  name_prefix = var.name_prefix
  tags        = var.tags
}

module "nat" {
  source           = "./submodules/nat"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.subnet_info["pub-1"].id
  tags             = var.tags
  name_prefix      = var.name_prefix
}

module "route_table" {
  source      = "./submodules/routetable"
  vpc_id      = module.vpc.vpc_id
  igw_id      = module.igw.igw_id
  nat_gw_id   = module.nat.nat_gw_id
  subnet_ids  = module.vpc.subnet_ids
  name_prefix = var.name_prefix
  tags        = var.tags
}

module "nacl" {
  source             = "./submodules/nacl"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.subnet_ids["pub"]
  app_subnet_ids     = module.vpc.subnet_ids["app"]
  db_subnet_ids      = module.vpc.subnet_ids["db"]
  public_subnet_cidr = var.subnets["pub"]
  app_subnet_cidr    = var.subnets["app"]
  db_subnet_cidr     = var.subnets["db"]
  name_prefix        = var.name_prefix
  tags               = var.tags
}

