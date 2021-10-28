output "invoke_arn" {
    value = module.login_function.lambda_function_invoke_arn
}

output "function_name" {
    value = module.login_function.lambda_function_name
}