# create vpc
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "custom-vpc"
    }
}

# create subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = "10.0.1.0/24"
    tags = {
        Name = "public-subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id          = aws_vpc.custom_vpc.id
    cidr_block      = "10.0.2.0/24"
    tags = {
        Name = "private-subnet"
    }
}

# create internet gateway
resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.custom_vpc.id
        tags = {
            Name = "custom-ig"
        }

}

# create route table
resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.custom_vpc.id
        tags = {
            Name = "custom-rt"
        }
    route {               # add route to internet gateway
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IG.id
    }

}

# associate route table with subnet
resource "aws_route_table_association" "RTA" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.RT.id
}

# create elastic ip for nat gateway
resource "aws_eip" "nat_eip" {
    
    tags = {
        Name = "nat-eip"
    }
}

# create nat gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
        tags = {
           Name = "nat-gateway"
       }
}

#create private route table
resource "aws_route_table" "private_RT" {
    vpc_id = aws_vpc.custom_vpc.id
        tags = {
            Name = "private-rt"
        }
    route {               # add route to nat gateway
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw.id
    }
}

# associate private route table with private subnet
resource "aws_route_table_association" "private_RTA" {
    subnet_id      = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_RT.id
}

# create security group
resource "aws_security_group" "allow_http" {
    name        = "allow_http"
    description = "Allow HTTP inbound traffic"
    vpc_id      = aws_vpc.custom_vpc.id
     tags = {
        Name = "custom_sg"
       
     }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
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

# create ec2 instance in public subnet
resource "aws_instance" "server" {
    ami = "ami-068c0051b15cdb816"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.allow_http.id]
       tags = {
        Name = "custom-nw-ec2"
    }
}
