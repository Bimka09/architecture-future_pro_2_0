output "vm_id" {
  description = "ID of the virtual machine"
  value       = yandex_compute_instance.vm.id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = yandex_compute_instance.vm.name
}

output "internal_ip_address" {
  description = "Internal IP address of the VM"
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "external_ip_address" {
  description = "External NAT IP address of the VM"
  value       = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "fqdn" {
  description = "FQDN of the VM"
  value       = yandex_compute_instance.vm.fqdn
}

output "additional_disk_id" {
  description = "ID of the additional attached disk"
  value       = yandex_compute_disk.additional_disk.id
}

output "additional_disk_name" {
  description = "Name of the additional disk"
  value       = yandex_compute_disk.additional_disk.name
}