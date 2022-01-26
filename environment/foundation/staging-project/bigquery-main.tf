#----------------------------------------------------------------------------
# BIGQUERY DATASET - GCS EVENTS
#----------------------------------------------------------------------------

module "bigquery_dataset_gcs_events" {
  source = "../../../modules/bigquery"

  // REQUIRED

  #dataset_id = var.gcs_events_dataset_id
  dataset_id = format("%v_%v", var.environment, "sde_gcs_events")
  project_id = module.secure-staging-project.project_id

  // OPTIONAL

  bigquery_access = var.gcs_events_bigquery_access
  dataset_labels  = { "bq-dataset" : format("%v-%v-project", var.environment, local.function) }
  #dataset_name                 = var.gcs_events_dataset_name
  dataset_name                 = format("%s_sde_gcs_events", var.environment)
  default_table_expiration_ms  = null
  delete_contents_on_destroy   = true
  bigquery_deletion_protection = false
  bigquery_description         = format("BigQuery %s Dataset created with Terraform for GCS events to be written to.", var.environment)
  encryption_key               = null
  external_tables              = []
  location                     = var.gcs_events_location
  routines                     = []
  views                        = []
  tables = [{
    table_id = "gcs_events"
    schema   = file("./bigquery-table-schema/table_schema_gcs_events.json") // LOCATED IN ./bigquery-table-schema
    time_partitioning = {
      type                     = "DAY",
      field                    = "gcs_event_ts",
      require_partition_filter = false,
      expiration_ms            = null,
    },
    range_partitioning = null
    clustering         = []
    expiration_time    = null
    labels = {
      "srde" : "gcs_events"
    }
  }]

}