#------------------------------------------------------------------------
# VPC Bridges
# Requests between service perimeters must have a bridge between them
# Build a bridge between the tenant/workspace and the data lake
# https://cloud.google.com/vpc-service-controls/docs/troubleshooting#requests-between-perimeters
#------------------------------------------------------------------------

module "bridge_service_perimeter_1" {
  # Build a bridge between two service perimeters.
  source         = "terraform-google-modules/vpc-service-controls/google//modules/bridge_service_perimeter"
  policy         = local.parent_access_policy_id
  perimeter_name = format("%s_bridge_foundation_%s", local.environment[terraform.workspace], lower(replace(var.researcher_workspace_name, "-", "")))
  description    = "Research bridge to Foundation - Terraform managed"

  resources = [
    local.workspace, local.data_ops, local.data_lake, local.egress
  ]

  depends_on = [
    module.regular_service_perimeter_1
  ]
}

module "bridge_service_perimeter_2" {
  # Build a bridge between two service perimeters.
  source         = "terraform-google-modules/vpc-service-controls/google//modules/bridge_service_perimeter"
  policy         = local.parent_access_policy_id
  perimeter_name = format("%s_bridge_image_prj_%s", local.environment[terraform.workspace], lower(replace(var.researcher_workspace_name, "-", "")))
  description    = "Research bridge to Imaging Project - Terraform managed"

  resources = [
    local.image_project, local.workspace
  ]

  depends_on = [
    module.regular_service_perimeter_1
  ]
}