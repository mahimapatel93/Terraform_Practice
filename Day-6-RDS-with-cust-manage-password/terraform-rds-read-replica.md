# Day 6 – RDS with Customer Managed Password & Read Replica (Terraform)

---

## What is Amazon RDS?

Amazon RDS (Relational Database Service) is a **managed database service** provided by AWS.

It helps to:
- Create databases easily
- Handle backups automatically
- Manage patching and monitoring

---

## Objective of Day 6

Create an **RDS MySQL database** using Terraform with:

- Custom VPC & Subnets
- DB Subnet Group
- Customer-managed password
- Automated backups enabled
- Read Replica for read scalability

---

## Architecture Used

- **VPC**: Custom VPC (10.0.0.0/16)
- **Subnets**: Two subnets in different AZs
- **DB Subnet Group**: Used for RDS placement
- **Primary RDS Instance**: MySQL
- **Read Replica**: For read-only traffic

---

## Customer Managed Password

### What does it mean?

Customer-managed password means:
- Password is defined manually using `password`
- User controls the password
- AWS does NOT rotate it automatically

---

### Why Customer-Managed Password is Used?

- **Required for MySQL Read Replicas**
- AWS-managed password (Secrets Manager) does not support MySQL replicas
- Best for learning & practice

⚠️ In production, always use **AWS Secrets Manager**

---

## What is an RDS Read Replica?

An **RDS Read Replica** is a **read-only copy** of the main database.

It uses **asynchronous replication** from primary DB.

---

## Why Read Replica is Used?

- Improve read performance
- Reduce load on primary database
- Handle heavy SELECT queries
- Used for reports & analytics

---

## Requirements for Read Replica

To create a Read Replica:

- Automated backups must be enabled
- `backup_retention_period` > 0
- Source DB must be available
- `manage_master_user_password` must be **false**

---

## Limitations of Read Replica

- Read-only (no write operations)
- Replication lag possible
- Not a replacement for Multi-AZ
- Failover is manual

---

## Terraform Important Points

- `replicate_source_db` links replica to primary DB
- Same DB Subnet Group is used
- Deletion protection enabled
- Monitoring enabled

---

## Common Errors & Fixes

### Error 1: Password Conflict

**Reason**
- Using `password` and `manage_master_user_password` together

**Fix**
- Use only one method

---

### Error 2: Read Replica Not Supported

**Reason**
- `manage_master_user_password = true`

**Fix**
- Use customer-managed password

---

## terraform.tfstate Impact

- State file tracks primary & replica DB
- Backup state helps in recovery
- Use remote backend for safety

---

## Interview One-Liner

> “I created an RDS MySQL database using Terraform with customer-managed password and enabled automated backups to successfully configure a read replica for better read scalability.”

---

## Interview Questions

### Q1. Why backups are required for read replicas?
Backups are used to create a consistent replica.

---

### Q2. Multi-AZ vs Read Replica?
- Multi-AZ → High Availability
- Read Replica → Read Performance

---

### Q3. Can Read Replica be promoted?
Yes, it can be promoted to a standalone primary DB.

---

## Best Practices

- Enable backups before replica creation
- Never hardcode passwords in production
- Use monitoring for performance
- Use remote backend for Terraform state

---

## Status

✅ **Day-6 Task Completed Successfully**
