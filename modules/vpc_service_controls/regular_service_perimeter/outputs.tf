#-----------------------------------------
# VPC SC REGULAR SERVICE PERIMETER OUTPUTS
#-----------------------------------------

output "regular_service_perimeter_resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  value       = google_access_context_manager_service_perimeter.regular_service_perimeter.status[0].resources
}

output "regular_service_perimeter_name" {
  description = "The perimeter's name."
  value       = google_access_context_manager_service_perimeter.regular_service_perimeter.title
}

output "vpc_accessible_services" {
  description = "The API services accessible from a network within the VPC SC perimeter."
  value       = google_access_context_manager_service_perimeter.regular_service_perimeter.status[0]
}