# Terraform State Backup File (terraform.tfstate.backup)

---

## What is terraform.tfstate.backup?
- `terraform.tfstate.backup` is a **state backup file**
- It stores the **previous Terraform state**
- Created automatically by Terraform

---

## Purpose of State Backup File
- Protects against accidental state corruption
- Helps recover from failed `terraform apply`
- Acts as a safety copy of the state

---

## What Does State Backup File Do?
- Stores last known good state
- Helps in debugging issues
- Enables state recovery

---

## When is Backup File Created?
- Whenever Terraform:
  - Updates the state file
  - Modifies resources
  - Runs `terraform apply`

---

## terraform.tfstate vs terraform.tfstate.backup

| File | Description |
|----|----|
| terraform.tfstate | Current active state |
| terraform.tfstate.backup | Previous state backup |

---

## State Backup Flow

Terraform Code (Desired State)
|
v
terraform.tfstate.backup
|
v
terraform.tfstate
|
v
Cloud Infrastructure (Current State)

---

## Key Takeaways
- Backup file is a **safety net**
- Automatically managed by Terraform
- Should never be edited manually

---

## Interview One-Liners
- **terraform.tfstate.backup** → previous snapshot of Terraform state
- **Used for recovery and debugging**
