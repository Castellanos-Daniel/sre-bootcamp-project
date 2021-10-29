output "resource_id" {
    value = aws_api_gateway_resource.health_check_resource.id
}
output "method_id" {
    value = aws_api_gateway_method.hc_method.id
}
output "integration_id" {
    value = aws_api_gateway_integration.integration.id
}

