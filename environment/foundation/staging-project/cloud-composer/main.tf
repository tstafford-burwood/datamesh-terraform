#----------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------

module "constants" {
  source = "../../../foundation/constants"
}

// SET LOCALS VALUES

locals {
  org_id                           = module.constants.value.org_id
  billing_account_id               = module.constants.value.billing_account_id
  srde_folder_id                   = module.constants.value.srde_folder_id
  staging_project_id               = module.constants.value.staging_project_id
  default_region                   = module.constants.value.staging_default_region
  #parent_access_policy_id          = module.constants.value.parent_access_policy_id  
  #cloud_composer_access_level_name = module.constants.value.cloud_composer_access_level_name
}

#----------------------------------------------------------------------------
# CLOUD COMPOSER MODULE
#----------------------------------------------------------------------------

// NULL RESOURCE TIMER
// USED FOR DISABLING ORG POLICIES AT THE PROJECT LEVEL
// NEED TIME DELAY TO ALLOW POLICY CHANGE TO PROPAGATE

resource "time_sleep" "wait_120_seconds" {

  create_duration = "120s"
  #depends_on      = [module.staging_project_shielded_vms, module.staging_project_disable_sa_creation, module.staging_project_vm_os_login]
}

#----------------------------------------------------------------------------
# CLOUD COMPOSER MODULE
#----------------------------------------------------------------------------

module "cloud_composer" {
  source = "../../../../modules/cloud_composer"

  // REQUIRED
  #composer_env_name = var.composer_env_name
  composer_env_name = format("%v-%v", var.environment, "composer-private")
  network           = var.network
  project_id        = local.staging_project_id
  subnetwork        = var.subnetwork

  // OPTIONAL
  airflow_config_overrides         = var.airflow_config_overrides
  allowed_ip_range                 = var.allowed_ip_range
  cloud_sql_ipv4_cidr              = var.cloud_sql_ipv4_cidr
  composer_service_account         = module.composer_service_account.email
  database_machine_type            = var.database_machine_type
  disk_size                        = var.disk_size
  enable_private_endpoint          = var.enable_private_endpoint
  env_variables                    = var.env_variables
  image_version                    = var.image_version
  labels                           = var.labels
  gke_machine_type                 = var.gke_machine_type
  master_ipv4_cidr                 = var.master_ipv4_cidr
  node_count                       = var.node_count
  oauth_scopes                     = var.oauth_scopes
  pod_ip_allocation_range_name     = var.pod_ip_allocation_range_name
  pypi_packages                    = var.pypi_packages
  python_version                   = var.python_version
  region                           = local.default_region
  service_ip_allocation_range_name = var.service_ip_allocation_range_name
  tags                             = var.tags
  use_ip_aliases                   = var.use_ip_aliases
  web_server_ipv4_cidr             = var.web_server_ipv4_cidr
  web_server_machine_type          = var.web_server_machine_type
  zone                             = "${local.default_region}-b"

  // SHARED VPC SUPPORT
  network_project_id = var.network_project_id
  subnetwork_region  = var.subnetwork_region

  depends_on = [module.composer_service_account]
}

#----------------------------------------------------------------------------
# CLOUD COMPOSER SERVICE ACCOUNT MODULE
#----------------------------------------------------------------------------

module "composer_service_account" {

  source = "../../../../modules/service_account"

  // REQUIRED

  project_id = local.staging_project_id

  // OPTIONAL

  billing_account_id    = local.billing_account_id
  description           = var.description
  display_name          = var.display_name
  generate_keys         = var.generate_keys
  grant_billing_role    = var.grant_billing_role
  grant_xpn_roles       = var.grant_xpn_roles
  service_account_names = var.service_account_names
  org_id                = local.org_id
  prefix                = var.prefix
  project_roles         = var.project_roles
  depends_on            = [time_sleep.wait_120_seconds]
}

#----------------------------------------------------------------------------
# FOLDER IAM MEMBER MODULE
#----------------------------------------------------------------------------

module "folder_iam_member" {
  source = "../../../../modules/iam/folder_iam"

  folder_id     = local.srde_folder_id
  iam_role_list = var.iam_role_list
  folder_member = module.composer_service_account.iam_email
  depends_on    = [module.composer_service_account]
}

#------------------------------------------------
# VPC SC ACCESS LEVELS - COMPOSER SERVICE ACCOUNT
#------------------------------------------------

// FOR COMPOSER SERVICE ACCOUNT

# module "cloud_composer_access_level_members" {
#   source = "../../../../modules/vpc_service_controls/access_levels"

#   // REQUIRED
#   #access_level_name  = var.access_level_name
#   access_level_name  = local.cloud_composer_access_level_name
#   parent_policy_name = local.parent_access_policy_id

#   // OPTIONAL - NON PREMIUM
#   combining_function       = var.combining_function
#   access_level_description = var.access_level_description
#   ip_subnetworks           = var.ip_subnetworks
#   access_level_members     = ["serviceAccount:${module.composer_service_account.email}"]
#   negate                   = var.negate
#   regions                  = var.regions
#   required_access_levels   = var.required_access_levels

#   // OPTIONAL - DEVICE POLICY (PREMIUM FEATURE)
#   allowed_device_management_levels = var.allowed_device_management_levels
#   allowed_encryption_statuses      = var.allowed_encryption_statuses
#   minimum_version                  = var.minimum_version
#   os_type                          = var.os_type
#   require_corp_owned               = var.require_corp_owned
#   require_screen_lock              = var.require_screen_lock
#   depends_on                       = [module.composer_service_account]
# }

// THE BELOW POLICIES ARE LISTED HERE TO DISABLE THEN RE-ENABLE DURING CLOUD BUILD PIPELINE RUNS
// THESE POLICIES ARE ALSO APPLIED AT THE SRDE FOLDER LEVEL IN THE `../..srde-folder-policies` DIRECTORY

#-----------------------------------------
# STAGING PROJECT SERVICE ACCOUNT CREATION
#-----------------------------------------

# module "staging_project_disable_sa_creation" {
#   source      = "terraform-google-modules/org-policy/google"
#   version     = "~> 3.0.2"
#   constraint  = "constraints/iam.disableServiceAccountCreation"
#   policy_type = "boolean"
#   policy_for  = "project"
#   project_id  = local.staging_project_id
#   enforce     = var.enforce_staging_project_disable_sa_creation
# }

#-----------------------------------------
# STAGING PROJECT REQUIRE OS LOGIN FOR VMs
#-----------------------------------------

# module "staging_project_vm_os_login" {
#   source      = "terraform-google-modules/org-policy/google"
#   version     = "~> 3.0.2"
#   constraint  = "constraints/compute.requireOsLogin"
#   policy_type = "boolean"
#   policy_for  = "project"
#   project_id  = local.staging_project_id
#   enforce     = var.enforce_staging_project_vm_os_login
# }

#-----------------------------
# STAGING PROJECT SHIELDED VMs
#-----------------------------

# module "staging_project_shielded_vms" {
#   source      = "terraform-google-modules/org-policy/google"
#   version     = "~> 3.0.2"
#   constraint  = "constraints/compute.requireShieldedVm"
#   policy_type = "boolean"
#   policy_for  = "project"
#   project_id  = local.staging_project_id
#   enforce     = var.enforce_staging_project_shielded_vms
# }