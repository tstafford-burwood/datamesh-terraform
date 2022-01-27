#------------------------------
# STANDALONE VPC MODULE OUTPUTS
#------------------------------

output "network_id" {
  description = "The ID of the VPC being created."
  value       = module.vpc.id
}

output "network_name" {
  description = "The name of the VPC being created"
  value       = module.vpc.network_name
}

output "network_self_link" {
  description = "The URI of the VPC being created"
  value       = module.vpc.network_self_link
}

output "subnets" {
  description = "A map with keys of form subnet_region/subnet_name and values being the outputs of the google_compute_subnetwork resources used to create corresponding subnets."
  value       = module.vpc.subnets
}

output "subnets_names" {
  description = "The names of the subnets being created"
  value       = module.vpc.subnets_names
}

output "subnets_self_links" {
  description = "The self-links of subnets being created"
  value       = module.vpc.subnets_self_links
}

output "subnets_regions" {
  description = "The region where the subnets will be created."
  value       = module.vpc.subnets_regions
}

output "subnets_secondary_ranges" {
  description = "The secondary ranges associated with these subnets"
  value       = module.vpc.subnets_secondary_ranges
}

output "route_names" {
  description = "The routes associated with this VPC."
  value       = module.vpc.route_names
}