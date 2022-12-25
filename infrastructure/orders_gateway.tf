// /orders
resource "aws_api_gateway_resource" "orders_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "orders"
}

/*
  GET    /v1/orders
*/
resource "aws_api_gateway_method" "get_all_orders" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.orders_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_all_orders" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.orders_resource.id
  http_method             = aws_api_gateway_method.get_all_orders.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.orders_url}/orders"
}

resource "aws_api_gateway_deployment" "get_all_orders_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.orders_resource.id,
      aws_api_gateway_method.get_all_orders.id,
      aws_api_gateway_integration.get_all_orders.id,
    ]))
  }

  stage_name = "v1"
}

/*
  GET    /v1/orders/id
*/
resource "aws_api_gateway_resource" "orders_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.orders_resource.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "get_specific_order" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.orders_proxy.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "get_specific_order" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.orders_proxy.id
  http_method             = aws_api_gateway_method.get_specific_order.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.orders_url}/orders/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "get_specific_order_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.orders_proxy.id,
      aws_api_gateway_method.get_specific_order.id,
      aws_api_gateway_integration.get_specific_order.id,
    ]))
  }

  stage_name = "v1"
}

/*
  PATCH    /v1/orders/id
*/
resource "aws_api_gateway_method" "patch_specific_order" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.orders_proxy.id
  http_method   = "PATCH"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "patch_specific_order" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.orders_proxy.id
  http_method             = aws_api_gateway_method.patch_specific_order.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.orders_url}/orders/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "patch_specific_order_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.orders_proxy.id,
      aws_api_gateway_method.patch_specific_order.id,
      aws_api_gateway_integration.patch_specific_order.id,
    ]))
  }

  stage_name = "v1"
}

/*
  POST    /v1/order
*/
resource "aws_api_gateway_resource" "order_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "order"
}

resource "aws_api_gateway_method" "post_order" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.order_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_order" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.order_resource.id
  http_method             = aws_api_gateway_method.post_order.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.orders_url}/order"
}

resource "aws_api_gateway_deployment" "post_order_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.order_resource.id,
      aws_api_gateway_method.post_order.id,
      aws_api_gateway_integration.post_order.id,
    ]))
  }

  stage_name = "v1"
}

/*
  GET    /v1/past_orders/id
*/
resource "aws_api_gateway_resource" "past_orders" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "past_orders"
}

resource "aws_api_gateway_resource" "past_orders_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.past_orders.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "get_past_orders_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.past_orders_proxy.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "get_past_orders_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.past_orders_proxy.id
  http_method             = aws_api_gateway_method.get_past_orders_proxy.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.orders_url}/past_orders/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "get_past_orders_proxy_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.past_orders_proxy.id,
      aws_api_gateway_method.get_past_orders_proxy.id,
      aws_api_gateway_integration.get_past_orders_proxy.id,
    ]))
  }

  stage_name = "v1"
}

/*
  GET    /v1/past_runs/id
*/
resource "aws_api_gateway_resource" "past_runs" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "past_runs"
}

resource "aws_api_gateway_resource" "past_runs_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.past_runs.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "get_past_runs_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.past_runs_proxy.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "get_past_runs_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.past_runs_proxy.id
  http_method             = aws_api_gateway_method.get_past_runs_proxy.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.orders_url}/past_runs/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "get_past_runs_proxy_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.past_runs_proxy.id,
      aws_api_gateway_method.get_past_runs_proxy.id,
      aws_api_gateway_integration.get_past_runs_proxy.id,
    ]))
  }

  stage_name = "v1"
}


/*
  GET    /v1/orders/orders-by-username/id
*/
resource "aws_api_gateway_resource" "orders-by-username" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.orders_resource.id
  path_part   = "orders-by-username"
}

resource "aws_api_gateway_resource" "orders-by-username_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.orders-by-username.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "get_orders-by-username_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.orders-by-username_proxy.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "get_orders-by-username_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.orders-by-username_proxy.id
  http_method             = aws_api_gateway_method.get_orders-by-username_proxy.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.orders_url}/orders/orders-by-username/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "get_orders-by-username_proxy_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.orders-by-username_proxy.id,
      aws_api_gateway_method.get_orders-by-username_proxy.id,
      aws_api_gateway_integration.get_orders-by-username_proxy.id,
    ]))
  }

  stage_name = "v1"
}


/*
  GET    /v1/orders/runs-by-username/id
*/
resource "aws_api_gateway_resource" "runs-by-username" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.orders_resource.id
  path_part   = "runs-by-username"
}

resource "aws_api_gateway_resource" "runs-by-username_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.runs-by-username.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "get_runs-by-username_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.runs-by-username_proxy.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "get_runs-by-username_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.runs-by-username_proxy.id
  http_method             = aws_api_gateway_method.get_runs-by-username_proxy.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.orders_url}/orders/runs-by-username/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "get_runs-by-username_proxy_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.runs-by-username_proxy.id,
      aws_api_gateway_method.get_runs-by-username_proxy.id,
      aws_api_gateway_integration.get_runs-by-username_proxy.id,
    ]))
  }

  stage_name = "v1"
}
