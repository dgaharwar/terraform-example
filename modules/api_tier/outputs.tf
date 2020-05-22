# Copyright 2020 Hewlett Packard Enterprise Development LP
output "app_instance_id" {
  value = "${vsphere_virtual_machine.app.id}"
}

output "app_instance_private_ip" {
  value = "${vsphere_virtual_machine.app.default_ip_address}"
}

