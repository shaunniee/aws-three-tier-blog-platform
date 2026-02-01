output "asg_name" {
  description = "asg name"
  value       = aws_autoscaling_group.backend_asg.name
}

output "alb_public_dns" {
  description = "The public DNS of the ALB"
  value       = aws_lb.backend_alb.dns_name
}