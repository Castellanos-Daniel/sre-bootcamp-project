data "aws_api_gateway_rest_api" "dev_api" {
  name = "capstone-project"
}

resource "aws_api_gateway_deployment" "prod_deployment" {
  rest_api_id = data.aws_api_gateway_rest_api.dev_api.id
  # triggers = {
  #   redeployment = sha1(jsonencode([
      
  #   ]))
  # }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "production_stage" {
  deployment_id = aws_api_gateway_deployment.prod_deployment.id
  rest_api_id   = data.aws_api_gateway_rest_api.dev_api.id
  stage_name    = "Production"
}