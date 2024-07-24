resource "aws_api_gateway_rest_api" "mikearcher_dev" {
  name = "mikearcher_dev_api"
}

resource "aws_api_gateway_resource" "mikearcher_dev_resource" {
  rest_api_id = aws_api_gateway_rest_api.mikearcher_dev.id
  parent_id = aws_api_gateway_rest_api.mikearcher_dev.root_resource_id
  path_part = "contact"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id = aws_api_gateway_rest_api.mikearcher_dev.id
  resource_id = aws_api_gateway_resource.mikearcher_dev_resource.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = aws_api_gateway_rest_api.mikearcher_dev.id
  resource_id = aws_api_gateway_resource.mikearcher_dev_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.send_email_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.mikearcher_dev.id
  resource_id = aws_api_gateway_resource.mikearcher_dev_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_email_lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.mikearcher_dev.execution_arn}/*"
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.mikearcher_dev.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.mikearcher_dev.body))
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [ aws_api_gateway_method.post_method, aws_api_gateway_integration.integration ]
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id = aws_api_gateway_rest_api.mikearcher_dev.id
  stage_name = "prod"
}