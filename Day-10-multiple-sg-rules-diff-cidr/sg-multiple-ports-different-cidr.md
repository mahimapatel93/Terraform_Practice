# Terraform Security Group – Dynamic Ingress Example

---

## ✅ Overview
This Terraform configuration demonstrates how to use a **variable map** with **dynamic ingress blocks** to create a Security Group with multiple ports and restricted access.  
- Dynamic ingress avoids writing multiple `ingress` blocks manually  
- Each port can have **different allowed IP ranges (CIDR)**  

---

## 🧱 Variable Definition

```hcl
variable "allowed_ports" {
  type = map(string)
  default = {
    22    = "203.0.113.0/24"    # SSH (Restrict to office IP)
    80    = "0.0.0.0/0"         # HTTP (Public)
    443   = "0.0.0.0/0"         # HTTPS (Public)
    8080  = "10.0.0.0/16"       # Internal App (Restrict to VPC)
    9000  = "192.168.1.0/24"    # SonarQube/Jenkins (Restrict to VPN)
    3389  = "10.0.1.0/24"       # RDP / Remote desktop
  }
}
🔑 Key Point
Using a map variable allows flexible CIDR per port

Easy to add/remove ports or change IP ranges

🧱 Security Group with Dynamic Ingress
hcl
Copy code
resource "aws_security_group" "devops_project_mahi" {
  name        = "devops-project-veera"
  description = "Allow restricted inbound traffic"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = "Allow access to port ${ingress.key}"
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-project-mahi"
  }
}
🔍 Explanation
1️⃣ dynamic "ingress"
Loops through each key/value in allowed_ports map

Creates one ingress rule per port with its respective allowed CIDR

2️⃣ Port Specific Rules
Port	CIDR	Purpose
22	203.0.113.0/24	SSH from office only
80	0.0.0.0/0	HTTP public
443	0.0.0.0/0	HTTPS public
8080	10.0.0.0/16	Internal app within VPC
9000	192.168.1.0/24	Jenkins/SonarQube via VPN
3389	10.0.1.0/24	Remote desktop

3️⃣ Egress Rule
Allows all outbound traffic

Required for updates, API calls, and internet access

4️⃣ Tags
Helps identify the Security Group easily in AWS

🧠 Why Use This Approach
Avoids duplicate ingress blocks

Easy to manage multiple ports with different IP ranges

Dynamic and maintainable

Recommended in production Terraform projects

📝 Interview Line
"I use a dynamic block with a variable map to create multiple ingress rules efficiently, which makes the Terraform code cleaner, reusable, and easy to maintain."