# 📘 Day-8 – EventBridge Scheduled Lambda using Terraform

## 🎯 Objective

To automate a Lambda function using **Amazon EventBridge** by:

- Creating a scheduled EventBridge rule  
- Triggering a Lambda function every **5 minutes**  
- Managing everything using **Terraform (Infrastructure as Code)**  

---

## 🧠 Concept Overview

### 🔹 What is AWS EventBridge?

Amazon EventBridge is a **serverless event scheduler and event router** that:

- Triggers AWS services automatically  
- Works with:
  - Scheduled rules (**cron / rate**)
  - AWS service events  

👉 In this task, **EventBridge triggers a Lambda function every 5 minutes**.

---

## 🧩 Architecture Flow

EventBridge Rule (Cron Schedule)
↓
Lambda Permission
↓
Lambda Function

yaml
Copy code

---

## 🛠 Terraform Configuration Explanation

### 1️⃣ AWS Provider

Defines the AWS region where resources will be created.

```hcl
provider "aws" {
  region = "us-east-1"
}
2️⃣ Lambda Function
Creates a Lambda function with:

Python runtime

15-minute timeout

Packaged code (lambda_function.zip)

hcl
Copy code
resource "aws_lambda_function" "example" {
  function_name = "example-scheduled-lambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 900
  memory_size   = 128

  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
}
📌 Note:
source_code_hash ensures Lambda updates only when code changes.

3️⃣ IAM Role for Lambda
Allows Lambda service to assume the IAM role.

hcl
Copy code
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}
4️⃣ Attach Basic Execution Policy
Grants permission to write logs to CloudWatch Logs.

hcl
Copy code
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
5️⃣ EventBridge Rule (Cron Schedule)
Runs the Lambda every 5 minutes using a cron expression.

h
Copy code
resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name        = "every-five-minutes"
  description = "Trigger Lambda every 5 minutes"
  schedule_expression = "cron(0/5 * * * ? *)"
}
📌 Cron Expression Breakdown:

0/5 → every 5 minutes

* * * → every hour, day, month

? → no specific day of week

6️⃣ EventBridge Target
Connects the EventBridge rule to the Lambda function.

hcl
Copy code
resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.every_five_minutes.name
  target_id = "lambda"
  arn       = aws_lambda_function.example.arn
}
7️⃣ Lambda Permission (🔥 Most Important)
Allows EventBridge to invoke the Lambda function.

hcl
Copy code
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_five_minutes.arn
}
🚨 Without this permission, EventBridge cannot trigger Lambda

🧪 Execution Result
✅ Lambda runs automatically every 5 minutes
✅ Logs visible in CloudWatch Logs
✅ Fully automated & serverless solution

📌 Key Interview Points
EventBridge replaces traditional cron jobs

aws_lambda_permission is mandatory

EventBridge supports:

Scheduled events

AWS service events

Custom events

cron provides more control than rate

❓ Interview Q&A
Q1. Why use EventBridge with Lambda?
👉 To run Lambda automatically without managing servers or cron machines.

Q2. Difference between rate and cron?
👉 rate is simple, cron provides detailed scheduling control.

Q3. Why is aws_lambda_permission needed?
👉 It allows EventBridge to securely invoke Lambda.

Q4. Can EventBridge trigger services other than Lambda?
✅ Yes – SNS, SQS, Step Functions, ECS, API Destinations.

📝 One-Line Interview Answer
EventBridge schedules events and triggers Lambda automatically using IAM permissions.

✅ Final Status
✔ Terraform applied successfully
✔ Lambda scheduled every 5 minutes
✔ Event-driven automation achieved