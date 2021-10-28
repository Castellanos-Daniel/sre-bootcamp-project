output "rest_api_invoke_url" {
  value = aws_api_gateway_stage.developmenet_stage.invoke_url
}