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