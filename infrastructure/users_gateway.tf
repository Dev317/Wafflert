// /user
resource "aws_api_gateway_resource" "users_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "user"
}


/*
  POST /v1/user/register/
*/
resource "aws_api_gateway_resource" "register" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.users_resource.id
  path_part   = "register"
}

resource "aws_api_gateway_method" "register" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.register.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "register" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.register.id
  http_method             = aws_api_gateway_method.register.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.user_url}/register/"
}

resource "aws_api_gateway_deployment" "user_register_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.users_resource.id,
      aws_api_gateway_method.register.id,
      aws_api_gateway_integration.register.id,
    ]))
  }

  stage_name = "v1"
}


/*
  POST /v1/user/login/
*/
resource "aws_api_gateway_resource" "login" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.users_resource.id
  path_part   = "login"
}

resource "aws_api_gateway_method" "login" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.login.id
  http_method   = "POST"
  authorization = "NONE"

  # request_parameters = {
  #   "method.request.header.Access-Control-Allow-Origin" = true,
  #   "method.request.header.Access-Control-Allow-Headers" = true,
  #   "method.request.header.Access-Control-Allow-Methods" = true,
  # }
}

resource "aws_api_gateway_integration" "login" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.login.id
  http_method             = aws_api_gateway_method.login.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.user_url}/login/"

  # request_parameters = {
  #   "integration.request.header.Access-Control-Allow-Origin" = "'*'",
  #   "integration.request.header.Access-Control-Allow-Headers" = "'Content-Type'"
  #   "integration.request.header.Access-Control-Allow-Methods" = "'OPTIONS,GET,POST,PUT,PATCH,DELETE'"

  # }
}

resource "aws_api_gateway_deployment" "user_login_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.users_resource.id,
      aws_api_gateway_method.login.id,
      aws_api_gateway_integration.login.id,
    ]))
  }

  stage_name = "v1"
}

/*
  PUT /v1/user/update-password/${uuid}
*/
resource "aws_api_gateway_resource" "update_password" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.users_resource.id
  path_part   = "update-password"
}

resource "aws_api_gateway_resource" "update_password_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.update_password.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "update_password_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.update_password_proxy.id
  http_method   = "PUT"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "update_password_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.update_password_proxy.id
  http_method             = aws_api_gateway_method.update_password_proxy.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.user_url}/update-password/{proxy}/"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "user_update_password_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.update_password_proxy.id,
      aws_api_gateway_method.update_password_proxy.id,
      aws_api_gateway_integration.update_password_proxy.id,
    ]))
  }

  stage_name = "v1"
}

/*
  GET /v1/user/retrieve/${uuid}
*/
resource "aws_api_gateway_resource" "retrieve_user" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.users_resource.id
  path_part   = "retrieve"
}

resource "aws_api_gateway_resource" "retrieve_user_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.retrieve_user.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "retrieve_user_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.retrieve_user_proxy.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "retrieve_user_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.retrieve_user_proxy.id
  http_method             = aws_api_gateway_method.retrieve_user_proxy.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.user_url}/retrieve/{proxy}/"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "user_retrieve_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.retrieve_user_proxy.id,
      aws_api_gateway_method.retrieve_user_proxy.id,
      aws_api_gateway_integration.retrieve_user_proxy.id,
    ]))
  }

  stage_name = "v1"
}

/*
  PUT /v1/user/update-telegram-id/${uuid}
*/
resource "aws_api_gateway_resource" "update_telegram_id" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.users_resource.id
  path_part   = "update-telegram-id"
}

resource "aws_api_gateway_resource" "update_telegram_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.update_telegram_id.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "update_telegram_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.update_telegram_proxy.id
  http_method   = "PUT"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "update_telegram_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.update_telegram_proxy.id
  http_method             = aws_api_gateway_method.update_telegram_proxy.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.user_url}/update-telegram-id/{proxy}/"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "user_update_telegram_id_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.update_telegram_proxy.id,
      aws_api_gateway_method.update_telegram_proxy.id,
      aws_api_gateway_integration.update_telegram_proxy.id,
    ]))
  }

  stage_name = "v1"
}

/*
  DELETE /v1/user/delete-waffle-user/${uuid}
*/
resource "aws_api_gateway_resource" "delete_user" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.users_resource.id
  path_part   = "delete-waffle-user"
}

resource "aws_api_gateway_resource" "delete_user_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.delete_user.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "delete_user_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.delete_user_proxy.id
  http_method   = "DELETE"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "delete_user_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.delete_user_proxy.id
  http_method             = aws_api_gateway_method.delete_user_proxy.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.user_url}/delete-waffle-user/{proxy}/"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "user_delete_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.delete_user_proxy.id,
      aws_api_gateway_method.delete_user_proxy.id,
      aws_api_gateway_integration.delete_user_proxy.id,
    ]))
  }

  stage_name = "v1"
}
