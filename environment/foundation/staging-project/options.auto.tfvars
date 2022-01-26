#-----------------------
# PROJECT FACTORY TFVARS
#-----------------------


// OPTIONAL TFVARS
# activate_apis = [
#   "compute.googleapis.com",
#   "pubsub.googleapis.com",
#   "bigquery.googleapis.com",
#   "composer.googleapis.com",
#   "dlp.googleapis.com"
# ]
# auto_create_network         = false
# create_project_sa           = false
# default_service_account     = "disable"
# disable_dependent_services  = true
# disable_services_on_destroy = true
# group_name                  = ""
# group_role                  = ""

# project_labels = {
#   "srde" : "secure-staging"
# }

# lien              = false
# random_project_id = true

#-----------------------
# STANDALONE VPC TFVARS
#-----------------------

# vpc_network_name        = "srde-staging-vpc"
# auto_create_subnetworks = false
# firewall_rules          = []
# routing_mode            = "GLOBAL"
# mtu                     = 1460

# subnets = [
#   {
#     subnet_name               = "subnet-01"
#     subnet_ip                 = "10.0.0.0/16"
#     subnet_region             = "us-central1"
#     subnet_flow_logs          = "true"
#     subnet_flow_logs_interval = "INTERVAL_10_MIN"
#     subnet_flow_logs_sampling = 0.7
#     subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
#     subnet_private_access     = "true"
#   }
# ]

# secondary_ranges = {
#   subnet-01 = [
#     {
#       range_name    = "kubernetes-pods"
#       ip_cidr_range = "10.1.0.0/20"
#     },
#     {
#       range_name    = "kubernetes-services"
#       ip_cidr_range = "10.2.0.0/24"
#     }
#   ]
# }


#---------------------
# PUB/SUB TOPIC TFVARS
#---------------------

// REQUIRED

#topic_name                  = "secure-staging-project-topic"
#allowed_persistence_regions = ["us-central1"]

// OPTIONAL
#kms_key_name = ""
#topic_labels = { "pub_sub_topic" : "secure-staging-project" }


#----------------------------
# PUB/SUB SUBSCRIPTION TFVARS
#----------------------------

// REQUIRED TFVARS

# subscription_name = "secure-staging-project-subscription"

# // OPTIONAL TFVARS

# #ack_deadline_seconds       = 10
# dead_letter_topic          = null
# enable_message_ordering    = true
# expiration_policy_ttl      = ""
# filter                     = null
# maximum_backoff            = null
# minimum_backoff            = null
# max_delivery_attempts      = null
# message_retention_duration = null
# retain_acked_messages      = false
# subscription_labels        = { "pub_sub_subscription" : "secure-staging-project" }

# // PUSH CONFIGURATION - OPTIONAL TFVARS

# audience              = ""
# push_endpoint         = ""
# push_attributes       = {}
# service_account_email = ""

#--------------------------------
# PUB/SUB TOPIC IAM MEMBER TFVARS
#--------------------------------

# role = "roles/pubsub.publisher"


#--------------------------------------------
# VPC SC ACCESS LEVELS TFVARS - DATA STEWARDS
#--------------------------------------------

// REQUIRED TFVARS

// OPTIONAL TFVARS - NON PREMIUM

#combining_function       = "OR"
#access_level_description = ""
#ip_subnetworks           = [] // CHANGE BEFORE FIRST DEPLOYMENT IF NEEDED
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

#---------------------------------------------------------
# VPC SC REGULAR PERIMETER TFVARS - SECURE STAGING PROJECT
# This is creating the permiter around the staging project and giving it
# the name declared in the `staging_project_regular_service_perimeter_name` variable.
#---------------------------------------------------------

// REQUIRED TFVARS

#staging_project_regular_service_perimeter_description = "Secure Staging Project perimeter made with Terraform."

// OPTIONAL TFVARS

#staging_project_enable_restriction = false
#staging_project_allowed_services   = []

#-------------------------------------
# BIGQUERY DATASET - GCS EVENTS TFVARS
#-------------------------------------

// REQUIRED TFVARS

// OPTIONAL TFVARS

gcs_events_bigquery_access = []
#gcs_events_dataset_labels               = { "bq-dataset" : "staging-project" }
#gcs_events_dataset_name                 = "wcm_srde_gcs_events"
#gcs_events_default_table_expiration_ms  = null
#gcs_events_delete_contents_on_destroy   = true
#gcs_events_bigquery_deletion_protection = false
#gcs_events_bigquery_description         = "BigQuery Dataset created with Terraform for GCS events to be written to."
#gcs_events_encryption_key               = null
#gcs_events_external_tables              = []
#gcs_events_location                     = "US"
#gcs_events_routines                     = []
#gcs_events_views                        = []

#-------------------------------------------------
# FOLDER IAM MEMBER TFVARS - DLP API SERVICE AGENT
#-------------------------------------------------

# dlp_service_agent_iam_role_list = [
#   "roles/dlp.jobsEditor"
# ]

#--------------------------------
# STAGING PROJECT IAM CUSTOM ROLE
#--------------------------------

#project_iam_custom_role_description = "Custom SDE Role for storage.buckets.list operation."
#project_iam_custom_role_id          = "sreCustomRoleStorageBucketsList"
#project_iam_custom_role_title       = "[Custom] SDE Storage Buckets List Role"
#project_iam_custom_role_permissions = ["storage.buckets.list"]
#project_iam_custom_role_stage       = "GA"
