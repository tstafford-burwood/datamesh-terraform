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
  parent_folder_id = format("%s/%s", "folders", module.constants.value.parent_folder_id)
}

#----------------------------------------------------------------------------
# SETUP FOLDER STRUCTURE
#----------------------------------------------------------------------------

# Environment Folder
resource "google_folder" "environment" {
  display_name = upper(var.environment)
  parent       = local.parent_folder_id
}

# Foundation
resource "google_folder" "foundation_sde" {
  display_name = "Foundation SDE"
  parent       = google_folder.environment.name
}

# Deployments
resource "google_folder" "deployments_sde_parent" {
  display_name = "Deployments SDE"
  parent       = google_folder.environment.name
}

# Researcher Workspaces
resource "google_folder" "researcher-workspaces" {
  for_each = toset(var.researcher_workspace_names)
  display_name = "${each.value}${local.suffix}"
  parent       = google_folder.deployments_sde_parent.name
}
