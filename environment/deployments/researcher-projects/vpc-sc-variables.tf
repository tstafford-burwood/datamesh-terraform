#-------------------------------------------------------
# VPC SC RESEARCHER GROUP MEMBER ACCESS LEVELS VARIABLES
#-------------------------------------------------------

// REQUIRED VARIABLES

variable "access_level_name" {
  description = "Description of the AccessLevel and its use. Does not affect behavior."
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES - NON PREMIUM

variable "combining_function" {
  description = "How the conditions list should be combined to determine if a request is granted this AccessLevel. If AND is used, each Condition must be satisfied for the AccessLevel to be applied. If OR is used, at least one Condition must be satisfied for the AccessLevel to be applied."
  type        = string
  default     = "AND"
}

variable "access_level_description" {
  description = "Description of the access level."
  type        = string
  default     = ""
}

variable "ip_subnetworks" {
  description = "Condition - A list of CIDR block IP subnetwork specifications. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, \"192.0.2.0/24\" is accepted but \"192.0.2.1/24\" is not. Similarly, for IPv6, \"2001:db8::/32\" is accepted whereas \"2001:db8::1/32\" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed."
  type        = list(string)
  default     = []
}

variable "access_level_members" {
  description = "Condition - An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
  default     = []
}

variable "negate" {
  description = "Whether to negate the Condition. If true, the Condition becomes a NAND over its non-empty fields, each field must be false for the Condition overall to be satisfied."
  type        = bool
  default     = false
}

variable "regions" {
  description = "Condition - The request must originate from one of the provided countries/regions. Format: A valid ISO 3166-1 alpha-2 code."
  type        = list(string)
  default     = []
}

variable "required_access_levels" {
  description = "Condition - A list of other access levels defined in the same Policy, referenced by resource name. Referencing an AccessLevel which does not exist is an error. All access levels listed must be granted for the Condition to be true."
  type        = list(string)
  default     = []
}

// OPTIONAL VARIABLES - DEVICE POLICY (PREMIUM FEATURE)

variable "allowed_device_management_levels" {
  description = "Condition - A list of allowed device management levels. An empty list allows all management levels."
  type        = list(string)
  default     = []
}

variable "allowed_encryption_statuses" {
  description = "Condition - A list of allowed encryption statuses. An empty list allows all statuses."
  type        = list(string)
  default     = []
}

variable "minimum_version" {
  description = "The minimum allowed OS version. If not set, any version of this OS satisfies the constraint. Format: \"major.minor.patch\" such as \"10.5.301\", \"9.2.1\"."
  type        = string
  default     = ""
}

variable "os_type" {
  description = "The operating system type of the device."
  type        = string
  default     = "OS_UNSPECIFIED"
}

variable "require_corp_owned" {
  description = "Condition - Whether the device needs to be corp owned."
  type        = bool
  default     = false
}

variable "require_screen_lock" {
  description = "Condition - Whether or not screenlock is required for the DevicePolicy to be true."
  type        = bool
  default     = false
}

#---------------------------------------------------------------------
# RESEARCHER WORKSPACE VPC SERVICE CONTROL REGULAR PERIMETER VARIABLES
#---------------------------------------------------------------------

// REQUIRED VARIALBES

variable "researcher_workspace_regular_service_perimeter_description" {
  description = "Description of the regular perimeter"
  type        = string
  default     = ""
}

variable "researcher_workspace_regular_service_perimeter_name" {
  description = "Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores"
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES


variable "researcher_workspace_regular_service_perimeter_restricted_services" {
  description = "GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions."
  type        = list(string)
  default     = []
}

variable "researcher_workspace_regular_service_perimeter_enable_restriction" {
  description = "Whether to restrict API calls within the Service Perimeter to the list of APIs specified in 'allowed_services'. This can be useful if only certain APIs should be allowed to be accessed from a network within the VPC service control perimeter."
  type        = bool
  default     = false
}

variable "researcher_workspace_regular_service_perimeter_allowed_services" {
  description = "The list of APIs usable within the Service Perimeter from a VPC network within the perimeter. Must be empty unless 'enable_restriction' is True."
  type        = list(string)
  default     = []
}

variable "researcher_workspace_regular_service_perimeter_egress_policies_identities" {
  description = "A list of allowed users"
  type = list(string)
  default = []
}

# variable "researcher_workspace_regular_service_perimeter_egress_policies" {
#   description = "	A list of all egress policies, each list object has a from and to value that describes egress_from and egress_to."
#   type = list(object({
#     from = any
#     to   = any
#   }))
#   default = []
# }

#-------------------------------------------------------------------------
# RESEARCHER WORKSPACE & STAGING PROJECT VPC SC BRIDGE PERIMETER VARIABLES
#-------------------------------------------------------------------------

// REQUIRED VARIABLES

variable "workspace_and_staging_bridge_service_perimeter_name" {
  description = "Name of the bridge perimeter. Should be one unified string. Must only be letters, numbers and underscores"
  type        = string
  default     = ""
}

variable "workspace_and_staging_bridge_service_perimeter_resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
  default     = []
}

// OPTIONAL

variable "workspace_and_staging_bridge_service_perimeter_description" {
  description = "Description of the bridge perimeter"
  type        = string
  default     = ""
}

#---------------------------------------------------------------------------
# RESEARCHER WORKSPACE & DATA LAKE PROJECT VPC SC BRIDGE PERIMETER VARIABLES
#---------------------------------------------------------------------------

// REQUIRED VARIABLES

variable "workspace_and_data_lake_bridge_service_perimeter_name" {
  description = "Name of the bridge perimeter. Should be one unified string. Must only be letters, numbers and underscores"
  type        = string
  default     = ""
}

variable "workspace_and_data_lake_bridge_service_perimeter_resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
  default     = []
}

// OPTIONAL

variable "workspace_and_data_lake_bridge_service_perimeter_description" {
  description = "Description of the bridge perimeter"
  type        = string
  default     = ""
}

#---------------------------------------------------------------------------
# RESEARCHER BASTION PROJECT VPC SERVICE CONTROL REGULAR PERIMETER VARIABLES
#---------------------------------------------------------------------------

// REQUIRED VARIALBES

variable "researcher_bastion_project_regular_service_perimeter_description" {
  description = "Description of the regular perimeter"
  type        = string
  default     = ""
}

variable "researcher_bastion_project_regular_service_perimeter_name" {
  description = "Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores"
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES


variable "researcher_bastion_project_regular_service_perimeter_restricted_services" {
  description = "GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions."
  type        = list(string)
  default     = []
}

variable "researcher_bastion_project_regular_service_perimeter_enable_restriction" {
  description = "Whether to restrict API calls within the Service Perimeter to the list of APIs specified in 'allowed_services'. This can be useful if only certain APIs should be allowed to be accessed from a network within the VPC service control perimeter."
  type        = bool
  default     = false
}

variable "researcher_bastion_project_regular_service_perimeter_allowed_services" {
  description = "The list of APIs usable within the Service Perimeter from a VPC network within the perimeter. Must be empty unless 'enable_restriction' is True."
  type        = list(string)
  default     = []
}

#variable "researcher_bastion_project_regular_service_perimeter_egress_policies" {
#  description = "	A list of all egress policies, each list object has a from and to value that describes egress_from and egress_to."
#  type = list(object({
#    from = any
#    to   = any
#  }))
#  default = []
#}

#-------------------------------------------------------------------
# RESEARCHER EXTERNAL DATA EGRESS VPC SC REGULAR PERIMETER VARIABLES
#-------------------------------------------------------------------

// REQUIRED VARIALBES

variable "researcher_data_egress_regular_service_perimeter_description" {
  description = "Description of the regular perimeter"
  type        = string
  default     = ""
}

variable "researcher_data_egress_regular_service_perimeter_name" {
  description = "Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores"
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "researcher_data_egress_regular_service_perimeter_access_levels" {
  description = "A list of AccessLevel resource names that allow resources within the ServicePerimeter to be accessed from the internet. AccessLevels listed must be in the same policy as this ServicePerimeter. Referencing a nonexistent AccessLevel is a syntax error. If no AccessLevel names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY_POLICY/accessLevels/MY_LEVEL'. For Service Perimeter Bridge, must be empty."
  type        = list(string)
  default     = []
}

variable "researcher_data_egress_regular_service_perimeter_restricted_services" {
  description = "GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions."
  type        = list(string)
  default     = []
}

variable "researcher_data_egress_regular_service_perimeter_enable_restriction" {
  description = "Whether to restrict API calls within the Service Perimeter to the list of APIs specified in 'allowed_services'. This can be useful if only certain APIs should be allowed to be accessed from a network within the VPC service control perimeter."
  type        = bool
  default     = false
}

variable "researcher_data_egress_regular_service_perimeter_allowed_services" {
  description = "The list of APIs usable within the Service Perimeter from a VPC network within the perimeter. Must be empty unless 'enable_restriction' is True."
  type        = list(string)
  default     = []
}

#------------------------------------------------------------------------------------
# RESEARCHER EXTERNAL DATA EGRESS & STAGING PROJECT VPC SC BRIDGE PERIMETER VARIABLES
#------------------------------------------------------------------------------------

// REQUIRED VARIABLES

variable "external_egress_and_staging_bridge_service_perimeter_name" {
  description = "Name of the bridge perimeter. Should be one unified string. Must only be letters, numbers and underscores"
  type        = string
  default     = ""
}

variable "external_egress_and_staging_bridge_service_perimeter_resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
  default     = []
}

// OPTIONAL

variable "external_egress_and_staging_bridge_service_perimeter_description" {
  description = "Description of the bridge perimeter"
  type        = string
  default     = ""
}