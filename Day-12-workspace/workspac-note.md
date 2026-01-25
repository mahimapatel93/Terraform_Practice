Terraform Workspaces 
What is a Workspace?

A Terraform workspace is a logical environment such as dev, test, or prod.

👉 Same Terraform code is used 👉 Each workspace has its own separate state file 👉 Resources never mix between environments

Default Workspace

When you start Terraform, it uses the default workspace

If you don’t create workspaces, all resources go into default

terraform workspace show
Create a New Workspace
terraform workspace new dev
terraform workspace new prod
terraform workspace new test

👉 Each command creates a new empty state

List All Workspaces
terraform workspace list

Example output:

  default
* dev
  prod
  test

* means the currently active workspace

Switch Workspace
terraform workspace select prod

👉 Now any plan or apply will run only for the prod workspace

Apply Rule (MOST IMPORTANT)

Terraform apply affects only the current workspace

dev selected → resources go to dev state

prod selected → resources go to prod state

test selected → resources go to test state

Resources never mix ❌

Where Are State Files Stored?

Terraform automatically stores them here:

.terraform/
└── terraform.tfstate.d/
    ├── dev/terraform.tfstate
    ├── prod/terraform.tfstate
    └── test/terraform.tfstate

👉 Each workspace has its own state file

Example Scenario
Same Code for All Environments
resource "aws_instance" "server" { ... }
resource "aws_s3_bucket" "bucket" { ... }
Apply in Dev
terraform workspace select dev
terraform apply

👉 Dev state: EC2 + S3

Apply in Prod
terraform workspace select prod
terraform apply

👉 Prod state: EC2 + S3 (separate from dev)

Why Use Workspaces?

✅ Manage multiple environments with the same code ✅ Dev / Test / Prod remain isolated ✅ Safe testing without affecting production

Workspace vs Folder (Simple Difference)
Workspace	Folder
Same code	Code may differ
State separated	State separated
Lightweight	More control
Interview One-Liner

"Terraform workspaces allow us to manage multiple environments using the same configuration by maintaining separate state files."

Common Mistake ❌

❌ Thinking workspaces separate resources

✅ Truth: workspaces separate environments, not resources

Key Line to Remember 💡

Workspaces separate environments, not resources