resource "aws_instance" "name" {
  ami =  "ami-068c0051b15cdb816"
    instance_type = "t2.micro"
    provisioner "local-exec" {
        command = "echo Instance has been created"
    }
}


resource "aws_s3_bucket" "name1" {
    bucket = "the-strainger-things"
  
}
# To taint the resource use the command
# terraform taint aws_instance.name 