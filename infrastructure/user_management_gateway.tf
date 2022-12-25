// /user-mgmt
resource "aws_api_gateway_resource" "user_management_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "user-mgmt"
}

/*
  POST /v1/user-mgmt/register
*/
resource "aws_api_gateway_resource" "user-mgmt-register" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.user_management_resource.id
  path_part   = "register"
}

resource "aws_api_gateway_method" "user-mgmt-register" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.user-mgmt-register.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "user-mgmt-register" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.user-mgmt-register.id
  http_method             = aws_api_gateway_method.user-mgmt-register.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.user_management_url}/user-mgmt/register"
}

resource "aws_api_gateway_deployment" "user-mgmt-register_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.user-mgmt-register.id,
      aws_api_gateway_method.user-mgmt-register.id,
      aws_api_gateway_integration.user-mgmt-register.id,
    ]))
  }

  stage_name = "v1"
}


/*
  POST /v1/user-mgmt/telegram
*/
resource "aws_api_gateway_resource" "user-mgmt-telegram" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.user_management_resource.id
  path_part   = "telegram"
}

resource "aws_api_gateway_method" "user-mgmt-telegram" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.user-mgmt-telegram.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "user-mgmt-telegram" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.user-mgmt-telegram.id
  http_method             = aws_api_gateway_method.user-mgmt-telegram.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.user_management_url}/user-mgmt/telegram"
}

resource "aws_api_gateway_deployment" "user-mgmt-telegram_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.user-mgmt-telegram.id,
      aws_api_gateway_method.user-mgmt-telegram.id,
      aws_api_gateway_integration.user-mgmt-telegram.id,
    ]))
  }

  stage_name = "v1"
}

/*
  GET /v1/user-mgmt/onboarding-status/{id}
*/
resource "aws_api_gateway_resource" "user-mgmt-onboarding-status" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.user_management_resource.id
  path_part   = "onboarding-status"
}

resource "aws_api_gateway_resource" "user-mgmt-onboarding-status-proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.user-mgmt-onboarding-status.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "user-mgmt-onboarding-status-proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.user-mgmt-onboarding-status-proxy.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "user-mgmt-onboarding-status-proxy" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.user-mgmt-onboarding-status-proxy.id
  http_method             = aws_api_gateway_method.user-mgmt-onboarding-status-proxy.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.user_management_url}/user-mgmt/onboarding-status/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "user-mgmt-onboarding-status-proxy_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.user-mgmt-onboarding-status-proxy.id,
      aws_api_gateway_method.user-mgmt-onboarding-status-proxy.id,
      aws_api_gateway_integration.user-mgmt-onboarding-status-proxy.id,
    ]))
  }

  stage_name = "v1"
}
