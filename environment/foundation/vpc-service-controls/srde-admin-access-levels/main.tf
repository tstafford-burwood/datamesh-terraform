#------------------
# IMPORT CONSTANTS
#------------------

module "constants" {
  source = "../../constants"
}

// SET LOCAL VALUES

locals {
  parent_access_policy_id      = module.constants.value.parent_access_policy_id
  srde_admin_access_level_name = module.constants.value.srde_admin_access_level_name
}

#-----------------------------
# VPC SC ACCESS LEVELS MODULE
#-----------------------------

module "access_level_members" {
  source = "../../../../modules/vpc_service_controls/access_levels"

  // REQUIRED
  # access_level_name  = var.access_level_name
  access_level_name  = local.srde_admin_access_level_name
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