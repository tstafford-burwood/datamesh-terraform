#------------------------
# PROJECT FACTORY OUTPUTS
#------------------------

output "enabled_apis" {
  description = "Enabled APIs in the project"
  value       = module.project-factory.enabled_apis
}

output "project_id" {
  value = module.project-factory.project_id
}

output "project_name" {
  value = module.project-factory.project_name
}

output "project_number" {
  value = module.project-factory.project_number
}

output "service_account_email" {
  description = "The email of the default service account"
  value       = module.project-factory.service_account_email
}