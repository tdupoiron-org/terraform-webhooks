output "api_endpoint" {
  value = aws_apigatewayv2_api.api_gateway.api_endpoint
}

output "api_gateway_stage_name" {
  value = aws_apigatewayv2_stage.api_gateway_stage.name
}