#----------------------------------------------------------------------------
# PROJECT FACTORY OUTPUTS
#----------------------------------------------------------------------------

output "enabled_apis" {
  description = "Enabled APIs in the project"
  value       = module.packer-project.enabled_apis
}

output "project_id" {
  value = module.packer-project.project_id
}

output "project_name" {
  value = module.packer-project.project_name
}

output "project_number" {
  value = module.packer-project.project_number
}

output "service_account_email" {
  description = "The email of the default service account"
  value       = module.packer-project.service_account_email
}

#----------------------------------------------------------------------------
# PACKER VPC MODULE OUTPUTS
#----------------------------------------------------------------------------

output "network_name" {
  description = "The name of the VPC being created"
  value       = module.packer_vpc.network_name
}

output "network_self_link" {
  description = "The URI of the VPC being created"
  value       = module.packer_vpc.network_self_link
}

output "subnets_names" {
  description = "The names of the subnets being created"
  value       = module.packer_vpc.subnets_names
}

output "subnets_self_links" {
  description = "The self-links of subnets being created"
  value       = module.packer_vpc.subnets_self_links
}

output "route_names" {
  description = "The routes associated with this VPC."
  value       = module.packer_vpc.route_names
}

#----------------------------------------------------------------------------
# PACKER CONTAINER ARTIFACT REGISTRY REPOSITORY OUTPUTS
#----------------------------------------------------------------------------

output "packer_container_artifact_repo_id" {
  description = "An identifier for the resource with format projects/{{project}}/locations/{{location}}/repositories/{{repository_id}}."
  value       = module.packer_container_artifact_registry_repository.id
}

output "packer_container_artifact_repo_name" {
  description = "The name of the repository, for example: `projects/p1/locations/us-central1/repositories/repo1`"
  value       = module.packer_container_artifact_registry_repository.name
}

#----------------------------------------------------------------------------
# terraform-validator CONTAINER ARTIFACT REGISTRY REPOSITORY OUTPUTS
#----------------------------------------------------------------------------

output "terraform_validator_container_artifact_repo_id" {
  description = "An identifier for the resource with format projects/{{project}}/locations/{{location}}/repositories/{{repository_id}}."
  value       = module.terraform_validator_container_artifact_registry_repository.id
}

output "terraform_validator_container_artifact_repo_name" {
  description = "The name of the repository, for example: `projects/p1/locations/us-central1/repositories/repo1`"
  value       = module.terraform_validator_container_artifact_registry_repository.name
}