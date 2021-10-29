output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "db_address" {
  value = module.rds_db.db_address
}

output "devStageApiUrl" {
  value = module.rest_api_gateway.rest_api_invoke_url
}

output "prodStageApiUrl" {
  value = module.rest_api_gateway.rest_api_invoke_url_production
}
