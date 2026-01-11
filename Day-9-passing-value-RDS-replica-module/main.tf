module "test" {
  source = "../Day-9-custom-RDS-replica-module"

  vpc_cidr = "10.0.0.0/16"
  vpc_tag  = "cust-vpc"

  subnet1_cidr = "10.0.1.0/24"
  subnet1_az   = "us-east-1a"
  subnet1_tag  = "subnet1"

  subnet2_cidr = "10.0.2.0/24"
  subnet2_az   = "us-east-1b"
  subnet2_tag  = "subnet2"

  aws_db_subnet_group = "cust-subnet-group"
  sg_name             = "cust-sg-group"

  aws_iam_role = "rds-Monitoring-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "monitoring.rds.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"

  identifier               = "cust-rds"
  db_name                  = "rds_database"
  instance_class           = "db.t3.micro"
  allocated_storage        = 20
  username                 = "admin"
  password                 = "pass87655123"
  engine                   = "mysql"
  backup_retention_period  = 7
  backup_window            = "03:00-04:00"
  maintenance_window       = "sun:05:00-sun:06:00"
  monitoring_interval      = 60
  skip_final_snapshot      = true

 replica_identifier = "cust-rds-replica"
  replica_instance_class = "db.t3.micro"
}

