data "archive_file" "lambda-worker-zipfile" {
  type        = "zip"
  source_file = "../handlers/worker/handler.py"
  output_path = "../handlers/worker/handler.zip"
}

data "aws_iam_policy_document" "lambda-worker-assume-policy-document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "lambda-worker-role" {
  name               = "lambda-worker-handler"
  assume_role_policy = data.aws_iam_policy_document.lambda-worker-assume-policy-document.json
}

data "aws_iam_policy_document" "lambda-worker-cloudwatch-policy-document" {
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
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
    ]
    resources = ["arn:aws:sqs:*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = ["arn:aws:lambda:*:*:function:*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "lambda-worker-cloudwatch-policy" {
  name        = "lambda-worker-handler-cloudwatch-policy"
  path        = "/"
  description = "IAM Policy fro logging from Lambda worker_handler"
  policy      = data.aws_iam_policy_document.lambda-worker-cloudwatch-policy-document.json
}

resource "aws_iam_role_policy_attachment" "lambda-worker" {
  role       = aws_iam_role.lambda-worker-role.name
  policy_arn = aws_iam_policy.lambda-worker-cloudwatch-policy.arn
}

resource "aws_cloudwatch_log_group" "lambda-worker" {
  name              = "/aws/lambda/worker_handler"
  retention_in_days = 14
}

resource "aws_lambda_function" "worker-handler" {
  function_name    = "worker_handler"
  handler          = "handler.worker_handler"
  runtime          = "python3.7"
  role             = aws_iam_role.lambda-worker-role.arn
  filename         = "../handlers/worker/handler.zip"
  source_code_hash = data.archive_file.lambda-worker-zipfile.output_base64sha256
  depends_on = [
    aws_iam_role_policy_attachment.lambda-worker,
    aws_cloudwatch_log_group.lambda-worker
  ]
}

resource "aws_lambda_event_source_mapping" "worker-handler" {
  event_source_arn = aws_sqs_queue.webhook-requests.arn
  function_name    = aws_lambda_function.worker-handler.arn
  enabled          = true
  batch_size = 1
}