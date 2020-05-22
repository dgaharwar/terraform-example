# Copyright 2020 Hewlett Packard Enterprise Development LP
variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "template_username" {}
variable "template_password" {}


variable "db_ip_address" {
  type        = "string"
  default     = "172.16.20.110"
  description = "IP address of DB server"


}

variable "db_hostname" {
  type    = "string"
  default = "eshop-database"

  description = "A prefix for the virtual machine name."
}

variable "app_ip_address" {
  type        = "string"
  default     = "172.16.20.111"
  description = "IP address of APP server"

}

variable "app_hostname" {
  type    = "string"
  default = "eshop-app"

  description = "A prefix for the virtual machine name."
}

variable "web_ip_address" {
  type        = "string"
  default     = "172.16.20.112"
  description = "IP address of WEB server"

}

variable "web_hostname" {
  type    = "string"
  default = "eshop-app"

  description = "A prefix for the virtual machine name."
}

variable "datacenter" {
  type        = "string"
  description = "Specify the vmware datacenter"
  default     = "Datacenter1"

}

variable "datastore" {
  type        = "string"
  description = "Specify the vmware datastore"
  default     = "3PAR_A64G-10TB-C3-01"

}

variable "resource_pool" {
  type        = "string"
  description = "Specify the resource pool"
  default     = "VMResourcePool1"


}

variable "vm_cluster_name" {
  type        = "string"
  description = "Specify the cluster name"
  default     = "Cluster1"


}


variable "network" {
  type        = "string"
  description = "Specify the network"
  default     = "vxw-dvs-693-virtualwire-5-sid-5001-Green-Net"


}

variable "template" {
  type        = "string"
  description = "Specify Ubuntu1604 template having docker and docker compose installed"
  default     = "eshopterraform"


}

variable "disk_name" {
  type        = "string"
  description = "Specify the disk name"
  default     = "root"


}

variable "disk_size" {

  description = "Specify the disk size"
  default     = 60


}

variable "cpu" {

  description = "Specify the number of CPUs"
  default     = "4"


}

variable "memory" {

  description = "Specify the memory size in MB"
  default     = "16384"


}

variable "dhcp" {
  type        = "string"
  default     = "false"
  description = "set it to true if environment using DHCP"
}

variable "netmask" {
  type    = "string"
  default = "24"

  description = "Netmask"
}

variable "gateway" {
  type    = "string"
  default = "172.16.20.1"

  description = "Gateway"
}

variable "nameservers" {
  type        = "list"
  default     = []
  description = "list of name servers"
}

#variable proxy {
#  type        = "string"
#  default     = "16.85.88.10:8080"
#  description = "Proxy server IP address with port"
#}