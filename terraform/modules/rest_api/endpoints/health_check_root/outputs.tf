output "method_id" {
    value = aws_api_gateway_method.hc_root_method.id
}
output "integration_id" {
    value = aws_api_gateway_integration.hc_root_integration.id
}