data "aws_api_gateway_rest_api" "dev_api" {
  name = "capstone-project"
}

resource "aws_api_gateway_deployment" "prod_deployment" {
  rest_api_id = data.aws_api_gateway_rest_api.dev_api.id

  # triggers = {
  #   redeployment = sha1(jsonencode([

  #     module.health_check_root_endpoint.method_id,
  #     module.health_check_root_endpoint.integration_id,

  #     module.health_check_endpoint.resource_id,
  #     module.health_check_endpoint.method_id,
  #     module.health_check_endpoint.integration_id,

  #     module.login_endpoint.resource_id,
  #     module.login_endpoint.method_id,
  #     module.login_endpoint.integration_id,

  #     module.cidr_to_mask_endpoint.resource_id,
  #     module.cidr_to_mask_endpoint.method_id,
  #     module.cidr_to_mask_endpoint.integration_id,

  #     module.mask_to_cidr_endpoint.resource_id,
  #     module.mask_to_cidr_endpoint.method_id,
  #     module.mask_to_cidr_endpoint.integration_id,
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