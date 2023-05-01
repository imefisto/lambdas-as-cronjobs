resource "aws_iam_role" "role_for_lambda" {
  name = "${var.lambda_function_name}-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "policy_for_lambda" {
  name = "${var.lambda_function_name}-policy"

  policy = jsonencode({
    "Version": "2012-10-17", 
    "Statement": concat([
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": [
          "${aws_cloudwatch_log_group.logs.arn}:*"
        ]
      }
    ], var.additional_policy_statements)
  })
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.role_for_lambda.name
  policy_arn = aws_iam_policy.policy_for_lambda.arn
}
