variable "ami_id" {
    description = "AMI ID"
    type        = string
  
}
variable "instance_type" {
    description = "EC2 instance type"
    type        = string
}    

variable "tags" {
    description = "Tags for the instance"
    type        = map(string)
    default     = {}
}

