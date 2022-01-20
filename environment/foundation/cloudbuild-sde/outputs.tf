output "folders_apply_trigger_dev" {
    value = google_cloudbuild_trigger.folders_apply_dev.trigger_id
}

output "packer_project_apply_trigger_dev" {
    value = google_cloudbuild_trigger.packer_project_apply_dev.trigger_id
}

output "staging_project_apply_trigger_dev" {
    value = google_cloudbuild_trigger.staging_project_apply_dev.trigger_id
}

output "data_lake_project_apply_trigger_dev" {
    value = google_cloudbuild_trigger.data_lake_project_apply_dev.trigger_id
}