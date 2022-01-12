#-----------------------------------
# VPC SC REGULAR PERIMETER VARIABLES
#-----------------------------------

// REQUIRED VARIALBES

variable "regular_service_perimeter_description" {
  description = "Description of the regular perimeter"
  type        = string
  default     = ""
}

variable "regular_service_perimeter_name" {
  description = "Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores"
  type        = string
  default     = ""
}

variable "parent_policy_id" {
  description = "ID of the parent policy"
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "access_level_names" {
  description = "A list of Access Level resource names that allow resources within the Service Perimeter to be accessed from the internet. Access Levels listed must be in the same policy as this Service Perimeter. Referencing a nonexistent Access Level is a syntax error. If no Access Level names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY_POLICY/accessLevels/MY_LEVEL'. For Service Perimeter Bridge, must be empty."
  type        = list(string)
  default     = []
}

variable "project_to_add_perimeter" {
  description = "A list of GCP resources (only projects) that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
  default     = []
}

variable "restricted_services" {
  description = "GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions."
  type        = list(string)
  default     = []
}

variable "enable_restriction" {
  description = "Whether to restrict API calls within the Service Perimeter to the list of APIs specified in 'allowed_services'. This can be useful if only certain APIs should be allowed to be accessed from a network within the VPC service control perimeter."
  type        = bool
  default     = false
}

variable "allowed_services" {
  description = "The list of APIs usable within the Service Perimeter from a VPC network within the perimeter. Must be empty unless 'enable_restriction' is True."
  type        = list(string)
  default     = []
}

variable "egress_policies" {
  description = "	A list of all egress policies, each list object has a from and to value that describes egress_from and egress_to."
  type = list(object({
    from = any
    to   = any
  }))
  default = []
}