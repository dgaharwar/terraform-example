# Copyright 2020 Hewlett Packard Enterprise Development LP

variable "cloudPassword" {}

variable "cloudUserName" {}

variable "cloudIP" {}

variable "DatabaseInstanceName" {
  default = "win-Database"
}
variable "DatabaseInstanceIPAddress" {
  default = "172.16.83.35"
}

variable "netmaskDatabaseServer" {
  default = "24"
}

variable "gatewayDatabaseServer" {
  default = "172.16.83.1"
}

variable "WebInstanceName" {
  default = "win-Web"
}
variable "WebInstanceIPAddress" {
  default = "172.16.83.36"
}

variable "netmaskWebServer" {
  default = "24"
}

variable "gatewayWebServer" {
  default = "172.16.83.1"
}

variable "template" {
  default = "Windows2012"
}

variable "nameservers" {
  default = "8.8.8.8"
}

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
                name = "3PAR-Shared2"
                datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "VMResourcePool"
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
                name = "vxw-dvs-53-virtualwire-100-sid-5000-Black-Network-1"
                datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


resource "vsphere_virtual_machine" "db" {
  name                       = "${var.DatabaseInstanceName}"
  resource_pool_id           = "${data.vsphere_resource_pool.pool.id}"
  datastore_id               = "${data.vsphere_datastore.datastore.id}"
  num_cpus                   = 4
  memory                     = 8192
  guest_id                   = "${data.vsphere_virtual_machine.template.guest_id}"
  wait_for_guest_net_timeout = 0
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  cdrom {
    client_device = true
  }
  disk {
    label = "root"
    size  = 100
  }
/*
  provisioner "file" {
    source = "wordpress.ps1"
    destination = "C:\\Users\\Administrator"
    connection {
      type = "winrm"
      host = "${var.WebInstanceIPAddress}"
      user = "${var.TemplateUserName}"
      password = "${var.TemplatePassword}"
    }
  }
*/
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize{
      network_interface{
        ipv4_address = "${var.DatabaseInstanceIPAddress}"
        ipv4_netmask = "${var.netmaskDatabaseServer}"
       }
      ipv4_gateway = "${var.gatewayDatabaseServer}"
      windows_options{
        computer_name = "Database"
        admin_password = "Pa$$w0rd" 
      }
  }

  }

}


resource "vsphere_virtual_machine" "web" {
  depends_on                 = ["vsphere_virtual_machine.db"]
  name                       = "${var.WebInstanceName}"
  resource_pool_id           = "${data.vsphere_resource_pool.pool.id}"
  datastore_id               = "${data.vsphere_datastore.datastore.id}"
  num_cpus                   = 4
  memory                     = 4096
  guest_id                   = "${data.vsphere_virtual_machine.template.guest_id}"
  wait_for_guest_net_timeout = 0
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"
/* 
 provisioner "file" {
    source = "wordpress.ps1"
    destination = "C:\\Users\\Administrator"
    connection {
      type = "winrm"
      host = "${var.WebInstanceIPAddress}"
      user = "${var.TemplateUserName}"
      password = "${var.TemplatePassword}"
    } 
  }

  provisioner "remote-exec" {
    script = "wordpress.ps1"
    connection {
      type = "winrm"
      host = "${var.WebInstanceIPAddress}"
      user = "${var.TemplateUserName}"
      password = "${var.TemplatePassword}"
    }
    interpreter = ["PowerShell"]
*/
  }
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  cdrom {
    client_device = true
  }
  disk {
    label = "root"
    size  = 100
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
   customize{
      network_interface{
        ipv4_address = "${var.WebInstanceIPAddress}"
        ipv4_netmask = "${var.netmaskWebServer}"
       }
      ipv4_gateway = "${var.gatewayWebServer}"
      windows_options{
        computer_name = "Database"
        admin_password = "Pa$$w0rd"
      }
  }
  }

}
