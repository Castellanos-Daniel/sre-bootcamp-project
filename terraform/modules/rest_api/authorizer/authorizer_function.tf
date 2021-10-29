resource "aws_api_gateway_authorizer" "token_authorizer" {
  name                   = "token_authorizer"
  rest_api_id            = var.rest_api_id
  authorizer_uri         = var.function_invoke_arn
  authorizer_credentials = aws_iam_role.invocation_role.arn
  authorizer_result_ttl_in_seconds = 0
}

resource "aws_iam_role" "invocation_role" {
  name = "api_gateway_auth_invocation"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invocation_policy" {
  name = "default"
  role = aws_iam_role.invocation_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${var.function_arn}"
    }
  ]
}
EOF
}

output "function_id" {
  value = aws_api_gateway_authorizer.token_authorizer.id
}