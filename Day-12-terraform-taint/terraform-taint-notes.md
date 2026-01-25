# Terraform: Taint & Untaint Cheat Sheet

---

## 1. What is `taint`?

`terraform taint` marks a resource as **broken or needing replacement**.  
Next time you run `terraform plan` and `terraform apply`, Terraform will **destroy and recreate** that resource.


Step-by-step mental picture
---
Original resource (working/broken)
        |
        | terraform taint
        v
Resource marked as tainted (Terraform state updated)
        |
        | terraform plan -> shows destroy & create
        |
        | terraform apply
        v
Resource destroyed and recreated → now NOT tainted
        |
        | terraform untaint ❌ (cannot run anymore)



## 2. Basic Syntax

```bash
terraform taint <resource_name>
terraform untaint <resource_name>
3. Example
hcl
Copy code
resource "aws_instance" "web_server" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
}
Mark resource as tainted
bash
Copy code
terraform taint aws_instance.web_server
Verify plan
bash
Copy code
terraform plan
✅ Terraform will destroy and recreate the EC2 instance

Untaint if marked by mistake
bash
Copy code
terraform untaint aws_instance.web_server
4. Common Use Cases (Simple)
Broken / corrupted resource

EC2, DB, etc. not working → recreate

Resource drift

Cloud resource changed → align with code

Testing / refreshing resources

Recreate auto-scaling group or refresh infra

Quick fix for failed deployments

Let Terraform handle recreation automatically

5. Key Points
taint does not change .tf code

Only marks the state file

Always check with terraform plan before apply

Can undo using terraform untaint

6. Interview-Friendly Answers
Q: What does terraform taint do?
A: Marks a resource as tainted so it will be destroyed and recreated on the next apply.

Q: When do you use taint?
A: Broken resource, drifted resource, testing refresh, or quick fix for failed deployments.

Q: Difference between taint and untaint?
A: taint marks for recreation; untaint cancels that mark.