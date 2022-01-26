#-----------------------------
# VPC SC ACCESS LEVELS OUTPUTS
#-----------------------------

output "name" {
  description = "Description of the AccessLevel and its use. Does not affect behavior."
  value       = module.cloudbuild_access_level.name
}

output "name_id" {
  description = "The fully-qualified name of the Access Level. Format: accessPolicies/{policy_id}/accessLevels/{name}"
  value       = module.cloudbuild_access_level.name_id
}