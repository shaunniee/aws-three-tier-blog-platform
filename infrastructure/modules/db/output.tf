output "db_instance_id" {
  description = "The ID of the RDS DB instance"
  value       = aws_db_instance.rds_main.id
}

output "db_instance_endpoint" {
  description = "The endpoint of the RDS DB instance"
  value       = aws_db_instance.rds_main.address
}


output "db_name" {
  description = "The name of the RDS DB instance"
  value       = aws_db_instance.rds_main.db_name

}

output "db_username" {
  description = "The master username of the RDS DB instance"
  value       = aws_db_instance.rds_main.username

}

output "db_port" {
  description = "The port of the RDS DB instance"
  value       = aws_db_instance.rds_main.port

}

output "db_secret_arn" {
  description = "The ARN of the RDS DB instance secret"
  value       = aws_db_instance.rds_main.master_user_secret[0].secret_arn

}