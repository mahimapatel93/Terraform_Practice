variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-068c0051b15cdb816"
}
variable "instance_type" {
  description = "The type of instance to use"
  type        = string
  default     = "t2.micro"
}
