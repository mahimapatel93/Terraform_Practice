# Day-9: Terraform Custom Module Practice (RDS)

---

## 🎯 Objective

Learn to create and use a **custom Terraform module** to provision an **AWS RDS (MySQL) instance** along with required networking components like **VPC, Subnets, and DB Subnet Group**, using reusable module logic.

---

## 📖 Definition of Terraform Modules

A **Terraform module** is a collection of Terraform resources that are grouped together to be reused across multiple environments.  
Modules help in:

- Reusability
- Clean code structure
- Passing values dynamically
- Managing complex infrastructure easily

Modules can be:
- **Root Module** (where values are passed)
- **Child Module** (where resources are created)

---

## 📁 Folder Structure

Terraform_Practice/
├── Day-9-Custom-RDS-Module/ # Main module
│ ├── main.tf # VPC, Subnets, RDS, IAM Role
│ └── variables.tf # Input variables
└── Day-9-reusing-RDS-Module/ # Root module
└── main.tf # Module call with values


---

## Module: Day-9-Custom-RDS-Module

This module is responsible for creating **all AWS resources**.

---

## 1️⃣ variables.tf

```hcl
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "subnet1_cidr" {
  description = "CIDR block for Subnet 1"
  type        = string
}

variable "subnet2_cidr" {
  description = "CIDR block for Subnet 2"
  type        = string
}

variable "rds_instance_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "rds_engine" {
  description = "Database engine"
  type        = string
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "rds_allocated_storage" {
  description = "Allocated storage for RDS"
  type        = number
}

variable "rds_username" {
  description = "Master username"
  type        = string
}

variable "rds_password" {
  description = "Master password"
  type        = string
}
🔑 Logic
Variables allow dynamic input

Same module can be reused in multiple environments

No hard-coding inside the module

2️⃣ main.tf (Child Module)
VPC
hcl
Copy code
resource "aws_vpc" "name" {
  cidr_block = var.vpc_cidr
}
Logic:

Creates a private AWS network

RDS must always be inside a VPC

Subnets (High Availability)
hcl
Copy code
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = var.subnet1_cidr
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = var.subnet2_cidr
  availability_zone = "us-east-1b"
}
Logic:

RDS requires minimum 2 subnets

Subnets must be in different AZs

Ensures high availability

DB Subnet Group
hcl
Copy code
resource "aws_db_subnet_group" "subnet_group" {
  subnet_ids = [
    aws_subnet.subnet1.id,
    aws_subnet.subnet2.id
  ]
}
Logic:

RDS does not accept subnets directly

It requires a DB Subnet Group

Defines where RDS can be launched

IAM Role (Created Only)
hcl
Copy code
resource "aws_iam_role" "rds_role" {
  name = "rds_custom_password_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
Logic:

IAM role is created for RDS Enhanced Monitoring

Currently:

Role is created

Policy is NOT attached

Role is NOT assigned to RDS

RDS Instance
hcl
Copy code
resource "aws_db_instance" "rds_instance" {
  identifier           = var.rds_instance_identifier
  db_name              = var.db_name
  engine               = var.rds_engine
  instance_class       = var.rds_instance_class
  allocated_storage    = var.rds_allocated_storage
  username             = var.rds_username
  password             = var.rds_password
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot  = true
}
Logic:

Creates actual MySQL RDS database

Uses subnet group for networking

Username & password used for DB login

Root Module (Module Call)
hcl
Copy code
module "rds_instance" {
  source = "../Day-9-Custom-RDS-Module"

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
Logic:

Root module passes values

Child module creates resources

Same module can be reused for different environments

📊 Diagram (Module Flow)
sql
Copy code
        ┌──────────────────────┐
        │     Root Module      │
        │ (Values Passed)      │
        └─────────┬────────────┘
                  │ calls
                  ▼
     ┌────────────────────────────┐
     │  Day-9-Custom-RDS-Module   │
     └─────────┬──────────────────┘
               │
               ▼
 ┌──────────────────────────────────┐
 │ VPC → Subnets → Subnet Group     │
 │ IAM Role → RDS MySQL Instance    │
 └──────────────────────────────────┘
🔑 Key Concepts Learned
One module can manage multiple resources

Variables make modules reusable

RDS requires:

VPC

Two subnets

DB subnet group

IAM roles must be:

Created

Given policy

Assigned to service

Module-based Terraform code is clean, scalable, and professional

🎯 Final Takeaway
A single custom Terraform module can provision a complete RDS infrastructure while keeping the code reusable, organized, and easy to manage.