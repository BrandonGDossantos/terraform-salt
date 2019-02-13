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
$admin = [adsi]("WinNT://./administrator, user")
$admin.psbase.invoke("SetPassword", "${var.instance_password}")
# net user Administrator "${var.instance_password}"
# wmic useraccount where "name='Administrator'" set PasswordExpires=FALSE

netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=block

winrm delete winrm/config/listener?Address=*+Transport=HTTP  2>$Null
winrm delete winrm/config/listener?Address=*+Transport=HTTPS 2>$Null

winrm create winrm/config/listener?Address=*+Transport=HTTP
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="0"}'
winrm set winrm/config '@{MaxTimeoutms="7200000"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service '@{MaxConcurrentOperationsPerUser="12000"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'

$Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$Setting = 'LocalAccountTokenFilterPolicy'
Set-ItemProperty -Path $Key -Name $Setting -Value 1 -Force

Stop-Service -Name WinRM
Set-Service -Name WinRM -StartupType Automatic
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=allow localip=any remoteip=any
Start-Service -Name WinRM
</powershell>
EOF

provisioner "file" {
    source = "test.txt"
    destination = "C:/test.txt"
    connection {
        type = "winrm"
        timeout = "20m"
        https = false
        user = "${var.instance_username}"
        password = "${var.instance_password}"
    }
}
}