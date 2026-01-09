# Day-8: Terraform Modules Practice (EC2)

---

## 🎯 Objective

Learn to create and use **Terraform modules** to provision **EC2 instances only** using child modules for different environments.

---

## 📖 Definition of Terraform Modules

A **Terraform module** is a container for multiple Terraform resources that are grouped together for **reusability, maintainability, and organization**. Modules can be **root modules** (the main configuration) or **child modules** (called by other modules). They allow passing variables in and outputting values back to the root module.

---

## 📁 Folder Structure

```
Terraform_Practice/
├── Day-8-modules-practice/             # Main module
│   ├── main.tf                         # EC2 resource
│   └── variables.tf                    # EC2 variables
├── Day-8-passing-values-practice-test/ # Child module for test environment
├── Day-8-passing-values-practice-dev/  # Child module for dev environment
└── Day-8-passing-values-practice-demo/ # Child module for demo environment
```

---

## Module: Day-8-modules-practice

### 1️⃣ variables.tf

```hcl
variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "tags" {
  description = "Tags for EC2 instance"
  type        = map(string)
  default     = {}
}
```

### 2️⃣ main.tf

```hcl
resource "aws_instance" "instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = var.tags
}
```

---

## Child Module Example (EC2 Only)

### Example: Day-8-passing-values-practice-dev/main.tf

```hcl
module "demo1" {
  source = "../Day-8-modules-practice"

  ami_id        = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"

  tags = {
    Name = "Dev-EC2-Only"
  }
}
```

> Each child module (test/dev/demo) can pass **different AMI, instance type, and tags**.

---

## 🔑 Important Concepts

* **Main module** contains EC2 resource only.
* **Child modules** call the main module with environment-specific values.
* **Reusability:** Same module can be used for multiple environments.
* **Tags** differentiate instances per environment.
* **Modules allow organization** of resources for better maintainability.
* **Variables and outputs** make modules flexible and dynamic.
* **Optional resources** can be added later if needed.
* Using modules improves **code readability and standardization**.

---

## 📌 Commands to Run

```bash
cd Day-8-passing-values-practice-dev
terraform init
terraform plan
terraform apply
```

---

## 📊 Diagram (Modules Flow)

```
          ┌────────────────────┐
          │    Root Module      │
          │  (Child Module)    │
          └────────┬───────────┘
                   │ calls
                   ▼
       ┌────────────────────────┐
       │    Main Module         │
       │ (Day-8-modules-practice)│
       └─────────┬──────────────┘
                 │
                 ▼
          ┌─────────────┐
          │ EC2 Instance│
          │  Created    │
          └─────────────┘
```

---

### 🎯 Key Concept

* One main module can serve **multiple child modules**.
* Each child module can pass different variable values to create EC2 instances per environment.
* Modules ensure **clean, reusable, maintainable, and scalable Terraform code**.
