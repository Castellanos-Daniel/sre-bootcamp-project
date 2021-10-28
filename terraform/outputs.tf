output "vpc_id" {
  value = module.my_vpc.vpc_id
}

output "db_address" {
  value = module.rds_db.db_address
}

output "db_identifier" {
  value = module.rds_db.identifier
}

output "lambda_deps_layer_arn" {
  value = module.lambda_deps_layer.layer_arn
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "invoke_arns" {
  value = {
    db_init = module.lambda_db_init.invoke_arn
    health_check = module.health_check_function.invoke_arn
  }
}

output "devStageApiUrl" {
  value = module.rest_api_gateway.rest_api_invoke_url
}
