# Terraform tfvars (Variable Values File)

---

## What is terraform.tfvars?
- `terraform.tfvars` is used to store **actual values** for variables
- Terraform automatically loads this file by default

---

## Default Behavior
- Terraform automatically picks `terraform.tfvars`
- No need to pass it explicitly during `terraform apply`

---

## Using Custom tfvars File
If you change the tfvars file name (example: `dev.tfvars`),  
you must explicitly mention it.

```bash
terraform apply -var-file="dev.tfvars"



Why Use Multiple tfvars Files?

To manage multiple environments

dev.tfvars

test.tfvars

prod.tfvars

Same Terraform code, different values

Clean and scalable infrastructure

Easy environment switching

Key Points

If terraform.tfvars exists → Terraform loads it by default

Other tfvars files must be passed using -var-file

Helps avoid hardcoding values

Improves reusability and security
---