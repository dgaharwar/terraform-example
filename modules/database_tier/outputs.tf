# Copyright 2020 Hewlett Packard Enterprise Development LP
output "db_instance_id" {
  value = "${vsphere_virtual_machine.db.id}"
}

output "db_instance_private_ip" {
  value = "${vsphere_virtual_machine.db.default_ip_address}"
}

