output "db_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}

output "identifier" {
  value = aws_db_instance.db_instance.identifier
}