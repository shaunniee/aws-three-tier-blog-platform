resource "aws_cognito_user_pool" "user_pool" {
      # Optional: auto-confirm new users for testing/demo
  auto_verified_attributes = ["email"]

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
    name = "${var.name_prefix}-user-pool"
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
    generate_secret = false
      explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  prevent_user_existence_errors = "ENABLED"
  
}