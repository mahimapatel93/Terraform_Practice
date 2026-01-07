resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my_vpc"
    }
  
}

resource "aws_subnet" "name" {
    vpc_id            = aws_vpc.name.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "my_subnet"
    }
}   

resource "aws_subnet" "name2" {
    vpc_id            = aws_vpc.name.id
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "my_subnet2"
    }
}

resource "aws_db_subnet_group" "name" {
    name       = "my_db_subnet_group"
    subnet_ids = [aws_subnet.name.id, aws_subnet.name2.id]
    tags = {
        Name = "my_db_subnet_group"
    }
}

resource "aws_iam_role" "rds_role" {
    name = "rds_custom_password_role"
    assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "monitoring.rds.amazonaws.com"
                ]
            },
            "Action": [
                "sts:AssumeRole"
            ]
        }
    ]
})
}


# rds instance with customer managed password

resource "aws_db_instance" "name" {
    identifier              = "mydbinstance"
    allocated_storage       = 20
    engine                  = "mysql"
    engine_version          = "8.0"
    instance_class          = "db.t3.micro"
    username                = "admin"
    password                = "cloud1234" # static password for demo purpose only
   # manage_master_user_password = false #rds and secret manager manage this password
    db_subnet_group_name    = aws_db_subnet_group.name.name
    parameter_group_name = "default.mysql8.0" # default parameter group for mysql 8.0
    # enable backup and retention
    backup_retention_period = 7 # days 
    backup_window = "02:00-03:00" # daily backup window UTC time
    monitoring_interval = 60  # in seconds 
    monitoring_role_arn = aws_iam_role.rds_role.arn # IAM role for enhanced monitoring 
    deletion_protection = true
    skip_final_snapshot     = true
    tags = {
        Name = "my_db_instance"
    }
}


resource "aws_db_instance" "replica" {
    identifier = "my-db-replica"
    engine = "mysql"
    replicate_source_db = aws_db_instance.name.arn
    instance_class = "db.t3.micro"
    db_subnet_group_name = aws_db_subnet_group.name.name
    tags = {
        Name = "my_db_replica"
    }
  
}