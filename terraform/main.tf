
module "my_vpc" {
  source = "./modules/vpc"
}

module "vpc_sg" {
  source = "./modules/lambda/vpc_security_group"
  vpc_id = module.my_vpc.vpc_id
}

module "rds_db" {
  source        = "./modules/db"
  vpc_id        = module.my_vpc.vpc_id
  subnets       = module.my_vpc.private_subnets
  instance_name = "terraform-instance"
  master_user   = var.db_master_user
  master_pass   = var.db_master_pass
  access_allowed_sg  = [ module.vpc_sg.vpc_sg_id ]
}

module "lambda_deps_layer" {
  source      = "./modules/lambda/layer"
  name        = "DepsLayer"
  bucket_name = "deps-layer-bucket"
  filename    = "deps.zip"
}

module "lambda_vpc_execution_role" {
  source = "./modules/lambda/vpc_execution_role"
  name = "lambda_db_access_role"
  db_username = "lambda-user"
}
