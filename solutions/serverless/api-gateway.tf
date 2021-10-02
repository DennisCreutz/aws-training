resource "aws_api_gateway_rest_api" "this" {
  name = "${local.prefix}-rest-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = local.default_tags
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_lambda_function.this,
    aws_api_gateway_resource.root_level
  ]
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "v1"

  # Need to set this or else Terraform always want to remove the value (cache_cluster is still not enabled)
  cache_cluster_size = 0.5

  tags = local.default_tags

  depends_on = [
    aws_lambda_function.this,
    aws_api_gateway_resource.root_level
  ]
}

resource "aws_api_gateway_resource" "root_level" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "trump-quotes"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

#########################
#### Lambda #############
#########################

resource "aws_api_gateway_method" "trump" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.root_level.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "trump" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_method.trump.resource_id
  http_method = aws_api_gateway_method.trump.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.this.invoke_arn
}

resource "aws_api_gateway_method_response" "http_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.root_level.id
  http_method = aws_api_gateway_integration.trump.http_method
  status_code = "200"

  response_models = {
    "application/json" : "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}
resource "aws_api_gateway_integration_response" "http_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.root_level.id
  http_method = aws_api_gateway_method_response.http_200.http_method
  status_code = aws_api_gateway_method_response.http_200.status_code

  response_templates = {
    "application/json" = ""
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowAPIGatewayInvoke-${local.function_name}-${aws_api_gateway_method.trump.resource_id}-${aws_api_gateway_method.trump.http_method}"
  action        = "lambda:InvokeFunction"
  function_name = local.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}

#########################
#### CORS ###############
#########################
module "cors" {
  source  = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = aws_api_gateway_rest_api.this.id
  api_resource_id = aws_api_gateway_resource.root_level.id
}
