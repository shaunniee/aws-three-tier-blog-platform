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

output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.bastion.bastion_public_ip
}

output "db_username" {
  description = "The master username of the RDS DB instance"
  value       = module.database_rds.db_username
  
}

output "db_instance_endpoint" {
  description = "The endpoint of the RDS DB instance"
  value       = module.database_rds.db_instance_endpoint
}

output "db_name" {
  description = "The name of the RDS DB instance"
  value       = module.database_rds.db_name
  
}
output "db_port" {
  description = "The port of the RDS DB instance"
  value       = module.database_rds.db_port
  
}

output "s3_media_bucket_name" {
    description = "The name of the S3 Media Bucket"
    value       = module.s3_media_bucket.s3_media_bucket_name
  
}

output "cognito_user_pool_id" {
    description = "The ID of the Cognito User Pool"
    value       = module.auth.cognito_user_pool_id
  
}

output "cognito_client_id" {
    description = "The ID of the Cognito User Pool Client"
    value       = module.auth.cognito_client_id
}

output "db_secret_arn" {
  description = "The ARN of the RDS DB instance secret"
  value       = module.database_rds.db_secret_arn
  
}

output "s3_bucket_arn" {
    description = "The ARN of the S3 Media Bucket"
    value       = module.s3_media_bucket.s3_bucket_arn
  
}
output "cog_user_pool_arn" {
    description = "The ARN of the Cognito User Pool"
    value       = module.auth.cog_user_pool_arn
  
}
output "cf_public_dns" {
    description = "The CloudFront Public DNS"
    value       = module.frontend.cf_public_dns
  
}
