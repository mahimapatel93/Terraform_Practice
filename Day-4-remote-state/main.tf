resource "aws_instance" "name" {
    ami      = "ami-068c0051b15cdb816"
    instance_type = "t2.micro"
       tags = {
        Name = "remote-state-instance"
    }
}

resource "aws_instance" "dev" {
    ami      = "ami-068c0051b15cdb816"
    instance_type = "t2.micro"
       tags = {
        Name = "ec2-instance"
    }
}


resource "aws_s3_bucket" "name" {
    bucket = "my-remote-bucket111111111111111"
}