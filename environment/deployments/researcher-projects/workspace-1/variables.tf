variable "billing_account" {
  description = "Google Billing Account ID"
  type        = string
}

variable "region" {
  description = "The default region to place resources."
  type        = string
  default     = "us-central1"
}

variable "researcher_workspace_name" {
  description = "Variable represents the GCP folder NAME to place resource into and is used to separate tfstate. GCP Folder MUST pre-exist."
  type        = string
  default     = "workspace-1"
}

variable "set_vm_os_login" {
  description = "Enable the requirement for OS login for VMs"
  type        = bool
  default     = true
}

variable "set_disable_sa_create" {
  description = "Enable the Disable Service Account Creation policy"
  type        = bool
  default     = true
}