# Copyright 2020 Hewlett Packard Enterprise Development LP

output "web_host_url" {
  value = "http://${var.web_ip_address}:5100"
}