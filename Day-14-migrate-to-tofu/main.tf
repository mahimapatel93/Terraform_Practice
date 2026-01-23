# resource "aws_instance" "name" {
#     ami          = "ami-068c0051b15cdb816"
#     instance_type = "t2.micro"
#     provisioner "local-exec" {
#         command = "echo Instance has been created"
#     }
  
# }

# using local-exec provisioner to run a script after resource creation

resource "aws_instance" "name" {
    ami          = "ami-068c0051b15cdb816"
    instance_type = "t2.micro"
    provisioner "local-exec" {
        command = "echo Instance has been created"
    }
    provisioner "local-exec" {
        when    = destroy
        command = "echo Instance is being destroyed"
    }
  
}
