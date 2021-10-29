output "invoke_arn" {
    value = module.lambda_authorizer.lambda_function_invoke_arn
}

output "function_arn" {
    value = module.lambda_authorizer.lambda_function_arn
}