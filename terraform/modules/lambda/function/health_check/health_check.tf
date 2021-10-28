
module "health_check" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "health_check"
  description   = "Returns a test response"
  handler       = "health_check.event_handler"
  runtime       = "python3.9"

  source_path = var.source_path
  publish = true
}
