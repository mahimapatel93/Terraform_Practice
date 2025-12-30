# Day-0: Terraform Basics (Infrastructure as Code)

## What is IaC (Infrastructure as Code)?
Infrastructure as Code (IaC) means managing and provisioning infrastructure
(servers, networks, databases, etc.) using code instead of manual configuration.

---

## Popular IaC Tools
- Terraform – Third-party tool (partially open source)
- OpenTofu – Fully open source Terraform alternative
- AWS CloudFormation – AWS native IaC tool
- Azure ARM Templates – Azure IaC tool
- GCP Deployment Manager – GCP IaC tool

---

## Manual Infrastructure vs IaC

### Manual Infrastructure
- Time consuming
- Error-prone
- Hard to reproduce
- Example:
  - Project-1 → 1 week
  - Project-2 → 1 week

### Infrastructure as Code
- Automated
- Reusable
- Faster
- Example:
  - Project-1 → 2 weeks
  - Project-2 → 30 minutes

---

## Advantages of Infrastructure as Code
- Reduces manual effort
- Less error probability
- Reusability
- Faster delivery
- Easy debugging
- Lower operational cost
- Complete infrastructure backup as code

---

## Terraform Overview
- Written in **Go language**
- Developed by **HashiCorp**
- Supports **AWS, Azure, GCP**, and virtualization platforms
- Uses **HCL (HashiCorp Configuration Language)** or **JSON**
- Platform-independent

---

## Terraform Architecture (Easy Diagram)
Developer
   |
   |  (1) Write Terraform Code
   |      - provider.tf
   |      - main.tf
   |      - variables.tf
   |      - terraform.tfvars
   |      - output.tf
   |
   v
Terraform CLI
   |
   |  terraform init
   |  → Downloads Provider Plugins
   |
   v
Terraform Provider
(AWS / Azure / GCP)
   |
   |  Authentication (Access Key / IAM Role)
   |
   v
Cloud API
(AWS / Azure / GCP)
   |
   |  Create / Update / Delete Resources
   |
   v
Cloud Infrastructure
(EC2, VPC, S3, RDS, etc.)

---

## Terraform Workflow (High Level)
1. Write Terraform configuration files
2. Initialize providers
3. Plan infrastructure changes
4. Apply infrastructure
5. Destroy when not required

---

## Terraform Configuration Files
- `provider.tf`  
  → Defines cloud provider details (AWS / Azure / GCP)

- `main.tf`  
  → Main resource creation code

- `variables.tf`  
  → Variable definitions (avoid hardcoding values)

- `terraform.tfvars`  
  → Variable values

- `output.tf`  
  → Prints output values after execution

---

## Terraform Commands
- `terraform init`  
  → Initializes provider plugins

- `terraform plan`  
  → Shows execution plan (what will be created)

- `terraform apply`  
  → Creates infrastructure

- `terraform destroy`  
  → Deletes infrastructure

---

## Key Takeaway (Day-0)
Terraform helps us manage cloud infrastructure using code,
making deployments faster, repeatable, and less error-prone.