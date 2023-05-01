variable "lambda_function_name" {
  description = "Lambda function name"
  type = string
}

variable "retention_in_days" {
  description = "How many days the logs must be preserved"
  type = number
  default = 7
}

variable "additional_policy_statements" {
  description = "Additional policy statements for the lambda function"
  type = list
  default = []
}

variable "schedule_expression" {
  description = "A schedule expression to set an event rule to trigger the lambda function"
  type = string
}
