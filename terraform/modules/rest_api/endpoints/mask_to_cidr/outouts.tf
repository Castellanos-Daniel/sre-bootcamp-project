output "resource_id" {
    value = aws_api_gateway_resource.mask_to_cidr_resource.id
}
output "method_id" {
    value = aws_api_gateway_method.mask_to_cidr_method.id
}
output "integration_id" {
    value = aws_api_gateway_integration.mask_to_cidr_integration.id
}