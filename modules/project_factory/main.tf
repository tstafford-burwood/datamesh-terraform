#-----------------
# PROJECT FACTORY
#-----------------

module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

  // REQUIRED FIELDS
  name            = var.project_name
  billing_account = var.billing_account_id
  folder_id       = var.folder_id
  org_id          = var.org_id

  // OPTIONAL FIELDS
  activate_apis               = var.activate_apis
  auto_create_network         = var.auto_create_network
  create_project_sa           = var.create_project_sa
  default_service_account     = var.default_service_account
  disable_dependent_services  = var.disable_dependent_services
  disable_services_on_destroy = var.disable_services_on_destroy
  group_name                  = var.group_name
  group_role                  = var.group_role
  labels                      = var.project_labels
  lien                        = var.lien
  random_project_id           = var.random_project_id
}