#----------------------------
# AI PLATFORM NOTEBOOK MODULE
#----------------------------

variable "name" {
  description = "The name specified for the Notebook instance."
  type        = string
  default     = ""
}

variable "machine_type" {
  description = "A reference to a machine type which defines VM kind"
  type        = string
  default     = ""
}

variable "location" {
  description = "A reference to the zone where the machine resides"
  type        = string
  default     = ""
}

variable "network" {
  description = "The name of the VP that the instance is in. Format: projects/{project_id}/global/networks/{network_id}"
  type        = string
  default     = ""
}

variable "project" {
  description = "The ID of the project in which the resource belongs."
  type        = string
  default     = ""
}

variable "subnet" {
  description = "The name of the subnet that this instance is in. Format: projects/{project_id}/regions/{region}/subnetworks/{subnetwork_id}"
  type        = string
  default     = ""
}

variable "instance_owners" {
  description = "The list of owners of this instance after creation. Format: alias@example.com. Currently supports one owner only."
  type        = list
  default     = []
}

variable "service_account" {
  description = "The service account on this instance, giving access to other Google Cloud services. If not specified, the Compute Engine default service account is used."
  type        = string
  default     = null
}

variable "service_account_scopes" {
  description = "The URIs of service account scopes to be included in Compute Engine instances. If not specified, the following scopes are defined:"
  type        = list
  default     = []
}

variable "nic_type" {
  description = "The type of vNIC driver. Possible values are `UNSPECIFIED_NIC_TYPE`, `VIRTIO_NET`, and `GVNIC`."
  type        = string
  default     = "VIRTIO_NET"
}

variable "install_gpu_driver" {
  description = "Whether the end user authorizes Google Cloud to install GPU driver on this instance. Only applicable to instances with GPUs."
  type        = bool
  default     = false
}

variable "boot_disk_type" {
  description = "Possible disk types for notebook instances. Possible values are `DISK_TYPE_UNSPECIFIED`, `PD_STANDARD`, `PD_SSD`, and `PD_BALANCED`."
  type        = string
  default     = "PD_STANDARD"
}

variable "boot_disk_size_gb" {
  description = "The size of the boot disk in GB attached to this instance, up to a maximum of 64000 GB (64 TB). The minimum recommended value is 100 GB. If not specified, this defaults to 100."
  type        = number
  default     = 100
}

variable "data_disk_type" {
  description = "Possible disk types for notebook instances. Possible values are `DISK_TYPE_UNSPECIFIED`, `PD_STANDARD`, `PD_SSD`, and `PD_BALANCED`."
  type        = string
  default     = null
}

variable "data_disk_size_gb" {
  description = "The size of the data disk in GB attached to this instance, up to a maximum of 64000 GB (64 TB). You can choose the size of the data disk based on how big your notebooks and data are. If not specified, this defaults to 100."
  type        = number
  default     = 100
}

variable "no_public_ip" {
  description = "No public IP will be assigned to this instance."
  type        = bool
  default     = true
}

variable "no_proxy_access" {
  description = "The notebook instance will not register with the proxy."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels to apply to this instance"
  type        = map
  default     = {}
}

variable "metadata" {
  description = <<EOT
Additional metadata key/values that can be used:
proxy-mode                 = "mail"
proxy-user-mail            = "alice@example.com"
notebook-disable-root      = "true"
notebook-disable-downloads = "true"
notebook-disable-nbconvert = "true"
serial-port-enable         = "FALSE"
block-project-ssh-keys     = "TRUE"
EOT

  type    = map
  default = {}
}

variable "enable_integrity_monitoring" {
  description = "Defines whether the instance has integrity monitoring enabled."
  type        = bool
  default     = false
}

variable "enable_secure_boot" {
  description = "Defines whether the instance has Secure Boot enabled."
  type        = bool
  default     = false
}

variable "enable_vtpm" {
  description = "Defines whether the instance has the vTPM enabled."
  type        = bool
  default     = false
}

variable "vm_project" {
  description = "The name of the Google Cloud project that this VM image belongs to. Format: projects/{project_id}"
  type        = string
}

variable "image_family" {
  description = "Use this VM image family to find the image; the newest image in this family will be used."
  type        = string
}

variable "image_name" {
  description = "Use VM image name to find the image"
  type        = string
  default     = null
}

variable "consume_reservation_type" {
  description = "The type of Compute Reservation. Possible values are `NO_RESERVATION`, `ANY_RESERVATION`, and `SPECIFIC_RESERVATION`."
  type        = string
  default     = "NO_RESERVATION"
}

variable "project_services" {
  description = "List of Service APIs to enable on the project"
  type        = list(string)
  default     = ["notebooks.googleapis.com", "ml.googleapis.com"]
}