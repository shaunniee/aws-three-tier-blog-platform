
module "network" {
  source             = "./modules/network"
  vpc_cidr           = var.vpc_cidr
  subnets            = var.subnets
  name_prefix        = var.name_prefix
  tags               = var.tags
  no_of_azs          = var.no_of_azs
}

module "igw" {
  source      = "./modules/igw"
  vpc_id      = module.network.vpc_id
  name_prefix = var.name_prefix
  tags        = var.tags
}

module "security_group" {
  source       = "./modules/security"
  vpc_id       = module.network.vpc_id
  name_prefix  = var.name_prefix
  tags         = var.tags 
}

# module "nat" {
#   source            = "./modules/nat"
#   vpc_id            = module.network.vpc_id
#   public_subnet_id = module.network.subnet_info["pub-1"].id
#   tags              = var.tags
#   name_prefix       = var.name_prefix

# }

module "route_table" {
  source             = "./modules/routetable"
  vpc_id             = module.network.vpc_id
  igw_id             = module.igw.igw_id
  nat_gw_id          = module.nat.nat_gw_id
  subnet_ids         = module.network.subnet_ids
  name_prefix        = var.name_prefix
  tags               = var.tags
}


module "nacl" {
  source             = "./modules/nacl"
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.subnet_ids["pub"]
  app_subnet_ids     = module.network.subnet_ids["app"]
  db_subnet_ids      = module.network.subnet_ids["db"]
  name_prefix        = var.name_prefix
  tags               = var.tags
  public_subnet_cidr = var.subnets["pub"]
  app_subnet_cidr    = var.subnets["app"]
  db_subnet_cidr     = var.subnets["db"]

}