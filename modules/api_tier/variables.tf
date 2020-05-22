# Copyright 2020 Hewlett Packard Enterprise Development LP
variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "template_username" {}
variable "template_password" {}

variable "datacenter" {
  type        = "string"
  description = "Specify the vmware datacenter"

}

variable "datastore" {
  type        = "string"
  description = "Specify the vmware datastore"

}

variable "resource_pool" {
  type        = "string"
  description = "Specify the resource pool"

}

variable "vm_cluster_name" {
  type        = "string"
  description = "Specify the cluster name"

}


variable "network" {
  type        = "string"
  description = "Specify the network"

}

variable "template" {
  type        = "string"
  description = "Specify Ubuntu1604 template having docker and docker compose installed"

}

variable "disk_name" {
  type        = "string"
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
  type        = "string"
  description = "set it to true if environment using DHCP"
}

variable "ip_address" {
  type        = "string"
  description = "IP address of DB server"
}

variable "netmask" {
  type        = "string"
  description = "Netmask"
}

variable "gateway" {
  type        = "string"
  description = "Gateway"
}

variable "nameservers" {
  type        = "list"
  description = "list of name servers"
}

variable "hostname" {
  type        = "string"
  description = "A prefix for the virtual machine name."
}

variable "db_ip_address" {
  type        = "string"
  description = "IP address of DB server"
}

variable "web_ip_address" {
  type        = "string"
  description = "IP address of Web server"
}

variable "db_instance_id" {
  type        = "string"
  description = "Workaround to avoid api instance creation before db instance. This variable will be updated after db instance is created"
}

#variable "proxy" {
#  type        = "string"
#  description = "Proxy server IP address with port"
#}