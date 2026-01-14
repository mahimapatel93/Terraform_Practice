## What are Locals?
# Locals are named values defined inside Terraform configuration to reuse expressions and avoid duplication.

locals {
  ami =  "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
  type          ="t2.medium"
  availability_zone = "us-east-1a"
  Name = "instance"
  Name1 = "dev"
}

resource "aws_instance" "name" {
   ami = local.ami
   instance_type = local.instance_type
   availability_zone = local.availability_zone

   tags = {
     Name = local.Name
   }

}

resource "aws_instance" "name1" {
   ami = local.ami
   instance_type = local.type
   availability_zone = local.availability_zone

   tags = {
     Name = local.Name1
   }

}
