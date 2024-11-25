output "sqs_queue_url" {
  description = "URL of the SQS queue"
  value       = aws_sqs_queue.taelqueue.id
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.lambda_function.arn
}

output "cloudwatch_alarm_name" {
  value       = aws_cloudwatch_metric_alarm.sqs_oldest_message_alarm.alarm_name
  description = "CloudWatch alarm name"
  
}
output "sns_topic_arn" {
  value = aws_sns_topic.alarm_topic.arn
  description = "The ARN of the SNS topic configured for cloudwatch alarm notification"
}