locals {
  policy_for = "project"
  project_id = module.secure-staging-project.project_id
}

#-----------------------------------------------------------------------
# SRDE FOLDER DISABLE AUTOMATIC IAM GRANTS FOR DEFAULT SERVICE ACCOUNTS check
#-----------------------------------------------------------------------
module "srde_project_disable_automatic_iam_for_default_sa" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 3.0.2"
  constraint  = "constraints/iam.automaticIamGrantsForDefaultServiceAccounts"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.project_id
  enforce     = var.enforce
}

#----------------------------------------------
# DISABLE SRDE FOLDER SERVICE ACCOUNT CREATION check
#----------------------------------------------
module "srde_project_disable_sa_creation" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 3.0.2"
  constraint  = "constraints/iam.disableServiceAccountCreation"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.project_id
  enforce     = var.enforce
}

#--------------------------------------------------
# DISABLE SRDE FOLDER SERVICE ACCOUNT KEY CREATION check
#--------------------------------------------------
module "srde_project_disable_sa_key_creation" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 3.0.2"
  constraint  = "constraints/iam.disableServiceAccountKeyCreation"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.project_id
  enforce     = var.enforce
}

#----------------------------------------------
# DISABLE SDE FOLDER VM NESTED VIRTUALIZATION check
#----------------------------------------------
module "srde_project_disable_vm_nested_virtualization" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 3.0.2"
  constraint  = "constraints/compute.disableNestedVirtualization"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.project_id
  enforce     = var.enforce
}

#------------------------------------------------------------
# SDE FOLDER ENFORCE PUBLIC ACCESS PREVENTION ON GCS BUCKETS
#------------------------------------------------------------

module "srde_project_enforce_public_access_prevention" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 3.0.2"
  constraint  = "constraints/storage.publicAccessPrevention"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.project_id
  enforce     = var.enforce
}

#------------------------------------------------
# SRDE FOLDER ENFORCE UNIFORM BUCKET LEVEL ACCESS check
#------------------------------------------------

module "srde_project_enforce_uniform_bucket_level_access" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 3.0.2"
  constraint  = "constraints/storage.uniformBucketLevelAccess"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.project_id
  enforce     = var.enforce
}

#--------------------------------------
# SRDE FOLDER REQUIRE OS LOGIN FOR VMs check
#--------------------------------------
module "srde_project_vm_os_login" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 3.0.2"
  constraint  = "constraints/compute.requireOsLogin"
  policy_type = "boolean"
  policy_for  = local.policy_for
  project_id  = local.project_id
  enforce     = var.enforce
}

# ------------------------------------------------------------------------------------

#--------------------------------------------------------
# SDE FOLDER LIST OF VMs ALLOWED TO HAVE AN EXTERNAL IP check
#--------------------------------------------------------
module "srde_project_vm_allowed_external_ip" {
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 3.0.2"
  constraint        = "constraints/compute.vmExternalIpAccess"
  policy_type       = "list"
  policy_for        = local.policy_for
  project_id        = local.project_id
  enforce           = var.enforce
  allow             = var.srde_project_vms_allowed_external_ip
  allow_list_length = length(var.srde_project_vms_allowed_external_ip)
}

#---------------------------------------
# SDE DOMAIN RESTRICTED SHARING
#---------------------------------------

resource "google_project_organization_policy" "domain_restricted_shared" {
  # Loop through any values
  for_each   = var.srde_project_domain_restricted_sharing_allow != [] ? toset(var.srde_project_domain_restricted_sharing_allow) : []
  project    = local.project_id
  constraint = "iam.allowedPolicyMemberDomains"
  list_policy {
    allow {
      values = [each.value]
    }
  }
}

#-------------------------------------------
# SRDE FOLDER RESOURCE LOCATION RESTRICTION
#-------------------------------------------

module "srde_project_resource_location_restriction" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 3.0.2"
  constraint  = "constraints/gcp.resourceLocations"
  policy_type = "list"
  policy_for  = "project"
  project_id  = local.project_id
  #allow             = var.srde_project_resource_location_restriction_allow
  allow             = ["in:us-locations"]
  allow_list_length = length(var.srde_project_resource_location_restriction_allow)
}

# ------------------------------------------
# VARIABLES
# ------------------------------------------

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
