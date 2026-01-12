Day 7 – Lambda Function Deployment with S3 and IAM Role
Objective

Set up an AWS Lambda function with a custom IAM role and S3 bucket using Terraform. Upload the Lambda code to S3 and verify deployment, ensuring Terraform correctly detects code changes.

Important Concepts

IAM Role: Required for Lambda to access AWS resources securely.

S3 Bucket: Stores the Lambda deployment package (ZIP file).

ETag (S3 Object): Helps Terraform detect changes in the uploaded ZIP file and re-upload it to S3.

source_code_hash (Lambda): Ensures Terraform detects Lambda code changes and triggers a redeployment.

Terraform Automation: Automates infrastructure creation, reducing manual errors and configuration drift and configuration drift.

Why ETag and source_code_hash Are Both Needed

When deploying Lambda using S3:

ETag works at the S3 level

Terraform compares the MD5 hash of the local ZIP file with the S3 object

If the hash changes, Terraform re-uploads the file

source_code_hash works at the Lambda level

Terraform compares the SHA256 hash of the ZIP file

If the hash changes, Terraform updates the Lambda function code

👉 Without ETag, S3 may not upload the new ZIP.
👉 Without source_code_hash, Lambda may continue running old code.

Steps
1. Create IAM Role for Lambda
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
2. Attach Policy to the Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
3. Create S3 Bucket to Store Lambda Code
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "the-strainger-things" # Must be globally unique
  tags = {
    Name = "Lambda_Bucket"
  }
}
4. Upload Lambda Code to S3 (Using ETag)
resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "app.zip"
  source = "app.zip"


  etag = filemd5("app.zip")
}

Why ETag is used here:

Ensures Terraform uploads the ZIP again when the file content changes

Prevents stale code from remaining in S3

5. Create Lambda Function (Using source_code_hash)
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 900
  memory_size  = 128


  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_code.key


  source_code_hash = filebase64sha256("app.zip")
}

Why source_code_hash is required:

Terraform does not automatically detect ZIP changes

This hash forces Lambda code redeployment when the ZIP changes

Why ETag and source_code_hash Are Both Needed

When deploying Lambda using S3:

ETag works at the S3 level

Terraform compares the MD5 hash of the local ZIP file with the S3 object

If the hash changes, Terraform re-uploads the file to S3

source_code_hash works at the Lambda level

Terraform compares the SHA256 hash of the ZIP file

If the hash changes, Terraform updates the Lambda function code

👉 Without ETag, S3 may not upload the new ZIP.

👉 Without source_code_hash, Lambda may continue running old code.

Verification

Confirm the Lambda function is deployed in AWS Console.

Test the function execution to ensure it works correctly.

Check logs in CloudWatch for debugging.

Key Takeaways

ETag ensures updated code is uploaded to S3

source_code_hash ensures updated code is deployed to Lambda

Both are required to keep S3 and Lambda fully in sync

Terraform provides a repeatable and reliable deployment process