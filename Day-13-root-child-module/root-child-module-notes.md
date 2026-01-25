# Root–Child Module in Terraform / OpenTofu

This document explains **why and how Root–Child Modules work**, using your exact project structure.

---

## 📁 Your Project Structure

```
day-13-root-child-module
│
├── main.tf              # Root module
├── provider.tf          # Provider config
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

## 🧠 What is Root Module?

👉 **Root module** is the main folder where:

* `tofu init / plan / apply` is executed
* Other modules are **called**

In your project:

* `day-13-root-child-module/` = **Root module**

---

## 🧠 What is Child Module?

👉 **Child modules** are reusable blocks of infrastructure.

In your project:

* `modules/vpc` → creates VPC & subnets
* `modules/ec2` → creates EC2
* `modules/s3` → creates S3 bucket

Each child module:

* Has **its own resources**
* Accepts **inputs (variables)**
* Exposes **outputs**

---

## 🔁 How Data Flows (IMPORTANT)

Terraform follows **strict boundaries**:

```
ROOT MODULE
   ↓ input variables
CHILD MODULE (resources)
   ↓ outputs
ROOT MODULE
   ↓ pass to another module
ANOTHER CHILD MODULE
```

👉 **Modules CANNOT see each other's resources directly**

---

## ❌ Why This Is NOT Allowed

```hcl
subnet1_id = module.vpc.subnet1.id   ❌
```

### Reason:

* `subnet1` is a **resource inside vpc module**
* Root module **cannot access internal resources**

Terraform rule:

> Root module can only access **outputs**, not resources

---

## ✅ Correct Way (Using Outputs)

### Step 1: Create output in `modules/vpc/output.tf`

```hcl
output "subnet1_id" {
  value = aws_subnet.subnet1.id
}
```

👉 This makes subnet ID **publicly available**

---

### Step 2: Use Output in Root Module

```hcl
module "ec2" {
  source        = "./modules/ec2"
  ami_id        = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
  subnet1_id    = module.vpc.subnet1_id
}
```

✔ `module.vpc.subnet1_id` = output value

---

## 🧠 Why Terraform Is Designed Like This

### 1️⃣ Encapsulation

* Internal resources stay **hidden**
* Prevents accidental misuse

### 2️⃣ Reusability

* Same VPC module can be reused in:

  * Dev
  * QA
  * Prod

### 3️⃣ Clean Architecture

* Root module = orchestration
* Child modules = implementation

---

## 🔄 Real-Life Analogy

🏠 **House example**

* VPC module = Builder
* Subnet ID = Key
* EC2 module = Tenant

👉 Builder gives **key**, not house blueprint

---

## 🎯 Interview One-Liner

> "Terraform does not allow accessing child module resources directly. We must expose required values using outputs and consume them via `module.<name>.<output>` to maintain encapsulation and reusability."

---

## ✅ Summary

✔ Root module calls child modules
✔ Child modules expose values via outputs
✔ Only outputs can be accessed
✔ `module.vpc.subnet1_id` is CORRECT
✔ `module.vpc.subnet1.id` is INVALID

---

📌 This structure is **production-grade & interview-safe**
