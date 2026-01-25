# Day‑13 Root–Child Module (VPC + EC2 + S3)

This document explains **your exact code**, **why each variable/output exists**, and **how data flows from root → child → root → child** in Terraform / OpenTofu.

---

## 📁 Project Structure

```
day-13-root-child-module
│
├── main.tf               # Root module
├── provider.tf
├── terraform.tfstate
├── .terraform.lock.hcl
│
└── modules
    ├── vpc
    │   ├── main.tf
    │   ├── variable.tf
    │   └── output.tf
    │
    ├── ec2
    │   ├── main.tf
    │   └── variable.tf
    │
    └── s3
        ├── main.tf
        └── variable.tf
```

---

## 🧠 Core Terraform Rule (MOST IMPORTANT)

> A **root module cannot directly access resources inside a child module**.
>
> Only **outputs** can be accessed.

---

## 🔹 VPC MODULE (Child Module)

### `modules/vpc/main.tf`

Creates:

* VPC
* Subnet‑1
* Subnet‑2

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet1_cidr
  availability_zone = var.az1
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet2_cidr
  availability_zone = var.az2
}
```

---

### `modules/vpc/variable.tf`

```hcl
variable "cidr_block" {}
variable "subnet1_cidr" {}
variable "subnet2_cidr" {}
variable "az1" {}
variable "az2" {}
```

---

### `modules/vpc/output.tf`

```hcl
output "subnet1_id" {
  value = aws_subnet.subnet1.id
}

output "subnet2_id" {
  value = aws_subnet.subnet2.id
}
```

👉 **Outputs expose subnet IDs to the root module**

---

## 🔹 EC2 MODULE (Child Module)

### `modules/ec2/main.tf`

```hcl
resource "aws_instance" "name" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet1_id

  tags = {
    Name = "ec2-from-module"
  }
}
```

---

### `modules/ec2/variable.tf`

```hcl
variable "ami_id" {}
variable "instance_type" {}
variable "subnet1_id" {}
```

👉 EC2 module **does not know where subnet comes from**
👉 It only accepts a subnet ID as input

---

## 🔹 S3 MODULE (Child Module)

### `modules/s3/main.tf`

```hcl
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}
```

### `modules/s3/variable.tf`

```hcl
variable "bucket_name" {}
```

---

## 🔹 ROOT MODULE (`main.tf`)

### Calling VPC Module

```hcl
module "vpc" {
  source        = "./modules/vpc"
  cidr_block    = "10.0.0.0/16"
  subnet1_cidr  = "10.0.1.0/24"
  subnet2_cidr  = "10.0.2.0/24"
  az1           = "us-east-1a"
  az2           = "us-east-1b"
}
```

---

### Calling EC2 Module

```hcl
module "ec2" {
  source        = "./modules/ec2"
  ami_id        = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
  subnet1_id    = module.vpc.subnet1_id
}
```

### ❓ WHY THIS LINE IS IMPORTANT

```hcl
subnet1_id = module.vpc.subnet1_id
```

✔ `module.vpc.subnet1_id` = output from VPC module

❌ This is NOT allowed:

```hcl
module.vpc.subnet1.id   ❌
```

Because:

* `subnet1` is **internal resource** of VPC module
* Root module cannot access it directly

---

### Calling S3 Module

```hcl
module "s3" {
  source      = "./modules/s3"
  bucket_name = "the-strainger-things-module"
}
```

---

## 🔁 Data Flow (Easy to Remember)

```
ROOT MODULE
   ↓ variables
VPC MODULE
   ↓ outputs
ROOT MODULE
   ↓ variables
EC2 MODULE
```

---

## 🏠 Real‑Life Analogy

* VPC module = Builder
* Subnet ID = Key
* EC2 module = Tenant

👉 Builder gives **key**, not blueprint

---

## 🎯 Interview Answer (One‑Liner)

> "Terraform enforces module encapsulation. Resources inside a module are private, so we expose required values using outputs and consume them via `module.<name>.<output>` in the root module."

---

## ✅ Final Summary

✔ Root module orchestrates
✔ Child modules are reusable
✔ Outputs act as bridge
✔ Direct resource access is forbidden
✔ This structure is production‑ready

---

## ⚠️ VERY IMPORTANT POINT (DO NOT MISS)

### 🔒 Module Boundaries Are STRICT

* A module is like a **black box**
* Anything inside it is **PRIVATE by default**
* Only values defined using `output` are **PUBLIC**

👉 Even if you know the exact resource name, Terraform will **not allow access** without an output.

---

### 🚨 Common Beginner Mistake

```hcl
subnet1_id = module.vpc.aws_subnet.subnet1.id   ❌
```

❌ This will **never work**, because:

* `aws_subnet.subnet1` lives **inside** the VPC module
* Root module cannot peek inside

✔ Correct way:

```hcl
subnet1_id = module.vpc.subnet1_id
```

---

### 🧠 Why Interviewers Love This Question

Because it tests:

* Understanding of **module encapsulation**
* Knowledge of **Terraform architecture**
* Real-world **production practices**

---

### 🎯 Golden Rule (MEMORIZE THIS)

> "If a value is needed outside a module, it MUST be exposed using an output."

---

📌 Same logic applies to **Terraform & OpenTofu**
