variable "region" {
    default = "us-east-1"
}
variable "instance_type" {
    default = "t3.medium"
}
variable "amis" {
    default = {
        us-east-1 = "ami-0f9cf087c1f27d9b1"
    }
}
variable "key_name" {
    default = "AWS Key"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

# variable "private_subnet_cidr" {
#     default = "10.0.1.0/24"
# }

