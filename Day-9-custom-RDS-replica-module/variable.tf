variable "vpc_cidr" {
description = "vpc_cidr_value"
type = string
  
}
variable "vpc_tag" {
    description = "tags of vpc"
    type = string
  
}

variable "subnet1_cidr" {
    description = "cidr value of subnet1"
    type = string
  
}

variable "subnet1_az" {
  description = "availbilty zone of subnet1"
  type = string
}

variable "subnet1_tag" {
  description = "name of subnet1"
  type = string
}

variable "subnet2_cidr" {
  description = " value of subnet2"
  type = string
}

variable "subnet2_az" {
    description = " value of subnet2_az"
    type = string
  
}

variable "subnet2_tag" {
    description = "value of subnet2_tag"
    type = string
  
}

variable "aws_db_subnet_group" {
    description = "value of db subnet group"
    type = string
  
}


variable "aws_iam_role" {
    description = " value of iam role"
    type = string
  
}

variable "assume_role_policy" {
    description = " value of assume role policy"
    type = string
  
}

variable "identifier" {
type = string
  
}

variable "db_name" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "engine" {
  type = string
}

#variable "engine_version" {
#    type = string
#}

variable "backup_retention_period" {
  type = number
}

variable "backup_window" {
  type = string
}

variable "maintenance_window" {
  type = string
}

variable "skip_final_snapshot" {
  type = bool
}


variable "policy_arn" {
  type = string
}

variable "monitoring_interval" {
  type = number
}

variable "sg_name" {
  type = string
}

variable "replica_instance_class" {
    type = string
  
}

variable "replica_identifier" {
  type = string
}
