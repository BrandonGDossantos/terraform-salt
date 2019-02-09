# provider "aws" {
#     region = "${var.region}"
#     access_key = "${var.access_key}"
#     secret_key = "${var.secret_key}"
# }
provider "aws" {
    region = "us-east-1"
    # access_key = "${var.access_key}"
    # secret_key = "${var.secret_key}"
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
