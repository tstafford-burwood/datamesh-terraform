output "folders_apply_trigger_dev" {
  value = google_cloudbuild_trigger.folders_apply_dev.trigger_id
}

output "image_project_apply_trigger_dev" {
  value = google_cloudbuild_trigger.image_project_apply_dev.trigger_id
}

output "data_ops_project_apply_trigger_dev" {
  value = google_cloudbuild_trigger.data_ops_project_apply_dev.trigger_id
}

output "data_lake_project_apply_trigger_dev" {
  value = google_cloudbuild_trigger.data_lake_project_apply_dev.trigger_id
}