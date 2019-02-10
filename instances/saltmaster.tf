resource "aws_security_group" "salt" {
    name = "salt"
    description = "Allow salt protocol."

    ingress { 
        from_port = 4505
        to_port = 4505
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress { 
        from_port = 4506
        to_port = 4506
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "SaltSG"
    }
}

resource "aws_instance" "saltmaster" {
    tags {
        Name = "Salt Master"
    }
    ami = "${lookup(var.amis, var.region)}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.us-east-1b-private.id}"
    # subnet_id = "subnet-0ea0a03d7c35eb2a9"
    vpc_security_group_ids = ["${aws_security_group.salt.id}"]
    private_ip = "${var.salt_master_private}"
    root_block_device {
        volume_type = "gp2"
        volume_size = 64
    }
   
    provisioner "remote-exec" {
        inline = [
        "sudo apt-get update",
        "sudo apt-get install salt-master -y"
        ]
        connection {
            agent = true
            type = "ssh"
            user = "ubuntu"
        }
    }
}