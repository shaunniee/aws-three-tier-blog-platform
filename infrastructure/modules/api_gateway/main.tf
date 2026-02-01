resource "aws_apigatewayv2_api" "backend_api" {
  name          = "blog-backend-api"
  protocol_type = "HTTP"
}
resource "aws_apigatewayv2_integration" "alb_integration" {
  api_id           = aws_apigatewayv2_api.backend_api.id
  integration_type = "HTTP_PROXY"
  integration_uri  = "http://${var.backend_alb_dns}"
  integration_method = "ANY"
}
resource "aws_apigatewayv2_route" "proxy_route" {
  api_id    = aws_apigatewayv2_api.backend_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.alb_integration.id}"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.backend_api.id
  name        = "prod"
  auto_deploy = true
}