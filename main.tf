# provider "aws" {
#     region = "${var.region}"
#     access_key = "${var.access_key}"
#     secret_key = "${var.secret_key}"
# }
provider "aws" {
    region = "${var.region}"
    access_key = "AKIAJXI3U4C3NBAHB2FA"
    secret_key = "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"
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
