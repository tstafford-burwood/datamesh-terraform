#---------------------
# VPC ROUTES VARIABLES
#---------------------

variable "vpc_project_id" {
  description = "The ID of the project where the routes will be created"
}

variable "vpc_network_name" {
  description = "The name of the network where routes will be created"
}

variable "vpc_routes" {
  type        = list(map(string))
  description = "List of routes being created in this VPC"
  default     = []
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}