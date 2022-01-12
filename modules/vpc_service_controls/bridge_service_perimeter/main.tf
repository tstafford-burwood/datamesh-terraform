#-------------------------------
# VPC SC BRIDGE PERIMETER MODULE
#-------------------------------

module "bridge_service_perimeter" {
  source = "terraform-google-modules/vpc-service-controls/google//modules/bridge_service_perimeter"

  // REQUIRED

  perimeter_name = var.bridge_service_perimeter_name
  policy         = var.parent_policy_name
  resources      = var.bridge_service_perimeter_resources

  // OPTIONAL

  description = var.bridge_service_perimeter_description
}