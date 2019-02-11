resource "aws_instance" "saltmaster" {
    tags {
        Name = "Salt Master"
    }
    ami = "${lookup(var.amis, var.region)}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
        "${aws_security_group.allow_ssh.id}",
        "${aws_security_group.allow_salt.id}"
        ]
    private_ip = "${var.salt_master_private}"
    root_block_device {
        volume_type = "gp2"
        volume_size = 64
    }
   
    provisioner "remote-exec" {
        inline = [
        "sudo curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com",
        "sudo sh bootstrap-salt.sh -M -N git develop"
        ]
        connection {
            agent = true
            type = "ssh"
            user = "ubuntu"
        }
    }
}