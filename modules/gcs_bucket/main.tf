#-------------------
# GCS BUCKET MODULE
#-------------------

module "gcs_bucket" {
  source               = "terraform-google-modules/cloud-storage/google"
  version              = "~> 1.7.0"
  project_id           = var.project_id
  names                = formatlist("%v-%v", var.bucket_suffix_name, random_id.bucket_suffix_addition.hex)
  prefix               = var.bucket_prefix_name
  set_admin_roles      = var.bucket_set_admin_roles
  admins               = var.admins
  versioning           = var.bucket_versioning
  creators             = var.creators
  encryption_key_names = var.bucket_encryption_key_names
  folders              = var.bucket_folders
  force_destroy        = var.bucket_force_destroy
  labels               = var.storage_bucket_labels
  location             = var.bucket_location
  set_creator_roles    = var.bucket_set_creator_roles
  set_viewer_roles     = var.bucket_set_viewer_roles
  storage_class        = var.bucket_storage_class
  viewers              = var.viewers
  depends_on           = []
}

resource "random_id" "bucket_suffix_addition" {
  byte_length = 2
}