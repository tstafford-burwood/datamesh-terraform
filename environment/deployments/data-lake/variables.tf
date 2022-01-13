#-----------------------------------------
# RESEARCHER WORKSPACE - PROJECT VARIABLES
#-----------------------------------------

// PROJECT REQUIRED VARIABLES

variable "data_lake_project_name" {
  description = "The name for the project"
  type        = string
  default     = ""
}


// PROJECT OPTIONAL VARIABLES

variable "data_lake_activate_apis" {
  description = "The list of apis to activate within the project"
  type        = list(string)
  default     = ["compute.googleapis.com"]
}

variable "data_lake_auto_create_network" {
  description = "Create the default network"
  type        = bool
  default     = false
}

variable "data_lake_create_project_sa" {
  description = "Whether the default service account for the project shall be created"
  type        = bool
  default     = true
}

variable "data_lake_default_service_account" {
  description = "Project default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`."
  type        = string
  default     = "delete"
}

variable "data_lake_disable_dependent_services" {
  description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed."
  type        = bool
  default     = true
}

variable "data_lake_disable_services_on_destroy" {
  description = "Whether project services will be disabled when the resources are destroyed"
  type        = string
  default     = "true"
}

variable "data_lake_group_name" {
  description = "A Google group to control the project by being assigned group_role (defaults to project viewer)"
  type        = string
  default     = ""
}

variable "data_lake_group_role" {
  description = "The role to give the controlling group (group_name) over the project (defaults to project viewer)"
  type        = string
  default     = "roles/viewer"
}

variable "data_lake_project_labels" {
  description = "Map of labels for project"
  type        = map(string)
  default     = {}
}

variable "data_lake_lien" {
  description = "Add a lien on the project to prevent accidental deletion"
  type        = bool
  default     = false
}

variable "data_lake_random_project_id" {
  description = "Adds a suffix of 4 random characters to the `project_id`"
  type        = bool
  default     = true
}

#-------------------------------------------------------
# RESEARCHER WORKSPACE PROJECT IAM CUSTOM ROLE VARIABLES
#-------------------------------------------------------

variable "datalake_iam_custom_role_description" {
  description = "A human-readable description for the role."
  type        = string
  default     = "Custom role created with Terraform."
}

variable "datalake_iam_custom_role_id" {
  description = "The camel case role id to use for this role. Cannot contain - characters."
  type        = string
  default     = ""
}

variable "datalake_iam_custom_role_title" {
  description = "A human-readable title for the role."
  type        = string
  default     = ""
}

variable "datalake_iam_custom_role_permissions" {
  description = "The names of the permissions this role grants when bound in an IAM policy. At least one permission must be specified."
  type        = list(string)
  default     = []
}

variable "datalake_iam_custom_role_stage" {
  description = "The current launch stage of the role. Defaults to GA. List of possible stages is [here](https://cloud.google.com/iam/docs/reference/rest/v1/organizations.roles#Role.RoleLaunchStage)."
  type        = string
  default     = ""
}

#--------------------------------------
# DATALAKE PROJECT IAM MEMBER VARIABLES
#--------------------------------------

variable "datalake_project_member" {
  description = "The member to apply the IAM role to. Possible options use the following syntax: user:{emailid}, serviceAccount:{emailid}, group:{emailid}, domain:{domain}."
  type        = string
  default     = ""
}

#-----------------------------------------------
# VPC SC REGULAR PERIMETER - DATA LAKE VARIABLES
#-----------------------------------------------

// REQUIRED VARIALBES

variable "datalake_regular_service_perimeter_description" {
  description = "Description of the regular perimeter"
  type        = string
  default     = ""
}

variable "datalake_regular_service_perimeter_name" {
  description = "Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores"
  type        = string
  default     = ""
}

variable "datalake_parent_policy_id" {
  description = "ID of the parent policy"
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "datalake_access_level_names" {
  description = "A list of Access Level resource names that allow resources within the Service Perimeter to be accessed from the internet. Access Levels listed must be in the same policy as this Service Perimeter. Referencing a nonexistent Access Level is a syntax error. If no Access Level names are listed, resources within the perimeter can only be accessed via GCP calls with request origins within the perimeter. Example: 'accessPolicies/MY_POLICY/accessLevels/MY_LEVEL'. For Service Perimeter Bridge, must be empty."
  type        = list(string)
  default     = []
}

variable "datalake_project_to_add_perimeter" {
  description = "A list of GCP resources (only projects) that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
  default     = []
}

variable "datalake_restricted_services" {
  description = "GCP services that are subject to the Service Perimeter restrictions. Must contain a list of services. For example, if storage.googleapis.com is specified, access to the storage buckets inside the perimeter must meet the perimeter's access restrictions."
  type        = list(string)
  default     = []
}

variable "datalake_enable_restriction" {
  description = "Whether to restrict API calls within the Service Perimeter to the list of APIs specified in 'allowed_services'. This can be useful if only certain APIs should be allowed to be accessed from a network within the VPC service control perimeter."
  type        = bool
  default     = false
}

variable "datalake_allowed_services" {
  description = "The list of APIs usable within the Service Perimeter from a VPC network within the perimeter. Must be empty unless 'enable_restriction' is True."
  type        = list(string)
  default     = []
}

#----------------------------------------
# VPC SC DATALAKE ACCESS LEVELS VARIABLES
#----------------------------------------

// REQUIRED VARIABLES

# variable "datalake_access_level_name" {
#   description = "Description of the AccessLevel and its use. Does not affect behavior."
#   type        = string
#   default     = ""
# }

# variable "datalake_parent_policy_name" {
#   description = "Name of the parent policy."
#   type        = string
#   default     = ""
# }

# // OPTIONAL VARIABLES - NON PREMIUM

# variable "datalake_combining_function" {
#   description = "How the conditions list should be combined to determine if a request is granted this AccessLevel. If AND is used, each Condition must be satisfied for the AccessLevel to be applied. If OR is used, at least one Condition must be satisfied for the AccessLevel to be applied."
#   type        = string
#   default     = "AND"
# }

# variable "datalake_access_level_description" {
#   description = "Description of the access level."
#   type        = string
#   default     = ""
# }

# variable "datalake_ip_subnetworks" {
#   description = "Condition - A list of CIDR block IP subnetwork specifications. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, \"192.0.2.0/24\" is accepted but \"192.0.2.1/24\" is not. Similarly, for IPv6, \"2001:db8::/32\" is accepted whereas \"2001:db8::1/32\" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed."
#   type        = list(string)
#   default     = []
# }

# variable "datalake_access_level_members" {
#   description = "Condition - An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
#   type        = list(string)
#   default     = []
# }

# variable "datalake_negate" {
#   description = "Whether to negate the Condition. If true, the Condition becomes a NAND over its non-empty fields, each field must be false for the Condition overall to be satisfied."
#   type        = bool
#   default     = false
# }

# variable "datalake_regions" {
#   description = "Condition - The request must originate from one of the provided countries/regions. Format: A valid ISO 3166-1 alpha-2 code."
#   type        = list(string)
#   default     = []
# }

# variable "datalake_required_access_levels" {
#   description = "Condition - A list of other access levels defined in the same Policy, referenced by resource name. Referencing an AccessLevel which does not exist is an error. All access levels listed must be granted for the Condition to be true."
#   type        = list(string)
#   default     = []
# }

#------------------------------------------------------
# VPC SC DATALAKE TO STAGING BRIDGE PERIMETER VARIABLES
#------------------------------------------------------

// REQUIRED VARIABLES

# variable "datalake_bridge_service_perimeter_name" {
#   description = "Name of the bridge perimeter. Should be one unified string. Must only be letters, numbers and underscores"
#   type        = string
#   default     = ""
# }

# variable "datalake_bridge_service_perimeter_resources" {
#   description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
#   type        = list(string)
#   default     = []
# }

# // OPTIONAL

# variable "datalake_bridge_service_perimeter_description" {
#   description = "Description of the bridge perimeter"
#   type        = string
#   default     = ""
# }