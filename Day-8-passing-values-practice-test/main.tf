module "test1" {
    source = "../Day-8-modules-practice"
    ami_id ="ami-068c0051b15cdb816"
    instance_type = "t2.nano"
    tags = {
      Name = "Test-Instance-1"
    }
  
}