output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = local.subnets_by_tier
}

output "subnet_info" {
  description = "Detailed information about subnets"
  value       = local.subnet_info
}