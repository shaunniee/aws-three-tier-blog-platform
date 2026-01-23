output "subnet_ids" {
  description = "List of subnet IDs"
  value       = module.vpc.subnet_ids
}
output "subnet_info" {
  description = "Detailed information about subnets"
  value       = module.vpc.subnet_info
}

output "sg_bastion_id" {
  description = "The ID of the Bastion Security Group"
  value = module.vpc.sg_bastion_id
}

output "sg_alb_id" {
  description = "The ID of the ALB Public Security Group"
  value = module.vpc.sg_alb_id
}
output "sg_asg_id" {
  description = "The ID of the ASG Private Security Group"
  value = module.vpc.sg_asg_id
}

output "sg_db_id" {
  description = "The ID of the DB Security Group"
  value = module.vpc.sg_db_id
}

output "nat_gw_id" {
  description = "The ID of the NAT Gateway"
  value       = module.vpc.nat_gw_id
}