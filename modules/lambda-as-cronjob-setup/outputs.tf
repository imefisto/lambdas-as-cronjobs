output "role_arn" {
  value = aws_iam_role.role_for_lambda.arn
}

output "rule_name" {
  value = aws_cloudwatch_event_rule.rule.id
}
