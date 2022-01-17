#------------------------------------------------------------------------
# IMPORT CONSTANTS
#------------------------------------------------------------------------

module "constants" {
  source = "../constants"
}


#------------------------------------------------------------------------
# SET LOCALS
#------------------------------------------------------------------------

locals {
  suffix           = var.suffix == "" ? "" : "-${var.suffix}"
  parent_folder_id = module.constants.value.parent_folder_id
}


# Foundation
resource "google_folder" "foundation_sde" {
  display_name = "Foundation SDE"
  parent       = local.parent_folder_id
}

# Deployments
resource "google_folder" "deployments_sde_parent" {
  display_name = "Deployments SDE"
  parent       = local.parent_folder_id
}

# Researcher Workspaces
resource "google_folder" "researcher-workspaces" {
  for_each = toset(var.researcher_workspace_names)
  display_name = "${each.value}${local.suffix}"
  parent       = google_folder.deployments_sde_parent.name
}
