# Copyright 2020 Hewlett Packard Enterprise Development LP

variable "cloudPassword" {
  default = "Hpinvent@123"
  }

variable "cloudUserName" {
  default = "Administrator@vsphere.local"
  }

variable "cloudIP" {
  default = "10.202.40.204"
  }

variable "DatabaseInstanceName" {
  default = "eShopDatabase"
}
variable "DatabaseInstanceIPAddress" {
  default = "10.70.50.10"
}

variable "netmaskDatabaseServer" {
  default = "16"
}

variable "gatewayDatabaseServer" {
  default = "10.70.0.1"
}
variable "AppInstanceName" {
  default = "eShopApp"
}
variable "AppInstanceIPAddress" {
  default = "10.70.50.11"
}

variable "netmaskAppServer" {
  default = "16"
}

variable "gatewayAppServer" {
  default = "10.70.0.1"
}

variable "WebInstanceName" {
  default = "eShopWeb"
}
variable "WebInstanceIPAddress" {
  default = "10.70.50.12"
}

variable "netmaskWebServer" {
  default = "16"
}

variable "gatewayWebServer" {
  default = "10.70.0.1"
}

variable "template" {
  default = "eshopterraform"
}

variable "nameservers" {}

variable "TemplateUserName" {}

variable "TemplatePassword" {}

provider "vsphere" {
                user = "${var.cloudUserName}"
                password = "${var.cloudPassword}"
                vsphere_server = "${var.cloudIP}"
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
  name          = "${var.template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
                name = "vxw-dvs-693-virtualwire-5-sid-5001-Green-Net"
                datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data template_file "db_metadata" {
  template = "${file("db_metadata.yaml")}"
  vars = {
    dhcp        = "false"
    db_hostname    = "${var.DatabaseInstanceName}"
    db_ip_address  = "${var.DatabaseInstanceIPAddress}"
    netmask     = "${var.netmaskDatabaseServer}"
    nameservers = "${jsonencode(var.nameservers)}"
    gateway     = "${var.gatewayDatabaseServer}"
  }
}

data template_file "db_userdata" {
  template = "${file("db_userdata.yaml")}"
  vars = {
    nameservers = "${jsonencode(var.nameservers)}"
  }

}

resource "vsphere_virtual_machine" "db" {
  name                       = "${var.DatabaseInstanceName}"
  resource_pool_id           = "${data.vsphere_resource_pool.pool.id}"
  datastore_id               = "${data.vsphere_datastore.datastore.id}"
  num_cpus                   = 2
  memory                     = 8192
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
    "guestinfo.metadata"          = "${base64encode(data.template_file.db_metadata.rendered)}"
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = "${base64encode(data.template_file.db_userdata.rendered)}"
    "guestinfo.userdata.encoding" = "base64"
  }

}

data template_file "app_metadata" {
  template = "${file("app_metadata.yaml")}"
  vars = {
    dhcp        = "false"
    app_hostname    = "${var.AppInstanceName}"
    app_ip_address  = "${var.AppInstanceIPAddress}"
    netmask     = "${var.netmaskAppServer}"
    nameservers = "${jsonencode(var.nameservers)}"
    gateway     = "${var.gatewayAppServer}"
  }
}

data template_file "app_userdata" {
  template = "${file("app_userdata.yaml")}"
  vars = {
    app_ip_address        = "${var.AppInstanceIPAddress}"
    db_ip_address     = "${var.DatabaseInstanceIPAddress}"
    web_ip_address    = "${var.WebInstanceIPAddress}"
    template_username = "${var.TemplateUserName}"
    template_password = "${var.TemplatePassword}"
    nameservers = "${jsonencode(var.nameservers)}"
  }

}

resource "vsphere_virtual_machine" "app" {
  depends_on                 = ["vsphere_virtual_machine.db"]
  name                       = "${var.AppInstanceName}"
  resource_pool_id           = "${data.vsphere_resource_pool.pool.id}"
  datastore_id               = "${data.vsphere_datastore.datastore.id}"
  num_cpus                   = 4
  memory                     = 8192
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
    "guestinfo.metadata"          = "${base64encode(data.template_file.app_metadata.rendered)}"
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = "${base64encode(data.template_file.app_userdata.rendered)}"
    "guestinfo.userdata.encoding" = "base64"
  }

}

data template_file "web_metadata" {
  template = "${file("web_metadata.yaml")}"
  vars = {
    dhcp        = "false"
    web_hostname    = "${var.WebInstanceName}"
    web_ip_address  = "${var.WebInstanceIPAddress}"
    netmask     = "${var.netmaskWebServer}"
    nameservers = "${jsonencode(var.nameservers)}"
    gateway     = "${var.gatewayWebServer}"
  }
}

data template_file "web_userdata" {
  template = "${file("web_userdata.yaml")}"
  vars = {
    web_ip_address        = "${var.WebInstanceIPAddress}"
    app_ip_address    = "${var.AppInstanceIPAddress}"
    template_username = "${var.TemplateUserName}"
    template_password = "${var.TemplatePassword}"
    nameservers       = "${jsonencode(var.nameservers)}"
  }

}

resource "vsphere_virtual_machine" "web" {
  depends_on                 = ["vsphere_virtual_machine.app"]
  name                       = "${var.WebInstanceName}"
  resource_pool_id           = "${data.vsphere_resource_pool.pool.id}"
  datastore_id               = "${data.vsphere_datastore.datastore.id}"
  num_cpus                   = 4
  memory                     = 4096
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
    "guestinfo.metadata"          = "${base64encode(data.template_file.web_metadata.rendered)}"
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = "${base64encode(data.template_file.web_userdata.rendered)}"
    "guestinfo.userdata.encoding" = "base64"
  }

}
