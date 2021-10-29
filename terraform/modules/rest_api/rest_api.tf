resource "aws_api_gateway_rest_api" "rest_api" {
  name = "capstone-project"
}

module "api_authorizer" {
  source              = "./authorizer"
  rest_api_id         = aws_api_gateway_rest_api.rest_api.id
  function_invoke_arn = var.authorizer.function_invoke_arn
  function_arn        = var.authorizer.function_arn
}

# API Endpoints

module "health_check_root_endpoint" {
  source              = "./endpoints/health_check_root"
  root_resource_id    = aws_api_gateway_rest_api.rest_api.root_resource_id
  rest_api_id         = aws_api_gateway_rest_api.rest_api.id
  function_name       = var.function_names[0]
  function_invoke_arn = var.invoke_arns[0]
  myregion            = var.myregion
  accountId           = var.accountId
}

module "health_check_endpoint" {
  source              = "./endpoints/health_check"
  root_resource_id    = aws_api_gateway_rest_api.rest_api.root_resource_id
  rest_api_id         = aws_api_gateway_rest_api.rest_api.id
  function_name       = var.function_names[0]
  function_invoke_arn = var.invoke_arns[0]
  myregion            = var.myregion
  accountId           = var.accountId
}
module "login_endpoint" {
  source              = "./endpoints/login"
  root_resource_id    = aws_api_gateway_rest_api.rest_api.root_resource_id
  rest_api_id         = aws_api_gateway_rest_api.rest_api.id
  function_name       = var.function_names[1]
  function_invoke_arn = var.invoke_arns[1]
  myregion            = var.myregion
  accountId           = var.accountId
}
module "cidr_to_mask_endpoint" {
  source              = "./endpoints/cidr_to_mask"
  root_resource_id    = aws_api_gateway_rest_api.rest_api.root_resource_id
  rest_api_id         = aws_api_gateway_rest_api.rest_api.id
  function_name       = var.function_names[2]
  function_invoke_arn = var.invoke_arns[2]
  myregion            = var.myregion
  accountId           = var.accountId
  authorizer_id       = module.api_authorizer.function_id
}
module "mask_to_cidr_endpoint" {
  source              = "./endpoints/mask_to_cidr"
  root_resource_id    = aws_api_gateway_rest_api.rest_api.root_resource_id
  rest_api_id         = aws_api_gateway_rest_api.rest_api.id
  function_name       = var.function_names[3]
  function_invoke_arn = var.invoke_arns[3]
  myregion            = var.myregion
  accountId           = var.accountId
  authorizer_id       = module.api_authorizer.function_id
}


# Deployment and Stage 
resource "aws_api_gateway_deployment" "dev_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeployment = sha1(jsonencode([

      module.health_check_root_endpoint.method_id,
      module.health_check_root_endpoint.integration_id,

      module.health_check_endpoint.resource_id,
      module.health_check_endpoint.method_id,
      module.health_check_endpoint.integration_id,

      module.login_endpoint.resource_id,
      module.login_endpoint.method_id,
      module.login_endpoint.integration_id,

      module.cidr_to_mask_endpoint.resource_id,
      module.cidr_to_mask_endpoint.method_id,
      module.cidr_to_mask_endpoint.integration_id,

      module.mask_to_cidr_endpoint.resource_id,
      module.mask_to_cidr_endpoint.method_id,
      module.mask_to_cidr_endpoint.integration_id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "development_stage" {
  deployment_id = aws_api_gateway_deployment.dev_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "dev"
}
resource "aws_api_gateway_stage" "production_stage" {
  deployment_id = aws_api_gateway_deployment.dev_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "prod"
}