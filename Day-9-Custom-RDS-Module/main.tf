resource "aws_vpc" "name" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "vpc"
    }
  
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.name.id
    cidr_block = var.subnet1_cidr
    availability_zone = "us-east-1a"
    tags = {
        Name = "subnet1"
    }
  
}

resource "aws_subnet" "subnet2" {
    vpc_id = aws_vpc.name.id
    cidr_block = var.subnet2_cidr
    availability_zone = "us-east-1b"
    tags = {
        Name = "subnet2"
    }
  
}

resource "aws_db_subnet_group" "subnet_group" {
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    tags = {
        Name = "subnet_group"
    }
}

resource "aws_iam_role" "rds_role" {
  name = "rds_custom_password_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_db_instance" "rds_instance" {
  identifier              = var.rds_instance_identifier
  db_name                 = var.db_name
  allocated_storage       = var.rds_allocated_storage
  engine                  = var.rds_engine
  engine_version          = "8.0"
  instance_class          = var.rds_instance_class
  username                = var.rds_username
  password                = var.rds_password
  db_subnet_group_name    = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot     = true

  tags = {
    Name = "rds_instance"
  }
}
