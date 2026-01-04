# Day 5 – Custom Network using Terraform

## 📌 Objective

Create a **custom AWS network** using Terraform that includes:

* VPC
* Public & Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Security Group
* EC2 Instance

---

## 🧱 Architecture Overview

* **VPC CIDR:** `10.0.0.0/16`
* **Public Subnet:** `10.0.1.0/24`
* **Private Subnet:** `10.0.2.0/24`
* Public subnet → Internet Gateway
* Private subnet → NAT Gateway → Internet

---

## 🔹 Terraform Resources Used

### 1️⃣ VPC

Creates a custom VPC

```hcl
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "custom-vpc"
  }
}
```

---

### 2️⃣ Public & Private Subnets

```hcl
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private-subnet"
  }
}
```

---

### 3️⃣ Internet Gateway

Allows internet access for public subnet

```hcl
resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "custom-ig"
  }
}
```

---

### 4️⃣ Public Route Table

Routes internet traffic via Internet Gateway

```hcl
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }

  tags = {
    Name = "custom-rt"
  }
}
```

### Route Table Association (Public Subnet)

```hcl
resource "aws_route_table_association" "RTA" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.RT.id
}
```

---

### 5️⃣ Elastic IP for NAT Gateway

```hcl
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "nat-eip"
  }
}
```

---

### 6️⃣ NAT Gateway

Provides internet access to private subnet

```hcl
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "nat-gateway"
  }
}
```

---

### 7️⃣ Private Route Table

Routes private subnet traffic via NAT Gateway

```hcl
resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-rt"
  }
}
```

### Route Table Association (Private Subnet)

```hcl
resource "aws_route_table_association" "private_RTA" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_RT.id
}
```

---

### 8️⃣ Security Group

Allows SSH (22) and HTTP (80)

```hcl
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.custom_vpc.id

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

  tags = {
    Name = "custom_sg"
  }
}
```

---

### 9️⃣ EC2 Instance (Public Subnet)

```hcl
resource "aws_instance" "server" {
  ami                    = "ami-068c0051b15cdb816"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  tags = {
    Name = "custom-nw-ec2"
  }
}
```

---

## ✅ Result

* Custom VPC created successfully
* Public EC2 accessible via Internet
* Private subnet secured with NAT Gateway
* Infrastructure fully managed using Terraform

---

## 📌 Terraform Commands Used

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

---

✨ **Day 5 Task Completed Successfully**
