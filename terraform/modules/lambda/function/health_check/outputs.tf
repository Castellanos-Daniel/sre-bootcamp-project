output "invoke_arn" {
    value = module.health_check.lambda_function_invoke_arn
}

output "function_name" {
    value = module.health_check.lambda_function_name
}