#-------------------------------------
# RESEARCHER WORKSPACE PROJECT OUTPUTS
#-------------------------------------

output "data_lake_enabled_apis" {
  description = "Enabled APIs in the project"
  value       = module.data-lake-project.enabled_apis
}

output "data_lake_project_id" {
  value = module.data-lake-project.project_id
}

output "data_lake_project_name" {
  value = module.data-lake-project.project_name
}

output "data_lake_project_number" {
  value = module.data-lake-project.project_number
}

#----------------------------------
# DATA LAKE IAM CUSTOM ROLE OUTPUTS
#----------------------------------

output "custom_role_name" {
  description = "The name of the role in the format projects/{{project}}/roles/{{role_id}}. Like id, this field can be used as a reference in other resources such as IAM role bindings."
  value       = module.datalake_iam_custom_role.name
}

output "custom_role_id" {
  description = "The role_id name."
  value       = module.datalake_iam_custom_role.role_id
}

#-------------------
# GCS BUCKET OUTPUTS
#-------------------

output "staging_data_lake_ingress_gcs_bucket" {
  description = "Name of ingress bucket in staging project."
  value       = module.gcs_bucket_staging_ingress.bucket_name
}

output "data_lake_gcs_bucket" {
  description = "Name of ingress bucket in researcher workspace project."
  value       = module.gcs_bucket_data_lake.bucket_name
}

#------------------
# BIGQUERY OUTPUTS
#------------------

output "data_lake_bq_dataset" {
  description = "Bigquery dataset resource."
  value       = module.bigquery_data_lake.bigquery_dataset
}

output "staging_data_lake_ingress_bq_dataset" {
  description = "Bigquery dataset resource."
  value       = module.bigquery_staging_data_lake_ingress.bigquery_dataset
}

#-----------------------------------------------------
# VPC SC REGULAR SERVICE PERIMETER - DATA LAKE OUTPUTS
#-----------------------------------------------------

output "regular_service_perimeter_resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  value       = module.data_lake_regular_service_perimeter.regular_service_perimeter_resources
}

output "regular_service_perimeter_name" {
  description = "The perimeter's name."
  value       = module.data_lake_regular_service_perimeter.regular_service_perimeter_name
}

output "vpc_accessible_services" {
  description = "The API services accessible from a network within the VPC SC perimeter."
  value       = module.data_lake_regular_service_perimeter.vpc_accessible_services
}

#-----------------------------
# VPC SC ACCESS LEVELS OUTPUTS
#-----------------------------
/*
output "name" {
  description = "Description of the AccessLevel and its use. Does not affect behavior."
  value       = module.datalake_access_level_members.name
}

output "name_id" {
  description = "The fully-qualified name of the Access Level. Format: accessPolicies/{policy_id}/accessLevels/{name}"
  value       = module.datalake_access_level_members.name_id
}

#----------------------------------------------------
# VPC SC DATALAKE TO STAGING BRIDGE PERIMETER OUTPUTS
#----------------------------------------------------

output "bridge_service_perimeter_resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  value       = module.datalake_to_staging_bridge_service_perimeter.bridge_service_perimeter_resources
}
*/