# Terraform `count` – Important Notes 📌

This file contains **important, interview‑ready notes** for understanding and using **`count`** in Terraform.

---

## 1️⃣ What is `count`?

`count` is a **meta‑argument** in Terraform used to create **multiple instances of the same resource** with similar configuration.

```hcl
count = <number>
```

---

## 2️⃣ Basic Rules of `count`

* `count` value must be **0 or greater**
* ❌ Negative values are **not allowed**
* Indexing always starts from **0**
* Resource address becomes a **list**

Example:

```hcl
aws_instance.example[0]
aws_instance.example[1]
```

---

## 3️⃣ Simple Example

```hcl
resource "aws_instance" "example" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
  count         = 2
}
```

➡️ This creates **2 EC2 instances**

---

## 4️⃣ `count.index`

`count.index` gives the **current resource number**.

```hcl
tags = {
  Name = "ec2-${count.index}"
}
```

Result:

* ec2‑0
* ec2‑1

---

## 5️⃣ Using `count` with a List

```hcl
variable "names" {
  default = ["dev", "prod", "test"]
}

resource "aws_instance" "instance" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
  count         = length(var.names)

  tags = {
    Name = var.names[count.index]
  }
}
```

➡️ Creates **3 instances**: dev, prod, test

---

## 6️⃣ Conditional Resource Creation

```hcl
variable "create_instance" {
  type    = bool
  default = true
}

resource "aws_instance" "server" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
  count         = var.create_instance ? 1 : 0
}
```

* `true` → resource created
* `false` → resource destroyed / skipped

---

## 7️⃣ Environment‑based `count`

```hcl
variable "environment" {
  default = "dev"
}

resource "aws_instance" "env" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
  count         = var.environment == "prod" ? 2 : 1
}
```

| Environment | Instances |
| ----------- | --------- |
| dev         | 1         |
| prod        | 2         |

---

## 8️⃣ `count = 0` Behavior (VERY IMPORTANT)

* No resource is created
* Existing resource is **destroyed**
* Used for **optional resources**

```hcl
count = 0
```

---

## 9️⃣ `count` with Multiple Variables

```hcl
variable "enable_instance" {
  default = true
}

variable "instance_count" {
  default = 2
}

resource "aws_instance" "test" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
  count         = var.enable_instance ? var.instance_count : 0
}
```

---

## 🔟 Limitations of `count`

* Index shifting can cause **unexpected destroy/recreate**
* Not ideal for resources with **unique identity**
* Changing list order may break state

---

## 1️⃣1️⃣ `count` vs `for_each`

| Feature         | count          | for_each      |
| --------------- | -------------- | ------------- |
| Indexing        | Numeric        | Key‑based     |
| Deletion safety | ❌ Risky        | ✅ Safe        |
| Best use        | Simple scaling | Real projects |

👉 **Best Practice:** Use `for_each` for production

---

## 🧠 Interview‑Ready Lines

> `count` is useful for simple resource scaling, but `for_each` is preferred in production because it avoids index‑based recreation issues.

> `count = 0` is commonly used to conditionally skip or destroy a resource.

---

## ✅ Key Takeaways

* `count` creates multiple similar resources
* Index starts from `0`
* `count = 0` destroys resource
* Avoid `count` for complex production infra
* Prefer `for_each` for stability

---

📌 **Use this file for revision, GitHub, and interviews**
