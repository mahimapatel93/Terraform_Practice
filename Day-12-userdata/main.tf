# resource "aws_instance" "server" {
#   ami = "ami-068c0051b15cdb816"
#   instance_type  = "t2.micro"

#   user_data = <<-EOF
#                 #!/bin/bash
#                 sudo apt update -y
#                 sudo apt install apache2 -y 
#                 sudo systemctl start apache2 
#                 sudo systemctl enable apache2
#                 echo "<h1> welcome to terraform practice </h1>"
#             EOF


# }

resource "aws_instance" "name" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t2.micro"

    user_data = file("test.sh")
    
    tags = {
        Name = "userdata-instance"
    }
}