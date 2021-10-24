
module "my_vpc" {
  source = "./modules/vpc"
}

module "rds_db" {
  source        = "./modules/db"
  subnets       = module.my_vpc.private_subnets
  instance_name = "terraform-instance"
  master_user = var.db_master_user
  master_pass = var.db_master_pass
}

module "lambda_deps_layer" {
  source = "./modules/lambda/layer"
  name = "DepsLayer"
  bucket_name = "deps-layer-bucket"
  filename = "deps.zip"
}