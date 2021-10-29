output "resource_id" {
    value = aws_api_gateway_resource.login_resource.parent_id
}
output "method_id" {
    value = aws_api_gateway_method.login_method.id
}
output "integration_id" {
    value = aws_api_gateway_integration.login_integration.id
}

