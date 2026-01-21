
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
    key_name = "key_pair"
    public_key = file("~/.ssh/key_pair.pub")
}
  

resource "aws_instance" "dev" {
    ami                    = "ami-068c0051b15cdb816"
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.sg_group.id]
    key_name               = aws_key_pair.key.key_name
    associate_public_ip_address = true
    tags = {
      Name = "server"
    }

    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("~/.ssh/key_pair")
        host        = self.public_ip

    }
   provisioner "file" {
     source      = "git-final-notes-7pm.txt"
     destination = "/home/ec2-user/git-final-notes-7pm.txt"
   }

}

#  ssh-keygen -t rsa -b 4096 -f ~/.ssh/key_pair    for generating key pair