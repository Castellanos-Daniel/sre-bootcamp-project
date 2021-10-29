resource "aws_api_gateway_resource" "cidr_to_mask_resource" {
  path_part   = "cidr-to-mask"
  parent_id   = var.root_resource_id
  rest_api_id = var.rest_api_id
}

resource "aws_api_gateway_method" "cidr_to_mask_method" {
  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.cidr_to_mask_resource.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = var.authorizer_id
}

resource "aws_api_gateway_integration" "cidr_to_mask_integration" {
  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.cidr_to_mask_resource.id
  http_method             = aws_api_gateway_method.cidr_to_mask_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.function_invoke_arn
}

resource "aws_lambda_permission" "cidr_to_mask_gw_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${var.rest_api_id}/*/${aws_api_gateway_method.cidr_to_mask_method.http_method}${aws_api_gateway_resource.cidr_to_mask_resource.path}"
}
