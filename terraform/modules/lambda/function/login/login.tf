module "login_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "login_function"
  description   = "Evaluate provided creadentials and return a JWT token in case are valid"
  handler       = "login.lambda_handler"
  runtime       = "python3.9"

  source_path = var.source_path

  vpc_subnet_ids         = var.subnets
  vpc_security_group_ids = var.security_groups
  attach_network_policy  = true

  attach_policy_statements = true
  policy_statements = {
    s3__secrets_manager_read = {
      effect    = "Allow",
      actions   = ["secretsmanager:GetSecretValue"],
      resources = ["*"]
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
