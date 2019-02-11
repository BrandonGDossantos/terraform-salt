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
        "${aws_security_group.allow_icmp.id}"
        ]
    private_ip = "${var.salt_minion_windows_private}"
    root_block_device {
        volume_type = "gp2"
        volume_size = 64
    }
    user_data = <<EOF
<powershell>
net user ${var.instance_username} ‘${var.instance_password}’ /add /y
net localgroup administrators ${var.instance_password} /add

winrm quickconfig -q
winrm set winrm/config/winrs ‘@{MaxMemoryPerShellMB=”300″}’
winrm set winrm/config ‘@{MaxTimeoutms=”1800000″}’
winrm set winrm/config/service ‘@{AllowUnencrypted=”true”}’
winrm set winrm/config/service/auth ‘@{Basic=”true”}’

netsh advfirewall firewall add rule name=”WinRM 5985″ protocol=TCP dir=in localport=5985 action=allow
netsh advfirewall firewall add rule name=”WinRM 5986″ protocol=TCP dir=in localport=5986 action=allow

net stop winrm
sc.exe config winrm start=auto
net start winrm
</powershell>
EOF

provisioner "file" {
    source = "test.txt"
    destination = "C:/test.txt"
    connection {
        type = "winrm"
        timeout = "10m"
        user = "${var.INSTANCE_USERNAME}"
        password = "${var.INSTANCE_PASSWORD}"
    }
}

output "ip" {
    value = "${aws_instance.salt_minion_windows.public_ip}"
}
}