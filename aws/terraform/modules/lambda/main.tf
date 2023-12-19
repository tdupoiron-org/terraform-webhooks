data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Name  = "tdupoiron_github_webhook_lambda_role"
    Owner = var.aws_owner
  }
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "tdupoiron_github_webhook_lambda"
  role          = aws_iam_role.iam_role.arn

  filename         = "${var.lambda_package_path}/${var.lambda_package_name}"
  source_code_hash = filebase64sha256("${var.lambda_package_path}/${var.lambda_package_name}")

  handler = "index.handler"
  runtime = "nodejs18.x"

  tags = {
    Name  = "tdupoiron_github_webhook_lambda_function"
    Owner = var.aws_owner
  }
}

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "tdupoiron_github_webhook_api_gateway"
  protocol_type = "HTTP"

  tags = {
    Name  = "tdupoiron_github_webhook_api_gateway"
    Owner = var.aws_owner
  }
}

resource "aws_apigatewayv2_stage" "api_gateway_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "github"
  auto_deploy = true
  tags = {
    Name  = "tdupoiron_github_webhook_api_gateway_stage"
    Owner = var.aws_owner
  }
}

resource "aws_lambda_permission" "api_gateway_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*/events"
}

resource "aws_apigatewayv2_integration" "api_gateway_lambda_integration" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.lambda_function.invoke_arn
}

resource "aws_apigatewayv2_route" "api_gateway_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "ANY /events"
  target    = "integrations/${aws_apigatewayv2_integration.api_gateway_lambda_integration.id}"
}