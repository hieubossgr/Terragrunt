
data "archive_file" "lambda" {
  type = "zip"
  source_file = "./lambda.py"
  output_path = var.lambda_package
}

resource "aws_lambda_function" "cronjob_lambda" {
  filename         = var.lambda_package
  function_name    = "python_terraform_lambda"
  role             = aws_iam_role.lambda_exec.arn
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.10"
  handler          = "lambda_handler"

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [var.security_group_id]
  }
}

resource "aws_cloudwatch_event_rule" "cron_schedule" {
  name        = "${var.project_name}-cron-schedule"
  description = "Triggers Lambda every hour"
  schedule_expression = "cron(0 * * * ? *)" 
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.cron_schedule.name
  target_id = "lambda_cronjob"
  arn       = aws_lambda_function.cronjob_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cronjob_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron_schedule.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.project_name}-lambda-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "${var.project_name}-lambda-policy"
  role   = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ecs:DescribeTasks",
          "ecs:ListTasks",
          "ecs:StartTask",
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "logs:*"
        Resource = "*"
      },
    ]
  })
}