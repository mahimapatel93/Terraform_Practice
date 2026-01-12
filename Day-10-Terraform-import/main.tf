resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "cust-vpc"
    }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "the-strainger-thingssssss"

  tags = {
    Name = "the-strainger-thingssssss"
  }
}

#Imported an existing vpc and S3 bucket into Terraform
#cammand:--------------
#terraform import aws_vpc.name vpc-07a2e5ffc0544c86e
#terraform import aws_s3_bucket.my_bucket the-strainger-thingssssss