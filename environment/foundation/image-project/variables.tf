#------------------------
# PACKER PROJECT FACTORY
#------------------------

variable "environment" {
  description = "Environment name."
  type        = string
}


// REQUIRED VARIABLES

# variable "project_name" {
#   description = "The name for the project"
#   type        = string
#   default     = ""
# }


// OPTIONAL VARIABLES

# variable "activate_apis" {
#   description = "The list of apis to activate within the project"
#   type        = list(string)
#   default     = ["compute.googleapis.com"]
# }

# variable "auto_create_network" {
#   description = "Create the default network"
#   type        = bool
#   default     = false
# }

variable "create_project_sa" {
  description = "Whether the default service account for the project shall be created"
  type        = bool
  default     = true
}

# variable "default_service_account" {
#   description = "Project default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`."
#   type        = string
#   default     = "keep"
# }

# variable "disable_dependent_services" {
#   description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed."
#   type        = bool
#   default     = true
# }

# variable "disable_services_on_destroy" {
#   description = "Whether project services will be disabled when the resources are destroyed"
#   type        = string
#   default     = "true"
# }

# variable "group_name" {
#   description = "A Google group to control the project by being assigned group_role (defaults to project viewer)"
#   type        = string
#   default     = ""
# }

# variable "group_role" {
#   description = "The role to give the controlling group (group_name) over the project (defaults to project viewer)"
#   type        = string
#   default     = "roles/viewer"
# }

# variable "project_labels" {
#   description = "Map of labels for project"
#   type        = map(string)
#   default     = {}
# }

# variable "lien" {
#   description = "Add a lien on the project to prevent accidental deletion"
#   type        = bool
#   default     = false
# }

# variable "random_project_id" {
#   description = "Adds a suffix of 4 random characters to the `project_id`"
#   type        = bool
#   default     = true
# }

#----------------------------
# GCS BUCKET MODULE VARIABLES
#----------------------------

variable "bucket_force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run."
  type        = bool
  default     = false
}

variable "storage_bucket_labels" {
  description = "Labels to be attached to the buckets"
  type        = map(any)
  default     = {}
}

variable "bucket_location" {
  description = "Bucket location. See this link for regional and multi-regional options https://cloud.google.com/storage/docs/locations#legacy"
  type        = string
  default     = "US"
}

variable "bucket_storage_class" {
  description = "Bucket storage class. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  type        = string
  default     = "STANDARD"
}

variable "uniform_bucket_level_access" {
  description = "Enables Uniform bucket-level access access to a bucket."
  type        = bool
  default     = false
}

#----------------------------
# PACKER VPC MODULE VARIABLES
#----------------------------

# variable "vpc_network_name" {
#   description = "The name of the network being created"
#   type        = string
# }

# variable "auto_create_subnetworks" {
#   description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
#   type        = bool
#   default     = false
# }

# variable "delete_default_internet_gateway_routes" {
#   description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
#   type        = bool
#   default     = false
# }

# variable "firewall_rules" {
#   description = "List of firewall rules"
#   type        = any
#   default     = []
# }

# variable "routing_mode" {
#   description = "The network routing mode for regional dynamic routing or global dynamic routing (default 'GLOBAL' otherwise use 'REGIONAL')"
#   type        = string
#   default     = "GLOBAL"
# }

# variable "vpc_description" {
#   description = "An optional description of this resource. The resource must be recreated to modify this field."
#   type        = string
#   default     = "VPC created from Terraform for web app use case deployment."
# }

# variable "shared_vpc_host" {
#   description = "Makes this project a Shared VPC host if 'true' (default 'false')"
#   type        = bool
#   default     = false
# }

# variable "mtu" {
#   type        = number
#   description = "The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically."
# }

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
  default     = []
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "routes" {
  type        = list(map(string))
  description = "List of routes being created in this VPC. For more information see [link](https://github.com/terraform-google-modules/terraform-google-network#route-inputs)"
  default     = []
}

variable "default_region" {
  description = "The default region to deploy resources."
  type        = string
  default     = "us-central1"
}

#--------------------------------------------------------
# PACKER CONTAINER ARTIFACT REGISTRY REPOSITORY VARIABLES
#--------------------------------------------------------

variable "packer_container_artifact_repository_name" {
  description = "The name of the repository that will be provisioned."
  type        = string
  default     = ""
}

variable "packer_container_artifact_repository_format" {
  description = "The format of packages that are stored in the repository. You can only create alpha formats if you are a member of the [alpha user group](https://cloud.google.com/artifact-registry/docs/supported-formats#alpha-access). DOCKER, MAVEN (Preview), NPM (Preview), PYTHON (Preview), APT (alpha), YUM (alpha)."
  type        = string
  default     = ""
}

variable "packer_container_artifact_repository_location" {
  description = "The name of the location this repository is located in."
  type        = string
  default     = ""
}

variable "packer_container_artifact_repository_description" {
  description = "The user-provided description of the repository."
  type        = string
  default     = "Artifact Registry Repository created with Terraform."
}

variable "packer_container_artifact_repository_labels" {
  description = "Labels with user-defined metadata. This field may contain up to 64 entries. Label keys and values may be no longer than 63 characters. Label keys must begin with a lowercase letter and may only contain lowercase letters, numeric characters, underscores, and dashes."
  type        = map(string)
  default     = {}
}

# #---------------------------------------------------------
# # PATH ML CONTAINER ARTIFACT REGISTRY REPOSITORY VARIABLES
# #---------------------------------------------------------

# variable "path_ml_container_artifact_repository_name" {
#   description = "The name of the repository that will be provisioned."
#   type        = string
#   default     = ""
# }

# variable "path_ml_container_artifact_repository_format" {
#   description = "The format of packages that are stored in the repository. You can only create alpha formats if you are a member of the [alpha user group](https://cloud.google.com/artifact-registry/docs/supported-formats#alpha-access). DOCKER, MAVEN (Preview), NPM (Preview), PYTHON (Preview), APT (alpha), YUM (alpha)."
#   type        = string
#   default     = ""
# }

# variable "path_ml_container_artifact_repository_location" {
#   description = "The name of the location this repository is located in."
#   type        = string
#   default     = ""
# }

# variable "path_ml_container_artifact_repository_description" {
#   description = "The user-provided description of the repository."
#   type        = string
#   default     = "Artifact Registry Repository created with Terraform."
# }

# variable "path_ml_container_artifact_repository_labels" {
#   description = "Labels with user-defined metadata. This field may contain up to 64 entries. Label keys and values may be no longer than 63 characters. Label keys must begin with a lowercase letter and may only contain lowercase letters, numeric characters, underscores, and dashes."
#   type        = map(string)
#   default     = {}
# }

#---------------------------------------------------------------------
# terraform-validator CONTAINER ARTIFACT REGISTRY REPOSITORY VARIABLES
#---------------------------------------------------------------------

variable "terraform_validator_container_artifact_repository_name" {
  description = "The name of the repository that will be provisioned."
  type        = string
  default     = ""
}

variable "terraform_validator_container_artifact_repository_format" {
  description = "The format of packages that are stored in the repository. You can only create alpha formats if you are a member of the [alpha user group](https://cloud.google.com/artifact-registry/docs/supported-formats#alpha-access). DOCKER, MAVEN (Preview), NPM (Preview), PYTHON (Preview), APT (alpha), YUM (alpha)."
  type        = string
  default     = ""
}

variable "terraform_validator_container_artifact_repository_location" {
  description = "The name of the location this repository is located in."
  type        = string
  default     = ""
}

variable "terraform_validator_container_artifact_repository_description" {
  description = "The user-provided description of the repository."
  type        = string
  default     = "Artifact Registry Repository created with Terraform."
}

variable "terraform_validator_container_artifact_repository_labels" {
  description = "Labels with user-defined metadata. This field may contain up to 64 entries. Label keys and values may be no longer than 63 characters. Label keys must begin with a lowercase letter and may only contain lowercase letters, numeric characters, underscores, and dashes."
  type        = map(string)
  default     = {}
}

#----------------------------------------
# PACKER PROJECT SERVICE ACCOUNT CREATION
#----------------------------------------

variable "enforce_packer_project_disable_sa_creation" {
  description = "Define variable to disable and enable policy at the project level during provisioning."
  type        = bool
  default     = true
}

#----------------------------------------
# PACKER PROJECT DEPLOYMENT MANAGER ROLE
#----------------------------------------

variable "deploymentmanager_editor" {
  description = "Accounts with Deployment Manager role."
  type        = string
}

variable "image_project_iam_roles" {
  description = "The IAM role(s) to assign to the member at the defined project."
  type        = list(string)
  default = [
    "roles/deploymentmanager.editor",
    "roles/artifactregistry.admin",
    "roles/compute.admin"
  ]
}