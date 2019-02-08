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
    # provisioner "remote-exec" {
    #     inline = [
    #     "git clone https://github.com/BrandonGDossantos/t-pot-autoinstall.git",
    #     "cd t-pot-autoinstall/",
    #     "sudo ./install.sh ubuntu 2 sundown"
    #     ]
    #     connection {
    #         agent = true
    #         type = "ssh"
    #         user = "ubuntu"
    #     }
    # }
}