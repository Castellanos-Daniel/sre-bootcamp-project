output "resource_id" {
    value = aws_api_gateway_resource.cidr_to_mask_resource.id
}
output "method_id" {
    value = aws_api_gateway_method.cidr_to_mask_method.id
}
output "integration_id" {
    value = aws_api_gateway_integration.cidr_to_mask_integration.id
}