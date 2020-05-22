# Copyright 2020 Hewlett Packard Enterprise Development LP
provider "vsphere" {
  user                 = "${var.vsphere_user}"
  password             = "${var.vsphere_user}"
  vsphere_server       = "${var.vsphere_user}"
  allow_unverified_ssl = true
}