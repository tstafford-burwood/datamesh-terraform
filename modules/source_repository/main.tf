#--------------------------------------
# GOOGLE CLOUD SOURCE REPOSITORY MODULE
#--------------------------------------

resource "google_sourcerepo_repository" "source_repository" {
  name    = var.cloud_source_repo_name
  project = var.cloud_source_repo_project_id
}