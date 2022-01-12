#--------------------
# VPC PEERING OUTPUTS
#--------------------

output "id" {
  description = "An identifier for the resource with format {{network}}/{{name}}"
  value       = google_compute_network_peering.peering.id
}

output "state" {
  description = "State for the peering, either ACTIVE or INACTIVE. The peering is ACTIVE when there's a matching configuration in the peer network."
  value       = google_compute_network_peering.peering.state
}

output "state_details" {
  description = "Details about the current state of the peering."
  value       = google_compute_network_peering.peering.state_details
}