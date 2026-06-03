variable "vm_name" {
  type        = string
  description = "Name of the virtual machine"
}

variable "zone" {
  type        = string
  description = "Availability zone for the VM"
}

variable "platform_id" {
  type        = string
  description = "Platform ID for the VM"
  default     = "standard-v3"
}

variable "cores" {
  type        = number
  description = "Number of CPU cores"
}

variable "memory" {
  type        = number
  description = "Amount of RAM in GB"
}

variable "image_id" {
  type        = string
  description = "Boot image ID"
}

variable "boot_disk_size" {
  type        = number
  description = "Boot disk size in GB"
  default     = 10
}

variable "boot_disk_type" {
  type        = string
  description = "Boot disk type"
  default     = "network-hdd"
}

variable "disk_size" {
  type        = number
  description = "Additional disk size in GB"
}

variable "disk_type" {
  type        = string
  description = "Additional disk type"
  default     = "network-hdd"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for network interface"
}

variable "ssh_user" {
  type        = string
  description = "SSH username"
  default     = "ubuntu"
}

variable "ssh_key" {
  type        = string
  description = "SSH public key"
  sensitive   = true
}

variable "preemptible" {
  type        = bool
  description = "Enable preemptible VM"
  default     = false
}