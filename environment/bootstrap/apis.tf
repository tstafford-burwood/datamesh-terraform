resource "google_project_service" "apis" {
  for_each = toset(var.services)
  project  = var.project_id
  service  = each.value
}

variable "services" {
  description = "List of API services to enable in the Cloud Build project"
  type        = list(string)
  default     = ["dlp.googleapis.com", "accesscontextmanager.googleapis.com"]
}