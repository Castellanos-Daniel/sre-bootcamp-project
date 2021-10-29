resource "aws_security_group" "db_sg" {
  name        = "database-sg"
  description = "MySQL connection"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow DB Connection to VPC security group"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.access_allowed_sg
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-sg"
  }
}

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

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  subnet_ids             = var.subnets
  deletion_protection    = false

  create_db_option_group    = false
  create_db_parameter_group = false
}
