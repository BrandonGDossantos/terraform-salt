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
variable "security_group_id" {
    default = "sg-055d40e8d83adc2e1"
}

variable "vpc_id" {
    default = "vpc-30fa5d4a"
  
}

variable "saltdns" {
    default = "salt.cptc.com"
}
