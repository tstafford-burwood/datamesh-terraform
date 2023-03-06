locals {
  parent = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
}

resource "google_folder" "parent" {
  # Create top level folder under another folder or organization. Default is org
  display_name = format("%s", upper(var.folder_name))
  parent       = local.parent
}

# --------------------------------------------------
# VARIABLES
# --------------------------------------------------

variable "folder_name" {
  description = "Folder name"
  type        = string
  default     = "SDE"
}

variable "parent_folder" {
  description = "Optional - if using a folder for testing."
  type        = string
  default     = ""
}

# --------------------------------------------------
# OUTPUTS
# --------------------------------------------------

output "id" {
  description = "Paren folder id"
  value       = google_folder.parent.id
}

output "name" {
  description = "Parent folder name."
  value       = google_folder.parent.display_name
}