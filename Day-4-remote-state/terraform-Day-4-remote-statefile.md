# Day 4 – Terraform Remote State

## What is Terraform State?

Terraform state is a file (`terraform.tfstate`) that tracks the real infrastructure created by Terraform.

By default, this state file is stored **locally**.

---

## What is Remote State?

Remote state means storing the Terraform state file in a **remote backend** instead of the local machine.

**Examples:** AWS S3, Terraform Cloud, Azure Blob Storage

---

## Why Remote State is Needed

* Team collaboration
* Centralized state management
* Prevents accidental deletion
* Supports state locking
* Used in real-world & production environments

---

## Problems with Local State

* Stored on one system only
* No locking mechanism
* Risk of corruption
* Difficult to share with teams

---

## AWS Remote State (S3 Backend)

### Required Services

1. **S3 Bucket** – stores the state file
2. **State Locking** – DynamoDB or S3 native locking

---

## Backend Configuration Example

```hcl
terraform {
  backend "s3" {
    bucket       = "the-new-stranger-things"
    key          = "day-4/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
```

---

## Backend Arguments Explained

* **bucket** → S3 bucket name
* **key** → Path of the state file in the bucket
* **region** → AWS region
* **use_lockfile** → Enables S3 native state locking

---

## Example EC2 Resource

```hcl
resource "aws_instance" "example" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"

  tags = {
    Name = "remote-state-instance"
  }
}
```

---

## Important Commands

```bash
terraform init
terraform plan
terraform apply
```

⚠️ **Note:** `terraform init` is mandatory when configuring or changing a backend.

---

## Important Notes

* Backend blocks cannot use variables
* S3 bucket must exist before running `terraform init`
* Never edit the state file manually
* Remote state is mandatory for team environments

---

## Interview Questions

**Q1. What is Terraform remote state?**
Storing the `terraform.tfstate` file in a remote backend.

**Q2. Why is state locking important?**
It prevents multiple users from modifying infrastructure simultaneously.

---

## Summary

* Remote state stores Terraform state securely
* AWS S3 is the most commonly used backend
* State locking avoids infrastructure conflicts

✅ **Day 4 – Remote State Completed**
