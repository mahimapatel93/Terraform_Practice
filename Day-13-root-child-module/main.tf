module "vpc"{
    source = "./modules/vpc"
    cidr_block = "10.0.0.0/16"
    subnet1_cidr = "10.0.1.0/24"
    subnet2_cidr = "10.0.2.0/24"
    az1 = "us-east-1a"
    az2 = "us-east-1b"
}

module "ec2"{
    source = "./modules/ec2"
    ami_id = "ami-068c0051b15cdb816"
    instance_type = "t2.micro"
    subnet1_id = module.vpc.subnet1_id
}

module "s3"{
    source = "./modules/s3"
    bucket_name = "the-strainger-things-module"
}

