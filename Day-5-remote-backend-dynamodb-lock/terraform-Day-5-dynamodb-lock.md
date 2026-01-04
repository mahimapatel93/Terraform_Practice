# Day 5 – Remote Backend with DynamoDB State Lock

## What is DynamoDB in Terraform?

DynamoDB is used in Terraform to **lock the state file** when a Terraform operation is running.

It prevents multiple users from running `terraform apply` at the same time.

---

## Why DynamoDB is Needed

* Prevents state file corruption
* Avoids concurrent Terraform runs
* Ensures safe infrastructure changes
* Used with S3 remote backend
* Recommended for team & production environments

---

## Important Note

* **S3 stores the state file**
* **DynamoDB provides state locking**

👉 DynamoDB does NOT store the state file.

---

## DynamoDB Table Requirements

### Required Configuration

* **Table Name**: terraform-lock
* **Partition Key**: LockID
* **Type**: String
* **Sort Key**: Not required

---

## How State Locking Works

1. `terraform apply` starts
2. Terraform creates a lock entry in DynamoDB
3. LockID prevents other users from applying changes
4. Apply completes
5. Lock is released automatically

---

## Backend Configuration Example (S3 + DynamoDB)

```hcl
terraform {
  backend "s3" {
    bucket         = "the-new-stranger-things"
    key            = "day-5/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
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

⚠️ DynamoDB table must exist before running `terraform init`.

---

## Common Mistakes

* Using wrong partition key name (must be `LockID`)
* Adding unnecessary sort key
* Forgetting to create DynamoDB table before init
* Running multiple `terraform apply` simultaneously

---

## Interview Questions

**Q1. Why do we use DynamoDB with Terraform?**
To provide state locking and prevent concurrent infrastructure changes.

**Q2. Does DynamoDB store Terraform state?**
No, Terraform state is stored in S3. DynamoDB is only for locking.

---

## Summary

* DynamoDB is used for Terraform state locking
* Works together with S3 remote backend
* Prevents infrastructure conflicts
* Mandatory for team-based Terraform projects

✅ **Day 5 – Remote Backend with DynamoDB Lock Completed**
