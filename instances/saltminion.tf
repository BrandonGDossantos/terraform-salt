resource "aws_instance" "saltminion" {
    tags {
        Name = "Salt Minion"
    }
    ami = "${lookup(var.amis, var.region)}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
        "${aws_security_group.allow_ssh.id}",
        "${aws_security_group.allow_icmp.id}"
        ]
    private_ip = "${var.salt_minion_private}"
    root_block_device {
        volume_type = "gp2"
        volume_size = 64
    }
   
    provisioner "remote-exec" {
        inline = [
        "curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com",
        "sudo sh bootstrap-salt.sh git develop"
        ]
        connection {
            agent = true
            type = "ssh"
            user = "ubuntu"
        }
    }
}
