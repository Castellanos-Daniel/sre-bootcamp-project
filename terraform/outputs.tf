output "vpc_id" {
  value = module.my_vpc.vpc_id
}

output "db_endpoint" {
  value = module.rds_db.db_endpoint
}

output "db_identifier" {
  value = module.rds_db.identifier
}

output "lambda_deps_layer_arn" {
  value = module.lambda_deps_layer.deps_layer_arn
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}