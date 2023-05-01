module "generate_report" {
  source = "./modules/lambda-as-cronjob-setup"
  lambda_function_name = var.generate_report_function_name
  schedule_expression = "cron(0/5 * * * ? *)"
  additional_policy_statements = [
    {
      "Effect": "Allow",
      "Action": "ssm:GetParameter",
      "Resource": [
        "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/someapi/apikey"
      ]
    }
  ]
}

data "archive_file" "generate_report" {
  type = "zip"
  source_file = "${var.generate_report_function_name}.js"
  output_path = "${var.generate_report_function_name}.zip"
}

resource "aws_lambda_function" "generate_report" {
  filename = data.archive_file.generate_report.output_path
  function_name = var.generate_report_function_name
  role = module.generate_report.role_arn
  handler = "${var.generate_report_function_name}.handler"
  source_code_hash = data.archive_file.generate_report.output_base64sha256
  runtime = "nodejs14.x"
  timeout = 25
  environment {
    variables = {
      HOST = var.generate_report_host
      ENDPOINT = var.generate_report_endpoint
    }
  }
}

resource "aws_cloudwatch_event_target" "generate_report" {
  arn  = aws_lambda_function.generate_report.arn
  rule = module.generate_report.rule_name
}
