````md
# Migrate Terraform to OpenTofu (Step-by-Step Guide)

## 📌 What is OpenTofu?
OpenTofu is an open-source fork of Terraform. It works almost the same but is fully community-driven and open-source.

---

## ✅ When Do You Need Migration?
You need to migrate when:
- You want 100% open-source IaC
- Your company avoids Terraform BSL license
- You want Terraform-compatible but vendor-neutral tool

---

# 🚀 Step-by-Step Migration from Terraform to OpenTofu

## 1️⃣ Install OpenTofu
### Windows (Winget)
```bash
winget install OpenTofu.Tofu
````

### Linux / Mac

```bash
brew install opentofu   # Mac
sudo apt install tofu   # Linux (if repo configured)
```

Check version:

```bash
tofu version
```

---

## 2️⃣ Replace Terraform Commands with Tofu

| Terraform Command  | OpenTofu Command |
| ------------------ | ---------------- |
| terraform init     | tofu init        |
| terraform plan     | tofu plan        |
| terraform apply    | tofu apply       |
| terraform destroy  | tofu destroy     |
| terraform fmt      | tofu fmt         |
| terraform validate | tofu validate    |

👉 Only command name changes.

---

## 3️⃣ Existing Terraform Project Migration

### Step 1: Go to Terraform Project Folder

```bash
cd my-terraform-project
```

### Step 2: Run OpenTofu Init

```bash
tofu init
```

👉 OpenTofu will read existing `.tf` files and `.terraform` state.

---

## 4️⃣ State File Migration

OpenTofu uses the **same Terraform state file**.

No changes required.

State file name stays:

```bash
terraform.tfstate
```

---

## 5️⃣ Provider Compatibility

Most Terraform providers work without changes.

Example (same in OpenTofu):

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

---

## 6️⃣ Backend Migration (S3, Remote, etc.)

No changes needed.

Example S3 backend:

```hcl
terraform {
  backend "s3" {
    bucket = "my-tf-state"
    key    = "prod/terraform.tfstate"
    region = "ap-south-1"
  }
}
```

OpenTofu reads it automatically.

---

# ⚠️ Important Differences (Interview Point)

| Terraform               | OpenTofu         |
| ----------------------- | ---------------- |
| BSL License             | 100% Open Source |
| Controlled by HashiCorp | Community Driven |
| Paid Enterprise         | Open Governance  |

---

# ❌ Common Migration Mistakes

* Forgetting to install tofu binary
* Running terraform instead of tofu
* Mixing Terraform and OpenTofu in same pipeline
* CI/CD pipeline still using terraform CLI

---

# 🎯 Interview One-Line Answer

**“OpenTofu is an open-source fork of Terraform, and migration involves installing tofu and replacing terraform commands while keeping the same configuration and state files.”**

---

# 🧠 Bonus: CI/CD Pipeline Change Example

### GitHub Actions Example

```yaml
- name: OpenTofu Init
  run: tofu init

- name: OpenTofu Apply
  run: tofu apply -auto-approve
```

---

# ✅ Conclusion

Migration is very easy:

* No code change
* Same .tf files
* Same state file
* Only CLI command changes

---

## 📌 If You Want

I can also create:

* OpenTofu vs Terraform interview Q&A notes
* Real migration project example
* PPT notes for study
* Short notes PDF style

Just tell me 😊

```
```
