# Copyright 2020 Hewlett Packard Enterprise Development LP

variable "cloudPassword" {}

variable "instanceNameDatabase" {}
variable "instanceIPAddressDatabase" {}

variable "nameservers" {}

variable "netmaskDatabaseServer" {}

variable "gatewayDatabaseServer" {}

provider "vsphere" {
                user = "raja@gemini.loc"
                password = "${var.cloudPassword}"
                vsphere_server = "172.20.21.13"
                version = "~> 1.11"
                # if you have a self-signed cert
                allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
                name = "Datacenter1"
}

data "vsphere_datastore" "datastore" {
                name = "3PAR_A64G-10TB-C3-01"
                datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "VMResourcePool1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


data "vsphere_compute_cluster" "cluster" {
name = "Cluster1"
datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "eshopterraform"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
                name = "vxw-dvs-693-virtualwire-5-sid-5001-Green-Net"
                datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data template_file "metadata" {
  template = "${file("${path.module}/metadata.yaml")}"
  vars = {
    dhcp        = "false"
    db_hostname    = "${var.instanceNameDatabase}"
    db_ip_address  = "${var.instanceIPAddressDatabase}"
    netmask     = "${var.netmaskDatabaseServer}"
    nameservers = "${jsonencode(var.nameservers)}"
    gateway     = "${var.gatewayDatabaseServer}"
  }
}

data template_file "userdata" {
  template = "${file("${path.module}/userdata.yaml")}"
  vars = {
    nameservers = "${jsonencode(var.nameservers)}"
  }

}

resource "vsphere_virtual_machine" "db" {
  name                       = "${var.instanceNameDatabase}"
  resource_pool_id           = "${data.vsphere_resource_pool.pool.id}"
  datastore_id               = "${data.vsphere_datastore.datastore.id}"
  num_cpus                   = 4
  memory                     = 16384
  guest_id                   = "${data.vsphere_virtual_machine.template.guest_id}"
  wait_for_guest_net_timeout = 0
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  cdrom {
    client_device = true
  }
  disk {
    label = "root"
    size  = 60
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