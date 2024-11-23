provider "aws" {
  region     = "eu-west-1"
  access_key = "AKIATR3Y72NI5E2TSO7R"
  secret_key = "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"
}

# SQS Queue
resource "aws_sqs_queue" "taelqueue" {
  name                      = "taelqueue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role_tael002"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Lambda Execution
resource "aws_iam_policy" "lambda_exec_policy" {
  name        = "lambda_exec_policy_tael"
  description = "Policy for Lambda to access SQS and S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"],
        Resource = aws_sqs_queue.taelqueue.arn
      },
      {
        Effect   = "Allow",
        Action   = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"],
        Resource = [
          "arn:aws:s3:::pgr301-couch-explorers",
          "arn:aws:s3:::pgr301-couch-explorers/18/*",
          "arn:aws:s3:::pgr301-couch-explorers/images/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect   = "Allow",
        Action   = ["bedrock:InvokeModel"],
        Resource = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-image-generator-v1"
      }
    ]
  })
}

# Attach the IAM Policy to the Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_exec_policy.arn
}

# Lambda Function
resource "aws_lambda_function" "lambda_function" {
  function_name = "lambda-function-tael002"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_sqs.lambda_handler"
  runtime       = "python3.9"

s3_bucket = "pgr301-2024-terraform-state"
s3_key    = "18/lambda_sqs.zip"


  memory_size = 512
  timeout     = 30

  environment {
    variables = {
      QUEUE_URL   = aws_sqs_queue.taelqueue.id
      BUCKET_NAME = "pgr301-couch-explorers"  # Bucket for generated images
    }
  }
}

# Allow SQS to Invoke Lambda
resource "aws_lambda_permission" "sqs_invoke" {
  statement_id  = "AllowSQSInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.taelqueue.arn
}

# SQS to Lambda Event Source Mapping
resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
  event_source_arn  = aws_sqs_queue.taelqueue.arn
  function_name     = aws_lambda_function.lambda_function.function_name
  batch_size        = 10
  enabled           = true
}
