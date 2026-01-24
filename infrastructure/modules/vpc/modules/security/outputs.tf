output "sg_bastion_id" {
  description = "The ID of the Bastion Security Group"
  value       = aws_security_group.bastion_sg.id
}

output "sg_alb_id" {
  description = "The ID of the ALB Public Security Group"
  value       = aws_security_group.alb_pub_sg.id
}
output "sg_asg_id" {
  description = "The ID of the ASG Private Security Group"
  value       = aws_security_group.asg_priv_sg.id
}

output "sg_db_id" {
  description = "The ID of the DB Security Group"
  value       = aws_security_group.db_sg.id
}