# Copyright 2020 Hewlett Packard Enterprise Development LP
output "web_host_url" {
  value = "http://${var.WebInstanceIPAddress}:5100"
}