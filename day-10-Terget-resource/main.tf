resource "aws_instance" "name" {
    ami      = "ami-068c0051b15cdb816"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
       tags = {
        Name = "instance"
    }
}


resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cust-vpc"
  }
}



#cammand :------------------
#terraform plan -target=aws_instance.name
# terraform apply -target=aws_instance.name