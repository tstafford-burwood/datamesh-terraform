//
// LOCAL.STAGING_PROJECT_ID IS SET IN MAIN.TF OF THIS WORKING DIRECTORY
//

#---------------------------------------
# BIGQUERY MODULE - DATA LAKE PROJECT
#---------------------------------------

module "bigquery_data_lake" {
  source = "../../../../modules/bigquery"

  // REQUIRED

  dataset_id = var.data_lake_bq_dataset_id
  project_id = module.data-lake-project.project_id

  // OPTIONAL

  bigquery_access = [
    {
      role          = "roles/bigquery.dataOwner"
      user_by_email = module.constants.value.cloudbuild_service_account
    },
  ]
  dataset_labels               = var.data_lake_bq_dataset_labels
  dataset_name                 = var.data_lake_bq_dataset_name
  default_table_expiration_ms  = var.data_lake_bq_default_table_expiration_ms
  delete_contents_on_destroy   = var.data_lake_bq_delete_contents_on_destroy
  bigquery_deletion_protection = var.data_lake_bq_bigquery_deletion_protection
  bigquery_description         = var.data_lake_bq_dataset_description
  encryption_key               = var.data_lake_bq_encryption_key
  external_tables              = var.data_lake_bq_external_tables
  location                     = var.data_lake_bq_location
  routines                     = var.data_lake_bq_routines
  tables                       = var.data_lake_bq_tables
  views                        = var.data_lake_bq_views
}

#---------------------------------------
# BIGQUERY MODULE - STAGING PROJECT
#---------------------------------------

module "bigquery_staging_data_lake_ingress" {
  source = "../../../../modules/bigquery"

  // REQUIRED

  dataset_id = var.staging_data_lake_ingress_bq_dataset_id
  project_id = local.staging_project_id

  // OPTIONAL

  bigquery_access = [
    {
      role          = "roles/bigquery.dataOwner"
      user_by_email = module.constants.value.cloudbuild_service_account
    },
  ]
  dataset_labels               = var.staging_data_lake_ingress_bq_dataset_labels
  dataset_name                 = var.staging_data_lake_ingress_bq_dataset_name
  default_table_expiration_ms  = var.staging_data_lake_ingress_bq_default_table_expiration_ms
  delete_contents_on_destroy   = var.staging_data_lake_ingress_bq_delete_contents_on_destroy
  bigquery_deletion_protection = var.staging_data_lake_ingress_bq_bigquery_deletion_protection
  bigquery_description         = var.staging_data_lake_ingress_bq_dataset_description
  encryption_key               = var.staging_data_lake_ingress_bq_encryption_key
  external_tables              = var.staging_data_lake_ingress_bq_external_tables
  location                     = var.staging_data_lake_ingress_bq_location
  routines                     = var.staging_data_lake_ingress_bq_routines
  tables                       = var.staging_data_lake_ingress_bq_tables
  views                        = var.staging_data_lake_ingress_bq_views
}