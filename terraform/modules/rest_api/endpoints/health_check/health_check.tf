resource "aws_api_gateway_resource" "health_check_resource" {
  path_part   = "_health"
  parent_id   = var.root_resource_id
  rest_api_id = var.rest_api_id
}

resource "aws_api_gateway_method" "hc_method" {
  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.health_check_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.health_check_resource.id
  http_method             = aws_api_gateway_method.hc_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.function_invoke_arn
}

resource "aws_lambda_permission" "hc_function_gw_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${var.rest_api_id}/*/${aws_api_gateway_method.hc_method.http_method}${aws_api_gateway_resource.health_check_resource.path}"
}
