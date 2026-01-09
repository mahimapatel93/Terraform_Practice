module "dev1" {
  source = "../Day-8-modules-practice"
  instance_type = "t2.micro"
  ami_id = "ami-068c0051b15cdb816"
  tags = {
    Name = "Dev-Instance-1"
  }
}
