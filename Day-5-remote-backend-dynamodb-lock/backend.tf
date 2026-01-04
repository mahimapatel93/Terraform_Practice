terraform {
  backend "s3" {
    bucket = "the-new-stranger-things"
    key    = "day-5/terraform.tfstate"
    region = "us-east-1"
     # Enable S3 native locking
    #use_lockfile = true   #tf version should be above 1.10
    # The dynamodb_table argument is no longer needed
    dynamodb_table = "terraform-lock1"
    encrypt        = true
  }
}