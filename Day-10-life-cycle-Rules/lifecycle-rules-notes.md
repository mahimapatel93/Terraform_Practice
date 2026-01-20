# Terraform Lifecycle Rules – EC2 Example

---

##  Objective

Understand **Terraform lifecycle rules** and how they control **resource creation, update, and deletion**, using an **AWS EC2 instance** example.

---

##  What are Lifecycle Rules?

Lifecycle rules allow you to **customize Terraform behavior** when resources change.

They are defined inside a resource using the `lifecycle {}` block.

---

##  Types of Lifecycle Rules

1. `create_before_destroy`
2. `prevent_destroy`
3. `ignore_changes`

---

##  EC2 Example Code

```hcl
resource "aws_instance" "name1" {
  ami               = "ami-07ff62358b87c7116"
  instance_type     = "t2.medium"
  availability_zone = "us-east-1a"

  tags = {
    Name = "ec-instance"
  }

  lifecycle {
    create_before_destroy = true
  }
}


🔹 1. create_before_destroy
✅ What it does
Creates a new resource first

Then destroys the old one

Prevents downtime

🧠 When it works
During terraform apply

When a replacement is required (like AMI change)

❌ When it does NOT work
terraform destroy

📌 Example
Change AMI → terraform apply

Order:

New EC2 created

Old EC2 destroyed



🔹 2. prevent_destroy
✅ What it does
Blocks accidental deletion

Terraform will throw an error if destroy is attempted

🧩 Example
hcl

lifecycle {
  prevent_destroy = true
}
❌ Result
bash

terraform destroy
➡️ ❌ Error: Resource cannot be destroyed



🔹 3. ignore_changes
✅ What it does
Terraform ignores changes to specific attributes

Useful when changes happen manually or automatically

🧩 Example: Ignore tag changes
hcl

lifecycle {
  ignore_changes = [tags]
}
🧠 Result
Tag changed in AWS Console

terraform plan → No changes

❌ ignore_changes LIMITATION (IMPORTANT)
ignore_changes cannot be used for attributes that force replacement.

❌ Does NOT work for:

ami

subnet_id

availability_zone

✔️ Works for:

tags

instance_type (if updatable)

metadata changes


🧠 ForceNew vs Update
Attribute	Behavior
ami	ForceNew ❌
subnet_id	ForceNew ❌
availability_zone	ForceNew ❌
tags	Update ✅
instance_type	Update ✅

🧠 Memory Trick (Easy)
ignore_changes → don’t update
create_before_destroy → safe replace
prevent_destroy → don’t delete


🎯 Real-World Usage
create_before_destroy → Zero downtime deployments

prevent_destroy → Protect production resources

ignore_changes → Ignore auto/manual changes


✅ Interview Line
“We use lifecycle rules in Terraform to control resource replacement, prevent accidental deletion, and ignore non-critical changes.”


📌 Conclusion
Lifecycle rules give fine-grained control over Terraform behavior and are very important in production infrastructure.
