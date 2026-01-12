# data "aws_vpc" "name"{
#     filter {
#       name = "tag:Name"
#       values = ["cust-vpc"]
#     }
# }


# resource "aws_subnet" "subnet1" {
#     vpc_id = data.aws_vpc.name.id
#     availability_zone = "us-east-1a"
#     cidr_block = "10.0.0.0/24"
#     tags = {
#       name = "subnet1"
#     }

  
# }

# resource "aws_subnet" "subnet2" {
#   vpc_id = data.aws_vpc.name.id
#   availability_zone = "us-east-1b"
#   cidr_block = "10.0.1.0/24"
#   tags = {
#     name = "subnet2"
#   }
# }


data "aws_s3_bucket" "name"{
    bucket  = "the-strainger-thingssssss"
}


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

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_s3_object" "lambda_code" {
    bucket = data.aws_s3_bucket.name.id
    key    = "app.zip"
    source = "app.zip"
    etag = filemd5("app.zip")
  }

resource "aws_lambda_function" "my_lambda" {
    function_name = "my_lambda_function"
    role          = aws_iam_role.lambda_role.arn
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.12"
    timeout       = 900
    memory_size  = 128
    s3_key = aws_s3_object.lambda_code.key
    s3_bucket = data.aws_s3_bucket.name.id
    source_code_hash = filebase64sha256("app.zip")

}

#aws_s3_bucket data source does not support filters; it requires the bucket name directly using the bucket argument.