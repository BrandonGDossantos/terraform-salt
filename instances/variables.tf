variable "region" {
    default = "us-east-1"
}
variable "instance_type" {
    default = {
        linux = "t3.medium",
        windows = "t3.large"
    }
}
variable "amis" {
    default = {
        linux = "ami-0ac019f4fcb7cb7e6",
        windows = "ami-07823c2db5abec688"
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

variable "salt_minion_linux_private" {
    default = "10.0.0.10"
}
variable "salt_minion_windows_private" {
    default = "10.0.0.11"
}
variable "instance_username" {
    default = "testuser"
}

variable "instance_password" {
    default = "testpassword"
}

