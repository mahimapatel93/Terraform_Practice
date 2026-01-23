resource "aws_s3_bucket" "name" {
    bucket = "the-strainger-things"
}

resource "aws_instance" "server" {
  ami = "ami-068c0051b15cdb816"
    instance_type = "t2.nano"

    tags = {
      Name = "ec2-instance"
    }
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }

    provisioner "local-exec" {
        command = "echo VPC has been created with CIDR block ${self.cidr_block}"
      
    }
}