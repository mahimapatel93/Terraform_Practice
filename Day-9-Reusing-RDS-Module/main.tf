module "rds_instance" {
  source = "../Day-9-Custom-RDS-Module"

  rds_role_name = "rds-monitoring-role"
  rds_policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"

  vpc_cidr                = "10.0.0.0/16"
  subnet1_cidr            = "10.0.1.0/24"
  subnet2_cidr            = "10.0.2.0/24"
  rds_instance_identifier = "my-rds-db"
  db_name                 = "rds_db"
  rds_engine              = "mysql"
  rds_instance_class      = "db.t3.micro"
  rds_allocated_storage   = 20
  rds_username            = "admin"
  rds_password            = "Admin123!"
}
