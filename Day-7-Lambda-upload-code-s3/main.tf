#create iam role for lambda function
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
    
}
)
}

#attach policy to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# create s3 bucket to store lambda code
resource "aws_s3_bucket" "lambda_bucket" {
    bucket = "the-strainger-things" # Bucket name must be globally unique
    tags = {
        Name        = "Lambda_Bucket"
    }

}

resource "aws_s3_object" "lambda_code" {
    bucket = aws_s3_bucket.lambda_bucket.id
    key    = "app.zip"
    source = "app.zip"
}


# create lambda function
resource "aws_lambda_function" "my_lambda" {
    function_name = "my_lambda_function"
    role          = aws_iam_role.lambda_role.arn
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.12"
    timeout       = 900
    memory_size  = 128
    filename      = "app.zip"
    source_code_hash = filebase64sha256("app.zip")

}

 #Without source_code_hash, Terraform might not detect when the code in the ZIP file has changed — meaning your Lambda might not update even after uploading a new ZIP.

#This hash is a checksum that triggers a deployment.
