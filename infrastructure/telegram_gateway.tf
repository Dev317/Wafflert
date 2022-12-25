resource "aws_api_gateway_resource" "telegram_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "telegram"
}

resource "aws_api_gateway_resource" "send_text" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_resource.telegram_resource.id
  path_part   = "send"
}

resource "aws_api_gateway_method" "send_text" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.send_text.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "send_text" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.send_text.id
  http_method             = aws_api_gateway_method.send_text.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://3.135.214.65:5001/send"
}

resource "aws_api_gateway_deployment" "telegram_send_text_api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.apigw.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.telegram_resource.id,
      aws_api_gateway_method.send_text.id,
      aws_api_gateway_integration.send_text.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
  stage_name = "v1"
}
