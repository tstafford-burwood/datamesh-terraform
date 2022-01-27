#-------------------------
# CLOUD COMPOSER VARIABLES
#-------------------------


variable "environment" {
  description = "Environment name."
  type        = string
}

variable "terraform_foundation_state_prefix" {
  description = "The name of the foundation prefix to create in the state bucket. Set in during the pipeline."
  type        = string
  #default     = "foundation"
}

// REQUIRED

# variable "composer_env_name" {
#   description = "Name of Cloud Composer Environment"
#   type        = string
# }

# variable "network" {
#   type        = string
#   description = "The VPC network to host the Composer cluster."
# }

# variable "subnetwork" {
#   description = "The subnetwork to host the Composer cluster."
#   type        = string
# }

// OPTIONAL

variable "airflow_config_overrides" {
  description = "Airflow configuration properties to override. Property keys contain the section and property names, separated by a hyphen, for example \"core-dags_are_paused_at_creation\"."
  type        = map(string)
  default     = { "webserver-rbac" = "True" }
}

variable "allowed_ip_range" {
  description = "The IP ranges which are allowed to access the Apache Airflow Web Server UI."
  type = list(object({
    value       = string
    description = string
  }))
  default = []
}

variable "cloud_sql_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for Cloud SQL."
  type        = string
  default     = "10.4.0.0/24"
}

variable "composer_service_account" {
  description = "Service Account for running Cloud Composer."
  type        = string
  default     = null
}

variable "database_machine_type" {
  description = "The machine type to setup for the SQL database in the Cloud Composer environment."
  type        = string
  default     = "db-n1-standard-4"
}

variable "disk_size" {
  description = "The disk size in GB for nodes."
  type        = string
  default     = "50"
}

variable "enable_private_endpoint" {
  description = "Configure the ability to have public access to the cluster endpoint. If private endpoint is enabled, connecting to the cluster will need to be done with a VM in the same VPC and region as the Composer environment. Additional details can be found [here](https://cloud.google.com/composer/docs/concepts/private-ip#cluster)."
  type        = bool
  default     = true
}

variable "env_variables" {
  description = "Variables of the airflow environment."
  type        = map(string)
  default     = {}
}

variable "image_version" {
  description = "The version of Airflow running in the Cloud Composer environment."
  type        = string
  default     = null
}

variable "labels" {
  description = "The resource labels (a map of key/value pairs) to be applied to the Cloud Composer."
  type        = map(string)
  default     = {}
}

variable "gke_machine_type" {
  description = "Machine type of Cloud Composer nodes."
  type        = string
  default     = "n1-standard-2"
}

variable "master_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for the master."
  type        = string
  default     = null
}

variable "node_count" {
  description = "Number of worker nodes in the Cloud Composer Environment."
  type        = number
  default     = 3
}

variable "oauth_scopes" {
  description = "Google API scopes to be made available on all node."
  type        = set(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "pod_ip_allocation_range_name" {
  description = "The name of the cluster's secondary range used to allocate IP addresses to pods."
  type        = string
  default     = "kubernetes-pods"
}

variable "pypi_packages" {
  description = "Custom Python Package Index (PyPI) packages to be installed in the environment. Keys refer to the lowercase package name (e.g. \"numpy\")."
  type        = map(string)
  default     = {}
}

variable "python_version" {
  description = "The default version of Python used to run the Airflow scheduler, worker, and webserver processes."
  type        = string
  default     = "3"
}

# variable "region" {
#   description = "Region where the Cloud Composer Environment is created."
#   type        = string
#   default     = "us-central1"
# }

variable "service_ip_allocation_range_name" {
  description = "The name of the services' secondary range used to allocate IP addresses to the cluster."
  type        = string
  default     = "kubernetes-services"
}

variable "tags" {
  description = "Tags applied to all nodes. Tags are used to identify valid sources or targets for network firewalls."
  type        = set(string)
  default     = []
}

variable "use_ip_aliases" {
  description = "Enable Alias IPs in the GKE cluster. If true, a VPC-native cluster is created."
  type        = bool
  default     = true
}

variable "web_server_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for the web server."
  type        = string
  default     = "10.3.0.0/29"
}

variable "web_server_machine_type" {
  description = "The machine type to setup for the Apache Airflow Web Server UI."
  type        = string
  default     = "composer-n1-webserver-4"
}

# variable "zone" {
#   description = "Zone where the Cloud Composer nodes are created."
#   type        = string
#   default     = "us-central1-f"
# }

// SHARED VPC SUPPORT

# variable "network_project_id" {
#   description = "The project ID of the shared VPC's host (for shared vpc support)"
#   type        = string
#   default     = ""
# }

# variable "subnetwork_region" {
#   description = "The subnetwork region of the shared VPC's host (for shared vpc support)"
#   type        = string
#   default     = ""
# }

#--------------------------
# SERVICE ACCOUNT VARIABLES
#--------------------------

// OPTIONAL VARIABLES

# variable "billing_account_id" {
#   description = "The ID of the billing account to associate this project with"
#   type        = string
#   default     = ""
# }

# variable "description" {
#   type        = string
#   description = "Descriptions of the created service accounts (defaults to no description)"
#   default     = ""
# }

# variable "display_name" {
#   type        = string
#   description = "Display names of the created service accounts (defaults to 'Terraform-managed service account')"
#   default     = "Terraform-managed service account"
# }

# variable "generate_keys" {
#   description = "Generate keys for service accounts."
#   type        = bool
#   default     = false
# }

# variable "grant_billing_role" {
#   description = "Grant billing user role."
#   type        = bool
#   default     = false
# }

# variable "grant_xpn_roles" {
#   description = "Grant roles for shared VPC management."
#   type        = bool
#   default     = false
# }

# variable "service_account_names" {
#   description = "Names of the service accounts to create."
#   type        = list(string)
#   default     = [""]
# }

# variable "org_id" {
#   description = "The organization ID."
#   type        = string
#   default     = ""
# }

# variable "prefix" {
#   description = "Prefix applied to service account names."
#   type        = string
#   default     = ""
# }

variable "project_roles" {
  description = "Common roles to apply to all service accounts, project=>role as elements."
  type        = list(string)
  default     = []
}

#----------------------------
# FOLDER IAM MEMBER VARIABLES
#----------------------------

variable "iam_role_list" {
  description = "The IAM role(s) to assign to the member at the defined folder."
  type        = list(string)
  default = [
    "roles/composer.worker",
    "roles/iam.serviceAccountUser",
    "roles/bigquery.dataOwner",
    "roles/dlp.jobsEditor",
    "roles/storage.objectAdmin"
  ]
}


#----------------------------------------------------------
# VPC SC ACCESS LEVELS - COMPOSER SERVICE ACCOUNT VARIABLES
#----------------------------------------------------------

// REQUIRED VARIABLES

# variable "access_level_name" {
#   description = "Description of the AccessLevel and its use. Does not affect behavior."
#   type        = string
#   default     = ""
# }

# // OPTIONAL VARIABLES - NON PREMIUM

# variable "combining_function" {
#   description = "How the conditions list should be combined to determine if a request is granted this AccessLevel. If AND is used, each Condition must be satisfied for the AccessLevel to be applied. If OR is used, at least one Condition must be satisfied for the AccessLevel to be applied."
#   type        = string
#   default     = "AND"
# }

# variable "access_level_description" {
#   description = "Description of the access level."
#   type        = string
#   default     = ""
# }

# variable "ip_subnetworks" {
#   description = "Condition - A list of CIDR block IP subnetwork specifications. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, \"192.0.2.0/24\" is accepted but \"192.0.2.1/24\" is not. Similarly, for IPv6, \"2001:db8::/32\" is accepted whereas \"2001:db8::1/32\" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed."
#   type        = list(string)
#   default     = []
# }

# variable "access_level_members" {
#   description = "Condition - An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
#   type        = list(string)
#   default     = []
# }

# variable "negate" {
#   description = "Whether to negate the Condition. If true, the Condition becomes a NAND over its non-empty fields, each field must be false for the Condition overall to be satisfied."
#   type        = bool
#   default     = false
# }

# variable "regions" {
#   description = "Condition - The request must originate from one of the provided countries/regions. Format: A valid ISO 3166-1 alpha-2 code."
#   type        = list(string)
#   default     = []
# }

# variable "required_access_levels" {
#   description = "Condition - A list of other access levels defined in the same Policy, referenced by resource name. Referencing an AccessLevel which does not exist is an error. All access levels listed must be granted for the Condition to be true."
#   type        = list(string)
#   default     = []
# }

# // OPTIONAL VARIABLES - DEVICE POLICY (PREMIUM FEATURE)

# variable "allowed_device_management_levels" {
#   description = "Condition - A list of allowed device management levels. An empty list allows all management levels."
#   type        = list(string)
#   default     = []
# }

# variable "allowed_encryption_statuses" {
#   description = "Condition - A list of allowed encryption statuses. An empty list allows all statuses."
#   type        = list(string)
#   default     = []
# }

# variable "minimum_version" {
#   description = "The minimum allowed OS version. If not set, any version of this OS satisfies the constraint. Format: \"major.minor.patch\" such as \"10.5.301\", \"9.2.1\"."
#   type        = string
#   default     = ""
# }

# variable "os_type" {
#   description = "The operating system type of the device."
#   type        = string
#   default     = "OS_UNSPECIFIED"
# }

# variable "require_corp_owned" {
#   description = "Condition - Whether the device needs to be corp owned."
#   type        = bool
#   default     = false
# }

# variable "require_screen_lock" {
#   description = "Condition - Whether or not screenlock is required for the DevicePolicy to be true."
#   type        = bool
#   default     = false
# }

# #-----------------------------------------
# # STAGING PROJECT SERVICE ACCOUNT CREATION
# #-----------------------------------------

# variable "enforce_staging_project_disable_sa_creation" {
#   description = "Define variable to disable and enable policy at the project level during provisioning."
#   type        = bool
#   default     = true
# }

# #-----------------------------------------
# # STAGING PROJECT REQUIRE OS LOGIN FOR VMs
# #-----------------------------------------

# variable "enforce_staging_project_vm_os_login" {
#   description = "Define variable to disable and enable policy at the project level during provisioning."
#   type        = bool
#   default     = true
# }

# #-----------------------------
# # STAGING PROJECT SHIELDED VMs
# #-----------------------------

# variable "enforce_staging_project_shielded_vms" {
#   description = "Define variable to disable and enable policy at the project level during provisioning."
#   type        = bool
#   default     = true
# }