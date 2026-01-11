resource "aws_vpc" "name" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_tag
    }
  
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.name.id
    cidr_block = var.subnet1_cidr
    availability_zone = var.subnet1_az
    tags = {
        Name = var.subnet1_tag
    }
  
}

resource "aws_subnet" "subnet2" {
    vpc_id = aws_vpc.name.id
    cidr_block = var.subnet2_cidr
    availability_zone = var.subnet2_az
    tags = {
        Name = var.subnet2_tag
    }
  
}

resource "aws_db_subnet_group" "subnet_group" {
    name = var.aws_db_subnet_group
    subnet_ids = [ aws_subnet.subnet1.id, aws_subnet.subnet2.id ]
  
}
resource "aws_security_group" "rds_sg" {
    name = var.sg_name 
    vpc_id = aws_vpc.name.id

    ingress {
    description = "MySQL access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}
resource "aws_iam_role" "rds_role" {
    name = var.aws_iam_role
    assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_access" {
    role = aws_iam_role.rds_role.name
    policy_arn = var.policy_arn
  
}


resource "aws_db_instance" "rds_instance" {
  identifier = var.identifier
  db_name = var.db_name
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  username =  var.username
  password = var.password
  engine = var.engine
  backup_retention_period = var.backup_retention_period
  backup_window = var.backup_window
  maintenance_window = var.maintenance_window
 # engine_version = var.engine_version
  publicly_accessible = false
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = aws_iam_role.rds_role.arn
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot =  var.skip_final_snapshot

  

}

resource "aws_db_instance" "rds-replica" {
  identifier =  var.replica_identifier
  replicate_source_db = aws_db_instance.rds_instance.arn  

  instance_class        = var.replica_instance_class
  engine                = var.engine

  publicly_accessible   = false
  monitoring_interval   = 60
  monitoring_role_arn  = aws_iam_role.rds_role.arn

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  
  skip_final_snapshot   = true
  
}