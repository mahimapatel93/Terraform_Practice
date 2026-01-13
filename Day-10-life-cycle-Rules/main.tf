resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
     tags = {
       Name = "cust-vpc"
     }
  
}

resource "aws_instance" "name1" {
#   ami = "ami-068c0051b15cdb816"
    ami =  "ami-07ff62358b87c7116"
  instance_type = "t2.medium"
  availability_zone = "us-east-1a"
  tags = {
    Name = "ec-instance"
  }
#   lifecycle {
#     prevent_destroy = true
#   }
  lifecycle {
    create_before_destroy = true
  }
#   lifecycle {
#     ignore_changes = [ tags ]
#   }
}





 # Lifecycle Rules
  # -------------------------------

  # create_before_destroy
  # When a change requires replacement (like AMI),
  # Terraform will:
  # 1. Create NEW instance first
  # 2. Then destroy OLD instance
  # This avoids downtime
#   lifecycle {
#     create_before_destroy = true
#   }


  # prevent_destroy
  # If enabled, Terraform will BLOCK
  # accidental deletion of EC2
  # lifecycle {
  #   prevent_destroy = true
  # }


  # ignore_changes
  # Terraform will IGNORE changes in tags
  # (manual or code changes will not affect EC2)
  # lifecycle {
  #   ignore_changes = [tags]
  # }
