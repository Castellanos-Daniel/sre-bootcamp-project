
module "my_vpc" {
  source = "./modules/vpc"
}

module "rds_db" {
  source        = "./modules/db"
  subnets       = module.my_vpc.private_subnets
  instance_name = "terraform-instance"
}

module "bastion_host" {
  source    = "./modules/bastion_host"
  subnet_id = module.my_vpc.public_subnet[0]
  vpc_ids   = data.aws_vpcs.created_vpc.ids
}
