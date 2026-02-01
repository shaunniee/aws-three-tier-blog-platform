resource "aws_ssm_parameter" "db_endpoint" {
  name  = "/${var.name_prefix}/database/endpoint"
  type  = "String"
  value = var.db_endpoint
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/${var.name_prefix}/database/port"
  type  = "String"
  value = tostring(var.db_port)

}

resource "aws_ssm_parameter" "db_name" {
  name  = "/${var.name_prefix}/database/name"
  type  = "String"
  value = var.db_name
}
resource "aws_ssm_parameter" "db_username" {
  name  = "/${var.name_prefix}/database/username"
  type  = "String"
  value = var.db_username
}


resource "aws_ssm_parameter" "s3_media_bucket_name" {
  name  = "/${var.name_prefix}/s3/media/bucket/name"
  type  = "String"
  value = var.s3_media_bucket_name
}

resource "aws_ssm_parameter" "db_secret_arn" {
  name  = "/${var.name_prefix}/db/secret_arn"
  type  = "String"
  value = var.db_secret_arn
}
resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name  = "/${var.name_prefix}/cognito/user_pool_id"
  type  = "String"
  value = var.cognito_user_pool_id
}

resource "aws_ssm_parameter" "cognito_client_id" {
  name  = "/${var.name_prefix}/cognito/app_client_id"
  type  = "String"
  value = var.cognito_client_id
}

resource "aws_ssm_parameter" "cognito_domain" {
  name  = "/${var.name_prefix}/cognito/domain"
  type  = "String"
  value = var.cognito_domain
}

resource "aws_ssm_parameter" "alb_dns" {
  name  = "/${var.name_prefix}/alb/dns"
  type  = "String"
  value = var.alb_dns
}
resource "aws_ssm_parameter" "cf_public_dns" {
  name  = "/${var.name_prefix}/cloudfront/public_dns"
  type  = "String"
  value = var.cf_public_dns
}