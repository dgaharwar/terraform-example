# Copyright 2020 Hewlett Packard Enterprise Development LP
variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}

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

/*variable "disk_size" {

  description = "Specify the disk size"

}*/

/*variable "cpu" {

  description = "Specify the number of CPUs"

}*/

/*variable "memory" {

  description = "Specify the memory size in MB"

}*/

variable dhcp {
  description = "set it to true if environment using DHCP"
}

variable db_ip_address {
  description = "IP address of DB server"
}

variable netmask {
  description = "Netmask"
}

variable gateway {
  description = "Gateway"
}

variable nameservers {
  description = "list of name servers"
}

variable db_hostname {
  description = "A prefix for the virtual machine name."
}

#variable proxy {
#  type        = "string"
#  description = "Proxy server IP address with port"
#}