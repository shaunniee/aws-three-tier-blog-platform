resource "aws_cognito_user_pool" "user_pool" {
  # Optional: auto-confirm new users for testing/demo
  auto_verified_attributes = ["email"]
  username_attributes      = ["email"]


  # Password policy
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  # MFA can be added later
  mfa_configuration = "OFF"
  name              = "${var.name_prefix}-user-pool"
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-user-pool"
    }
  )

}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "${var.name_prefix}-user-pool-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id
  supported_identity_providers = ["COGNITO"] 

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["openid", "email"]
  generate_secret                      = false
  callback_urls                        = ["http://localhost:5173", "https://${var.cf_public_dns}", "https://${var.cf_public_dns}/*"]
  logout_urls                          = ["http://localhost:5173", "https://${var.cf_public_dns}", "https://${var.cf_public_dns}/*"]
  prevent_user_existence_errors        = "ENABLED"
}



resource "aws_cognito_user_pool_domain" "blog_domain" {
  domain       = "blogapp-auth"
  user_pool_id = aws_cognito_user_pool.user_pool.id
  depends_on = [aws_cognito_user_pool_client.user_pool_client]
}

