output "vpc_public_subnet" {
  value = module.my_vpc.public_subnet
}

output "db_endpoint" {
  value = module.rds_db.db_endpoint
}

output "vpc_id" {
  value = data.aws_vpcs.created_vpc.ids
}

output "db_identifier" {
  value = module.rds_db.identifier
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
