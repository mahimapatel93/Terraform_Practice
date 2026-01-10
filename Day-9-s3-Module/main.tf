module "aws_s3_bucket" {
   source = "terraform-aws-modules/s3-bucket/aws"
   version = "3.14.0"
    
    bucket = "the-strainger-things" 
    acl    = "private"

    control_object_ownership = true
    object_ownership =  "ObjectWriter"
    
    versioning = {
      enabled = true
    }
  
}

