#-----------------------------
# AI PLATFORM NOTEBOOK OUTPUTS
#-----------------------------

output "proxy_uri" {
  description = "The proxy endpoint that is used to access the Jupyter notebook."
  value       = google_notebooks_instance.instance.proxy_uri
}

output "id" {
  description = "An identifier for the resource."
  value       = google_notebooks_instance.instance.id
}

output "state" {
  description = "The state of the instance."
  value       = google_notebooks_instance.instance.state
}