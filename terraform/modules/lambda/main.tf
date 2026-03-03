# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.app_name}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# CloudWatch Log Group with retention
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 7
  tags              = var.tags
}

# Minimal execution policy for Lambda
resource "aws_iam_role_policy" "lambda_logging" {
  name = "${var.app_name}-logging-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "${aws_cloudwatch_log_group.lambda_logs.arn}:*"
      }
    ]
  })
}

# Lambda Function
resource "aws_lambda_function" "this" {
  filename         = var.source_path
  function_name    = "${var.app_name}-${var.environment}"
  role             = aws_iam_role.lambda_role.arn
  handler          = var.handler
  source_code_hash = var.source_hash
  runtime          = var.runtime
  memory_size      = 128
  timeout          = 10

  environment {
    variables = {
      APP_NAME    = var.app_name
      ENVIRONMENT = var.environment
    }
  }

  tags = var.tags
}

# Lambda Function URL
resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}
