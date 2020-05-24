# Copyright 2020 Hewlett Packard Enterprise Development LP
variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "template_username" {}
variable "template_password" {}

variable "datacenter" {
  description = "Specify the vmware datacenter"

}

variable "datastore" {
  description = "Specify the vmware datastore"

}

variable "resource_pool" {
  description = "Specify the resource pool"

}

variable "vm_cluster_name" {
  description = "Specify the cluster name"

}


variable "network" {
  description = "Specify the network"

}

variable "template" {
  description = "Specify Ubuntu1604 template having docker and docker compose installed"

}

variable "disk_name" {
  description = "Specify the disk name"

}

variable "disk_size" {

  description = "Specify the disk size"

}

variable "cpu" {

  description = "Specify the number of CPUs"

}

variable "memory" {

  description = "Specify the memory size in MB"

}

variable "dhcp" {
  description = "set it to true if environment using DHCP"
}

variable "web_ip_address" {
  description = "IP address of WEB server"
}

variable "netmask" {
  description = "Netmask"
}

variable "gateway" {
  description = "Gateway"
}

variable "nameservers" {
  description = "list of name servers"
}

variable "web_hostname" {
  description = "A prefix for the virtual machine name."
}

variable "app_ip_address" {
  description = "IP address of App server"
}

#variable "app_instance_id" {
#  description = "Workaround to avoid web instance creation before api instance. This variable will be updated after api instance is created"
#}

#variable proxy {
#  type        = "string"
#  description = "Proxy server IP address with port"
#}