// /payments
resource "aws_api_gateway_resource" "payments_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "payments"
}

/*
  GET    /v1/payments
*/
resource "aws_api_gateway_method" "get_all_payments" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.payments_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_all_payments" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.payments_resource.id
  http_method             = aws_api_gateway_method.get_all_payments.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.payments_url}/payments"
}

resource "aws_api_gateway_deployment" "payments_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.payments_resource.id,
      aws_api_gateway_method.get_all_payments.id,
      aws_api_gateway_integration.get_all_payments.id,
    ]))
  }

  stage_name = "v1"
}

/*
  GET    /v1/payments/bidId
*/
resource "aws_api_gateway_resource" "payments_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.payments_resource.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "payments_proxy_get" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.payments_proxy.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "payments_proxy_get" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.payments_proxy.id
  http_method             = aws_api_gateway_method.payments_proxy_get.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.payments_url}/payments/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "specific_payments_get_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.payments_proxy.id,
      aws_api_gateway_method.payments_proxy_get.id,
      aws_api_gateway_integration.payments_proxy_get.id,
    ]))
  }

  stage_name = "v1"
}

/*
  DELETE    /v1/payments/bidId
*/
resource "aws_api_gateway_method" "payments_proxy_delete" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.payments_proxy.id
  http_method   = "DELETE"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "payments_proxy_delete" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.payments_proxy.id
  http_method             = aws_api_gateway_method.payments_proxy_delete.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.payments_url}/payments/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "specific_payments_delete_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.payments_proxy.id,
      aws_api_gateway_method.payments_proxy_delete.id,
      aws_api_gateway_integration.payments_proxy_delete.id,
    ]))
  }

  stage_name = "v1"
}


/*
  POST    /v1/payments
*/
resource "aws_api_gateway_method" "payments_post" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.payments_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "payments_post" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.payments_resource.id
  http_method             = aws_api_gateway_method.payments_post.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.payments_url}/payments"
}

resource "aws_api_gateway_deployment" "payments_post_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.payments_resource.id,
      aws_api_gateway_method.payments_post.id,
      aws_api_gateway_integration.payments_post.id,
    ]))
  }

  stage_name = "v1"
}

/*
  PATCH    /v1/payments/bidId
*/
resource "aws_api_gateway_method" "payments_patch" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.payments_proxy.id
  http_method   = "PATCH"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "payments_patch" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.payments_proxy.id
  http_method             = aws_api_gateway_method.payments_patch.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.payments_url}/payments/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "payments_patch_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.payments_resource.id,
      aws_api_gateway_method.payments_patch.id,
      aws_api_gateway_integration.payments_patch.id,
    ]))
  }

  stage_name = "v1"
}


/*
  GET    /v1/payments/accounts
*/
resource "aws_api_gateway_resource" "payments_accounts" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.payments_resource.id
  path_part   = "accounts"
}

resource "aws_api_gateway_method" "payments_accounts_get" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.payments_accounts.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "payments_accounts_get" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.payments_accounts.id
  http_method             = aws_api_gateway_method.payments_accounts_get.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.payments_url}/payments/accounts"
}

resource "aws_api_gateway_deployment" "payments_accounts_get_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.payments_accounts.id,
      aws_api_gateway_method.payments_accounts_get.id,
      aws_api_gateway_integration.payments_accounts_get.id,
    ]))
  }

  stage_name = "v1"
}

/*
  POST    /v1/payments/accounts
*/
resource "aws_api_gateway_method" "payments_accounts_post" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.payments_accounts.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "payments_accounts_post" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.payments_accounts.id
  http_method             = aws_api_gateway_method.payments_accounts_post.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.payments_url}/payments/accounts"
}

resource "aws_api_gateway_deployment" "payments_accounts_post_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.payments_accounts.id,
      aws_api_gateway_method.payments_accounts_post.id,
      aws_api_gateway_integration.payments_accounts_post.id,
    ]))
  }

  stage_name = "v1"
}

/*
  GET    /v1/payments/accounts/setup-link/{userid}
*/
resource "aws_api_gateway_resource" "payments_accounts_setup_link" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.payments_accounts.id
  path_part   = "setup-link"
}

resource "aws_api_gateway_resource" "payments_accounts_setup_link_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.payments_accounts_setup_link.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "payments_accounts_setup_link" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.payments_accounts_setup_link_proxy.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "payments_accounts_setup_link" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.payments_accounts_setup_link_proxy.id
  http_method             = aws_api_gateway_method.payments_accounts_setup_link.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.payments_url}/payments/accounts/setup-link/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "payments_accounts_setup_link_get_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.payments_accounts_setup_link_proxy.id,
      aws_api_gateway_method.payments_accounts_setup_link.id,
      aws_api_gateway_integration.payments_accounts_setup_link.id,
    ]))
  }

  stage_name = "v1"
}


/*
  GET    /v1/payments/accounts/setup-secret/{userid}
*/
resource "aws_api_gateway_resource" "payments_accounts_setup_secret" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.payments_accounts.id
  path_part   = "setup-secret"
}

resource "aws_api_gateway_resource" "payments_accounts_setup_secret_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.payments_accounts_setup_secret.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "payments_accounts_setup_secret" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.payments_accounts_setup_secret_proxy.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "payments_accounts_setup_secret" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.payments_accounts_setup_secret_proxy.id
  http_method             = aws_api_gateway_method.payments_accounts_setup_secret.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.payments_url}/payments/accounts/setup-secret/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "payments_accounts_setup_secret_get_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.payments_accounts_setup_secret_proxy.id,
      aws_api_gateway_method.payments_accounts_setup_secret.id,
      aws_api_gateway_integration.payments_accounts_setup_secret.id,
    ]))
  }

  stage_name = "v1"
}

/*
  GET    /v1/payments/accounts/payment-methods/{userid}
*/
resource "aws_api_gateway_resource" "payments_accounts_payment_methods" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.payments_accounts.id
  path_part   = "payment-methods"
}

resource "aws_api_gateway_resource" "payments_accounts_payment_methods_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.payments_accounts_payment_methods.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "payments_accounts_payment_methods" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.payments_accounts_payment_methods_proxy.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "payments_accounts_payment_methods" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.payments_accounts_payment_methods_proxy.id
  http_method             = aws_api_gateway_method.payments_accounts_payment_methods.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.payments_url}/payments/accounts/payment-methods/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "payments_accounts_payment_methods_get_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.payments_accounts_payment_methods_proxy.id,
      aws_api_gateway_method.payments_accounts_payment_methods.id,
      aws_api_gateway_integration.payments_accounts_payment_methods.id,
    ]))
  }

  stage_name = "v1"
}

/*
  GET    /v1/payments/accounts/connected-account-verified/{userid}
*/
resource "aws_api_gateway_resource" "connected-account-verified" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.payments_accounts.id
  path_part   = "connected-account-verified"
}

resource "aws_api_gateway_resource" "connected-account-verified_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.connected-account-verified.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "connected-account-verified" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.connected-account-verified_proxy.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "connected-account-verified" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.connected-account-verified_proxy.id
  http_method             = aws_api_gateway_method.connected-account-verified.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.payments_url}/payments/accounts/connected-account-verified/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "connected-account-verified_get_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.connected-account-verified_proxy.id,
      aws_api_gateway_method.connected-account-verified.id,
      aws_api_gateway_integration.connected-account-verified.id,
    ]))
  }

  stage_name = "v1"
}
