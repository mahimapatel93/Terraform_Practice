# Day 6 – RDS with Customer Managed Password & Read Replica (Terraform)

---

## 🎯 Objective

Provision an **Amazon RDS MySQL** database using **Terraform** with:

* Custom VPC and subnets
* DB Subnet Group
* Enhanced Monitoring (IAM Role)
* **Customer-managed master password**
* **Read Replica** creation

---

## 🏗️ Architecture Components

* **VPC**: Custom VPC with CIDR `10.0.0.0/16`
* **Subnets**: Two subnets in different AZs (Multi-AZ ready)
* **DB Subnet Group**: For RDS placement
* **IAM Role**: For RDS Enhanced Monitoring
* **Primary RDS Instance**: MySQL with static password
* **Read Replica**: For read scalability

---

## 🔐 Password Management Explained

### Customer-Managed Password

* Password is explicitly defined using `password`
* Stored and controlled by the user
* **Required for MySQL Read Replicas**
* Suitable for learning, demos, and controlled environments

> ⚠️ In production, avoid hardcoding passwords. Use Secrets Manager.

---

## 🔁 Read Replica – Key Requirement

### What is an RDS Read Replica?

An **RDS Read Replica** is a read-only copy of the primary RDS database that uses **asynchronous replication**. It is mainly used to:

* Improve **read performance**
* Reduce load on the primary database
* Scale applications that have heavy read traffic

---

### When should you use a Read Replica?

* When your application has **more SELECT queries** than INSERT/UPDATE
* When reporting, analytics, or dashboards impact primary DB performance
* When you want horizontal read scaling

---

### Key Requirements for Read Replica

To create a **Read Replica**:

* Automated backups **must be enabled**
* `backup_retention_period > 0`
* Source DB must be in **available state**
* `manage_master_user_password` **must be disabled** for MySQL

✅ This configuration satisfies all requirements.

---

### Limitations of Read Replicas

* Read replicas are **read-only**
* Replication is **asynchronous** (slight lag possible)
* Not a replacement for **Multi-AZ**
* Failover is **manual** (unless promoted)

---

## 📌 Terraform Highlights

* `replicate_source_db` links replica to primary RDS
* Same subnet group used for consistency
* Enhanced monitoring enabled using IAM role
* Deletion protection enabled for safety

---

## 🧠 Common Errors Faced & Fixes

### ❌ Password Conflict Error

**Cause:**

* Using `password` and `manage_master_user_password` together

**Fix:**

* Use only **one** method

---

### ❌ Read Replica Not Supported Error

**Cause:**

* `manage_master_user_password = true`

**Fix:**

* Switch to customer-managed password

---

## 🏆 Final Result

✅ Successfully created:

* RDS MySQL Primary Instance
* RDS Read Replica using Terraform

---

## 🗣️ Interview Explanation (Simple)

> "I used Terraform to create an RDS MySQL instance with a customer-managed password and enabled automated backups, which allowed me to successfully configure a read replica for better read scalability."

---

## 💡 Logical Interview Questions & Answers

### Q1. Why are automated backups required for read replicas?

**Answer:**
Read replicas use database backups to initialize replication. Without backups, AWS cannot create a consistent replica.

---

### Q2. Why does MySQL not support read replicas with AWS-managed passwords?

**Answer:**
Because AWS-managed passwords are stored in Secrets Manager and rotated automatically, which can break MySQL replication consistency.

---

### Q3. What is the difference between Multi-AZ and Read Replica?

**Answer:**

* Multi-AZ: High availability (failover)
* Read Replica: Read scalability and performance

---

### Q4. Why use a DB Subnet Group?

**Answer:**
It tells AWS in which subnets RDS instances can be launched, ensuring network isolation and availability.

---

### Q5. What happens if deletion protection is enabled?

**Answer:**
The RDS instance cannot be deleted accidentally until deletion protection is disabled.

---

### Q6. Can a read replica be promoted to primary?

**Answer:**
Yes, a read replica can be promoted to a standalone primary instance.

---

## ✅ Best Practices

* Enable backups before replicas
* Use customer-managed passwords only for learning
* Use Secrets Manager in production
* Enable monitoring for performance insights

---

## 📅 Status

**Day‑6 Task Completed Successfully ✅**
