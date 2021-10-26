
module "lambda_db_init_load" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "db-init-load"
  description   = "Set up user and data in a new RDS DB"
  handler       = "index.lambda_handler"
  runtime       = "python3.9"

  source_path = var.source_path

  vpc_subnet_ids         = var.subnets
  vpc_security_group_ids = var.security_groups
  attach_network_policy  = true

#   attach_policy = true
#   policies      = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  attach_policy_statements = true
  policy_statements = {
    s3_read = {
      effect    = "Allow",
      actions   = ["s3:GetObject"],
      resources = ["arn:aws:s3:::*/*"]
    },
    rds_read = {
      effect    = "Allow"
      actions   = ["rds-db:connect"]
      resources = ["arn:aws:rds-db:us-east-2:874223335165:dbuser:*/lambda-user"]
    }
  }

  publish = true
  layers = [var.deps_layer_arn]
  environment_variables = var.env_vars
}
