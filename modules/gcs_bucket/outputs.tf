#-------------------
# GCS BUCKET OUTPUTS
#-------------------

output "bucket_name" {
  description = "Bucket name (for single use)."
  value       = module.gcs_bucket.name
}

output "buckets" {
  description = "Bucket resources as list."
  value       = module.gcs_bucket.buckets
}

output "bucket" {
  description = "Bucket resource (for single use)."
  value       = module.gcs_bucket.bucket
}

output "names" {
  description = "Bucket names."
  value       = module.gcs_bucket.name
}

output "names_list" {
  description = "List of bucket names."
  value       = module.gcs_bucket.names_list
}