# Day 7 – Lambda Function Deployment with S3 and IAM Role

## Objective

Set up an AWS Lambda function with a custom IAM role and S3 bucket using Terraform. Upload the Lambda code to S3 and verify deployment.

## Important Concepts

* **IAM Role:** Required for Lambda to access AWS resources securely.
* **S3 Bucket:** Storage for Lambda code so that Lambda can pull and execute it.
* **source_code_hash:** Ensures Terraform detects changes in Lambda code and triggers deployment.
* **Terraform Automation:** Automates infrastructure creation, reducing manual errors.

## Steps

### 1. Create IAM Role for Lambda

```hcl
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"
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
```

### 2. Attach Policy to the Role

```hcl
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
```

### 3. Create S3 Bucket to Store Lambda Code

```hcl
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "the-strainger-things" # Must be globally unique
  tags = {
    Name = "Lambda_Bucket"
  }
}
```

### 4. Upload Lambda Code to S3

```hcl
resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "git-final-notes-7pm.zip"
  source = "git-final-notes-7pm.zip"
}
```

### 5. Create Lambda Function

```hcl
resource "aws_lambda_function" "my_lambda" {
  function_name    = "my_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  timeout          = 900
  memory_size      = 128
  filename         = "git-final-notes-7pm.zip"
  source_code_hash = filebase64sha256("git-final-notes-7pm.zip")
}
```

## Verification

* Confirm the Lambda function is deployed in AWS Console.
* Test the function execution to ensure it works correctly.
* Check logs in CloudWatch for debugging.

## Key Takeaways

* Terraform can **automate infrastructure setup** for Lambda functions.
* **IAM roles** and **policies** are essential for secure access.
* Uploading Lambda code to **S3** allows better version control and deployment management.
* **source_code_hash** ensures updated code triggers redeployment.

> Automated creation of S3 bucket, Lambda function, and IAM role with Terraform; uploaded Lambda code to S3 and successfully verified the deployment.
