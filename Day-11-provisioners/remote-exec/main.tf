# resource "aws_security_group" "allow_ssh_http" {
#   name = "allow_ssh_http"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }




# resource "aws_instance" "name" {
#   ami = "ami-068c0051b15cdb816"
#   instance_type = "t2.micro"
#   key_name = "my-key"
#   vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
#   associate_public_ip_address = true


#   connection {
#     type = "ssh"                       # specify connection type
#     user = "ec2-user"                  # default user for Amazon Linux
#     private_key = file("my-key.pem")  # path to your private key file
#     host = self.public_ip                # use the instance's public IP
#     timeout     = "10m"                  # optional, agar EC2 slow ho to
#   } 

#   provisioner "remote-exec" {
#     inline = [
#         "sudo yum update -y",               # update packages
#         "sudo yum install -y httpd",        # install Apache    
#         "sudo systemctl start httpd",       # start Apache service
#         "sudo systemctl enable httpd",      # enable Apache to start on boot
#      ]
#   }

# }


# #associate_public_ip_address = true


resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
  
}

resource "aws_subnet" "public" {
   vpc_id = aws_vpc.my-vpc.id
   cidr_block = "10.0.1.0/24"
   tags = {
     Name = "public-subnet"
   }
}

resource "aws_security_group" "sg_group" {
    name        = "allow_ssh_http"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id      = aws_vpc.my-vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my-vpc.id
    tags = {
        Name = "my-igw"
    }
}


resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "public-route-table"
    }
}

resource "aws_route_table_association" "public_assoc" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public_rt.id
}


resource "aws_key_pair" "key" {
    key_name = "cust-key_name"
    public_key = file("~/.ssh/cust-key_name.pub")
}
  

resource "aws_instance" "web" {
    ami                    = "ami-068c0051b15cdb816"
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.sg_group.id]
    key_name               = aws_key_pair.key.key_name
    associate_public_ip_address = true

    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("~/.ssh/cust-key_name")
        host        = self.public_ip

    }

    provisioner "remote-exec" {
        inline = [ 
            "sudo yum update -y",
            "sudo yum install -y httpd",
            "sudo systemctl start httpd",
            "sudo systemctl enable httpd",
         ]
      
    }
}
 

#  ssh-keygen -t rsa -b 4096 -f ~/.ssh/cust-key_name    for generating key pair