#--------------------------------
# VPC SC BRIDGE PERIMETER OUTPUTS
#--------------------------------

output "bridge_service_perimeter_resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  value       = module.bridge_service_perimeter.resources
}