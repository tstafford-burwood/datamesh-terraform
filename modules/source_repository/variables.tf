#-----------------------------------------
# GOOGLE CLOUD SOURCE REPOSITORY VARIABLES
#-----------------------------------------

variable "cloud_source_repo_name" {
  description = "Resource name of the repository, of the form {{repo}}. The repo name may contain slashes. eg, name/with/slash."
  type        = string
  default     = ""
}

variable "cloud_source_repo_project_id" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
  default     = ""
}