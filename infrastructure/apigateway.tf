resource "aws_api_gateway_rest_api" "apigw" {
  name        = "api-gateway"
  description = "Proxy to handle requests to our API"
}
