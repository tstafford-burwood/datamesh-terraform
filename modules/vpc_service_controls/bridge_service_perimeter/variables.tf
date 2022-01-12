#----------------------------------
# VPC SC BRIDGE PERIMETER VARIABLES
#----------------------------------

// REQUIRED VARIABLES

variable "bridge_service_perimeter_name" {
  description = "Name of the bridge perimeter. Should be one unified string. Must only be letters, numbers and underscores"
  type        = string
  default     = ""
}

variable "parent_policy_name" {
  description = "Name of the parent policy."
  type        = string
  default     = ""
}

variable "bridge_service_perimeter_resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
  default     = []
}

// OPTIONAL

variable "bridge_service_perimeter_description" {
  description = "Description of the bridge perimeter"
  type        = string
  default     = ""
}