#--------------------------------------------------------------------
# BIGQUERY DATASET - RESEARCHER DLP RESULTS STAGING PROJECT VARIABLES
#--------------------------------------------------------------------

// REQUIRED VARIABLES

variable "bq_researcher_dlp_dataset_id" {
  description = "Unique ID for the dataset being provisioned."
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "bq_researcher_dlp_bigquery_access" {
  description = "An array of objects that define dataset access for one or more entities."
  type        = any

  # At least one owner access is required.
  default = [{
    role           = "roles/bigquery.dataOwner"
    group_by_email = ""
  }]
}

variable "bq_researcher_dlp_dataset_labels" {
  description = "Key value pairs in a map for dataset labels."
  type        = map(string)
  default     = {}
}

variable "bq_researcher_dlp_dataset_name" {
  description = "Friendly name for the dataset being provisioned."
  type        = string
  default     = ""
}

variable "bq_researcher_dlp_default_table_expiration_ms" {
  description = "TTL of tables using the dataset in milliseconds."
  type        = number
  default     = null
}

variable "bq_researcher_dlp_delete_contents_on_destroy" {
  description = "If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = true
}

variable "bq_researcher_dlp_bigquery_deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the instance will fail."
  type        = bool
  default     = false
}

variable "bq_researcher_dlp_bigquery_description" {
  description = "Bigquery dataset description."
  type        = string
  default     = ""
}

variable "bq_researcher_dlp_encryption_key" {
  description = "Default encryption key to apply to the dataset. Defaults to null (Google-managed)."
  type        = string
  default     = null
}

variable "bq_researcher_dlp_external_tables" {
  description = "A list of objects which include table_id, expiration_time, external_data_configuration, and labels."
  type = list(object({
    table_id              = string,
    autodetect            = bool,
    compression           = string,
    ignore_unknown_values = bool,
    max_bad_records       = number,
    schema                = string,
    source_format         = string,
    source_uris           = list(string),
    csv_options = object({
      quote                 = string,
      allow_jagged_rows     = bool,
      allow_quoted_newlines = bool,
      encoding              = string,
      field_delimiter       = string,
      skip_leading_rows     = number,
    }),
    google_sheets_options = object({
      range             = string,
      skip_leading_rows = number,
    }),
    hive_partitioning_options = object({
      mode              = string,
      source_uri_prefix = string,
    }),
    expiration_time = string,
    labels          = map(string),
  }))
  default = []
}

variable "bq_researcher_dlp_location" {
  description = "The regional location for the dataset. Only US and EU are allowed in module."
  type        = string
  default     = ""
}

variable "bq_researcher_dlp_routines" {
  description = "A list of objects which include routine_id, routine_type, routine_language, definition_body, return_type, routine_description and arguments."
  type = list(object({
    routine_id      = string,
    routine_type    = string,
    language        = string,
    definition_body = string,
    return_type     = string,
    description     = string,
    arguments = list(object({
      name          = string,
      data_type     = string,
      argument_kind = string,
      mode          = string,
    })),
  }))
  default = []
}

variable "bq_researcher_dlp_tables" {
  description = "A list of objects which include table_id, schema, clustering, time_partitioning, range_partitioning, expiration_time and labels."
  type = list(object({
    table_id   = string,
    schema     = string,
    clustering = list(string),
    time_partitioning = object({
      expiration_ms            = string,
      field                    = string,
      type                     = string,
      require_partition_filter = bool,
    }),
    range_partitioning = object({
      field = string,
      range = object({
        start    = string,
        end      = string,
        interval = string,
      }),
    }),
    expiration_time = string,
    labels          = map(string),
  }))
  default = []
}

variable "bq_researcher_dlp_views" {
  description = "A list of objects which include table_id, which is view id, and view query."
  type = list(object({
    view_id        = string,
    query          = string,
    use_legacy_sql = bool,
    labels         = map(string),
  }))
  default = []
}

#--------------------------------------------------------------------
# BIGQUERY DATASET - RESEARCHER DLP RESULTS STAGING PROJECT VARIABLES
#--------------------------------------------------------------------

// REQUIRED VARIABLES

variable "bq_workspace_dataset_id" {
  description = "Unique ID for the dataset being provisioned."
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "bq_workspace_bigquery_access" {
  description = "An array of objects that define dataset access for one or more entities."
  type        = any

  # At least one owner access is required.
  default = [{
    role           = "roles/bigquery.dataOwner"
    group_by_email = ""
  }]
}

variable "bq_workspace_dataset_labels" {
  description = "Key value pairs in a map for dataset labels."
  type        = map(string)
  default     = {}
}

variable "bq_workspace_dataset_name" {
  description = "Friendly name for the dataset being provisioned."
  type        = string
  default     = ""
}

variable "bq_workspace_default_table_expiration_ms" {
  description = "TTL of tables using the dataset in milliseconds."
  type        = number
  default     = null
}

variable "bq_workspace_delete_contents_on_destroy" {
  description = "If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = true
}

variable "bq_workspace_bigquery_deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the instance will fail."
  type        = bool
  default     = false
}

variable "bq_workspace_bigquery_description" {
  description = "Bigquery dataset description."
  type        = string
  default     = ""
}

variable "bq_workspace_encryption_key" {
  description = "Default encryption key to apply to the dataset. Defaults to null (Google-managed)."
  type        = string
  default     = null
}

variable "bq_workspace_external_tables" {
  description = "A list of objects which include table_id, expiration_time, external_data_configuration, and labels."
  type = list(object({
    table_id              = string,
    autodetect            = bool,
    compression           = string,
    ignore_unknown_values = bool,
    max_bad_records       = number,
    schema                = string,
    source_format         = string,
    source_uris           = list(string),
    csv_options = object({
      quote                 = string,
      allow_jagged_rows     = bool,
      allow_quoted_newlines = bool,
      encoding              = string,
      field_delimiter       = string,
      skip_leading_rows     = number,
    }),
    google_sheets_options = object({
      range             = string,
      skip_leading_rows = number,
    }),
    hive_partitioning_options = object({
      mode              = string,
      source_uri_prefix = string,
    }),
    expiration_time = string,
    labels          = map(string),
  }))
  default = []
}

variable "bq_workspace_location" {
  description = "The regional location for the dataset. Only US and EU are allowed in module."
  type        = string
  default     = ""
}

variable "bq_workspace_routines" {
  description = "A list of objects which include routine_id, routine_type, routine_language, definition_body, return_type, routine_description and arguments."
  type = list(object({
    routine_id      = string,
    routine_type    = string,
    language        = string,
    definition_body = string,
    return_type     = string,
    description     = string,
    arguments = list(object({
      name          = string,
      data_type     = string,
      argument_kind = string,
      mode          = string,
    })),
  }))
  default = []
}

variable "bq_workspace_tables" {
  description = "A list of objects which include table_id, schema, clustering, time_partitioning, range_partitioning, expiration_time and labels."
  type = list(object({
    table_id   = string,
    schema     = string,
    clustering = list(string),
    time_partitioning = object({
      expiration_ms            = string,
      field                    = string,
      type                     = string,
      require_partition_filter = bool,
    }),
    range_partitioning = object({
      field = string,
      range = object({
        start    = string,
        end      = string,
        interval = string,
      }),
    }),
    expiration_time = string,
    labels          = map(string),
  }))
  default = []
}

variable "bq_workspace_views" {
  description = "A list of objects which include table_id, which is view id, and view query."
  type = list(object({
    view_id        = string,
    query          = string,
    use_legacy_sql = bool,
    labels         = map(string),
  }))
  default = []
}