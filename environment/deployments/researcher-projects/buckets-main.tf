//
// GRAB GCS BUCKET NAMES FROM MODULE AND PUT INTO A LOCAL VALUE TO REFERENCE IN PUB SUB NOTIFICATIONS
//

locals {
  researcher_bucket_names = {
    staging_ingress   = module.gcs_bucket_staging_ingress.bucket_name,
    staging_egress    = module.gcs_bucket_staging_egress.bucket_name,
    workspace_ingress = module.gcs_bucket_researcher_workspace_ingress.bucket_name,
    workspace_egress  = module.gcs_bucket_researcher_workspace_egress.bucket_name,
    data_egress       = module.gcs_bucket_researcher_data_egress.bucket_name
  }
}

// LOCAL.STAGING_PROJECT_ID SET IN MAIN.TF OF THIS DIRECTORY

#---------------------------------
# STAGING PROJECT - INGRESS BUCKET
#---------------------------------

module "gcs_bucket_staging_ingress" {
  source = "../../../modules/gcs_bucket"

  // REQUIRED FIELDS
  project_id         = local.staging_project_id
  bucket_suffix_name = formatlist("%v-%v", var.staging_ingress_bucket_suffix_name, "staging-ingress")
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
  # bucket_location             = var.staging_ingress_bucket_location
  bucket_location          = local.staging_default_region
  bucket_set_creator_roles = var.staging_ingress_bucket_set_creator_roles
  bucket_set_viewer_roles  = var.staging_ingress_bucket_set_viewer_roles
  bucket_storage_class     = var.staging_ingress_bucket_storage_class
  viewers                  = var.staging_ingress_bucket_viewers
  depends_on               = []
}

#--------------------------------
# STAGING PROJECT - EGRESS BUCKET
#--------------------------------

module "gcs_bucket_staging_egress" {
  source = "../../../modules/gcs_bucket"

  // REQUIRED FIELDS
  project_id         = local.staging_project_id
  bucket_suffix_name = formatlist("%v-%v", var.staging_egress_bucket_suffix_name, "staging-egress")
  bucket_prefix_name = var.staging_egress_bucket_prefix_name

  // OPTIONAL FIELDS
  bucket_set_admin_roles      = var.staging_egress_bucket_set_admin_roles
  admins                      = var.staging_egress_bucket_admins
  bucket_versioning           = var.staging_egress_bucket_versioning
  creators                    = var.staging_egress_bucket_creators
  bucket_encryption_key_names = var.staging_egress_bucket_encryption_key_names
  bucket_folders              = var.staging_egress_bucket_folders
  bucket_force_destroy        = var.staging_egress_bucket_force_destroy
  storage_bucket_labels       = var.staging_egress_storage_bucket_labels
  bucket_location             = var.staging_egress_bucket_location
  bucket_set_creator_roles    = var.staging_egress_bucket_set_creator_roles
  bucket_set_viewer_roles     = var.staging_egress_bucket_set_viewer_roles
  bucket_storage_class        = var.staging_egress_bucket_storage_class
  viewers                     = var.staging_egress_bucket_viewers
  depends_on                  = []
}


#--------------------------------------
# RESEARCHER WORKSPACE - INGRESS BUCKET
#--------------------------------------

module "gcs_bucket_researcher_workspace_ingress" {
  source = "../../../modules/gcs_bucket"

  // REQUIRED FIELDS
  project_id         = module.researcher-workspace-project.project_id
  bucket_suffix_name = formatlist("%v-%v", var.workspace_ingress_bucket_suffix_name, "workspace-ingress")
  bucket_prefix_name = var.workspace_ingress_bucket_prefix_name

  // OPTIONAL FIELDS
  bucket_set_admin_roles      = var.workspace_ingress_bucket_set_admin_roles
  admins                      = var.workspace_ingress_bucket_admins
  bucket_versioning           = var.workspace_ingress_bucket_versioning
  creators                    = var.workspace_ingress_bucket_creators
  bucket_encryption_key_names = var.workspace_ingress_bucket_encryption_key_names
  bucket_folders              = var.workspace_ingress_bucket_folders
  bucket_force_destroy        = var.workspace_ingress_bucket_force_destroy
  storage_bucket_labels       = var.workspace_ingress_storage_bucket_labels
  #bucket_location             = var.workspace_ingress_bucket_location
  bucket_location          = local.workspace_default_region
  bucket_set_creator_roles = var.workspace_ingress_bucket_set_creator_roles
  bucket_set_viewer_roles  = var.workspace_ingress_bucket_set_viewer_roles
  bucket_storage_class     = var.workspace_ingress_bucket_storage_class
  viewers                  = var.workspace_ingress_bucket_viewers
  depends_on               = []
}

#-------------------------------------
# RESEARCHER WORKSPACE - EGRESS BUCKET
#-------------------------------------

module "gcs_bucket_researcher_workspace_egress" {
  source = "../../../modules/gcs_bucket"

  // REQUIRED FIELDS
  project_id         = module.researcher-workspace-project.project_id
  bucket_suffix_name = formatlist("%v-%v", var.workspace_egress_bucket_suffix_name, "workspace-egress")
  bucket_prefix_name = var.workspace_egress_bucket_prefix_name

  // OPTIONAL FIELDS
  bucket_set_admin_roles      = var.workspace_egress_bucket_set_admin_roles
  admins                      = var.workspace_egress_bucket_admins
  bucket_versioning           = var.workspace_egress_bucket_versioning
  creators                    = var.workspace_egress_bucket_creators
  bucket_encryption_key_names = var.workspace_egress_bucket_encryption_key_names
  bucket_folders              = var.workspace_egress_bucket_folders
  bucket_force_destroy        = var.workspace_egress_bucket_force_destroy
  storage_bucket_labels       = var.workspace_egress_storage_bucket_labels
  bucket_location             = var.workspace_egress_bucket_location
  bucket_set_creator_roles    = var.workspace_egress_bucket_set_creator_roles
  bucket_set_viewer_roles     = var.workspace_egress_bucket_set_viewer_roles
  bucket_storage_class        = var.workspace_egress_bucket_storage_class
  viewers                     = var.workspace_egress_bucket_viewers
  depends_on                  = []
}


// THIS BUCKET IS IN A STANDALONE PROJECT FOR EXTERNAL COLLABORATION AFTER DLP SCANNING

#-----------------------------------------------
# RESEARCHER DATA EGRESS PROJECT - EGRESS BUCKET
#-----------------------------------------------

module "gcs_bucket_researcher_data_egress" {
  source = "../../../modules/gcs_bucket"

  // REQUIRED FIELDS
  project_id         = module.researcher-data-egress-project.project_id
  bucket_suffix_name = formatlist("%v-%v", var.researcher_data_egress_project_bucket_suffix_name, "external-collaboration-egress")
  bucket_prefix_name = var.researcher_data_egress_project_bucket_prefix_name

  // OPTIONAL FIELDS
  bucket_set_admin_roles      = var.researcher_data_egress_project_bucket_set_admin_roles
  admins                      = var.researcher_data_egress_project_bucket_admins
  bucket_versioning           = var.researcher_data_egress_project_bucket_versioning
  creators                    = var.researcher_data_egress_project_bucket_creators
  bucket_encryption_key_names = var.researcher_data_egress_project_bucket_encryption_key_names
  bucket_folders              = var.researcher_data_egress_project_bucket_folders
  bucket_force_destroy        = var.researcher_data_egress_project_bucket_force_destroy
  storage_bucket_labels       = var.researcher_data_egress_project_storage_bucket_labels
  #bucket_location             = var.researcher_data_egress_project_bucket_location
  bucket_location          = local.workspace_default_region
  bucket_set_creator_roles = var.researcher_data_egress_project_bucket_set_creator_roles
  bucket_set_viewer_roles  = var.researcher_data_egress_project_bucket_set_viewer_roles
  bucket_storage_class     = var.researcher_data_egress_project_bucket_storage_class
  viewers                  = var.researcher_data_egress_project_bucket_viewers
  depends_on               = []
}

#-------------------------------------
# RESEARCHER WORKSPACE - VM GCS BUCKET
#-------------------------------------

module "gcs_bucket_researcher_workspace_vm_access" {
  source = "../../../modules/gcs_bucket"

  // REQUIRED FIELDS
  project_id         = module.researcher-workspace-project.project_id
  bucket_suffix_name = formatlist("%v-%v", var.workspace_vm_access_bucket_suffix_name, "workspace-vm-access")
  bucket_prefix_name = var.workspace_vm_access_bucket_prefix_name

  // OPTIONAL FIELDS
  bucket_set_admin_roles      = var.workspace_vm_access_bucket_set_admin_roles
  admins                      = var.workspace_vm_access_bucket_admins
  bucket_versioning           = var.workspace_vm_access_bucket_versioning
  creators                    = var.workspace_vm_access_bucket_creators
  bucket_encryption_key_names = var.workspace_vm_access_bucket_encryption_key_names
  bucket_folders              = var.workspace_vm_access_bucket_folders
  bucket_force_destroy        = var.workspace_vm_access_bucket_force_destroy
  storage_bucket_labels       = var.workspace_vm_access_storage_bucket_labels
  #bucket_location             = var.workspace_vm_access_bucket_location
  bucket_location          = local.workspace_default_region
  bucket_set_creator_roles = var.workspace_vm_access_bucket_set_creator_roles
  bucket_set_viewer_roles  = var.workspace_vm_access_bucket_set_viewer_roles
  bucket_storage_class     = var.workspace_vm_access_bucket_storage_class
  viewers                  = var.workspace_vm_access_bucket_viewers
  depends_on               = []
}