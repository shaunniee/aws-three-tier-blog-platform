
output "subnet_ids" {
  description = "List of subnet IDs"
  value       = module.vpc.subnet_ids
}

output "subnet_info" {
  description = "Detailed information about subnets"
  value       = module.vpc.subnet_info
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.igw.igw_id

}

output "nat_gw_id" {
  description = "The ID of the NAT Gateway"
  value       = module.nat.nat_gw_id
}


output "sg_bastion_id" {
  description = "The ID of the Bastion Security Group"
  value       = module.security_group.sg_bastion_id
}

output "sg_alb_id" {
  description = "The ID of the ALB Public Security Group"
  value       = module.security_group.sg_alb_id
}

output "sg_asg_id" {
  description = "The ID of the ASG Private Security Group"
  value       = module.security_group.sg_asg_id
}

output "sg_db_id" {
  description = "The ID of the DB Security Group"
  value       = module.security_group.sg_db_id
}

output "app_rt_id" {
  description = "The ID of the application route table"
  value       = module.route_table.app_rt_id

}