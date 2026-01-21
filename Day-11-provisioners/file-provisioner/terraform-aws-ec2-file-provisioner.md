# Terraform AWS EC2 Setup with File Provisioner

## Overview

This Terraform configuration creates a **basic AWS infrastructure** and launches an **EC2 instance** with a **file provisioner**.

Resources created:

* VPC
* Public Subnet
* Internet Gateway
* Route Table + Association
* Security Group (SSH + HTTP)
* Key Pair
* EC2 Instance
* File Provisioner (copy file to EC2)

This is a **fresher-to-intermediate level DevOps setup**, commonly asked in interviews.

---

## Architecture Flow (High Level)

1. Create a VPC
2. Create a public subnet inside the VPC
3. Attach an Internet Gateway to the VPC
4. Add a route to the Internet Gateway
5. Associate the route table with the public subnet
6. Create a Security Group (allow SSH & HTTP)
7. Create an SSH Key Pair
8. Launch EC2 instance in public subnet
9. Copy a file to EC2 using file provisioner

---

## SSH Key Pair Generation (Important)

Command used:

```
ssh-keygen -t rsa -b 4096 -f ~/.ssh/key_pair
```

This generates:

* `key_pair` → private key (keep secure)
* `key_pair.pub` → public key (used in Terraform)

---

## Important Key Points (Interview Ready)

* EC2 must be in a **public subnet** for SSH access
* Internet Gateway is mandatory for outbound internet
* Route table must have `0.0.0.0/0` route
* Security Group must allow port **22** for SSH
* File provisioner requires **working SSH connection**
* `associate_public_ip_address = true` is required
* Key pair must match the private key used in connection block

---

## File Provisioner Logic

* File provisioner runs **after EC2 creation**
* Uses SSH to connect to the instance
* Copies local file → remote EC2 instance

Source:

* Local machine file: `git-final-notes-7pm.txt`

Destination:

* EC2 path: `/home/ec2-user/git-final-notes-7pm.txt`

---

## Common Errors You May Face (Very Important)

### 1. SSH Timeout Error

**Reason:**

* Security group not allowing port 22
* Wrong subnet or no public IP
* Internet Gateway missing

### 2. Permission Denied (Publickey)

**Reason:**

* Wrong private key used
* Key pair mismatch
* Wrong SSH user (should be `ec2-user` for Amazon Linux)

### 3. File Provisioner Failed

**Reason:**

* EC2 not fully ready
* SSH connection failed
* Wrong file path on local system

### 4. Invalid Key Path Error

**Reason:**

* `~` not expanded properly in some systems
* Use full path like `/home/user/.ssh/key_pair`

---

## Interview-Level Logic Questions (With Intent)

### Q1. Why do we need an Internet Gateway?

➡️ To allow EC2 instances to access the internet.

### Q2. Why is a route table required?

➡️ It defines how traffic flows in the VPC.

### Q3. Why use file provisioner?

➡️ To copy configuration or scripts to EC2.

### Q4. Why is state important in Terraform?

➡️ It tracks real infrastructure vs configuration.

### Q5. Can we use provisioners in production?

➡️ Not recommended; better use user_data or configuration management tools.

---

## Terraform Best Practices (Interview Bonus)

* Avoid provisioners in production
* Use `user_data` for bootstrapping
* Store state remotely (S3 + DynamoDB)
* Use separate environments (dev, test, prod)
* Follow least privilege IAM

---

## Difficulty Level (Honest Assessment)

* Fresher: ⭐⭐⭐ (Medium)
* DevOps Interview: ⭐⭐⭐⭐ (Good Hands-on Question)

---

## One-Line Interview Summary

> "This Terraform setup creates a public EC2 instance with networking components and uses a file provisioner to copy files via SSH."

---

✅ This project is **strong enough for fresher DevOps interviews** and shows real hands-on experience.
