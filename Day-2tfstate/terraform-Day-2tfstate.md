# Terraform State File (terraform.tfstate)

---

## What is terraform.tfstate?
- `terraform.tfstate` is a **state file**
- It maps:
  - Terraform configuration (code)
  - To real cloud resources (local / remote)

---

## Purpose of State File
- Tracks real infrastructure
- Stores current state of resources
- Maintains mapping between:
  - Resource name in code
  - Actual resource ID in cloud

---

## What Does State File Do?
- Tracks real-time changes
- Compares:
  - Desired state (Terraform code)
  - Current state (Cloud resources)
- Decides what to:
  - Create
  - Update
  - Delete

---

## State File Comparison Logic

Terraform Code (Desired State)
|
v
terraform.tfstate
|
v
Cloud Infrastructure (Current State)



---

## Terraform Apply – First Time vs Later

### First `terraform apply`
- Resources are created in the cloud
- State file is generated
- State file stores current resource details

---

### Subsequent `terraform apply`
- Terraform refreshes the state file
- Compares:
  - Code changes
  - Remote infrastructure changes
- Applies **only required updates**

---

## Terraform State Flow (Easy Diagram)

+------------------+
| Terraform Code |
| (Desired State) |
+------------------+
|
| terraform apply
v
+------------------+
| terraform.tfstate|
+------------------+
|
| refresh & compare
v
+------------------+
| Cloud Resources |
| (Current State) |
+------------------+

---

## Key Takeaways
- `terraform.tfstate` is the **single source of truth**
- Tracks and manages real infrastructure
- Enables Terraform to detect drift
- Must be protected (never edit manually)

---

## Interview One-Liners
- **state file** → single source of truth  
- **terraform apply** → reconciliation engine

---

📁 Folder Structure
day-2/
├── provider.tf
├── main.tf
├── variables.tf
├── terraform.tfvars
├── dev.tfvars
├── prod.tfvars
├── output.tf
├── terraform.tfstate
├── terraform-tfvars.md
└── terraform-tfstate.md
---