#----------------------------
# AI PLATFORM NOTEBOOK MODULE
#----------------------------

resource "google_notebooks_instance" "instance" {

  name         = var.name
  location     = var.location
  machine_type = var.machine_type
  project      = var.project
  labels       = var.labels
  metadata     = var.metadata

  // ACCOUNT INFO
  instance_owners        = var.instance_owners
  service_account        = var.service_account
  service_account_scopes = var.service_account_scopes

  // GPU DRIVER
  install_gpu_driver = var.install_gpu_driver

  // VPC AND SUBNET
  network = var.network
  subnet  = var.subnet

  // BOOT DISK AND DATA DISK 
  boot_disk_type    = var.boot_disk_type
  boot_disk_size_gb = var.boot_disk_size_gb
  data_disk_type    = var.data_disk_type
  data_disk_size_gb = var.data_disk_size_gb

  // ONLY ALLOW NETWORK WITH PRIVATE IP
  no_public_ip = var.no_public_ip

  // IF TRUE FORCES TO USE SSH TUNNEL
  no_proxy_access = var.no_proxy_access

  vm_image {
    project      = var.vm_project
    image_family = var.image_family
    image_name   = var.image_name
  }

  // A SET OF SHIELDED INSTANCE OPTIONS
  // CHECK IF IMAGE SUPPORTS THIS OPTION
  shielded_instance_config {
    enable_integrity_monitoring = var.enable_integrity_monitoring
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = var.enable_vtpm
  }

  depends_on = [
    google_project_service.project
  ]
}

// ENABLE THE REQUIRED APIS
resource "google_project_service" "project" {

  for_each = toset(var.project_services)
  project  = var.project
  service  = each.value
}