resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "terraform-aws-vpc"
    }
}
resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}
resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.default.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1b"

  tags {
    Name = "Public Subnet"
  }
}
resource "aws_internet_gateway" "default_igw" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "VPC Internet Gateway"
  }
}

resource "aws_route_table" "default_us_east_1b_public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default_igw.id}"
    }

    tags {
        Name = "Public Subnet Route Table"
    }
}

resource "aws_route_table_association" "default_us_east_1a_public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.my_vpc_us_east_1a_public.id}"
}
/*
  Private Subnet
*/
# resource "aws_subnet" "us-east-1b-private" {
#     vpc_id = "${aws_vpc.default.id}"

#     cidr_block = "${var.private_subnet_cidr}"
#     availability_zone = "us-east-1b"

#     tags {
#         Name = "Private Subnet"
#     }
# }
# resource "aws_security_group" "nat" {
#     name = "vpc_nat"
#     description = "Allow traffic to pass from the private subnet to the internet"

#     ingress {
#         from_port = 80
#         to_port = 80
#         protocol = "tcp"
#         cidr_blocks = ["${var.private_subnet_cidr}"]
#     }
#     ingress {
#         from_port = 443
#         to_port = 443
#         protocol = "tcp"
#         cidr_blocks = ["${var.private_subnet_cidr}"]
#     }
#     ingress {
#         from_port = 22
#         to_port = 22
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
#     ingress {
#         from_port = -1
#         to_port = -1
#         protocol = "icmp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     egress {
#         from_port = 80
#         to_port = 80
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
#     egress {
#         from_port = 443
#         to_port = 443
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
#     egress {
#         from_port = 22
#         to_port = 22
#         protocol = "tcp"
#         cidr_blocks = ["${var.vpc_cidr}"]
#     }
#     egress {
#         from_port = -1
#         to_port = -1
#         protocol = "icmp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     vpc_id = "${aws_vpc.default.id}"

#     tags {
#         Name = "NATSG"
#     }
# }