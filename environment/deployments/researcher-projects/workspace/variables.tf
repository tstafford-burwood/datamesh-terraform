variable "billing_account" {
  description = "Google Billing Account ID"
  type        = string
}

variable "researcher_workspace_name" {
  description = "Variable represents the GCP folder NAME to place resource into and is used to separate tfstate. GCP Folder MUST pre-exist."
  type        = string
  default     = "workspace-1"
}

variable "region" {
  description = "The default region to place resources."
  type        = string
  default     = "us-central1"
}

variable "project_admins" {
  description = "Name of the Google Group for admin level access."
  type        = list(string)
}

variable "num_instances" {
  description = "Number of instances to create."
  type        = number
  default     = 0
}

variable "instance_machine_type" {
  description = "The machine type to create. For example `n2-standard-2`."
  type        = string
  default     = "n2-standard-2"
}

variable "vm_disk_size" {
  description = "How big of an OS disk size to attach to instance."
  type        = number
  default     = 100
}

variable "instance_name" {
  description = "A unique name for the resource, required by GCE. Changing this forces a new resource to be created."
  type        = string
  default     = "deep-learning-vm"
}

variable "instance_tags" {
  description = "A list of network tags to attach to the instance."
  type        = list(string)
  default     = ["deep-learning-vm", "jupyter-notebook"]
}

variable "set_disable_sa_create" {
  description = "Enable the Disable Service Account Creation policy"
  type        = bool
  default     = true
}

variable "set_vm_os_login" {
  description = "Enable the requirement for OS login for VMs"
  type        = bool
  default     = true
}

variable "metadata" {
  description = "Key/value pairs made available to instance. Default is to turn off serial port."
  default = {
    serial-port-enable = false
  }
}

variable "force_destroy" {
  default = true
}

variable "zone" {
  type        = string
  description = "Zone where the instances should be created. If not specified, instances will be spread across available zones in the region."
  default     = null
}

variable "researchers" {
  description = "The list of users who get their own managed notebook. Do not pre-append with `user`."
  type        = list(string)
  default     = []
}

variable "data_stewards" {
  description = "List of or users of data stewards for this research initiative. Grants access to initiative bucket in `data-ingress`, `data-ops`. Prefix with `user:foo@bar.com`. DO NOT INCLUDE GROUPS, breaks the VPC Perimeter."
  type        = list(string)
  default     = []
}

variable "stewards_project_iam_roles" {
  description = "The IAM role(s) to assign to the `Data Stewards` at the defined project."
  type        = list(string)
  default = [
    "roles/container.clusterViewer", # Provides access to get and list GKE clusters - used to view Composer Environemtn
    "roles/composer.user",
    "roles/monitoring.viewer", # read-only access to get and list info about all monitoring data
    "roles/logging.viewer",    # see longs from within Cloud Composer
    "roles/dlp.admin",
    "roles/integrations.integrationInvoker", # Can invoke (run) integrations,
    "roles/integrations.integrationAdmin",   # Full access to all Application Integration resources
    "roles/integrations.suspensionResolver", # A role that can resolve suspended integrations. 
  ]
}

variable "set_trustedimage_project_policy" {
  description = "Apply org policy to set the trusted image projects. {{UIMeta group=0 order=18 updatesafe }}"
  type        = bool
  default     = true
}

variable "golden_image_version" {
  description = "Retrieves the specific custom image version from the image project."
  type        = string
}

#--------------------------------------
# PROJECT LABELS
#--------------------------------------
variable "lbl_department" {
  description = "labels."
  type        = string
}

variable "snapshot_max_retention_days" {
  description = "Snapshot max retention days."
  type        = number
  default     = "7"
}

variable "snapshot_days_in_cycle" {
  description = "Snapshot cycle days."
  type        = number
  default     = "1"

}

variable "snapshot_start_time" {
  description = "snapshot start time."
  type        = string
  default     = "04:00"

}
