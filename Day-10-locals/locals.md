
## What are Locals?
**Locals** are named values defined inside a Terraform configuration that help reuse expressions and avoid duplication in code.

They make Terraform code:
- Cleaner
- Easier to read
- Easier to maintain

---

## Example Used

```hcl
locals {
  ami               = "ami-068c0051b15cdb816"
  instance_type     = "t2.micro"
  type              = "t2.medium"
  availability_zone = "us-east-1a"
  Name              = "instance"
  Name1             = "dev"
}
Why We Use Locals
Avoid hardcoding values again and again

Change value at one place, reflect everywhere

Improve readability of Terraform code

Useful for common configurations

Important Points (Very IMP)
1. Locals Are Read-Only
You cannot change local values during runtime

They are evaluated before resource creation

2. Use Locals for Common Values
✔ Good use cases:

AMI IDs

Instance types

Availability zones

Common tags

❌ Avoid using locals for:

Unique resource names

Values that differ per resource (unless clearly separated)

3. Same Local Value = Same Output
If two resources use:

hcl
Name = local.Name
➡ Both resources will have the same Name tag

So for different names:

hcl
Name = local.Name
Name = local.Name1

4. Access Locals Using local.<name>
Example:

hcl
ami = local.ami

5. Locals Reduce Duplication, Not Resources
Locals do not create resources

They only help manage values used by resources