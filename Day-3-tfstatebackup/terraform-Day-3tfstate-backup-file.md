Terraform State Backup File (terraform.tfstate.backup)
What is terraform.tfstate.backup?

terraform.tfstate.backup is a backup of the previous state file

It is automatically created by Terraform

Stores the last known good state before changes

Why State Backup is Needed?

Protects against:

Accidental state corruption

Failed terraform apply

Wrong resource changes

Allows recovery of previous state

When is Backup Created?

Whenever Terraform:

Updates the state file

Modifies resources

Runs terraform apply

👉 Terraform first saves old state as backup
👉 Then updates terraform.tfstate

What Does Backup Contain?

Previous version of:

Resource IDs

Attributes

Dependencies

Same structure as terraform.tfstate

But represents older infrastructure state

terraform.tfstate vs terraform.tfstate.backup
File	Purpose
terraform.tfstate	Current state (latest)
terraform.tfstate.backup	Previous state (safe copy)
State Backup Flow (Easy Diagram)

Current State
|
| terraform apply
v
terraform.tfstate.backup ← old state saved
|
v
terraform.tfstate ← new updated state

Why Backup is Important?

Disaster recovery

Rollback reference

Debugging failed applies

Manual state restore (advanced cases)

Can We Use Backup File?

⚠️ Normally NO direct usage

But in emergency:

Backup can be restored manually

Used by Terraform experts only

Best Practices

Never edit backup manually

Store state securely (S3 backend recommended)

Enable versioning when using remote backend

Do not commit state files to Git

Interview One-Liners

terraform.tfstate.backup → previous safe snapshot of state

Created automatically before state update

Recovery support file

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
├── terraform.tfstate.backup
├── terraform-tfvars.md
├── terraform-tfstate.md
└── terraform-tfstate-backup.md