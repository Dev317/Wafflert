// /bids
resource "aws_api_gateway_resource" "bids_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "bids"
}

/*
  GET    /v1/bids
*/
resource "aws_api_gateway_method" "get_all_bids" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.bids_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_all_bids" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.bids_resource.id
  http_method             = aws_api_gateway_method.get_all_bids.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.bids_url}/bids"
}

resource "aws_api_gateway_deployment" "get_all_bids_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.bids_resource.id,
      aws_api_gateway_method.get_all_bids.id,
      aws_api_gateway_integration.get_all_bids.id,
    ]))
  }

  stage_name = "v1"
}

/*
  GET    /v1/bids/id
*/
resource "aws_api_gateway_resource" "bids_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.bids_resource.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "get_specific_bid" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.bids_proxy.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "get_specific_bid" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.bids_proxy.id
  http_method             = aws_api_gateway_method.get_specific_bid.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.bids_url}/bids/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "get_specific_bid_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.bids_proxy.id,
      aws_api_gateway_method.get_specific_bid.id,
      aws_api_gateway_integration.get_specific_bid.id,
    ]))
  }

  stage_name = "v1"
}

/*
  PATCH    /v1/bids/id
*/
resource "aws_api_gateway_method" "patch_specific_bid" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.bids_proxy.id
  http_method   = "PATCH"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "patch_specific_bid" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.bids_proxy.id
  http_method             = aws_api_gateway_method.patch_specific_bid.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.bids_url}/bids/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "patch_specific_bid_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.bids_proxy.id,
      aws_api_gateway_method.patch_specific_bid.id,
      aws_api_gateway_integration.patch_specific_bid.id,
    ]))
  }

  stage_name = "v1"
}

/*
  DELETE    /v1/bids/id
*/
resource "aws_api_gateway_method" "delete_specific_bid" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.bids_proxy.id
  http_method   = "DELETE"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "delete_specific_bid" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.bids_proxy.id
  http_method             = aws_api_gateway_method.delete_specific_bid.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.bids_url}/bids/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "delete_specific_bid_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.bids_proxy.id,
      aws_api_gateway_method.delete_specific_bid.id,
      aws_api_gateway_integration.delete_specific_bid.id,
    ]))
  }

  stage_name = "v1"
}


/*
  POST    /v1/bids
*/
resource "aws_api_gateway_method" "post_bid" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.bids_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_bid" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.bids_resource.id
  http_method             = aws_api_gateway_method.post_bid.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.bids_url}/bids"
}

resource "aws_api_gateway_deployment" "post_bid_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.bids_resource.id,
      aws_api_gateway_method.post_bid.id,
      aws_api_gateway_integration.post_bid.id,
    ]))
  }

  stage_name = "v1"
}

/*
  PATCH    /v1/bids/fufill-bid/id
*/
resource "aws_api_gateway_resource" "fufill_bid" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.bids_resource.id
  path_part   = "fufill-bid"
}

resource "aws_api_gateway_resource" "fufill_bid_proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.fufill_bid.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "patch_fufill_bid_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.fufill_bid_proxy.id
  http_method   = "PATCH"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "patch_fufill_bid_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.fufill_bid_proxy.id
  http_method             = aws_api_gateway_method.patch_fufill_bid_proxy.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.bids_url}/bids/fufill-bid/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "patch_fufill_bid_proxy_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.fufill_bid_proxy.id,
      aws_api_gateway_method.patch_fufill_bid_proxy.id,
      aws_api_gateway_integration.patch_fufill_bid_proxy.id,
    ]))
  }

  stage_name = "v1"
}
