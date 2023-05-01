resource "aws_cloudwatch_event_rule" "rule" {
  name = "${var.lambda_function_name}-rule"
  description = "Rule for ${var.lambda_function_name}"
  schedule_expression = var.schedule_expression
}

resource "aws_lambda_permission" "allow_cloudwatch_to_trigger_lambda" {
    action = "lambda:InvokeFunction"
    function_name = var.lambda_function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.rule.arn
}
