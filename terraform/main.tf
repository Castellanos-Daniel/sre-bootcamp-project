
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

module "lambda_db_init" {
  source = "./modules/lambda/function/db_init"
  source_path = "./modules/lambda/function/db_init/load_data.py"
  security_groups = [module.vpc_sg.vpc_sg_id]
  subnets = module.my_vpc.private_subnets
  deps_layer_arn = module.lambda_deps_layer.layer_arn
  env_vars = {
    s3_bucket = "initial-data-bucket",
    s3_filename = "initial_data.sql"
    region_name = "us-east-2"
    secret_name = "db-creds"
    # Change the host for one that doesn't include the port
    db_host = module.rds_db.db_address
  }
}

module "health_check_function" {
  source = "./modules/lambda/function/health_check"
  source_path = "../functions/health_check/"
}

module "login_function" {
  source = "./modules/lambda/function/login"
  source_path = "../functions/auth"
  security_groups = [module.vpc_sg.vpc_sg_id]
  subnets = module.my_vpc.private_subnets
  deps_layer_arn = module.lambda_deps_layer.layer_arn
  env_vars = {
    AwsRegion = "us-east-2"
    DB_HOST   = module.rds_db.db_address
    DB_NAME   = "bootcamp"
    DB_USER   = "lambda-user"
    DbSecret  = "arn:aws:secretsmanager:us-east-2:874223335165:secret:dev/db_creds-TnOxtk"
    ENVIRONMENT = "dev"
  }
}

module "cidr_to_mask_function" {
  source = "./modules/lambda/function/conversion_function"
  source_path = "../functions/conversions"
  function_handler = "urlCidrToMask.urlCidrToMask"
  name = "urlCidrToMask_function"
}

module "mask_to_cidr_function" {
  source = "./modules/lambda/function/conversion_function"
  source_path = "../functions/conversions"
  function_handler = "urlMaskToCidr.urlMaskToCidr"
  name = "mask_to_cidr_function"
}

module "authorizer_function" {
  source = "./modules/lambda/function/authorizer"
  source_path = "../functions/auth"
  deps_layer_arn = module.lambda_deps_layer.layer_arn
}


# Rest API Gateway
module "rest_api_gateway" {
  source = "./modules/rest_api"
  myregion = "us-east-2"
  accountId = data.aws_caller_identity.current.account_id
  authorizer = {
    function_arn = module.authorizer_function.function_arn,
    function_invoke_arn = module.authorizer_function.invoke_arn
  }
  invoke_arns = [
    module.health_check_function.invoke_arn,
    module.login_function.invoke_arn,
    module.cidr_to_mask_function.invoke_arn,
    module.mask_to_cidr_function.invoke_arn,
  ]
  function_names = [
    module.health_check_function.function_name,
    module.login_function.function_name,
    module.cidr_to_mask_function.function_name,
    module.mask_to_cidr_function.function_name,
  ]
}
