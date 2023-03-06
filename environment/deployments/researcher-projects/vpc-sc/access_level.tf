locals {
  pe_1_acclvl   = compact([local.fdn_sa])
  access_levels = length(var.external_users_vpc) > 0 ? [local.fdn_sa, module.access_level_users[0].name] : [local.fdn_sa]
}

module "access_level_users" {
  count   = length(var.external_users_vpc) > 0 ? 1 : 0
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 4.0"

  policy         = local.parent_access_policy_id
  name           = format("sde_%s_%s_users", local.environment[terraform.workspace], lower(replace(var.researcher_workspace_name, "-", "")))
  regions        = ["US"]
  ip_subnetworks = []
  members        = var.external_users_vpc
}