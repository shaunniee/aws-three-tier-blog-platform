output "db_instance_id" {
  description = "The ID of the RDS DB instance"
  value       = aws_db_instance.rds_main.id
}

output "db_instance_endpoint" {
  description = "The endpoint of the RDS DB instance"
  value       = aws_db_instance.rds_main.endpoint
}



