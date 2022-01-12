// LOCAL.STAGING_PROJECT_ID SET IN MAIN.TF OF THIS DIRECTORY

#---------------------------------
# STAGING PROJECT - INGRESS BUCKET
#---------------------------------

module "gcs_bucket_staging_ingress" {
  source = "../../../../modules/gcs_bucket"

  // REQUIRED FIELDS
  project_id         = local.staging_project_id
  bucket_suffix_name = formatlist("%v-%v", var.staging_ingress_bucket_suffix_name, "data-lake-staging-ingress")
  bucket_prefix_name = var.staging_ingress_bucket_prefix_name

  // OPTIONAL FIELDS
  bucket_set_admin_roles      = var.staging_ingress_bucket_set_admin_roles
  admins                      = var.staging_ingress_bucket_admins
  bucket_versioning           = var.staging_ingress_bucket_versioning
  creators                    = var.staging_ingress_bucket_creators
  bucket_encryption_key_names = var.staging_ingress_bucket_encryption_key_names
  bucket_folders              = var.staging_ingress_bucket_folders
  bucket_force_destroy        = var.staging_ingress_bucket_force_destroy
  storage_bucket_labels       = var.staging_ingress_storage_bucket_labels
  #bucket_location             = var.staging_ingress_bucket_location
  bucket_location             = local.data_lake_default_region
  bucket_set_creator_roles    = var.staging_ingress_bucket_set_creator_roles
  bucket_set_viewer_roles     = var.staging_ingress_bucket_set_viewer_roles
  bucket_storage_class        = var.staging_ingress_bucket_storage_class
  viewers                     = var.staging_ingress_bucket_viewers
  depends_on                  = []
}

#---------------------------
# DATA LAKE - INGRESS BUCKET
#---------------------------

module "gcs_bucket_data_lake" {
  source = "../../../../modules/gcs_bucket"

  // REQUIRED FIELDS
  project_id         = module.data-lake-project.project_id
  bucket_suffix_name = formatlist("%v-%v", var.data_lake_bucket_suffix_name, "data-lake-ingress")
  bucket_prefix_name = var.data_lake_ingress_bucket_prefix_name

  // OPTIONAL FIELDS
  bucket_set_admin_roles      = var.data_lake_ingress_bucket_set_admin_roles
  admins                      = var.data_lake_ingress_bucket_admins
  bucket_versioning           = var.data_lake_ingress_bucket_versioning
  creators                    = var.data_lake_ingress_bucket_creators
  bucket_encryption_key_names = var.data_lake_ingress_bucket_encryption_key_names
  bucket_folders              = var.data_lake_ingress_bucket_folders
  bucket_force_destroy        = var.data_lake_ingress_bucket_force_destroy
  storage_bucket_labels       = var.data_lake_ingress_storage_bucket_labels
  #bucket_location             = var.data_lake_ingress_bucket_location
  bucket_location             = local.data_lake_default_region
  bucket_set_creator_roles    = var.data_lake_ingress_bucket_set_creator_roles
  bucket_set_viewer_roles     = var.data_lake_ingress_bucket_set_viewer_roles
  bucket_storage_class        = var.data_lake_ingress_bucket_storage_class
  viewers                     = var.data_lake_ingress_bucket_viewers
  depends_on                  = []
}