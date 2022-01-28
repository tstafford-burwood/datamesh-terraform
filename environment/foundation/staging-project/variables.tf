#---------------------------------
# SECURE STAGING PROJECT VARIABLES
#---------------------------------

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "terraform_foundation_state_prefix" {
  description = "The name of the foundation prefix to create in the state bucket. Set in during the pipeline."
  type        = string
  #default     = "foundation"
}

variable "default_service_account" {
  description = "Project compute engine default service account setting: can be one of `delete`, `deprivilege`, `disable`, or `keep`."
  type        = string
  default     = "keep"
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
  default = [
    {
      subnet_name               = "subnet-01"
      subnet_ip                 = "10.0.0.0/16"
      subnet_region             = "us-central1"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_private_access     = "true"
    }
  ]
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default = {
    subnet-01 = [
      {
        range_name    = "kubernetes-pods"
        ip_cidr_range = "10.1.0.0/20"
      },
      {
        range_name    = "kubernetes-services"
        ip_cidr_range = "10.2.0.0/24"
      }
    ]
  }
}

variable "routes" {
  type        = list(map(string))
  description = "List of routes being created in this VPC. For more information see [link](https://github.com/terraform-google-modules/terraform-google-network#route-inputs)"
  default     = []
}

#-------------------------
# PUB/SUB TOPIC VARIABLES
#-------------------------

variable "kms_key_name" {
  description = "The resource name of the Cloud KMS CryptoKey to be used to protect access to messages published on this topic. Your project's PubSub service account `(service-{{PROJECT_NUMBER}}@gcp-sa-pubsub.iam.gserviceaccount.com)` must have `roles/cloudkms.cryptoKeyEncrypterDecrypter` to use this feature. The expected format is `projects/*/locations/*/keyRings/*/cryptoKeys/*`"
  type        = string
  default     = null
}

#----------------------------------------------------
# FOLDER IAM MEMBER VARIABLES - DLP API SERVICE AGENT
#----------------------------------------------------

variable "dlp_service_agent_iam_role_list" {
  description = "The IAM role(s) to assign to the member at the defined folder."
  type        = list(string)
  default     = ["roles/dlp.jobsEditor"]
}

#------------------------------------------
# STAGING PROJECT IAM CUSTOM ROLE VARIABLES
#------------------------------------------

variable "project_iam_custom_role_id" {
  description = "The camel case role id to use for this role. Cannot contain - characters."
  type        = string
  default     = "sreCustomRoleStorageBucketsList"
}

variable "project_iam_custom_role_permissions" {
  description = "The names of the permissions this role grants when bound in an IAM policy. At least one permission must be specified."
  type        = list(string)
  default     = ["storage.buckets.list"]
}

variable "project_iam_custom_role_stage" {
  description = "The current launch stage of the role. Defaults to GA. List of possible stages is [here](https://cloud.google.com/iam/docs/reference/rest/v1/organizations.roles#Role.RoleLaunchStage)."
  type        = string
  default     = "GA"
}

#---------------------------------------------
# DATA STEWARDS - PROJECT IAM MEMBER VARIABLES
#---------------------------------------------

variable "data_stewards_iam_staging_project" {
  description = "The list of Data Stewards that will be assigned IAM roles on the Secure Staging Project."
  type        = list(string)
  #default     = []
}

#---------------------------------------------
# ORGANIZATION POLICY VARIABLES
#---------------------------------------------

variable "srde_project_vms_allowed_external_ip" {
  description = "This list constraint defines the set of Compute Engine VM instances that are allowed to use external IP addresses, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT_ID/zones/ZONE/instances/INSTANCE"
  type        = list(string)
  default     = []
}

variable "srde_project_domain_restricted_sharing_allow" {
  description = "List one or more Cloud Identity or Google Workspace custom IDs whose principals can be added to IAM policies. Leave empty to not enable."
  type        = list(string)
  default     = []
}

variable "srde_project_resource_location_restriction_allow" {
  description = "This list constraint defines the set of locations where location-based GCP resources can be created."
  type        = list(string)
  default     = ["in:us-locations"]
}

variable "enforce" {
  description = "Whether this policy is enforce."
  type        = bool
  default     = true
}