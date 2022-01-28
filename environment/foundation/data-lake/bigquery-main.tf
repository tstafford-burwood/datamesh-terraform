//
// LOCAL.STAGING_PROJECT_ID IS SET IN MAIN.TF OF THIS WORKING DIRECTORY
//

#---------------------------------------
# BIGQUERY MODULE - DATA LAKE PROJECT
#---------------------------------------

module "bigquery_data_lake" {
  source = "../../../modules/bigquery"

  // REQUIRED

  dataset_id = format("%s_%s_%s", var.environment, replace(local.function, "-", "_"), "dataset")
  project_id = module.data-lake-project.project_id

  // OPTIONAL

  bigquery_access = [
    {
      role          = "roles/bigquery.dataOwner"
      user_by_email = local.cloudbuild_service_account
    },
  ]
  dataset_labels = {
    "data_lake_name" : "data_lake_1"
  }
  dataset_name                 = format("%s-%s-%s", var.environment, local.function, "dataset-1")
  default_table_expiration_ms  = null
  delete_contents_on_destroy   = true
  bigquery_deletion_protection = false
  bigquery_description         = format("%s BigQuery Dataset created with Terraform for %s", var.environment, local.function)
  encryption_key               = null
  external_tables              = []
  location                     = "US"
  routines                     = []
  tables                       = []
  views                        = []
}

#---------------------------------------
# BIGQUERY MODULE - STAGING PROJECT
#---------------------------------------

module "bigquery_staging_data_lake_ingress" {
  source = "../../../modules/bigquery"

  // REQUIRED

  dataset_id = format("%s_%s", lower(var.environment), "staging_data_lake_ingress_dataset_1")
  project_id = local.staging_project_id

  // OPTIONAL

  bigquery_access = [
    {
      role          = "roles/bigquery.dataOwner"
      user_by_email = local.cloudbuild_service_account
    },
  ]
  dataset_labels               = { "data_lake_name" : "data_lake_1" }
  dataset_name                 = format("%s-%s", lower(var.environment), "staging-data-lake-ingress-dataset-1")
  default_table_expiration_ms  = null
  delete_contents_on_destroy   = true
  bigquery_deletion_protection = false
  bigquery_description         = format("%s BigQuery Dataset created with Terraform for %s", var.environment, local.function)
  encryption_key               = null
  external_tables              = []
  location                     = "US"
  routines                     = []
  tables                       = []
  views                        = []
}