resource "aws_instance" "saltmaster" {
    tags {
        Name = "Salt Master"
    }
    ami = "${lookup(var.amis, var.region)}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    vpc_security_group_ids = ["${var.security_group_id}"]
    root_block_device {
        volume_type = "gp2"
        volume_size = 64
    }
    provisioner "remote-exec" {
        inline = [
        "sudo apt-get update && sudo apt-get dist-upgrade",
        "sudo apt-get install salt-master -y", 
        "sudo salt-master --log-file=/var/log/salt/master"
        ]
        connection {
            agent = true
            type = "ssh"
            user = "ubuntu"
        }
    }
}