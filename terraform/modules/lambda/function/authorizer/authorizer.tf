
module "lambda_authorizer" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "authorizer"
  description   = "Evaluates token from client before redirecting request to the api function"
  handler       = "authorizer.verify_token"
  runtime       = "python3.9"

  source_path = var.source_path

  attach_policy_statements = true
  policy_statements = {
    s3__secrets_manager_read = {
      effect    = "Allow",
      actions   = ["secretsmanager:GetSecretValue"],
      resources = ["*"]
    }
  }

  publish = true
  layers = [var.deps_layer_arn]
  environment_variables = {
      DbSecret = "arn:aws:secretsmanager:us-east-2:874223335165:secret:dev/db_creds-TnOxtk",
      AwsRegion = "us-east-2"
  }
}
