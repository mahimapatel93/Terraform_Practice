# Day-11 | Terraform – Null Resource & Provisioners ✅

## 📌 Objective
To understand and implement **Terraform provisioners** using `null_resource` by:
- Creating AWS infrastructure
- Uploading a file to S3 using **two different approaches**

---

## 🏗️ Infrastructure Created
- VPC
- Subnet
- Internet Gateway
- Route Table & Association
- Security Group (SSH access)
- EC2 Instance
- IAM Role & Instance Profile (S3 access)
- S3 Bucket

---

## 🔄 Approach 1: EC2 → S3 (File + Remote-exec)

### Flow:
1. Terraform creates EC2 and S3 bucket.
2. `file` provisioner copies `file.txt` from local system to EC2.
3. `remote-exec` provisioner runs AWS CLI command on EC2.
4. File is uploaded from EC2 to S3.

### Used Components:
- `null_resource`
- `file` provisioner
- `remote-exec` provisioner
- SSH connection

### Why this approach?
- Simulates real-world automation
- Useful when tasks must run **inside a server**

---

## 🔄 Approach 2: Local System → S3 (Local-exec)

### Flow:
1. Terraform creates the S3 bucket.
2. `local-exec` provisioner runs AWS CLI on local machine.
3. File is directly uploaded to S3.

### Used Components:
- `null_resource`
- `local-exec` provisioner

### Why this approach?
- Simple and fast
- No EC2 involvement
- Depends on local AWS CLI setup

---

## ⚙️ Key Terraform Concepts Used
- `null_resource`
- `depends_on`
- Provisioners:
  - `local-exec`
  - `file`
  - `remote-exec`
- IAM Role & Instance Profile
- SSH-based remote connection

---

## ❗ Issues Faced & Fixes

### 1️⃣ Security Group Error
**Error:**


Inappropriate value for attribute "ingress": set of object required
**Cause:**  
Used `ingress = {}` instead of block syntax.

**Fix:**
```hcl
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


2️⃣ Route Table Error

Error:
Inappropriate value for attribute "route": set of object required


Cause:
Used route = {} instead of route {} block.

Fix:

route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

3️⃣ Key Pair File Path Error

Error:

Invalid value for "path" parameter


Cause:
Terraform could not find ~/.ssh/key-pair.pub on Windows.

Fix:

Generated key in project directory using:

ssh-keygen -t rsa -b 4096 -f key-pair


Used correct relative path in Terraform.

4️⃣ S3 Bucket Creation Stuck

Error:

Still creating...
request canceled, context canceled


Cause:
S3 bucket names are globally unique and name already existed.

Fix:

Changed bucket name to a unique one.

Added randomness / personal identifier.

🎯 Key Learnings

null_resource is useful for tasks outside Terraform’s core lifecycle.

Provisioners should be used carefully and as a last resort.

S3 bucket names must be globally unique.

Block syntax vs argument syntax is critical in Terraform.

Debugging Terraform errors improves understanding of AWS + IaC.

🧠 Interview One-Liner

“I used Terraform null_resource with different provisioners to automate file uploads to S3, both via EC2 and directly from the local system.”





---

## 🎤 Interview-Level Logical Questions (Terraform – Null Resource & Provisioners)

### 1️⃣ Why did you use `null_resource` when Terraform already manages resources?
**Answer:**  
`null_resource` is used to execute actions (scripts, commands, file transfers) that are not directly supported by Terraform resources, especially post-creation tasks.

---

### 2️⃣ What happens if you run `terraform apply` again with `null_resource`?
**Answer:**  
Provisioners inside `null_resource` will **run again** if:
- `triggers` change
- Resource is recreated  
Otherwise, they do not re-run automatically.

---

### 3️⃣ Why is `depends_on` important in your project?
**Answer:**  
It ensures correct execution order.  
For example, the file upload should happen **only after** the S3 bucket and EC2 instance are created.

---

### 4️⃣ Difference between `local-exec` and `remote-exec`?
**Answer:**  
- `local-exec`: Runs commands on the **local machine**
- `remote-exec`: Runs commands on a **remote resource (EC2)** using SSH

---

### 5️⃣ Why did you need an IAM Role for EC2?
**Answer:**  
To allow EC2 to upload files to S3 securely without using AWS access keys inside the instance.

---

### 6️⃣ Can Terraform manage files inside EC2 without provisioners?
**Answer:**  
No. Terraform manages infrastructure, not configuration inside servers.  
Provisioners are required for inside-server operations.

---

### 7️⃣ Why are provisioners considered a last resort?
**Answer:**  
Because they are:
- Not idempotent
- Harder to debug
- Dependent on external tools (SSH, AWS CLI)

---

### 8️⃣ What happens if the `remote-exec` provisioner fails?
**Answer:**  
Terraform marks the resource as **failed**, and the apply process stops.

---

### 9️⃣ Why did S3 bucket creation hang for a long time?
**Answer:**  
Because S3 bucket names are **globally unique** and the chosen name already existed, causing AWS to reject the request.

---

### 🔟 Which approach is better: EC2-based upload or local-exec upload?
**Answer:**  
- `local-exec`: Simple and fast
- EC2-based (`file + remote-exec`): Better for real-world automation  
Choice depends on use case.

---

## ⭐ Bonus Question (Advanced Fresher Level)

### Why is `null_resource` not recommended for production?
**Answer:**  
Because it lacks state awareness, retry logic, and proper lifecycle management.

---

