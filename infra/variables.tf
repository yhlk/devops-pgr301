variable "sqs_queue_name" {
  description = "Navn på SQS køen"
  type        = string
  default     = "tael002"
}

variable "lambda_function_name" {
  description = "Navn på Lambda-funksjonen"
  type        = string
  default     = "lambda-function"
}

variable "lambda_s3_bucket" {
  description = "Navn på S3 bucket for Lambda kode"
  type        = string
  default     = "pgr301-couch-explorers"
}

variable "lambda_s3_key" {
  description = "S3 nøkkel for Lambda kode"
  type        = string
  default     = "lambda/lambda_sqs.zip"
}

variable "alarm_email" {
  description = "Email address for receiving CloudWatch alarm alerts"
  type = string
  default = "tael002@student.kristiania.no"
}