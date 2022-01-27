output "foundation_folder_id" {
  value = google_folder.foundation_sde.id
}

output "deployments_folder_id" {
  description = "The deployment folder id."
  value       = google_folder.deployments_sde_parent.id
}

output "ids" {
  description = "Folder ids."
  value = { for name, folder in google_folder.researcher_workspaces :
    name => folder.name
  }
}

output "names" {
  description = "Folder names."
  value = { for name, folder in google_folder.researcher_workspaces :
    name => folder.display_name
  }
}