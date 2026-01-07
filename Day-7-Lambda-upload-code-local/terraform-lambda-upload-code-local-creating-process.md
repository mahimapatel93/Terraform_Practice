# Terraform Day – 7 📒  
## Lambda – Upload Code (Local ZIP)

---

##  Objective

Create an **AWS Lambda function** using **Terraform**  
and upload **Lambda code from local system (ZIP file)**.

---

## 1️⃣ IAM Role for Lambda

### Why required?
- Lambda needs permission to write logs in CloudWatch

### Required:
1. Name
2. assume_role_policy

Trusted Entity:
- Service → lambda.amazonaws.com  
- Action → sts:AssumeRole

---

## 2️⃣ Attach Policy to IAM Role

### Policy Used:
- AWSLambdaBasicExecutionRole

### Resource:
- aws_iam_role_policy_attachment

### Important:
- role = aws_iam_role.lambda_role.name  
- policy_arn = AWS managed policy ARN

---

## 3️⃣ Lambda Function (Terraform)

### Required Parameters:

1. function_name  
2. role (IAM role ARN)  
3. handler  
   - format → file_name.function_name  
4. runtime  
   - python3.9 / python3.12  
5. timeout  
6. memory_size  
7. filename (ZIP file path)

---

## 4️⃣ Local Lambda Code

### File:
- Lambda_function.py

### Example Code:

- Uses Python
- Contains lambda_handler(event, context)
- This is the entry point of Lambda

---

## 5️⃣ Create ZIP File (Important Step)

### Why ZIP?
- AWS Lambda accepts code in ZIP format

### Command:
zip lambda_function.zip Lambda_function.py

Result:
- lambda_function.zip created locally

---

## 6️⃣ source_code_hash

### Why required?
- Terraform cannot detect ZIP code changes automatically

### Used Function:
- filebase64sha256("lambda_function.zip")

### Purpose:
- Forces Lambda update when code changes

---

## 7️⃣ Terraform Lambda Resource Flow

1. IAM Role created  
2. Policy attached  
3. ZIP file prepared locally  
4. Lambda function created using ZIP  

---

## 🔁 Overall Flow

IAM Role → Policy → ZIP File → Lambda Function

---

## 🧠 One-Line Explanation (Interview)

"In Day-7, I used Terraform to create an IAM role, uploaded a local ZIP file, and deployed a Lambda function."
---
