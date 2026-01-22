

module "vpc" {
  source    = "./modules/vpc"
  no_of_azs = 2
  vpc_cidr  = "10.0.0.0/16"
  subnets = {
    pub = ["10.0.1.0/24", "10.0.2.0/24"]
    app    = ["10.0.11.0/24", "10.0.12.0/24"]
    db     = ["10.0.21.0/24", "10.0.22.0/24"]
  }
  name_prefix = local.name_prefix
  tags        = var.tags
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = module.vpc.subnet_ids
}
output "subnet_info" {
  description = "Detailed information about subnets"
  value       = module.vpc.subnet_info
}