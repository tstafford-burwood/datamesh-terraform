#-----------------------------
# VPC SC ACCESS LEVELS MODULE
#-----------------------------

module "access_level_members" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "3.0.1"

  // REQUIRED
  name   = var.access_level_name
  policy = var.parent_policy_name

  // OPTIONAL - NON PREMIUM
  combining_function     = var.combining_function
  description            = var.access_level_description
  ip_subnetworks         = var.ip_subnetworks
  members                = var.access_level_members
  negate                 = var.negate
  regions                = var.regions
  required_access_levels = var.required_access_levels

  // OPTIONAL - DEVICE POLICY (PREMIUM FEATURE)
  allowed_device_management_levels = var.allowed_device_management_levels
  allowed_encryption_statuses      = var.allowed_encryption_statuses
  minimum_version                  = var.minimum_version
  os_type                          = var.os_type
  require_corp_owned               = var.require_corp_owned
  require_screen_lock              = var.require_screen_lock
}