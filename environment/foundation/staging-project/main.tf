#----------------------------------------------------------------------------
# TERRAFORM STATE IMPORTS
#----------------------------------------------------------------------------

data "terraform_remote_state" "folders" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/folders"
  }
}

data "google_storage_project_service_account" "gcs_account" {
  # DATA BLOCK TO RETRIEVE PROJECT'S GCS SERVICE ACCOUNT
  project = module.secure-staging-project.project_id
}

#----------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------

module "constants" {
  source = "../constants"
}

// SET CONSTANTS VALUES

locals {
  org_id             = module.constants.value.org_id
  billing_account_id = module.constants.value.billing_account_id
  folder_id          = data.terraform_remote_state.folders.outputs.foundation_folder_id
  default_region     = module.constants.value.staging_default_region
  function           = "data-ops"
  primary_contact    = "example1"
}

# ---------------------------------------------------------------------------
# SECURE STAGING PROJECT
# ---------------------------------------------------------------------------

module "secure-staging-project" {
  source = "../../../modules/project_factory"

  // REQUIRED FIELDS
  project_name       = format("%v-%v", var.environment, local.function)
  org_id             = local.org_id
  billing_account_id = local.billing_account_id
  folder_id          = local.folder_id

  // OPTIONAL FIELDS
  activate_apis               = ["compute.googleapis.com", "pubsub.googleapis.com", "bigquery.googleapis.com", "composer.googleapis.com", "dlp.googleapis.com"]
  auto_create_network         = false
  create_project_sa           = false
  default_service_account     = var.default_service_account
  disable_dependent_services  = true
  disable_services_on_destroy = true
  lien                        = false
  random_project_id           = true
  project_labels = {
    environment      = var.environment
    application_name = local.function
    primary_contact  = local.primary_contact
  }
}

# ---------------------------------------------------------------------------
# SECURE STAGING VPC MODULE
#----------------------------------------------------------------------------

module "vpc" {
  source = "../../../modules/vpc"

  project_id                             = module.secure-staging-project.project_id
  vpc_network_name                       = format("%v-%v-vpc", var.environment, local.function)
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = 1460
  routing_mode                           = "GLOBAL"
  vpc_description                        = format("%s VPC for %s managed by Terraform.", var.environment, local.function)
  shared_vpc_host                        = false
  subnets                                = var.subnets
  secondary_ranges                       = var.secondary_ranges
  routes                                 = var.routes
}

#----------------------------------------------------------------------------
# PUB/SUB TOPIC MODULE
#----------------------------------------------------------------------------

module "pub_sub_topic" {
  source = "../../../modules/pub_sub/pub_sub_topic"

  #topic_name                  = var.topic_name
  topic_name                  = format("%v-%v-topic", var.environment, local.function)
  project_id                  = module.secure-staging-project.project_id
  allowed_persistence_regions = [local.default_region]
  kms_key_name                = var.kms_key_name
  topic_labels = {
    "pub_sub_topic" : format("%v-%v-project", var.environment, local.function)
  }
}

#----------------------------------------------------------------------------
# PUB/SUB SUBSCRIPTION MODULE
#----------------------------------------------------------------------------

module "pub_sub_subscription" {
  source = "../../../modules/pub_sub/pub_sub_subscription"

  subscription_name          = format("%v-%v-subscription", var.environment, local.function)
  project_id                 = module.secure-staging-project.project_id
  subscription_topic_name    = module.pub_sub_topic.topic_name
  ack_deadline_seconds       = 10
  dead_letter_topic          = null
  enable_message_ordering    = true
  expiration_policy_ttl      = ""
  filter                     = null
  maximum_backoff            = null
  minimum_backoff            = null
  max_delivery_attempts      = null
  message_retention_duration = null
  retain_acked_messages      = false
  subscription_labels        = {}

  // PUSH CONFIGURATION - OPTIONAL

  audience              = null
  push_endpoint         = ""
  push_attributes       = {}
  service_account_email = ""
}

#----------------------------------------------------------------------------
# PUB/SUB TOPIC IAM MEMBER
# USED TO SET THE DEFINED IAM ROLE TO A PROJECT'S GCS SERVICE ACCOUNT AT THE PUB/SUB TOPIC LEVEL
# ENABLES PUBLISHING GCS NOTIFICATIONS TO A PUB/SUB TOPIC
# LOCAL.STAGING_PROJECT_ID LOCATED IN MAIN.TF OF THIS DIRECTORY
#----------------------------------------------------------------------------

module "pub_sub_topic_iam_binding" {
  source = "../../../modules/pub_sub/pub_sub_topic/pub_sub_topic_iam_member"

  project_id = module.secure-staging-project.project_id
  topic_name = module.pub_sub_topic.topic_name
  iam_member = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
  role       = "roles/pubsub.publisher"
}

#----------------------------------------------------------------------------
# STAGING PROJECT IAM CUSTOM ROLE MODULE
#----------------------------------------------------------------------------

module "staging_project_iam_custom_role" {
  source = "../../../modules/iam/project_iam_custom_role"

  project_iam_custom_role_project_id  = module.secure-staging-project.project_id
  project_iam_custom_role_description = "Custom SDE Role for storage.buckets.list operation."
  project_iam_custom_role_title       = "[Custom] SDE Storage Buckets List Role"
  project_iam_custom_role_id          = var.project_iam_custom_role_id
  project_iam_custom_role_permissions = var.project_iam_custom_role_permissions
  project_iam_custom_role_stage       = var.project_iam_custom_role_stage
}

#----------------------------------------------------------------------------
# DATA STEWARDS - PROJECT IAM MEMBER CUSTOM SRDE ROLE
# DEFINE DATA STEWARDS THAT WILL BE GIVEN THE SRDE CUSTOM ROLE AT THE PROJECT LEVEL
#----------------------------------------------------------------------------

resource "google_project_iam_member" "staging_project_custom_srde_role" {

  for_each = toset(var.data_stewards_iam_staging_project)

  project = module.secure-staging-project.project_id
  role    = module.staging_project_iam_custom_role.name
  member  = each.value
}

#----------------------------------------------------------------------------
# DATA STEWARDS - PROJECT IAM MEMBER roles/composer.user
# DEFINE DATA STEWARDS THAT WILL BE GIVEN roles/composer.user AT THE PROJECT LEVEL
#----------------------------------------------------------------------------

resource "google_project_iam_member" "staging_project_composer_user_role" {

  for_each = toset(var.data_stewards_iam_staging_project)

  project = module.secure-staging-project.project_id
  role    = "roles/composer.user"
  member  = each.value
}

#----------------------------------------------------------------------------
# IAM MEMBER MODULE - DLP API SERVICE AGENT
#----------------------------------------------------------------------------

# module "folder_iam_member" {
#   source = "../../../modules/iam/folder_iam"

#   folder_id     = local.folder_id
#   iam_role_list = var.dlp_service_agent_iam_role_list
#   folder_member = "serviceAccount:service-${module.secure-staging-project.project_number}@dlp-api.iam.gserviceaccount.com"
# }

resource "google_project_iam_member" "dlp_service_account_iam" {
  for_each = toset(var.dlp_service_agent_iam_role_list)
  project  = module.secure-staging-project.project_id
  role     = each.value
  member   = "serviceAccount:service-${module.secure-staging-project.project_number}@dlp-api.iam.gserviceaccount.com"
}