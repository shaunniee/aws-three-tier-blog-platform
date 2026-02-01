resource "aws_apigatewayv2_api" "backend_api" {
  name          = "${var.name_prefix}-backend-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["https://${var.cf_public_dns}"]            # your frontend domain
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"] # all methods your frontend uses
    allow_headers = ["Content-Type", "Authorization"]           # headers your frontend sends
    max_age       = 3600
  }
  tags = merge(
    var.tags,
    {
      "Name" = "${var.name_prefix}-backend-api"
    }
  )
}
resource "aws_apigatewayv2_integration" "alb_integration" {
  api_id                 = aws_apigatewayv2_api.backend_api.id
  integration_type       = "HTTP_PROXY"
  integration_uri        = "http://${var.backend_alb_dns}/{proxy}"
  integration_method     = "ANY"
  payload_format_version = "1.0"
}
resource "aws_apigatewayv2_route" "proxy_route" {
  api_id    = aws_apigatewayv2_api.backend_api.id
  route_key = "ANY /{proxy+}" # catch-all
  target    = "integrations/${aws_apigatewayv2_integration.alb_integration.id}"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.backend_api.id
  name        = "prod"
  auto_deploy = true
}