#---------------------------
# PROJECT FACTORY VARIABLES
#---------------------------


// REQUIRED VARIABLES

variable "project_name" {
  description = "The name for the project"
  type        = string
  default     = ""
}

variable "org_id" {
  description = "The organization ID."
  type        = string
  default     = ""
}

variable "billing_account_id" {
  description = "The ID of the billing account to associate this project with"
  type        = string
  default     = ""
}


// OPTIONAL VARIABLES

variable "activate_apis" {
  description = "The list of apis to activate within the project"
  type        = list(string)
  default     = ["compute.googleapis.com"]
}

variable "auto_create_network" {
  description = "Create the default network"
  type        = bool
  default     = false
}

variable "create_project_sa" {
  description = "Whether the default service account for the project shall be created"
  type        = bool
  default     = true
}

variable "default_service_account" {
  description = "Project default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`."
  type        = string
  default     = "delete"
}

variable "disable_dependent_services" {
  description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed."
  type        = bool
  default     = true
}

variable "disable_services_on_destroy" {
  description = "Whether project services will be disabled when the resources are destroyed"
  type        = string
  default     = "true"
}

variable "folder_id" {
  description = "The ID of a folder to host this project"
  type        = string
  default     = ""
}

variable "group_name" {
  description = "A Google group to control the project by being assigned group_role (defaults to project viewer)"
  type        = string
  default     = ""
}

variable "group_role" {
  description = "The role to give the controlling group (group_name) over the project (defaults to project viewer)"
  type        = string
  default     = "roles/viewer"
}

variable "project_labels" {
  description = "Map of labels for project"
  type        = map(string)
  default     = {}
}

variable "lien" {
  description = "Add a lien on the project to prevent accidental deletion"
  type        = bool
  default     = false
}

variable "random_project_id" {
  description = "Adds a suffix of 4 random characters to the `project_id`"
  type        = bool
  default     = true
}