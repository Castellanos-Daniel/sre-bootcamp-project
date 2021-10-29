output "invoke_arn" {
    value = module.lambda_db_init_load.lambda_function_invoke_arn
}

output "function_version" {
    value = module.lambda_db_init_load.lambda_function_version
}