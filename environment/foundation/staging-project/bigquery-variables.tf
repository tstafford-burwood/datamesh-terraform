#----------------------------------------
# BIGQUERY DATASET - GCS EVENTS VARIABLES
#----------------------------------------

variable "gcs_events_bigquery_access" {
  description = "An array of objects that define dataset access for one or more entities."
  type        = any

  # At least one owner access is required.
  default = [{
    # role           = "roles/bigquery.dataOwner"
    # group_by_email = ""
  }]
}

variable "gcs_events_location" {
  description = "The regional location for the dataset. Only US and EU are allowed in module."
  type        = string
  default     = "US"
}