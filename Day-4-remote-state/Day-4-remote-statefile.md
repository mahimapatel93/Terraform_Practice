<!-- # Day 4 – Terraform Remote State

## What is Terraform State?

Terraform state is a file (`terraform.tfstate`) that keeps track of real infrastructure created by Terraform.

By default, this state file is stored **locally**.

---

## What is Remote State?

Remote state means storing the Terraform state file in a **remote location** instead of local machine.

Example: AWS S3, Terraform Cloud, Azure Blob Storage.

---

## Why Remote State is Needed

* Team collaboration
* Centralized state file
* Prevents accidental deletion
* Supports state locking
* Used in real-world & production projects

---

## Problems with Local State

* Stored on one system only
* No locking mechanism
* Risk of corruption
* Difficult for teams

---

## AWS Remote State (S3 Backend)

### Required Services

1. **S3 Bucket** – to store state file
2. **State Locking** – via DynamoDB or S3 native locking

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

## Meaning of Backend Fields

* **bucket** → S3 bucket name
* **key** → Path of state file inside bucket
* **region** → AWS region
* **use_lockfile** → Enables S3 native locking

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

⚠️ `terraform init` is mandatory when using remote backend.

---

## Important Notes

* Backend block cannot use variables
* S3 bucket must exist before init
* Never edit state file manually
* Remote state is mandatory for teams

---

## Interview Questions

**Q1. What is Terraform remote state?**
Remote storage of terraform.tfstate file.

**Q2. Why state locking is important?**
Prevents multiple users from modifying infrastructure at the same time.

---

## Summary

* Remote state stores Terraform state safely
* AWS S3 is commonly used
* Locking avoids infrastructure conflicts

✅ **Day 4 – Remote State Completed** -->
