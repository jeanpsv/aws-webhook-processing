resource "aws_api_gateway_rest_api" "webhook" {
  name        = "Webhook Endpoint"
  description = "RESTful API endpoint to handle webhooks"
}

resource "aws_api_gateway_resource" "webhook" {
  rest_api_id = aws_api_gateway_rest_api.webhook.id
  parent_id   = aws_api_gateway_rest_api.webhook.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "webhook" {
  rest_api_id   = aws_api_gateway_rest_api.webhook.id
  resource_id   = aws_api_gateway_resource.webhook.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "webhook" {
  rest_api_id             = aws_api_gateway_rest_api.webhook.id
  resource_id             = aws_api_gateway_resource.webhook.id
  http_method             = aws_api_gateway_method.webhook.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.callback-handler.invoke_arn
}

resource "aws_api_gateway_method" "webhook_root" {
  rest_api_id   = aws_api_gateway_rest_api.webhook.id
  resource_id   = aws_api_gateway_rest_api.webhook.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "webhook_root" {
  rest_api_id             = aws_api_gateway_rest_api.webhook.id
  resource_id             = aws_api_gateway_method.webhook_root.resource_id
  http_method             = aws_api_gateway_method.webhook_root.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.callback-handler.invoke_arn
}

resource "aws_api_gateway_deployment" "webhook" {
  rest_api_id = aws_api_gateway_rest_api.webhook.id
  stage_name  = "test"
  depends_on = [
    aws_api_gateway_integration.webhook,
    aws_api_gateway_integration.webhook_root
  ]
}

output "webhook_url" {
  value = aws_api_gateway_deployment.webhook.invoke_url
}
