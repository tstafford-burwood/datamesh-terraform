variable "bastion_project_numbers" {
  description = "List of GCP bastion project numbers"
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
