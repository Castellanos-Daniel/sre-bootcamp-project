variable "source_path" { type = string }
variable "function_handler" { type = string }
variable "name" { type = string }

module "conversion_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.name
  description   = "Convert the input string to the corresponding value"
  handler       = var.function_handler
  runtime       = "python3.9"

  source_path = var.source_path

  publish = true
}

module "conversion_function_alias_dev" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  refresh_alias = false
  name = "dev"
  function_name    = module.conversion_function.lambda_function_name
  function_version = "$LATEST"
}