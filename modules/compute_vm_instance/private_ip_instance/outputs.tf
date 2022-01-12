#---------------------------
# SINGLE VM INSTANCE OUTPUTS
#---------------------------

output "instance_id" {
  description = "The server-assigned unique identifier of this instance."
  value       = google_compute_instance.single_vm_instance.instance_id
}

output "self_link" {
  description = "The URI of the instance that was created."
  value       = google_compute_instance.single_vm_instance.self_link
}

output "tags" {
  description = "The tags applied to the VM instance."
  value       = google_compute_instance.single_vm_instance.tags
}