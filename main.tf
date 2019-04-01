provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "%USERPROFILE%\\.aws\\credentials"
    profile = "default"
}
terraform {
    backend "s3" {
        bucket = "leix.terraform-salt.s3"
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}
module "instances" {
    source = "./instances"
}
