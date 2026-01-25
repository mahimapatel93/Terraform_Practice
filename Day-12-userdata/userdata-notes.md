````md
# User Data in Terraform

## 📌 What is User Data?
User data is a **startup script** that runs automatically when an **EC2 instance launches for the first time**.

It is mainly used to:
- Install software
- Start services
- Configure servers automatically
- Deploy frontend/backend applications

---

## 🔹 Why User Data is Important?
Without user data ❌ you must manually SSH into servers.

With user data ✅ everything is automated.

In real DevOps projects, **manual configuration is not allowed**.

---

## 🔹 How User Data Works
1. EC2 instance launches
2. OS boots
3. User data script runs
4. Server becomes ready

---

## 🔹 Simple Terraform Example

```hcl
resource "aws_instance" "example" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello from Terraform User Data" > /var/www/html/index.html
              EOF
}
````

---

## 🔹 Why `#!/bin/bash` is Required

It tells AWS that the script should run using **Bash shell**.

Without it, the script may fail.

---

## 🔹 Real-World Example (Frontend Server)

```hcl
user_data = <<-EOF
#!/bin/bash
yum install -y nginx
systemctl start nginx
systemctl enable nginx

echo "<h1>Frontend Server</h1>" > /usr/share/nginx/html/index.html
EOF
```

---

## 🔹 User Data with Auto Scaling Group

User data **cannot** be added directly to an Auto Scaling Group.

It must be added inside a **Launch Template**.

```hcl
resource "aws_launch_template" "frontend_lt" {
  image_id      = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"

  user_data = base64encode(<<-EOF
  #!/bin/bash
  yum install -y nginx
  systemctl start nginx
  EOF
  )
}
```

📌 `base64encode()` is mandatory in Launch Templates.

---

## 🔹 Where to Check User Data Logs

Login to EC2 and check:

```bash
/var/log/cloud-init-output.log
```

---

## 🔹 Important Behavior

* User data runs **only once** (first boot)
* It does not run again after reboot

---

## ❌ Common Mistakes

* Missing `#!/bin/bash`
* Service installed but not started
* Using `yum` on Ubuntu (should use `apt`)
* Forgetting `base64encode()` in Launch Template

---

## 🎯 Interview One-Line Answer

**User data is a bootstrap script that automatically configures an EC2 instance at launch time.**

---

## ✅ Summary

* User data automates EC2 setup
* Used for real DevOps projects
* Works with Terraform and OpenTofu
* Essential for Auto Scaling environments

```
```
