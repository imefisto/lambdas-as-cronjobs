resource "aws_cloudwatch_log_group" "logs" {
  name = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = var.retention_in_days
}
