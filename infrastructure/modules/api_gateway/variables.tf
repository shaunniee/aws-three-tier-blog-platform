variable "backend_alb_dns" {
  description = "The DNS name of the backend ALB"
  type        = string
  
}
variable "cf_public_dns" {
  description = "The public DNS name of the CloudFront distribution"
  type        = string
  
}