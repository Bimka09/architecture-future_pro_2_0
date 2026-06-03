module "vm" {
  source = "../../modules/vm"

  vm_name = var.vm_name

  zone = var.zone

  platform_id = var.platform_id

  cores = var.cores
  memory = var.memory

  image_id = var.image_id

  boot_disk_size = var.boot_disk_size
  boot_disk_type = var.boot_disk_type

  disk_size = var.disk_size
  disk_type = var.disk_type

  subnet_id = var.subnet_id

  ssh_user = var.ssh_user
  ssh_key  = var.ssh_key

  preemptible = var.preemptible
}