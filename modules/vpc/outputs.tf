#------------------------------
# STANDALONE VPC MODULE OUTPUTS
#------------------------------

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

output "route_names" {
  description = "The routes associated with this VPC."
  value       = module.vpc.route_names
}