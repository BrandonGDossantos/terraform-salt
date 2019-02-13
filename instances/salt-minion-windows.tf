resource "aws_instance" "salt_minion_windows" {
    tags {
        Name = "Salt Minion Windows"
    }
    ami = "${lookup(var.amis, "windows")}"
    instance_type = "${lookup(var.instance_type, "windows")}"
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
        "${aws_security_group.allow_winrm.id}",
        "${aws_security_group.allow_salt.id}",
        "${aws_security_group.allow_icmp.id}",
        "${aws_security_group.allow_rdp.id}"
        ]
    private_ip = "${var.salt_minion_windows_private}"
    root_block_device {
        volume_type = "gp2"
        volume_size = 64
    }
    user_data = <<EOF
<powershell>
curl -OutFile bootstrap-salt.ps1 https://raw.githubusercontent.com/saltstack/salt-bootstrap/develop/bootstrap-salt.ps1
./bootstrap-salt.ps1 -master salt.cptc.com
</powershell>
EOF

    provisioner "file" {
        source = "instances/hosts"
        destination = "C:/Windows/System32/drivers/etc/hosts"
        connection {
            type = "winrm"
            timeout = "20m"
            https = false
            user = "${var.instance_username}"
            password = "${var.instance_password}"
        }
    }
}