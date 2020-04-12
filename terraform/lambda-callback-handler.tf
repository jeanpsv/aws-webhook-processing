data "archive_file" "lambda-callback-zipfile" {
  type        = "zip"
  source_file = "../handlers/callback/handler.py"
  output_path = "../handlers/callback/handler.zip"
}

data "aws_iam_policy_document" "lambda-callback-assume-policy-document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "lambda-callback-role" {
  name               = "lambda-callback-handler"
  assume_role_policy = data.aws_iam_policy_document.lambda-callback-assume-policy-document.json
}

data "aws_iam_policy_document" "lambda-callback-cloudwatch-policy-document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
    effect    = "Allow"
  }

    statement {
    actions = [
      "sqs:SendMessage"
    ]
    resources = ["arn:aws:sqs:*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "lambda-callback-cloudwatch-policy" {
  name        = "lambda-callback-handler-cloudwatch-policy"
  path        = "/"
  description = "IAM Policy fro logging from Lambda callback_handler"
  policy      = data.aws_iam_policy_document.lambda-callback-cloudwatch-policy-document.json
}

resource "aws_iam_role_policy_attachment" "lambda-callback" {
  role       = aws_iam_role.lambda-callback-role.name
  policy_arn = aws_iam_policy.lambda-callback-cloudwatch-policy.arn
}

resource "aws_cloudwatch_log_group" "lambda-callback" {
  name              = "/aws/lambda/callback_handler"
  retention_in_days = 14
}

resource "aws_lambda_function" "callback-handler" {
  function_name    = "callback_handler"
  handler          = "handler.callback_handler"
  runtime          = "python3.7"
  role             = aws_iam_role.lambda-callback-role.arn
  filename         = "../handlers/callback/handler.zip"
  source_code_hash = data.archive_file.lambda-callback-zipfile.output_base64sha256
  depends_on = [
    aws_iam_role_policy_attachment.lambda-callback,
    aws_cloudwatch_log_group.lambda-callback
  ]
}

resource "aws_lambda_permission" "callback-handler" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.callback-handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.webhook.execution_arn}/*/*"
}

resource "aws_lambda_function_event_invoke_config" "callback-handler" {
  function_name = aws_lambda_function.callback-handler.function_name
  destination_config {
    on_success {
      destination = aws_sqs_queue.webhook-requests.arn
    }
  }
}