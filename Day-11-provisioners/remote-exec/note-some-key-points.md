# Terraform Remote-Exec Practice Guide

## Key Points / Errors Explained (Mahima's Case)

1. **Public/Private Key Path Issue**

   * Terraform cannot expand `~` on Windows. So `file("~/.ssh/cust-key_name.pub")` fails.
   * **Fix:** Use absolute path (e.g., `C:/Users/Mahima/.ssh/cust-key_name.pub`) or put key in project folder and use relative path (`file("cust-key_name.pub")`).

2. **SSH Timeout / Connection Failure**

   * Error: `dial tcp <public-ip>:22: i/o timeout`
   * Causes:

     * EC2 instance does not have a **public IP**.
     * Security Group blocks **port 22 (SSH)**.
     * Wrong private key path or wrong key permissions.
   * **Fix:**

     * Ensure `associate_public_ip_address = true`
     * Security Group allows inbound SSH (22) from your IP or `0.0.0.0/0`.
     * Private key file path correct, key exists.

3. **Private Key Permissions**

   * On Linux/Mac: `chmod 400 ~/.ssh/cust-key_name` is required.
   * On Windows using Git Bash or WSL, run the same command.
   * Purpose: SSH refuses keys that are too open.

4. **Better Practice: Terraform-Generated Key**

   * Use `tls_private_key` to generate keys in Terraform.
   * Avoids all path / permission issues.

5. **Remote-Exec Provisioner Basics**

   * Executes commands on the remote EC2 instance after creation.
   * Needs working SSH connection (user, private key, host).
   * Inline commands example:

     ```hcl
     inline = [
       "sudo yum update -y",
       "sudo yum install -y httpd",
       "sudo systemctl start httpd",
       "sudo systemctl enable httpd"
     ]
     ```

6. **Common Confusions**

   * `key_name` in EC2 must match AWS Key Pair, not file name.
   * `file()` function reads local file content; path must exist **before Terraform apply**.
   * Security group ID vs name: EC2 expects **SG ID** in `vpc_security_group_ids`.
   * `associate_public_ip_address` must be **true** for remote-exec to connect if subnet is public.

7. **Commands to Generate Key**

   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/cust-key_name
   chmod 400 ~/.ssh/cust-key_name
   ```

   * `.pub` file → upload to AWS as `public_key`
   * Private file → used in `connection` block

---

**Recommendation:**

* Fix the path issues first.
* Ensure EC2 has public IP and SG allows SSH.
* Test SSH manually from your terminal using the private key:

  ```bash
  ssh -i ~/.ssh/cust-key_name ec2-user@<public-ip>
  ```
* Once SSH works, `remote-exec` will also work.

---

**Terraform File Organization:**

* Keep `key pair`, `VPC`, `Subnet`, `Security Group`, and `EC2` in same `.tf` file for practice.
* Optionally split into multiple `.tf` files (e.g., `vpc.tf`, `security.tf`, `ec2.tf`) for bigger projects.
