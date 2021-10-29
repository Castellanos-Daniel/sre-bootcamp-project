output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "devStageApiUrl" {
  value = module.rest_api_gateway.rest_api_invoke_url
}

output "prodStageApiUrl" {
  value = module.rest_api_gateway.rest_api_invoke_url_production
}

output "function_versions" {
  value = {
    "Database init" : module.lambda_db_init.function_version
    "Health Check": module.health_check_function.function_version
    "Login" : module.login_function.function_version
    "CIDR to Mask" : module.cidr_to_mask_function.function_version
    "Mask to CIDR" : module.mask_to_cidr_function.function_version
  }
}
