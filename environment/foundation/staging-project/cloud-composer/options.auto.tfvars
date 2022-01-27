#-----------------------
# CLOUD COMPOSER TFVARS
#-----------------------

// REQUIRED
#composer_env_name = "composer-all-private" // CHANGE BEFORE FIRST DEPLOYMENT
#network           = "srde-staging-vpc"                   // CHANGE BEFORE FIRST DEPLOYMENT IF VPC NAME WAS UPDATED IN SECURE STAGING PROJECT DIRECTORY
#subnetwork        = "subnet-01"

// OPTIONAL

#airflow_config_overrides = { "webserver-rbac" = "True" }
#allowed_ip_range         = [] // CHANGE IF NEEDED

#cloud_sql_ipv4_cidr              = "10.4.0.0/24"
#database_machine_type            = "db-n1-standard-4"
#disk_size                        = "50"
#enable_private_endpoint          = true
#env_variables                    = {}
#image_version                    = null
#labels                           = {}
#gke_machine_type                 = "n1-standard-2"
#master_ipv4_cidr                 = null
#node_count                       = 3
#oauth_scopes                     = ["https://www.googleapis.com/auth/cloud-platform"]
#pod_ip_allocation_range_name     = "kubernetes-pods"
#pypi_packages                    = {}
#python_version                   = "3"
#region                           = "us-central1"
#service_ip_allocation_range_name = "kubernetes-services"
#tags                             = []
#use_ip_aliases                   = true
#web_server_ipv4_cidr             = "10.3.0.0/29"
#web_server_machine_type          = "composer-n1-webserver-4"
#zone                             = "us-central1-a"

// SHARED VPC SUPPORT

#network_project_id = ""
#subnetwork_region  = ""

#--------------------------------------
# CLOUD COMPOSER SERVICE ACCOUNT TFVARS
#--------------------------------------

// OPTIONAL TFVARS

#description           = "Cloud Composer Service Account made with Terraform"
#display_name          = "Cloud Composer Service Account made with Terraform"
#generate_keys         = false
#grant_billing_role    = false
#grant_xpn_roles       = false
#service_account_names = ["staging-project-composer-sa"]
#prefix                = ""
#project_roles         = []

#-------------------------
# FOLDER IAM MEMBER TFVARS
#-------------------------

#iam_role_list = [
#  "roles/composer.worker",
###  "roles/iam.serviceAccountUser",
#  "roles/bigquery.dataOwner",
#  "roles/dlp.jobsEditor",
#  "roles/storage.objectAdmin"
#]

#-------------------------------------------------------
# VPC SC ACCESS LEVELS - COMPOSER SERVICE ACCOUNT TFVARS
#-------------------------------------------------------
// OPTIONAL TFVARS - NON PREMIUM

#combining_function       = "OR"
#access_level_description = ""
#ip_subnetworks           = []
#negate                   = false
#regions                  = []
#required_access_levels   = []

// OPTIONAL TFVARS - DEVICE POLICY (PREMIUM)

#allowed_device_management_levels = []
#allowed_encryption_statuses      = []
#minimum_version                  = ""
#os_type                          = "OS_UNSPECIFIED"
#require_corp_owned               = false
#require_screen_lock              = false
