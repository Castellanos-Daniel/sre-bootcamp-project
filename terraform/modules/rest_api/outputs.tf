output "rest_api_invoke_url" {
  value = aws_api_gateway_stage.development_stage.invoke_url
}
output "rest_api_invoke_url_production" {
  value = aws_api_gateway_stage.production_stage.invoke_url
}