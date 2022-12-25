// /orders-mgmt

/*
  POST /v1/place-order
*/
resource "aws_api_gateway_resource" "place_order_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "place-order"
}

resource "aws_api_gateway_method" "place_order" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.place_order_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "place_order" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.place_order_resource.id
  http_method             = aws_api_gateway_method.place_order.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.orders_management_url}/place-order"
}

resource "aws_api_gateway_deployment" "place_order_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.place_order_resource.id,
      aws_api_gateway_method.place_order.id,
      aws_api_gateway_integration.place_order.id,
    ]))
  }

  stage_name = "v1"
}

/*
  PATCH /v1/accept-order/{bidId}
*/
resource "aws_api_gateway_resource" "accept_order_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "accept-order"
}

resource "aws_api_gateway_resource" "accept_order_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.accept_order_resource.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "accept_order_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.accept_order_proxy.id
  http_method   = "PATCH"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "accept_order_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.accept_order_proxy.id
  http_method             = aws_api_gateway_method.accept_order_proxy.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.orders_management_url}/accept-order/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "accept_order_proxy_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.accept_order_proxy.id,
      aws_api_gateway_method.accept_order_proxy.id,
      aws_api_gateway_integration.accept_order_proxy.id,
    ]))
  }

  stage_name = "v1"
}

/*
  PATCH /v1/complete-order/{orderId}
*/
resource "aws_api_gateway_resource" "complete_order_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "complete-order"
}

resource "aws_api_gateway_resource" "complete_order_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.complete_order_resource.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "complete_order_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.complete_order_proxy.id
  http_method   = "PATCH"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "complete_order_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.complete_order_proxy.id
  http_method             = aws_api_gateway_method.complete_order_proxy.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.orders_management_url}/complete-order/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "complete_order_proxy_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.complete_order_proxy.id,
      aws_api_gateway_method.complete_order_proxy.id,
      aws_api_gateway_integration.complete_order_proxy.id,
    ]))
  }

  stage_name = "v1"
}