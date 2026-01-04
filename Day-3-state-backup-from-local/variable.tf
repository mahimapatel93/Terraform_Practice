variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = ""
}
variable "instance_type" {
  description = "The type of instance to use"
  type        = string
  default     = ""
}