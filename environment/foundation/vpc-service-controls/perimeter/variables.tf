
variable "access_levels" {
  description = "List of access levels allowed in service perimeter"
  type        = list(string)
  default     = []
}

variable "data_ingress_project_numbers" {
  description = "List of data data ingress project numbers"
  type        = list(string)
  default     = []
}

variable "data_ingress_project_number" {
  description = "List of data data ingress project numbers"
  type        = string
  default     = ""
}

variable "data_ops_egress_project_numbers" {
  description = "List of data ops egress project numbers"
  type        = list(string)
  default     = []
}

variable "env_name_dev" {
  description = "Name of development environment to append to triggers"
  type        = string
  default     = "dev"
}

variable "env_name_prod" {
  description = "Name of production environment to append to triggers"
  type        = string
  default     = "prod"
}


variable "restricted_services" {
  description = "GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions."
  type        = list(string)
  default     = []
}

variable "resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
  default     = []
}

variable "scp_perimeter_projects" {
  description = "List of projects in scp perimeter"
  type        = list(string)
  default     = []
}

variable "terraform_foundation_state_prefix" {
  description = "The name of the prefix to create in the state bucket. This will end up creating additional sub-directories to store state files in an orderly fashion. The additional sub-directories are generally created as a declaration inside of the Cloud Build YAML file of each pipeline."
  type        = string
  default     = "foundation"
}

variable "vpc_accessible_services" {
  description = "Accessible services from VPC Perimeter"
  type        = list(string)
  default     = []
}
