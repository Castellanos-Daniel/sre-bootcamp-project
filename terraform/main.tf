provider "aws" {
  region  = "us-east-2"
}
terraform {
  backend "s3" {
    bucket  = "daniel-terraform-backend"
    key     = "terraform/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true

  }
}

module "my_vpc" {
  source = "./modules/vpc"
}

module "rds_db" {
  source = "./modules/db"
  subnets = module.my_vpc.private_subnets
  instance_name = "terraform-instance"
}

module "bastion_host" {
  source = "./modules/bastion_host"
  subnet_id = module.my_vpc.public_subnet[0]
  vpc_ids = data.aws_vpcs.created_vpc.ids
}

data "aws_vpcs" "created_vpc" {
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  depends_on = [
    module.my_vpc
  ]
}

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