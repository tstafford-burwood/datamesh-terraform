#------------------
# CLOUD NAT OUTPUTS
#------------------

output "name" {
  description = "Name of the Cloud NAT"
  value       = module.cloud_nat.name
}

output "nat_ip_allocate_option" {
  description = "NAT IP allocation mode"
  value       = module.cloud_nat.nat_ip_allocate_option
}

output "region" {
  description = "Cloud NAT region"
  value       = module.cloud_nat.region
}

output "router_name" {
  description = "Cloud NAT router name"
  value       = module.cloud_nat.router_name
}