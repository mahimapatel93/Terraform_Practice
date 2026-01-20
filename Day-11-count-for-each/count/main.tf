# count is used to create multiple resources of the same type with similar configurations.

# resource "aws_instance" "name" {
#   ami = "ami-068c0051b15cdb816"
#   instance_type = "t2.micro"
#         count = 2
#     tags = {
#         Name = "dev"
#         }
# }


# resource "aws_instance" "name" {
#    ami = "ami-068c0051b15cdb816"
#    instance_type = "t2.micro"
#        count = 2 
#        tags = {
#         Name = "ec2-${count.index}"
#        }
# }


#using count with a list 
# this will create 3 instances with names dev , prod , test

# variable "names"{
#     type = list(string)
#     default = [ "dev", "prod", "test"] 

# }

# resource "aws_instance" "instance" {
#   ami = "ami-068c0051b15cdb816"
#   instance_type = "t2.micro"
#         count = length(var.names)
#         tags = {
#             Name = var.names[count.index]
#         }
# }


# condtional resource creation using count

# variable "create_instance" {
#   type = bool
#   default = true
# }

# resource "aws_instance" "server" {
#   ami = "ami-068c0051b15cdb816"
#   instance_type = "t2.micro"
#   count = var.create_instance ? 1 : 0
#     tags = {
#         Name = "conditional-instance"
#     }
# }  # tf apply -var="create_instance=false"  to skip instance creation





# conditional count using environment variable

# variable "environment" {
#   default = "dev"
# }

# resource "aws_instance" "env_instance" {
#   ami =  "ami-068c0051b15cdb816"
#     instance_type = "t2.micro"
#     count = var.environment == "prod" ? 2 : 1

#     tags = {
#         Name =  "env-${var.environment}"
#     }
# }    # tf apply -var="environment=prod"  to create instance





# condition count with multiple resources

variable "instance_count" {
  default = 2
}

variable "enable_instance" {
  default = true
}

resource "aws_instance" "test" {
  ami =  "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
  count = var.enable_instance ? var.instance_count : 0
    tags = {
        Name =  "test-instance-${count.index}"
    }
}

