#--------------------------
# DATA LAKE PROJECT TFVARS
#--------------------------

// DATA LAKE TFVARS - OPTIONAL
data_lake_activate_apis = [
  "compute.googleapis.com",
  "serviceusage.googleapis.com",
  "bigquery.googleapis.com"
]

data_lake_auto_create_network         = false
data_lake_create_project_sa           = false
data_lake_default_service_account     = "delete"
data_lake_disable_dependent_services  = true
data_lake_disable_services_on_destroy = true
data_lake_group_name                  = ""
data_lake_group_role                  = ""

data_lake_project_labels = {
  "data-lake-project" : "data_lake_1" // CHANGE LABEL WITH EACH NEW PROJECT
}

data_lake_lien              = false
data_lake_random_project_id = true

#---------------------------------
# DATA LAKE IAM CUSTOM ROLE TFVARS
#---------------------------------

datalake_iam_custom_role_description = "Custom SRDE Role for Data Lake Storage Operations."
datalake_iam_custom_role_id          = "srdeCustomRoleDataLakeStorageOperations"
datalake_iam_custom_role_title       = "[Custom] SRDE Data Lake Storage Operations Role"
datalake_iam_custom_role_permissions = ["storage.buckets.list", "storage.objects.list", "storage.objects.get"] # TODO: Update as needed
datalake_iam_custom_role_stage       = "GA"

#----------------------------------------
# STAGING PROJECT - INGRESS BUCKET TFVARS
#----------------------------------------

// STAGING PROJECT INGRESS TFVARS - REQUIRED
staging_ingress_bucket_suffix_name     = ["data_lake"] // CHANGE WITH EACH NEW PROJECT
staging_ingress_bucket_prefix_name     = "wcm"
staging_ingress_bucket_set_admin_roles = true

#----------------------------------
# DATA LAKE - INGRESS BUCKET TFVARS
#----------------------------------

// RESEARCHER WORKSPACE INGRESS TFVARS - REQUIRED
data_lake_bucket_suffix_name         = ["data_lake"] // CHANGE WITH EACH NEW PROJECT
data_lake_ingress_bucket_prefix_name = "wcm"

#-----------------------------------
# BIGQUERY DATASET DATA LAKE TFVARS
#-----------------------------------

// REQUIRED TFVARS

data_lake_bq_dataset_id                   = "data_lake_dataset"                  // CHANGE WITH EACH NEW PROJECT
data_lake_bq_dataset_labels               = { "data_lake_name" : "data_lake_1" } // CHANGE WITH EACH NEW PROJECT
data_lake_bq_dataset_name                 = "data-lake-dataset-1"                // CHANGE WITH EACH NEW PROJECT
data_lake_bq_default_table_expiration_ms  = null
data_lake_bq_delete_contents_on_destroy   = true
data_lake_bq_bigquery_deletion_protection = false
data_lake_bq_dataset_description          = "BigQuery Dataset created with Terraform for data lake."
data_lake_bq_encryption_key               = null
data_lake_bq_external_tables              = []
data_lake_bq_location                     = "US"
data_lake_bq_routines                     = []
data_lake_bq_tables                       = []
data_lake_bq_views                        = []


#-------------------------------------------------------
# BIGQUERY DATASET STAGING DATA LAKE INGRESS TFVARS
#-------------------------------------------------------

// REQUIRED TFVARS

staging_data_lake_ingress_bq_dataset_id                   = "staging_data_lake_ingress_dataset_1"
staging_data_lake_ingress_bq_dataset_labels               = { "data_lake_name" : "data_lake_1" }
staging_data_lake_ingress_bq_dataset_name                 = "staging-data-lake-ingress-dataset-1"
staging_data_lake_ingress_bq_default_table_expiration_ms  = null
staging_data_lake_ingress_bq_delete_contents_on_destroy   = true
staging_data_lake_ingress_bq_bigquery_deletion_protection = false
staging_data_lake_ingress_bq_dataset_description          = "BigQuery Dataset created with Terraform for data lake."
staging_data_lake_ingress_bq_encryption_key               = null
staging_data_lake_ingress_bq_external_tables              = []
staging_data_lake_ingress_bq_location                     = "US"
staging_data_lake_ingress_bq_routines                     = []
staging_data_lake_ingress_bq_tables                       = []
staging_data_lake_ingress_bq_views                        = []

#--------------------------------------------
# VPC SC REGULAR PERIMETER - DATA LAKE TFVARS
#--------------------------------------------

// REQUIRED TFVARS

datalake_regular_service_perimeter_description = "Data Lake Project Service Control Perimeter"


// OPTIONAL TFVARS

datalake_enable_restriction = true
datalake_allowed_services   = []

#----------------------------
# VPC SC ACCESS LEVELS TFVARS
#----------------------------

datalake_combining_function       = "OR"
datalake_access_level_description = "Access Level for Data Lake project."
datalake_ip_subnetworks           = []
datalake_negate                   = false
datalake_regions                  = []
datalake_required_access_levels   = []

#---------------------------------------------------
# VPC SC DATALAKE TO STAGING BRIDGE PERIMETER TFVARS
#---------------------------------------------------

datalake_bridge_service_perimeter_description = "Bridge Perimeter between Data Lake project and Staging Project."