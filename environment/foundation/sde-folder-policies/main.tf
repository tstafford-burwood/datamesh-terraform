#---------------------
# SRDE FOLDER POLICIES
#---------------------

// IMPORT CONSTANTS

module "constants" {
  source = "../constants"
}

// SET LOCAL VALUES

locals {
  srde_folder_id                      = module.constants.value.srde_folder_id
  packer_project_id                   = module.constants.value.packer_project_id
  packer_default_region               = module.constants.value.packer_default_region
  default_zone                        = "b"
  zone                                = "${local.packer_default_region}-${local.default_zone}"
  srde_folder_vms_allowed_external_ip = ["projects/${local.packer_project_id}/zones/${local.zone}/instances/packer-builder-vm"]

  srde_folder_define_trusted_image_projects = [
    "projects/deeplearning-platform-release",
    "projects/${local.packer_project_id}"
  ]
}

#-------------------------------------------
# SRDE FOLDER RESOURCE LOCATION RESTRICTION
#-------------------------------------------
module "srde_folder_resource_location_restriction" {
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 3.0.2"
  constraint        = "constraints/gcp.resourceLocations"
  policy_type       = "list"
  policy_for        = "folder"
  folder_id         = local.srde_folder_id
  enforce           = null
  exclude_folders   = []
  exclude_projects  = []
  allow             = var.srde_folder_resource_location_restriction_allow
  allow_list_length = length(var.srde_folder_resource_location_restriction_allow)
}

#---------------------------------------
# SRDE FOLDER DOMAIN RESTRICTED SHARING
#---------------------------------------
module "srde_folder_domain_restricted_sharing" {
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 3.0.2"
  constraint        = "constraints/iam.allowedPolicyMemberDomains"
  policy_type       = "list"
  policy_for        = "folder"
  folder_id         = local.srde_folder_id
  enforce           = null
  exclude_folders   = []
  exclude_projects  = []
  allow             = var.srde_folder_domain_restricted_sharing_allow
  allow_list_length = length(var.srde_folder_domain_restricted_sharing_allow)
}

#-----------------------------------------------------------------
# SRDE FOLDER SHARED VPC ALLOWED SUBNETWORKS FOR RESOURCES TO USE
#-----------------------------------------------------------------
module "srde_folder_restrict_shared_vpc_subnetwork" {
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 3.0.2"
  constraint        = "constraints/compute.restrictSharedVpcSubnetworks"
  policy_type       = "list"
  policy_for        = "folder"
  folder_id         = local.srde_folder_id
  enforce           = null
  exclude_folders   = []
  exclude_projects  = []
  allow             = var.srde_folder_restrict_shared_vpc_subnetwork_allow
  allow_list_length = length(var.srde_folder_restrict_shared_vpc_subnetwork_allow)
}

#--------------------------------------
# SRDE FOLDER REQUIRE OS LOGIN FOR VMs
#--------------------------------------
module "srde_folder_vm_os_login" {
  source           = "terraform-google-modules/org-policy/google"
  version          = "~> 3.0.2"
  constraint       = "constraints/compute.requireOsLogin"
  policy_type      = "boolean"
  policy_for       = "folder"
  folder_id        = local.srde_folder_id
  enforce          = true
  exclude_folders  = []
  exclude_projects = []
}

#---------------------------------------------------------------
# SRDE FOLDER RESTRICT PUBLIC IP ACCESS FOR CLOUD SQL INSTANCES
#---------------------------------------------------------------
module "srde_folder_restrict_public_ip_cloud_sql" {
  source           = "terraform-google-modules/org-policy/google"
  version          = "~> 3.0.2"
  constraint       = "constraints/sql.restrictPublicIp"
  policy_type      = "boolean"
  policy_for       = "folder"
  folder_id        = local.srde_folder_id
  enforce          = true
  exclude_folders  = []
  exclude_projects = []
}

#--------------------------------------------------------
# SRDE FOLDER LIST OF VMs ALLOWED TO HAVE AN EXTERNAL IP
#--------------------------------------------------------
module "srde_folder_vm_allowed_external_ip" {
  source           = "terraform-google-modules/org-policy/google"
  version          = "~> 3.0.2"
  constraint       = "constraints/compute.vmExternalIpAccess"
  policy_type      = "list"
  policy_for       = "folder"
  folder_id        = local.srde_folder_id
  enforce          = null
  exclude_folders  = []
  exclude_projects = []
  #allow             = var.srde_folder_vms_allowed_external_ip
  allow = local.srde_folder_vms_allowed_external_ip
  #allow_list_length = length(var.srde_folder_vms_allowed_external_ip)
  allow_list_length = length(local.srde_folder_vms_allowed_external_ip)
}

#---------------------------------------------------------
# SRDE FOLDER LIST OF VMs ALLOWED TO ENABLE IP FORWARDING
#---------------------------------------------------------
module "srde_folder_vm_allowed_ip_forwarding" {
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 3.0.2"
  constraint        = "constraints/compute.vmCanIpForward"
  policy_type       = "list"
  policy_for        = "folder"
  folder_id         = local.srde_folder_id
  enforce           = null
  exclude_folders   = []
  exclude_projects  = []
  allow             = var.srde_folder_vms_allowed_ip_forwarding
  allow_list_length = length(var.srde_folder_vms_allowed_ip_forwarding)
}

#----------------------------------------------
# DISABLE SRDE FOLDER VM NESTED VIRTUALIZATION
#----------------------------------------------
module "srde_folder_disable_vm_nested_virtualization" {
  source           = "terraform-google-modules/org-policy/google"
  version          = "~> 3.0.2"
  constraint       = "constraints/compute.disableNestedVirtualization"
  policy_type      = "boolean"
  policy_for       = "folder"
  folder_id        = local.srde_folder_id
  enforce          = true
  exclude_folders  = []
  exclude_projects = []
}

#----------------------------------------------
# DISABLE SRDE FOLDER SERVICE ACCOUNT CREATION
#----------------------------------------------
module "srde_folder_disable_sa_creation" {
  source           = "terraform-google-modules/org-policy/google"
  version          = "~> 3.0.2"
  constraint       = "constraints/iam.disableServiceAccountCreation"
  policy_type      = "boolean"
  policy_for       = "folder"
  folder_id        = local.srde_folder_id
  enforce          = true
  exclude_folders  = []
  exclude_projects = []
}

#--------------------------------------------------
# DISABLE SRDE FOLDER SERVICE ACCOUNT KEY CREATION
#--------------------------------------------------
module "srde_folder_disable_sa_key_creation" {
  source           = "terraform-google-modules/org-policy/google"
  version          = "~> 3.0.2"
  constraint       = "constraints/iam.disableServiceAccountKeyCreation"
  policy_type      = "boolean"
  policy_for       = "folder"
  folder_id        = local.srde_folder_id
  enforce          = true
  exclude_folders  = []
  exclude_projects = []
}

#-------------------------------------------
# SRDE FOLDER DEFINE TRUSTED IMAGE PROJECTS
#-------------------------------------------
module "srde_folder_define_trusted_image_projects" {
  source           = "terraform-google-modules/org-policy/google"
  version          = "~> 3.0.2"
  constraint       = "constraints/compute.trustedImageProjects"
  policy_type      = "list"
  policy_for       = "folder"
  folder_id        = local.srde_folder_id
  enforce          = null
  exclude_folders  = []
  exclude_projects = []
  # allow             = var.srde_folder_define_trusted_image_projects
  allow = local.srde_folder_define_trusted_image_projects
  # allow_list_length = length(var.srde_folder_define_trusted_image_projects)
  allow_list_length = length(local.srde_folder_define_trusted_image_projects)
}

#--------------------------
# SRDE FOLDER SHIELDED VMs
#--------------------------
module "srde_folder_shielded_vms" {
  source           = "terraform-google-modules/org-policy/google"
  version          = "~> 3.0.2"
  constraint       = "constraints/compute.requireShieldedVm"
  policy_type      = "boolean"
  policy_for       = "folder"
  folder_id        = local.srde_folder_id
  enforce          = true
  exclude_folders  = []
  exclude_projects = []
}

#-----------------------------------------------------------------------
# SRDE FOLDER DISABLE AUTOMATIC IAM GRANTS FOR DEFAULT SERVICE ACCOUNTS
#-----------------------------------------------------------------------
module "srde_folder_disable_automatic_iam_for_default_sa" {
  source           = "terraform-google-modules/org-policy/google"
  version          = "~> 3.0.2"
  constraint       = "constraints/iam.automaticIamGrantsForDefaultServiceAccounts"
  policy_type      = "boolean"
  policy_for       = "folder"
  folder_id        = local.srde_folder_id
  enforce          = true
  exclude_folders  = []
  exclude_projects = []
}

#-------------------------------------------
# SRDE FOLDER SKIP DEFAULT NETWORK CREATION
#-------------------------------------------
module "srde_folder_skip_default_network_creation" {
  source           = "terraform-google-modules/org-policy/google"
  version          = "~> 3.0.2"
  constraint       = "constraints/compute.skipDefaultNetworkCreation"
  policy_type      = "boolean"
  policy_for       = "folder"
  folder_id        = local.srde_folder_id
  enforce          = true
  exclude_folders  = []
  exclude_projects = []
}

#------------------------------------------------------------
# SRDE FOLDER ENFORCE PUBLIC ACCESS PREVENTION ON GCS BUCKETS
#------------------------------------------------------------

module "srde_folder_enforce_public_access_prevention" {
  source           = "terraform-google-modules/org-policy/google"
  version          = "~> 3.0.2"
  constraint       = "constraints/storage.publicAccessPrevention"
  policy_type      = "boolean"
  policy_for       = "folder"
  folder_id        = local.srde_folder_id
  enforce          = true
  exclude_projects = var.srde_folder_disable_public_access_prevention_projects
}

#------------------------------------------------
# SRDE FOLDER ENFORCE UNIFORM BUCKET LEVEL ACCESS
#------------------------------------------------

module "srde_folder_enforce_uniform_bucket_level_access" {
  source           = "terraform-google-modules/org-policy/google"
  version          = "~> 3.0.2"
  constraint       = "constraints/storage.uniformBucketLevelAccess"
  policy_type      = "boolean"
  policy_for       = "folder"
  folder_id        = local.srde_folder_id
  enforce          = true
  exclude_projects = []
}