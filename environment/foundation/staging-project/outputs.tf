#-------------------------------
# SECURE STAGING PROJECT OUTPUTS
#-------------------------------

output "staging_project_enabled_apis" {
  description = "Enabled APIs in the project"
  value       = module.secure-staging-project.enabled_apis
}

output "staging_project_id" {
  value = module.secure-staging-project.project_id
}

output "staging_project_name" {
  value = module.secure-staging-project.project_name
}

output "staging_project_number" {
  value = module.secure-staging-project.project_number
}

#-------------------------------
# STANDALONE VPC MODULE OUTPUTS
#-------------------------------

output "network_name" {
  description = "The name of the VPC being created"
  value       = module.vpc.network_name
}

output "network_self_link" {
  description = "The URI of the VPC being created"
  value       = module.vpc.network_self_link
}

output "subnets_names" {
  description = "The names of the subnets being created"
  value       = module.vpc.subnets_names
}

output "subnets_self_links" {
  description = "The self-links of subnets being created"
  value       = module.vpc.subnets_self_links
}

output "subnets_secondary_ranges" {
  description = "The secondary ranges associated with these subnets."
  value       = module.vpc.subnets_secondary_ranges
}

#----------------------
# PUB/SUB TOPIC OUTPUTS
#----------------------

output "topic_name" {
  description = "Pub/Sub topic name."
  value       = module.pub_sub_topic.topic_name
}

output "topic_labels" {
  description = "Pub/Sub label as a key:value pair."
  value       = module.pub_sub_topic.topic_labels
}

#-----------------------------
# PUB/SUB SUBSCRIPTION OUTPUTS
#-----------------------------

output "staging_pubsub_subscription_gcs_events" {
  description = "Name of the subscription."
  value       = module.pub_sub_subscription.subscription_name
}

output "subscription_labels" {
  description = "Labels applied to the subscription."
  value       = module.pub_sub_subscription.subscription_labels
}

#----------------------------------------------------------------
# SECURE STAGING PROJECT VPC SC REGULAR SERVICE PERIMETER OUTPUTS
#----------------------------------------------------------------

# output "staging_project_regular_service_perimeter_resources" {
#   description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
#   value       = module.staging_project_regular_service_perimeter.regular_service_perimeter_resources
# }

# output "staging_project_regular_service_perimeter_name" {
#   description = "The perimeter's name."
#   value       = module.staging_project_regular_service_perimeter.regular_service_perimeter_name
# }

# output "staging_project_vpc_accessible_services" {
#   description = "The API services accessible from a network within the VPC SC perimeter."
#   value       = module.staging_project_regular_service_perimeter.vpc_accessible_services
# }

#-----------------------------
# VPC SC ACCESS LEVELS OUTPUTS
#-----------------------------

# output "name" {
#   description = "Description of the AccessLevel and its use. Does not affect behavior."
#   value       = module.access_level_members.name
# }

# output "name_id" {
#   description = "The fully-qualified name of the Access Level. Format: accessPolicies/{policy_id}/accessLevels/{name}"
#   value       = module.access_level_members.name_id
# }

#--------------------------------------
# BIGQUERY DATASET - GCS EVENTS OUTPUTS
#--------------------------------------

output "staging_bq_dataset" {
  description = "Bigquery dataset resource name for GCS events."
  value       = module.bigquery_dataset_gcs_events.bigquery_dataset
}

output "staging_bigquery_tables" {
  description = "Map of bigquery table resources being provisioned."
  value       = module.bigquery_dataset_gcs_events.bigquery_tables
}

output "staging_bigquery_views" {
  description = "Map of bigquery view resources being provisioned."
  value       = module.bigquery_dataset_gcs_events.bigquery_views
}

output "staging_bigquery_external_tables" {
  description = "Map of BigQuery external table resources being provisioned."
  value       = module.bigquery_dataset_gcs_events.bigquery_external_tables
}

output "staging_bigquery_project" {
  description = "Project where the dataset and tables are created."
  value       = module.bigquery_dataset_gcs_events.project
}

output "staging_bigquery_table_ids" {
  description = "Unique ID for the table being provisioned."
  value       = module.bigquery_dataset_gcs_events.table_ids
}

output "staging_bigquery_table_names" {
  description = "Friendly name for the table being provisioned."
  value       = module.bigquery_dataset_gcs_events.table_names
}

output "staging_bigquery_view_ids" {
  description = "Unique ID for the view being provisioned."
  value       = module.bigquery_dataset_gcs_events.view_ids
}

output "staging_bigquery_view_names" {
  description = "Friendly name for the view being provisioned."
  value       = module.bigquery_dataset_gcs_events.view_names
}

output "staging_bigquery_external_table_ids" {
  description = "Unique IDs for any external tables being provisioned."
  value       = module.bigquery_dataset_gcs_events.external_table_ids
}

output "staging_bigquery_external_table_names" {
  description = "Friendly names for any external tables being provisioned."
  value       = module.bigquery_dataset_gcs_events.external_table_names
}

output "staging_bigquery_routine_ids" {
  description = "Unique IDs for any routine being provisioned."
  value       = module.bigquery_dataset_gcs_events.routine_ids
}

#----------------------------------------
# STAGING PROJECT IAM CUSTOM ROLE OUTPUTS
#----------------------------------------

output "custom_role_name" {
  description = "The name of the role in the format projects/{{project}}/roles/{{role_id}}. Like id, this field can be used as a reference in other resources such as IAM role bindings."
  value       = module.staging_project_iam_custom_role.name
}

output "custom_role_id" {
  description = "The role_id name."
  value       = module.staging_project_iam_custom_role.role_id
}