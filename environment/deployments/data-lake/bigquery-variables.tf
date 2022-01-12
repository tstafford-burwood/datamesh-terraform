#----------------------------------------
# BIGQUERY VARIABLES - DATA LAKE PROJECT
#----------------------------------------

// REQUIRED VARIABLES

variable "data_lake_bq_dataset_id" {
  description = "Unique ID for the dataset being provisioned."
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "data_lake_bq_dataset_access" {
  description = "An array of objects that define dataset access for one or more entities."
  type        = any

  # At least one owner access is required.
  default = [{
    role           = "roles/bigquery.dataOwner"
    group_by_email = ""
  }]
}

variable "data_lake_bq_dataset_labels" {
  description = "Key value pairs in a map for dataset labels."
  type        = map(string)
  default     = {}
}

variable "data_lake_bq_dataset_name" {
  description = "Friendly name for the dataset being provisioned."
  type        = string
  default     = ""
}

variable "data_lake_bq_default_table_expiration_ms" {
  description = "TTL of tables using the dataset in milliseconds."
  type        = number
  default     = null
}

variable "data_lake_bq_delete_contents_on_destroy" {
  description = "If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = true
}

variable "data_lake_bq_bigquery_deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the instance will fail."
  type        = bool
  default     = false
}

variable "data_lake_bq_dataset_description" {
  description = "Bigquery dataset description."
  type        = string
  default     = ""
}

variable "data_lake_bq_encryption_key" {
  description = "Default encryption key to apply to the dataset. Defaults to null (Google-managed)."
  type        = string
  default     = null
}

variable "data_lake_bq_external_tables" {
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

variable "data_lake_bq_location" {
  description = "The regional location for the dataset. Only US and EU are allowed in module."
  type        = string
  default     = ""
}

variable "data_lake_bq_routines" {
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

variable "data_lake_bq_tables" {
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

variable "data_lake_bq_views" {
  description = "A list of objects which include table_id, which is view id, and view query."
  type = list(object({
    view_id        = string,
    query          = string,
    use_legacy_sql = bool,
    labels         = map(string),
  }))
  default = []
}

#------------------------------------------------------------
# BIGQUERY VARIABLES - STAGING DATA LAKE INGRESS
#------------------------------------------------------------

// REQUIRED VARIABLES

variable "staging_data_lake_ingress_bq_dataset_id" {
  description = "Unique ID for the dataset being provisioned."
  type        = string
  default     = ""
}

// OPTIONAL VARIABLES

variable "staging_data_lake_ingress_bq_dataset_access" {
  description = "An array of objects that define dataset access for one or more entities."
  type        = any

  # At least one owner access is required.
  default = [{
    role           = "roles/bigquery.dataOwner"
    group_by_email = ""
  }]
}

variable "staging_data_lake_ingress_bq_dataset_labels" {
  description = "Key value pairs in a map for dataset labels."
  type        = map(string)
  default     = {}
}

variable "staging_data_lake_ingress_bq_dataset_name" {
  description = "Friendly name for the dataset being provisioned."
  type        = string
  default     = ""
}

variable "staging_data_lake_ingress_bq_default_table_expiration_ms" {
  description = "TTL of tables using the dataset in milliseconds."
  type        = number
  default     = null
}

variable "staging_data_lake_ingress_bq_delete_contents_on_destroy" {
  description = "If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = true
}

variable "staging_data_lake_ingress_bq_bigquery_deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the instance will fail."
  type        = bool
  default     = false
}

variable "staging_data_lake_ingress_bq_dataset_description" {
  description = "Bigquery dataset description."
  type        = string
  default     = ""
}

variable "staging_data_lake_ingress_bq_encryption_key" {
  description = "Default encryption key to apply to the dataset. Defaults to null (Google-managed)."
  type        = string
  default     = null
}

variable "staging_data_lake_ingress_bq_external_tables" {
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

variable "staging_data_lake_ingress_bq_location" {
  description = "The regional location for the dataset. Only US and EU are allowed in module."
  type        = string
  default     = ""
}

variable "staging_data_lake_ingress_bq_routines" {
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

variable "staging_data_lake_ingress_bq_tables" {
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

variable "staging_data_lake_ingress_bq_views" {
  description = "A list of objects which include table_id, which is view id, and view query."
  type = list(object({
    view_id        = string,
    query          = string,
    use_legacy_sql = bool,
    labels         = map(string),
  }))
  default = []
}