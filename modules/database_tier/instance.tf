# Copyright 2020 Hewlett Packard Enterprise Development LP

data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.vm_cluster_name}/Resources/${var.resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


data "vsphere_network" "network" {
  name          = "${var.network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data template_file "metadata" {
  template = "${file("${path.module}/metadata.yaml")}"
  vars = {
    dhcp        = "${var.dhcp}"
    hostname    = "${var.hostname}"
    ip_address  = "${var.ip_address}"
    netmask     = "${var.netmask}"
    nameservers = "${jsonencode(var.nameservers)}"
    gateway     = "${var.gateway}"
  }
}

data template_file "userdata" {
  template = "${file("${path.module}/userdata.yaml")}"
  vars = {
    #proxy = "${var.proxy}"
  }

}

resource "vsphere_virtual_machine" "db" {
  name                       = "${var.hostname}"
  resource_pool_id           = "${data.vsphere_resource_pool.pool.id}"
  datastore_id               = "${data.vsphere_datastore.datastore.id}"
  num_cpus                   = "${var.cpu}"
  memory                     = "${var.memory}"
  guest_id                   = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type                  = "${data.vsphere_virtual_machine.template.scsi_type}"
  wait_for_guest_net_timeout = 0
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  cdrom {
    client_device = true
  }
  disk {
    label = "${var.disk_name}"
    size  = "${var.disk_size}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }

  extra_config = {
    "guestinfo.metadata"          = "${base64encode(data.template_file.metadata.rendered)}"
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = "${base64encode(data.template_file.userdata.rendered)}"
    "guestinfo.userdata.encoding" = "base64"
  }

}