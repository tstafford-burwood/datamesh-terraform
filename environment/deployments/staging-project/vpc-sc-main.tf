// CONSTANTS MODULE IMPORTED IN MAIN.TF OF THIS DIRECTORY

locals {
  parent_access_policy_id          = module.constants.value.parent_access_policy_id
  cloudbuild_access_level_name     = module.constants.value.cloudbuild_access_level_name
  cloud_composer_access_level_name = module.constants.value.cloud_composer_access_level_name // COMMENT OUT ON FIRST DEPLOYMENT OF STAGING PROJECT
  srde_admin_access_level_name     = module.constants.value.srde_admin_access_level_name
  vpc_sc_all_restricted_apis       = module.constants.value.vpc_sc_all_restricted_apis
}

#-------------------------------------
# VPC SC ACCESS LEVELS - DATA STEWARDS
#-------------------------------------

module "access_level_members" {
  source = "../../../modules/vpc_service_controls/access_levels"

  // REQUIRED
  access_level_name  = var.access_level_name
  parent_policy_name = local.parent_access_policy_id

  // OPTIONAL - NON PREMIUM
  combining_function       = var.combining_function
  access_level_description = var.access_level_description
  ip_subnetworks           = var.ip_subnetworks
  access_level_members     = var.access_level_members
  negate                   = var.negate
  regions                  = var.regions
  required_access_levels   = var.required_access_levels

  // OPTIONAL - DEVICE POLICY (PREMIUM FEATURE)
  allowed_device_management_levels = var.allowed_device_management_levels
  allowed_encryption_statuses      = var.allowed_encryption_statuses
  minimum_version                  = var.minimum_version
  os_type                          = var.os_type
  require_corp_owned               = var.require_corp_owned
  require_screen_lock              = var.require_screen_lock
}


#----------------------------------------------------------
# VPC SC REGULAR SERVICE PERIMETER - SECURE STAGING PROJECT
#----------------------------------------------------------

# TODO: Consider implementing ingress/egress rules instead of using bridges (determine whether or not this is requires too much maintenance.)

module "staging_project_regular_service_perimeter" {
  source = "../../../modules/vpc_service_controls/regular_service_perimeter"

  // REQUIRED
  regular_service_perimeter_description = var.staging_project_regular_service_perimeter_description
  regular_service_perimeter_name        = var.staging_project_regular_service_perimeter_name
  parent_policy_id                      = local.parent_access_policy_id

  // OPTIONAL

  access_level_names = compact([
    # local.srde_admin_access_level_name, // BREAK GLASS USAGE
    local.cloudbuild_access_level_name,
    module.access_level_members.name,
    try(local.cloud_composer_access_level_name, "")
  ])

  project_to_add_perimeter = [module.secure-staging-project.project_number] // NEEDS THE PROJECT NUMBER
  restricted_services      = local.vpc_sc_all_restricted_apis
  enable_restriction       = var.staging_project_enable_restriction
  allowed_services         = var.staging_project_allowed_services
}