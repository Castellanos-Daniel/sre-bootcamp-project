output "invoke_arn" {
  value = module.health_check.lambda_function_invoke_arn
}

output "function_name" {
  value = module.health_check.lambda_function_name
}

output "function_version" {
  value = module.health_check.lambda_function_version
}

output "alias_invoke_arn" {
  value = module.hc_alias_dev.lambda_alias_invoke_arn
}

output "lambda_alias_name" {
  value = module.hc_alias_dev.lambda_alias_name
}
