resource "aws_db_subnet_group" "subnet_group" {
  name        = "terraform_subnet_group"
  description = "RDS subnet group from terraform"
  subnet_ids  = var.subnets
}

resource "aws_db_parameter_group" "default_parameter_group" {
  name   = "rds-parameter-group"
  family = "mysql8.0"
}

resource "aws_db_instance" "db_instance" {
  identifier           = var.instance_name
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.23"
  instance_class       = "db.t2.micro"
  name                 = "capstone_project_rds"
  username             = "gdaniel"          # figure out how to protect
  password             = "samplePassword"   # figure out how to protect
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  parameter_group_name = aws_db_parameter_group.default_parameter_group.name
  skip_final_snapshot  = true
}