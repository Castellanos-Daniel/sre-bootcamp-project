# resource "aws_db_subnet_group" "subnet_group" {
#   name        = "terraform_subnet_group"
#   description = "RDS subnet group from terraform"
#   subnet_ids  = var.subnets
# }

# resource "aws_db_parameter_group" "default_parameter_group" {
#   name   = "rds-parameter-group"
#   family = "mysql8.0"
# }

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = var.instance_name

  engine            = "mysql"
  engine_version    = "8.0.23"
  instance_class    = "db.t2.micro"
  allocated_storage = 20

  name     = var.db_name
  username = var.master_user 
  password = var.master_pass
  port     = "3306"

  iam_database_authentication_enabled = true

    # vpc_security_group_ids = ["sg-12345678"]
  subnet_ids = var.subnets
  deletion_protection = false

  create_db_option_group = false
  create_db_parameter_group = false
}

# resource "aws_db_instance" "db_instance" {
#   identifier           = var.instance_name
#   allocated_storage    = 10
#   engine               = "mysql"
#   engine_version       = "8.0.23"
#   instance_class       = "db.t2.micro"
#   name                 = "capstone_project_rds"
#   username             = var.master_user         # figure out how to protect
#   password             = var.master_pass   # figure out how to protect
#   db_subnet_group_name = aws_db_subnet_group.subnet_group.name
#   parameter_group_name = aws_db_parameter_group.default_parameter_group.name
#   skip_final_snapshot  = true
# }

