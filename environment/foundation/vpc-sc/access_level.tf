locals {
  # Note: to remove an access level, first remove the binding between perimeter and access level in `local.fnd_pe_0_acclvl`, `fnd_pe_1_acclvl` without
  # removing the access level itself. Once you run `terraform apply`, you'll then be able to remove the access level and run
  # `terraform apply` again.

  acl_admins   = length(module.constants.value.vpc_sc_admins) > 0 ? module.access_level_admins[0].name : ""
  acl_stewards = length(module.constants.value.vpc_sc_stewards) > 0 ? module.access_level_stewards[0].name : ""

  fnd_pe_0_acclvl = compact([module.access_level_service-accounts.name, local.acl_admins]) # foundation_perimeter_0 access_levels
  fnd_pe_1_acclvl = compact([module.access_level_service-accounts.name, local.acl_admins]) # foundation_perimeter_1 access_levels
}

module "access_level_admins" {
  count   = length(module.constants.value.vpc_sc_admins) > 0 ? 1 : 0
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 4.0"

  policy         = var.parent_access_policy_id
  name           = "sde_${local.environment[terraform.workspace]}_admins"
  members        = module.constants.value.vpc_sc_admins
  regions        = ["US"] # Additional regions can be added
  ip_subnetworks = var.ip_subnetworks_admins
}

module "access_level_stewards" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 4.0"

  policy = var.parent_access_policy_id
  name   = "sde_${local.environment[terraform.workspace]}_stewards"
  #members        = module.constants.value.vpc_sc_stewards
  members        = local.acclvl_stewards
  regions        = ["US"]
  ip_subnetworks = var.ip_subnetworks_stewards
}

module "access_level_service-accounts" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 4.0"

  policy  = var.parent_access_policy_id
  name    = "sde_${local.environment[terraform.workspace]}_cloudbuild"
  members = local.acclvl_sa
}