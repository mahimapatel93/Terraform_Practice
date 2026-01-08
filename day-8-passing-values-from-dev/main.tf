provider "aws" {
  region = "us-east-1"
}

module "dev" {
  source = "../Day-8-modules"

  ami           = "ami-068c0051b15cdb816"
  instance_type = "t2.micro"
}
