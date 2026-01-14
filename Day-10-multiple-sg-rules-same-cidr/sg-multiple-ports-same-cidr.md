# Terraform Security Group – Multiple Ingress Rules Explained

---

## ✅ Complete Terraform Code

```hcl
resource "aws_security_group" "devops-project-mahi" {
  name        = "security-group-mahi"
  description = "allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8080, 3000, 8082, 8081] : {
      description      = "Inbound rule for port ${port}"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]

      ipv6_cidr_blocks = []     # No IPv6 traffic allowed
      prefix_list_ids  = []     # No AWS service access (S3/DynamoDB)
      security_groups  = []     # No access from other security groups
      self             = false  # Traffic from same security group not allowed
    }
  ]

  egress {
    from_port   = 0             # All source ports
    to_port     = 0             # All destination ports
    protocol    = "-1"          # All protocols (TCP/UDP/ICMP)
    cidr_blocks = ["0.0.0.0/0"] # Allow outbound traffic to anywhere
  }

  tags = {
    Name = "security-group-mahi"
  }
}
🔑 Important Points (Line by Line)
1️⃣ for port in [...]
Creates one ingress rule per port

Avoids writing multiple separate ingress blocks

Clean, maintainable, and scalable

2️⃣ from_port & to_port
Allows only the specific port

Example: port 80 → HTTP, port 22 → SSH

3️⃣ protocol = "tcp"
Required for SSH, HTTP, HTTPS, and applications

UDP/ICMP traffic is not included

4️⃣ cidr_blocks = ["0.0.0.0/0"]
Allows traffic from any IP

Safe for HTTP/HTTPS, but risky for SSH (should restrict in production)

5️⃣ Empty fields: Why?
hcl

ipv6_cidr_blocks = []
prefix_list_ids  = []
security_groups  = []
self             = false
IPv6 traffic not allowed

AWS service access (S3/DynamoDB) blocked

No traffic from other security groups

No traffic from instances within the same security group

6️⃣ Egress Rule
hcl

protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
Allows all outbound traffic

Required for updates, API calls, and internet access

🧠 Summary
for loop avoids repetition

Ports can be added or removed easily

Clear, maintainable, production-ready code

Recommended in real-world DevOps Terraform projects

📝 Interview Line
"I used a for-loop inside the ingress block to dynamically create multiple security group rules, which improves maintainability, scalability, and readability."

