# Terraform `for_each` – Important Notes

## 📌 What is `for_each`?

`for_each` is used to create **multiple resources using a set or map**.
Each resource gets a **unique key**, making it safer and more predictable than `count`.

---

## 🔹 When to Use `for_each`

* When resources need **unique names/keys**
* When using **maps or sets**
* When you want to avoid index-related issues of `count`

---

## 🔹 `for_each` with a List (Set)

```hcl
resource "aws_instance" "example" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
  for_each      = toset(["dev", "prod", "test"])

  tags = {
    Name = each.key
  }
}
```

### ✔ What Happens?

| Value | Instance Created |
| ----- | ---------------- |
| dev   | 1 EC2 instance   |
| prod  | 1 EC2 instance   |
| test  | 1 EC2 instance   |

---

## 🔹 `for_each` with a Map (Recommended)

```hcl
variable "instances" {
  default = {
    dev  = "t2.micro"
    prod = "t2.small"
    test = "t2.medium"
  }
}

resource "aws_instance" "server" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = each.value
  for_each      = var.instances

  tags = {
    Name = each.key
  }
}
```

### ✔ Explanation

* `each.key` → instance name (dev, prod, test)
* `each.value` → instance type

---

## 🔹 Conditional Resource Creation using `for_each`

```hcl
variable "enable_instance" {
  default = true
}

variable "instances" {
  default = {
    dev  = "t2.micro"
    prod = "t2.small"
    test = "t2.medium"
  }
}

resource "aws_instance" "server" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = each.value

  for_each = var.enable_instance ? var.instances : {}

  tags = {
    Name = each.key
  }
}
```

### ✔ Commands

```bash
terraform apply -var="enable_instance=true"
terraform apply -var="enable_instance=false"
```

* `{}` → empty map → **no resources created**

---

## 🔹 `count` vs `for_each`

| Feature       | count | for_each |
| ------------- | ----- | -------- |
| Uses index    | Yes   | No       |
| Uses keys     | No    | Yes      |
| Supports map  | ❌     | ✅        |
| Safe for prod | ⚠️    | ✅        |

---

## 🔹 Important Rules

* `for_each` **cannot use numbers** directly
* Keys must be **unique**
* Use `{}` to disable resources
* Changing keys may recreate resources

---

## 🎯 Interview Points

* `for_each` is preferred for production
* Avoids index shifting problem of `count`
* Best with maps for clear resource identity

---

## ✅ Best Practice

✔ Use `count` → simple duplicate resources
✔ Use `for_each` → named, configurable resources

