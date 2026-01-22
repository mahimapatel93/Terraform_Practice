# resource "null_resource" "name" {

#     triggers = {
#         runs = timestamp()
#     }

#     provisioner "local-exec" {
#       command = "echo Null Resource has been created hahahha"
#     }
  
# }



# using null resource with local-exec provisioner to run a script after resource creation
# resource "null_resource" "name" {

#     triggers = {
#         runs = timestamp()
#     }

#     provisioner "local-exec" {
#       command = "echo Null Resource has been created"
#     }

#     provisioner "local-exec" {
#         when    = destroy
#         command = "echo Null Resource is being destroyed"
#     }
  
# }




# using null resource with local-exec provisioner to upload a file to s3 bucket after its creation

# resource "aws_s3_bucket" "bucket" {
#   bucket = "the-strainger-things"
# }

# resource "null_resource" "name" {
#   depends_on = [ aws_s3_bucket.bucket ]

#   provisioner "local-exec" {
#     command = "aws s3 cp file.txt s3://${aws_s3_bucket.bucket.bucket}/file.txt"    # upload file.txt to s3 bucket 
    
#   }
# }




resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "my-vpc"
    }
  
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "my-subnet"
    }
}

resource "aws_security_group" "sg" {
    name      = "allow_ssh_http"
    vpc_id    = aws_vpc.vpc.id

    ingress{
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 

    egress{
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name = "igw"
    }
  
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}


resource "aws_route_table_association" "rta" {
    subnet_id      = aws_subnet.subnet.id
    route_table_id = aws_route_table.rt.id
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


resource "aws_iam_instance_profile" "profile" {
  name = "ec2_s3_access_profile"
  role = aws_iam_role.ec2_role.name
}


resource "aws_key_pair" "key_pair" {
   key_name = "key-pair"
   public_key = file("~/.ssh/key-pair.pub")
}


resource "aws_instance" "server" {
  ami =  "ami-068c0051b15cdb816"
    instance_type = "t2.nano"
    subnet_id = aws_subnet.subnet.id
    vpc_security_group_ids = [aws_security_group.sg.id]
    iam_instance_profile = aws_iam_instance_profile.profile.name
    key_name = aws_key_pair.key_pair.key_name
    associate_public_ip_address = true

    tags = {
      Name = "my-instance"
    }


}

resource "aws_s3_bucket" "bucket" {
  bucket = "the-strainger-things"
}


resource "null_resource" "name" {
    depends_on = [ aws_s3_bucket.bucket ]

    connection {
      type = "ssh"
      user = "ec2-user"
        private_key = file("~/.ssh/key-pair")
        host = aws_instance.server.public_ip
    }
    provisioner "file" {
        source      = "file.txt"
        destination = "/home/ec2-user/file.txt"
    }

    provisioner "remote-exec" {
        inline = [
            "aws s3 cp /home/ec2-user/file.txt s3://${aws_s3_bucket.bucket.bucket}/file.txt",
        ]
      
    }

}

# ssh-keygen -t rsa -b 4096 -f ~/.ssh/key-pair           use this command in current directory to generate key pair
# terraform import aws_key_pair.key_pair key-pair    use this command to import existing key
