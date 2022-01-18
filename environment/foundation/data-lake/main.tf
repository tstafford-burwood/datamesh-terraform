// DATA BLOCK
// RETRIEVE STAGING PROJECT NUMBER (I.E. 1234567890)

data "terraform_remote_state" "staging_project" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/staging-project"
  }
}

#------------------
# IMPORT CONSTANTS
#------------------

module "constants" {
  source = "../constants"
}

// SET CONSTANT MODULE VALUES AS LOCALS

locals {
  org_id                           = module.constants.value.org_id
  billing_account_id               = module.constants.value.billing_account_id
  srde_folder_id                   = module.constants.value.srde_folder_id
  parent_access_policy_id          = module.constants.value.parent_access_policy_id
  cloudbuild_access_level_name     = module.constants.value.cloudbuild_access_level_name
  cloud_composer_access_level_name = module.constants.value.cloud_composer_access_level_name
  srde_admin_access_level_name     = module.constants.value.srde_admin_access_level_name
  vpc_sc_all_restricted_apis       = module.constants.value.vpc_sc_all_restricted_apis
  staging_project_id               = data.terraform_remote_state.staging_project.outputs.staging_project_id
  staging_project_number           = data.terraform_remote_state.staging_project.outputs.staging_project_number
  custom_iam_role_name = {
    custom_iam_role_name = module.datalake_iam_custom_role.name
  }
  data_lake_default_region = module.constants.value.data_lake_default_region
}

#------------------
# DATA LAKE PROJECT
#------------------

module "data-lake-project" {
  source = "../../../modules/project_factory"

  // REQUIRED FIELDS
  project_name       = format("%v-%v", var.data_lake_project_name, "data-lake")
  org_id             = local.org_id
  billing_account_id = local.billing_account_id
  folder_id          = local.srde_folder_id

  // OPTIONAL FIELDS
  activate_apis               = var.data_lake_activate_apis
  auto_create_network         = var.data_lake_auto_create_network
  create_project_sa           = var.data_lake_create_project_sa
  default_service_account     = var.data_lake_default_service_account
  disable_dependent_services  = var.data_lake_disable_dependent_services
  disable_services_on_destroy = var.data_lake_disable_services_on_destroy
  group_name                  = var.data_lake_group_name
  group_role                  = var.data_lake_group_role
  project_labels              = var.data_lake_project_labels
  lien                        = var.data_lake_lien
  random_project_id           = var.data_lake_random_project_id
}

#-----------------------------------------
# DATA LAKE PROJECT IAM CUSTOM ROLE MODULE
#-----------------------------------------

module "datalake_iam_custom_role" {
  source = "../../../modules/iam/project_iam_custom_role"

  project_iam_custom_role_project_id  = module.data-lake-project.project_id
  project_iam_custom_role_description = var.datalake_iam_custom_role_description
  project_iam_custom_role_id          = var.datalake_iam_custom_role_id
  project_iam_custom_role_title       = var.datalake_iam_custom_role_title
  project_iam_custom_role_permissions = var.datalake_iam_custom_role_permissions
  project_iam_custom_role_stage       = var.datalake_iam_custom_role_stage
  depends_on                          = [module.data-lake-project]
}

#-----------------------------------
# DATALAKE PROJECT IAM MEMBER MODULE
#-----------------------------------

resource "google_project_iam_member" "datalake_project" {

  for_each = local.custom_iam_role_name

  project    = module.data-lake-project.project_id
  role       = each.value
  member     = var.datalake_project_member
  depends_on = [module.datalake_iam_custom_role]
}

# ----------------------------------------------------
# VPC SC REGULAR SERVICE PERIMETER - DATA LAKE PROJECT
# ----------------------------------------------------

# module "data_lake_regular_service_perimeter" {
#   source = "../../../modules/vpc_service_controls/regular_service_perimeter"

#   // REQUIRED
#   regular_service_perimeter_description = var.datalake_regular_service_perimeter_description
#   regular_service_perimeter_name        = var.datalake_regular_service_perimeter_name
#   parent_policy_id                      = local.parent_access_policy_id

#   // OPTIONAL
#   access_level_names = [
#     local.cloudbuild_access_level_name,
#     local.cloud_composer_access_level_name,
#     local.srde_admin_access_level_name
#   ]
#   project_to_add_perimeter = [module.data-lake-project.project_number]
#   restricted_services      = local.vpc_sc_all_restricted_apis
#   enable_restriction       = var.datalake_enable_restriction
#   allowed_services         = var.datalake_allowed_services
#   depends_on               = [module.data-lake-project]
# }

#--------------------------------------
# VPC SC DATA LAKE ACCESS LEVELS MODULE
#--------------------------------------

# module "datalake_access_level_members" {
#   source = "../../../modules/vpc_service_controls/access_levels"

#   // REQUIRED
#   access_level_name  = var.datalake_access_level_name
#   parent_policy_name = local.parent_access_policy_id

#   // OPTIONAL - NON PREMIUM
#   combining_function       = var.datalake_combining_function
#   access_level_description = var.datalake_access_level_description
#   ip_subnetworks           = var.datalake_ip_subnetworks
#   access_level_members     = var.datalake_access_level_members
#   negate                   = var.datalake_negate
#   regions                  = var.datalake_regions
#   required_access_levels   = var.datalake_required_access_levels
# }

#----------------------------------------------------
# VPC SC DATALAKE TO STAGING PROJECT BRIDGE PERIMETER 
#----------------------------------------------------

# module "datalake_to_staging_bridge_service_perimeter" {
#   source = "../../../modules/vpc_service_controls/bridge_service_perimeter"

#   // REQUIRED

#   bridge_service_perimeter_name = var.datalake_bridge_service_perimeter_name
#   parent_policy_name            = local.parent_access_policy_id
#   bridge_service_perimeter_resources = [
#     local.staging_project_number,
#     module.data-lake-project.project_number
#   ]

#   // OPTIONAL

#   bridge_service_perimeter_description = var.datalake_bridge_service_perimeter_description
#   depends_on                           = [module.data_lake_regular_service_perimeter]
# }