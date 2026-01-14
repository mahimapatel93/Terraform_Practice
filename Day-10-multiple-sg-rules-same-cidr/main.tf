# resource "aws_security_group" "name" {
#   name = "security_group"
  
#   ingress{
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"
#     cidr_blocks = ["0.0.0.0/16"]
#   }

#   ingress {
#     from_port = 80
#     to_port   = 80
#     protocol  = "tcp"
#     cidr_blocks = ["0.0.0.0/16"]
#    }

#   ingress {
#     from_port = 443
#     to_port = 443
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/16"]
#   } 
# }
# #


resource "aws_security_group" "devops-project-mahi" {
  name = "security-group-mahi"
  description = "allow TLS inbound traffic"

  ingress = [                                             # Multiple ingress rules ek sath define karne ke liye
    for port in [22, 80, 443, 8080, 3000, 8082, 8081] : {
      description     = "inblund rules"
      from_port       = port
      to_port         = port
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []                # IPv6 traffic is not allowed
      prefix_list_ids  = []                # No AWS service (S3, DynamoDB) access
      security_groups  = []                # No traffic allowed from other security groups
      self             = false             # Same security group traffic not allowed

    }
   ]

   egress {
    from_port   = 0              # Allow traffic from all ports
    to_port     = 0              # Allow traffic to all ports
    protocol    = "-1"           # Allow all protocols (TCP, UDP, ICMP)
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound traffic to any IP
   }

   tags = {
     Name = "security-group-mahi"
   }
}

