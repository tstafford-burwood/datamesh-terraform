#------------------------------
# BIGQUERY DATASET - GCS EVENTS
#------------------------------

module "bigquery_dataset_gcs_events" {
  source = "../../../modules/bigquery"

  // REQUIRED

  dataset_id = var.gcs_events_dataset_id
  project_id = module.secure-staging-project.project_id

  // OPTIONAL

  bigquery_access              = var.gcs_events_bigquery_access
  dataset_labels               = var.gcs_events_dataset_labels
  dataset_name                 = var.gcs_events_dataset_name
  default_table_expiration_ms  = var.gcs_events_default_table_expiration_ms
  delete_contents_on_destroy   = var.gcs_events_delete_contents_on_destroy
  bigquery_deletion_protection = var.gcs_events_bigquery_deletion_protection
  bigquery_description         = var.gcs_events_bigquery_description
  encryption_key               = var.gcs_events_encryption_key
  external_tables              = var.gcs_events_external_tables
  location                     = var.gcs_events_location
  routines                     = var.gcs_events_routines
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
  views = var.gcs_events_views
}