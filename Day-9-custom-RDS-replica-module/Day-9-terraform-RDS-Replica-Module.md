# Day-9: Custom RDS Read Replica Module

## 🎯 Objective

Create a custom Terraform module to provision an AWS RDS instance with the option to create **read replicas**, using reusable module logic.

---

## 1. Module Structure

**Child Module:** `Day-9-custom-RDS-replica-module`

Day-9-custom-RDS-replica-module/
├─ main.tf # All resources: VPC, subnets, SG, IAM, RDS instance & replica
├─ variables.tf # Input variables for the module
├─ outputs.tf # Output variables for module
└─ provider.tf # AWS provider configuration (if needed)

pgsql
Copy code

**File Responsibilities:**

- `main.tf`: All resources (VPC, subnets, DB, RDS instance, read replica, security groups, IAM roles)
- `variables.tf`: Module input variables
- `outputs.tf`: Module output variables
- `provider.tf`: AWS provider configuration (optional in child modules)

---

## 2. Resources in Module

### 2.1 VPC & Subnets

```hcl
resource "aws_vpc" "name" {
  cidr_block = var.vpc_cidr
  tags = { Name = var.vpc_tag }
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.subnet1_cidr
  availability_zone = var.subnet1_az
  tags = { Name = var.subnet1_tag }
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.subnet2_cidr
  availability_zone = var.subnet2_az
  tags = { Name = var.subnet2_tag }
}

resource "aws_db_subnet_group" "subnet_group" {
  name = var.aws_db_subnet_group
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}
2.2 Security Group
hcl
Copy code
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
2.3 IAM Role for Enhanced Monitoring
hcl
Copy code
resource "aws_iam_role" "rds_role" {
  name = var.aws_iam_role
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_access" {
  role       = aws_iam_role.rds_role.name
  policy_arn = var.policy_arn
}
2.4 Primary RDS Instance
hcl
Copy code
resource "aws_db_instance" "rds_instance" {
  identifier               = var.identifier
  db_name                  = var.db_name
  instance_class           = var.instance_class
  allocated_storage        = var.allocated_storage
  username                 = var.username
  password                 = var.password
  engine                   = var.engine
  engine_version           = var.engine_version
  backup_retention_period  = var.backup_retention_period
  backup_window            = var.backup_window
  maintenance_window       = var.maintenance_window
  publicly_accessible      = false
  monitoring_interval      = var.monitoring_interval
  monitoring_role_arn      = aws_iam_role.rds_role.arn
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]
  db_subnet_group_name     = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot      = var.skip_final_snapshot
}
2.5 Read Replica
hcl
Copy code
resource "aws_db_instance" "rds_replica" {
  identifier              = var.replica_identifier
  replicate_source_db     = aws_db_instance.rds_instance.arn
  instance_class          = var.replica_instance_class
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
}
Note: replicate_source_db must be the ARN of the primary DB instance if db_subnet_group_name is specified.

3. Variable Definitions (variables.tf)
hcl
Copy code
# VPC & Subnet
variable "vpc_cidr" { type = string }
variable "vpc_tag" { type = string }
variable "subnet1_cidr" { type = string }
variable "subnet1_az" { type = string }
variable "subnet1_tag" { type = string }
variable "subnet2_cidr" { type = string }
variable "subnet2_az" { type = string }
variable "subnet2_tag" { type = string }
variable "aws_db_subnet_group" { type = string }

# Security
variable "sg_name" { type = string }

# IAM
variable "aws_iam_role" { type = string }
variable "assume_role_policy" { type = string }
variable "policy_arn" { type = string }

# Primary RDS
variable "identifier" { type = string }
variable "db_name" { type = string }
variable "instance_class" { type = string }
variable "allocated_storage" { type = number }
variable "username" { type = string }
variable "password" { type = string }
variable "engine" { type = string }
variable "engine_version" { type = string }
variable "backup_retention_period" { type = number }
variable "backup_window" { type = string }
variable "maintenance_window" { type = string }
variable "monitoring_interval" { type = number }
variable "skip_final_snapshot" { type = bool }

# Replica
variable "replica_identifier" { type = string }
variable "replica_instance_class" { type = string }
4. Common Errors & Fixes
Error	Cause	Fix
MasterUserPassword is not valid	Password < 8 chars	Use 8+ characters for password variable
MonitoringRoleARN required	monitoring_interval set > 0 but role missing	Provide monitoring_role_arn pointing to IAM role
replicate_source_db must be ARN	Using DB identifier instead of ARN	Use aws_db_instance.rds_instance.arn for read replica
DBInstanceClass / EngineVersion combination not supported	Instance class incompatible with engine version	Check AWS supported versions for chosen instance class
identifier must be lowercase, alphanumeric, hyphen	Used uppercase/underscore	Use lowercase letters, numbers, hyphen only

5. Root Module: Day-9-passing-value-RDS-replica-module
pgsql
Copy code
Day-9-passing-value-RDS-replica-module/
└─ main.tf        # Calls the child module and passes all variable values
Root Module main.tf Example
hcl
Copy code
module "rds" {
  source = "../Day-9-custom-RDS-replica-module"

  # VPC and Subnet
  vpc_cidr = "10.0.0.0/16"
  vpc_tag  = "cust-vpc"
  
  subnet1_cidr = "10.0.1.0/24"
  subnet1_az   = "us-east-1a"
  subnet1_tag  = "subnet1"
  
  subnet2_cidr = "10.0.2.0/24"
  subnet2_az   = "us-east-1b"
  subnet2_tag  = "subnet2"
  
  aws_db_subnet_group = "cust-subnet-group"

  # Security Group
  sg_name = "cust-sg-group"

  # IAM Role for monitoring
  aws_iam_role      = "rds-Monitoring-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "rds.amazonaws.com" }
        Action = "sts:AssumeRole"
      }
    ]
  })
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"

  # Master RDS instance
  identifier               = "cust-rds"
  db_name                  = "rds_database"
  instance_class           = "db.t3.micro"
  allocated_storage        = 20
  username                 = "admin"
  password                 = "pass123456"  # 8+ characters
  engine                   = "mysql"
  engine_version           = "8.0.43"
  backup_retention_period  = 7
  backup_window            = "03:00-04:00"
  maintenance_window       = "sun:05:00-sun:06:00"
  monitoring_interval      = 60
  skip_final_snapshot      = true

  # Read Replica
  replica_identifier       = "cust-rds-replica"
  replicate_source_db      = "arn:aws:rds:us-east-1:123456789012:db:cust-rds"  # ARN of master DB
  replica_instance_class   = "db.t3.micro"
}
6. Important Notes
RDS Engine Version: Must be supported by chosen instance class.
e.g., db.t3.micro supports MySQL 8.0.43 but not 8.0.35.

Passwords: Must be at least 8 characters.

RDS Replica Rules: replicate_source_db must be ARN of master RDS if db_subnet_group_name is set.

Identifiers: Use lowercase alphanumeric and hyphens only.

IAM Role for Monitoring: Required if monitoring_interval is not 0.

Provider Block: Child module should not include empty provider block to avoid deprecation warnings.

7. Best Practices
Always use lowercase for identifier and replica_identifier.

Passwords: 8+ characters with letters, numbers, symbols.

Check AWS supported combinations for engine version and instance class.

ARN required for replicate_source_db when using db_subnet_group_name.

Module is reusable; input variables allow easy customization.

Use skip_final_snapshot = true in dev/test environments to avoid manual snapshots.

8. References
AWS RDS Terraform Docs

Read Replica Requirements

IAM Role for RDS Monitoring