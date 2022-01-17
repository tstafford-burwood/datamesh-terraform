#----------------------------------------------------------------------------------------------
# DATA EGRESS - PROJECT
#----------------------------------------------------------------------------------------------

module "researcher-data-egress-project" {
  source = "../../../modules/project_factory"

  // REQUIRED FIELDS
  project_name       = format("%v-%v", local.researcher_workspace_name, "data-egress")
  org_id             = local.org_id
  billing_account_id = local.billing_account_id
  folder_id          = local.srde_folder_id

  // OPTIONAL FIELDS
  activate_apis               = ["storage.googleapis.com"]
  auto_create_network         = false
  create_project_sa           = false
  lien                        = false
  random_project_id           = true
  default_service_account     = var.egress_default_service_account
  disable_dependent_services  = true
  disable_services_on_destroy = true
  project_labels = {
    "researcher-workspace" : "${local.researcher_workspace_name}-egress-project"
  }
}

resource "google_compute_project_metadata" "researcher_egress_project" {
  project = module.researcher-data-egress-project.project_id
  metadata = {
    enable-osconfig = "TRUE",
    enable-oslogin  = "TRUE"
  }
}