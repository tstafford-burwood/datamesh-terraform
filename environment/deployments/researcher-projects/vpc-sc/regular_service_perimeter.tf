#------------------------------------------------------------------------
# VPC Perimeters
#------------------------------------------------------------------------

module "regular_service_perimeter_1" {
  source         = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version        = "~>4.0"
  policy         = local.parent_access_policy_id
  perimeter_name = format("%s_%s", local.environment[terraform.workspace], lower(replace(var.researcher_workspace_name, "-", "")))
  description    = "Perimeter shielding researcher projects - Terraform Managed"
  resources      = [local.workspace, local.egress]

  # Grant the service accounts, like cloud build, to access project through perimeter
  # Note: To remove an access level, first remove the binding between perimeter and the access level. IE, remove the access module from the access level
  #access_levels = local.access_levels # change value to [local.fdn_sa] to remove binding from access_level_users
  access_levels = [module.access_level_users[0].name]

  restricted_services     = ["storage.googleapis.com", "run.googleapis.com", "bigquery.googleapis.com", "bigtable.googleapis.com", "cloudbuild.googleapis.com", "storage.googleapis.com", "aiplatform.googleapis.com", "sqladmin.googleapis.com", "pubsub.googleapis.com", "container.googleapis.com", "artifactregistry.googleapis.com"]
  vpc_accessible_services = ["notebooks.googleapis.com", "compute.googleapis.com", "storage.googleapis.com", "artifactregistry.googleapis.com", "logging.googleapis.com", "monitoring.googleapis.com"]
  ingress_policies        = []
  egress_policies = [{
    "from" = {
      "identity_type" = "ANY_SERVICE_ACCOUNT"
      "identities"    = []
    },
    "to" = {
      "resources" = ["*"]
      "operations" = {
        "artifactregistry.googleapis.com" = {
          "methods" = ["*"]
        }
      }
    }
  }, ]
}
