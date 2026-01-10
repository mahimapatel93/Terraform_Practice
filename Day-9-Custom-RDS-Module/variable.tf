variable "vpc_cidr" {
    description = "CIDR block for the VPC"
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
  description = "RDS Instance Identifier"
  type        = string
  
}

variable "rds_role_name" {
  description = "IAM role name for RDS"
  type        = string
}

variable "db_name" {
    description = "Database name for RDS"
    type        = string
  
}

variable "rds_policy_arn" {
  description = "Policy ARN for RDS enhanced monitoring"
  type        = string
}


variable "rds_instance_class" {
  description = "Instance class for RDS"
  type        = string
}
variable "rds_engine" {
  description = "Database engine for RDS"
  type        = string
}

variable "rds_username" {
  description = "Master username for RDS"
  type        = string
}
variable "rds_password" {
  description = "Master password for RDS"
  type        = string
}
variable "rds_allocated_storage" {
  description = "Allocated storage (in GB) for RDS"
  type        = number
}
