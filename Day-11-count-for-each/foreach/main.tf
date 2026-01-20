# create multiple instances using foreach

# resource "aws_instance" "name" {
#     ami = "ami-068c0051b15cdb816"
#     instance_type = "t2.micro"
#     for_each = toset(["dev", "prod", "test"])
#     tags = {
#         Name = each.key
#     }
  
# }



# using map with foreach

# variable "instances" {
#   default = {
#     dev  = "t2.micro"
#     prod = "t2.small"
#     test = "t2.medium"
#   }
# }
# resource "aws_instance" "server" {
#     ami = "ami-068c0051b15cdb816"
#     instance_type = each.value
#     for_each = var.instances
#     tags = {
#         Name = each.key
#     }
  
# }




# conditional resource creation using foreach

variable "enable_instance" {
  default = true
}

variable "instances" {
  default = {
    dev  = "t2.micro"
    prod = "t2.small"
    test = "t2.medium"
  }
}
resource "aws_instance" "server" {
    ami = "ami-068c0051b15cdb816"
    instance_type = each.value
    for_each = var.enable_instance ? var.instances : {}   # if false, empty map so no resource created, {} means empty map
    tags = {
        Name = each.key
    }
  }  # tf apply -var="enable_instance=false"  to skip instance creation
     # tf apply -var="enable_instance=true"  to create instance
     # By default, it's true so instances will be created
     # You can change the value during apply to test both scenarios
       
