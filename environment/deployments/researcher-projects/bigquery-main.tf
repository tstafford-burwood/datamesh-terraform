//
// LOCAL.STAGING_PROJECT_ID IS SET IN MAIN.TF OF THIS WORKING DIRECTORY
//

// THIS MODULE IS FOR A BQ DATASET FOR THE RESEARCHER IN THE STAGING PROJECT

#----------------------------------------------------------
# BIGQUERY DATASET - RESEARCHER DLP RESULTS STAGING PROJECT
#----------------------------------------------------------

module "bigquery_researcher_dlp" {
  source = "../../../modules/bigquery"

  // REQUIRED

  dataset_id = var.bq_researcher_dlp_dataset_id
  project_id = local.staging_project_id

  // OPTIONAL

  bigquery_access              = var.bq_researcher_dlp_bigquery_access
  dataset_labels               = var.bq_researcher_dlp_dataset_labels
  dataset_name                 = var.bq_researcher_dlp_dataset_name
  default_table_expiration_ms  = var.bq_researcher_dlp_default_table_expiration_ms
  delete_contents_on_destroy   = var.bq_researcher_dlp_delete_contents_on_destroy
  bigquery_deletion_protection = var.bq_researcher_dlp_bigquery_deletion_protection
  bigquery_description         = var.bq_researcher_dlp_bigquery_description
  encryption_key               = var.bq_researcher_dlp_encryption_key
  external_tables              = var.bq_researcher_dlp_external_tables
  location                     = var.bq_researcher_dlp_location
  routines                     = var.bq_researcher_dlp_routines
  tables                       = var.bq_researcher_dlp_tables
  views                        = var.bq_researcher_dlp_views
}

// THIS MODULE IS FOR A BQ DATASET IN THE RESEARCHER WORKSPACE PROJECT

#----------------------------------------
# BIGQUERY DATASET - RESEARCHER WORKSPACE
#----------------------------------------

module "bigquery_researcher_workspace" {
  source = "../../../modules/bigquery"

  // REQUIRED

  dataset_id = var.bq_workspace_dataset_id
  project_id = module.researcher-workspace-project.project_id

  // OPTIONAL

  bigquery_access              = var.bq_workspace_bigquery_access
  dataset_labels               = var.bq_workspace_dataset_labels
  dataset_name                 = var.bq_workspace_dataset_name
  default_table_expiration_ms  = var.bq_workspace_default_table_expiration_ms
  delete_contents_on_destroy   = var.bq_workspace_delete_contents_on_destroy
  bigquery_deletion_protection = var.bq_workspace_bigquery_deletion_protection
  bigquery_description         = var.bq_workspace_bigquery_description
  encryption_key               = var.bq_workspace_encryption_key
  external_tables              = var.bq_workspace_external_tables
  location                     = var.bq_workspace_location
  routines                     = var.bq_workspace_routines
  tables                       = var.bq_workspace_tables
  views                        = var.bq_workspace_views
}