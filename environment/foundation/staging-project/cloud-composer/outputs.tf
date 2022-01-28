#------------------------
# CLOUD COMPOSER OUTPUTS
#------------------------

output "composer_env_name" {
  description = "Name of the Cloud Composer Environment."
  value       = module.cloud_composer.composer_env_name
}

output "composer_env_id" {
  description = "ID of Cloud Composer Environment."
  value       = module.cloud_composer.composer_env_id
}

output "gke_cluster" {
  description = "Google Kubernetes Engine cluster used to run the Cloud Composer Environment."
  value       = module.cloud_composer.gke_cluster
}

output "gcs_bucket" {
  description = "Google Cloud Storage bucket which hosts DAGs for the Cloud Composer Environment."
  value       = module.cloud_composer.gcs_bucket
}

#-------------------------------------
# CLOUD COMPOSER SERVICE ACCOUNT OUTPUTS
#---------------------------------------

output "email" {
  description = "The service account email."
  value       = module.composer_service_account.email
}

output "iam_email" {
  description = "The service account IAM-format email."
  value       = module.composer_service_account.iam_email
}

output "service_account" {
  description = "Service account resource (for single use)."
  value       = module.composer_service_account.service_account
}

output "service_accounts" {
  description = "Service account resources as list."
  value       = module.composer_service_account.service_accounts
}