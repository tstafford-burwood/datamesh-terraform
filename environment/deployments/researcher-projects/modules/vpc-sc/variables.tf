variable "environment" {

}

variable "prefix" {
  type    = string
  default = "test"
}

variable "cloudbuild_service_account" {
  description = "Cloud Build Service Account"
  type        = string
}

variable "imaging_project_number" {
  type = string
}

variable "data_ingress_project_number" {
  type = string
}

variable "data_ops_project_number" {
  description = "Project number for data ops project"
  type        = string
}

variable "data_lake_project_number" {
  type = string
}

variable "workspace_project_number" {
  type = string
}

variable "egress_project_number" {
  type = string
}

variable "tf_state_bucket" {
  description = "Bucket that holds terraform state"
  type        = string
}

variable "access_policy_id" {
  description = "Access Policy ID"
  type        = string
}

variable "serviceaccount_access_level_name" {
  description = "Name of the Access Context for the Service Accounts"
  type        = string
}

variable "admin_access_level_name" {
  type    = string
  default = ""
}

variable "stewards_access_level_name" {
  type    = string
  default = ""
}

variable "notebook_sa_email" {
  default = ""
}

variable "researcher_workspace_name" {
  description = "Variable represents the GCP folder to place resource into and is used to separate tfstate. GCP Folder MUST pre-exist."
  type        = string
  default     = "workspace-1"
}

variable "external_users_vpc" {
  description = "List of individual external user ids to be added to the VPC Service Control Perimeter to allow access to bucket in Egress project. Each account must be prefixed as `user:foo@bar.com`. Groups are not allowed to a VPC SC."
  type        = list(string)
  default     = []
}