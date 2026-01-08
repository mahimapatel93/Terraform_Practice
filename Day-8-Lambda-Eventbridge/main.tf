# create lambda function
resource "aws_lambda_function" "my_lambda" {
  filename         = "lambda_function.zip"
  function_name    = "my_lambda_function"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  timeout          = 15
  memory_size      = 128
  source_code_hash = filebase64sha256("lambda_function.zip")

}

# create iam role for lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

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

# attach policy to iam role
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# create custom policy for lambda to access rds
resource "aws_iam_policy" "lambda_rds_policy" {
  name        = "lambda_rds_access_policy"
  description = "Policy for Lambda to access RDS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:DescribeDBInstances",
          "rds:Connect"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
# attach custom policy to iam role
resource "aws_iam_role_policy_attachment" "lambda_rds_policy_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_rds_policy.arn
}


# create eventbridge rule to trigger lambda every 5 minutes (cron expression)
resource "aws_cloudwatch_event_rule" "every_5_minutes" {
  name                = "every_5_minutes_rule"
  description         = "Triggers every 5 minutes"
  schedule_expression = "rate(5 minutes)"
}
# create eventbridge target to link rule to lambda
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_5_minutes.name
  target_id = "my_lambda_target"
  arn       = aws_lambda_function.my_lambda.arn
}

# give eventbridge permission to invoke lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_5_minutes.arn
}

