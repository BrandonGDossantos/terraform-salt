variable "region" {
    default = "us-east-1"
}
variable "instance_type" {
    default = "t3.medium"
}
variable "amis" {
    default = {
        us-east-1 = "ami-0ac019f4fcb7cb7e6"
    }
}
variable "key_name" {
    default = "AWS Key"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
    default = "10.0.1.0/24"
}

variable "salt_master_private" {
    default = "10.0.0.5"
}

variable "salt_minion_private" {
    default = "10.0.0.10"
}
