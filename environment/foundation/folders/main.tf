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
resource "google_folder" "foundation-sde" {
  display_name = "Foundation"
  parent       = local.parent_folder_id
}

# Deployments
resource "google_folder" "researcher-workspaces-parent" {
  display_name = "Researcher Workspaces"
  parent       = local.parent_folder_id
}

# Group 2 Folder
resource "google_folder" "researcher-workspaces" {
  for_each = toset(var.researcher_workspace_names)
  display_name = "${each.value}${local.suffix}"
  parent       = google_folder.researcher-workspaces-parent.name
}
