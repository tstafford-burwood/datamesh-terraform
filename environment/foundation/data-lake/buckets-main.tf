// LOCAL.STAGING_PROJECT_ID SET IN MAIN.TF OF THIS DIRECTORY

#---------------------------------
# STAGING PROJECT - INGRESS BUCKET
#---------------------------------

module "gcs_bucket_staging_ingress" {
  source = "../../../modules/gcs_bucket"

  // REQUIRED FIELDS
  project_id         = local.staging_project_id
  bucket_suffix_name = [local.function]
  bucket_prefix_name = var.environment

  // OPTIONAL FIELDS
  bucket_set_admin_roles = var.staging_ingress_bucket_set_admin_roles
  admins                 = var.staging_ingress_bucket_admins
  creators               = var.staging_ingress_bucket_creators
  viewers                = var.staging_ingress_bucket_viewers
  bucket_versioning = {
    local.function = true
  }
  bucket_encryption_key_names = {}
  bucket_folders              = {}
  bucket_force_destroy        = {}
  storage_bucket_labels = {
    "environment" = var.environment
  }
  bucket_location          = "US"
  bucket_set_creator_roles = false
  bucket_set_viewer_roles  = false
  bucket_storage_class     = "STANDARD"
}

#---------------------------
# DATA LAKE - INGRESS BUCKET
#---------------------------

module "gcs_bucket_data_lake" {
  source = "../../../modules/gcs_bucket"

  // REQUIRED FIELDS
  project_id         = module.data-lake-project.project_id
  bucket_suffix_name = ["data-lake-ingress"]
  bucket_prefix_name = var.environment

  // OPTIONAL FIELDS
  bucket_set_admin_roles = var.data_lake_ingress_bucket_set_admin_roles
  admins                 = var.data_lake_ingress_bucket_admins
  creators               = var.data_lake_ingress_bucket_creators
  viewers                = var.data_lake_ingress_bucket_viewers
  bucket_versioning = {
    data-lake-ingress = true
  }
  bucket_encryption_key_names = {}
  bucket_folders              = {}
  bucket_force_destroy        = {}
  storage_bucket_labels = {
    "environment" = var.environment
  }
  bucket_location          = "US"
  bucket_set_creator_roles = false
  bucket_set_viewer_roles  = false
  bucket_storage_class     = "STANDARD"
}