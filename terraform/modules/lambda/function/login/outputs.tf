output "invoke_arn" {
  value = module.login_function.lambda_function_invoke_arn
}

output "function_name" {
  value = module.login_function.lambda_function_name
}

output "function_version" {
  value = module.login_function.lambda_function_version
}

output "alias_invoke_arn" {
  value = module.login_alias_dev.lambda_alias_invoke_arn
}

output "lambda_alias_name" {
  value = module.login_alias_dev.lambda_alias_name
}
