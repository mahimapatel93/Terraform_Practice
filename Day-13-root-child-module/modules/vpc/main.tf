resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet1_cidr
    availability_zone =  var.az1
  
}

resource "aws_subnet" "subnet2" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet2_cidr
    availability_zone =  var.az2
  
}
