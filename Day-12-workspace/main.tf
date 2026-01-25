resource "aws_instance" "server" {
    ami = "ami-068c0051b15cdb816"
      instance_type = "t2.nano"
  
      tags = {
        Name = "terraform-workspace"
      }
  
}

resource "aws_s3_bucket" "name" {
    bucket = "the-strainger-things-workspace"
    tags = {
      Name = "s3-workspace"
    }
}

# To create workspace use the command
# terraform workspace new             create new workspace and select it
# terraform workspace select          switch to existing workspace 
# terraform workspace list            list existing workspaces
# terraform workspace show            show the name of the current workspace
# terraform workspace delete          delete only empty workspace
#terraform workspace  -force delete   delete non empty workspace

# By default terraform creates a workspace named "default"
# Each workspace has its own state file
