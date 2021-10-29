
module "health_check" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "health_check"
  description   = "Returns a test response"
  handler       = "health_check.event_handler"
  runtime       = "python3.9"

  source_path = var.source_path
  publish = true
}

module "hc_alias_dev" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  refresh_alias = false
  name = "dev"
  function_name    = module.health_check.lambda_function_name
  function_version = "$LATEST"

  # allowed_triggers = {
  #   AnotherAPIGatewayAny = {
  #     service    = "apigateway"
  #     source_arn = "arn:aws:lambda:us-east-2:874223335165:function:health_check:Develpment"
  #   }
  # }
}
