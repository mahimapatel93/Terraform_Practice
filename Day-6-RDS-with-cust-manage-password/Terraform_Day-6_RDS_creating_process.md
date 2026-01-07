# Terraform Day – 6 📘 (Handwritten Notes Style)

## Topic: RDS with Customer Managed Password & Read Replica

---

## 1️⃣ VPC

Required:
1. CIDR Block
2. Tags (Name)

---

## 2️⃣ Subnets

Required:
1. Minimum **2 subnets**
2. Prefer **Private Subnets**
3. Different Availability Zones

Subnet contains:
1. VPC ID
2. CIDR Block
3. Availability Zone
4. Tags

---

## 3️⃣ IAM Role (Enhanced Monitoring)

Why required?
- For RDS enhanced monitoring

Required:
1. Name
2. Trusted Entity
   - Service: monitoring.rds.amazonaws.com
3. Action: sts:AssumeRole

---

## 4️⃣ Attach Policy to IAM Role

Policy:
- AmazonRDSEnhancedMonitoringRole

Resource:
- aws_iam_role_policy_attachment

Important:
- role = resource_type.resource_name.name
- policy_arn = AWS managed policy ARN

---

## 5️⃣ DB Subnet Group

Why required?
- Tells RDS where to launch DB

Required:
1. Name
2. Subnet IDs
3. Description

---

## 6️⃣ RDS Instance

Required Parameters:
1. identifier
2. engine (mysql)
3. engine_version
4. instance_class
5. allocated_storage
6. username
7. password (Customer Managed)
8. db_subnet_group_name
9. monitoring_role_arn

---

## 7️⃣ Read Replica

Points:
1. Created from source DB
2. Read-only database
3. Improves read performance
4. Same engine as source

---

## 🔁 Flow

VPC → Subnets → IAM Role → Policy → DB Subnet Group → RDS → Read Replica
