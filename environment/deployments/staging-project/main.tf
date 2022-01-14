#----------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------

module "constants" {
  source = "../../foundation/constants"
}

// SET CONSTANTS VALUES

locals {
  org_id             = module.constants.value.org_id
  billing_account_id = module.constants.value.billing_account_id
  srde_folder_id     = module.constants.value.srde_folder_id
}


data "google_storage_project_service_account" "gcs_account" {
  # DATA BLOCK TO RETRIEVE PROJECT'S GCS SERVICE ACCOUNT
  project = module.secure-staging-project.project_id
}

# ---------------------------------------------------------------------------
# SECURE STAGING PROJECT
# ---------------------------------------------------------------------------

module "secure-staging-project" {
  source = "../../../modules/project_factory"

  // REQUIRED FIELDS
  project_name       = var.project_name
  org_id             = local.org_id
  billing_account_id = local.billing_account_id

  // OPTIONAL FIELDS
  activate_apis               = var.activate_apis
  auto_create_network         = var.auto_create_network
  create_project_sa           = var.create_project_sa
  default_service_account     = var.default_service_account
  disable_dependent_services  = var.disable_dependent_services
  disable_services_on_destroy = var.disable_services_on_destroy
  folder_id                   = local.srde_folder_id
  group_name                  = var.group_name
  group_role                  = var.group_role
  project_labels              = var.project_labels
  lien                        = var.lien
  random_project_id           = var.random_project_id
}

# ---------------------------------------------------------------------------
# SECURE STAGING VPC MODULE
#----------------------------------------------------------------------------

module "vpc" {
  source = "../../../modules/vpc"

  project_id                             = module.secure-staging-project.project_id
  vpc_network_name                       = var.vpc_network_name
  auto_create_subnetworks                = var.auto_create_subnetworks
  delete_default_internet_gateway_routes = var.delete_default_internet_gateway_routes
  firewall_rules                         = var.firewall_rules
  routing_mode                           = var.routing_mode
  vpc_description                        = var.vpc_description
  shared_vpc_host                        = var.shared_vpc_host
  mtu                                    = var.mtu
  subnets                                = var.subnets
  secondary_ranges                       = var.secondary_ranges
  routes                                 = var.routes
}

#----------------------------------------------------------------------------
# PUB/SUB TOPIC MODULE
#----------------------------------------------------------------------------

module "pub_sub_topic" {
  source = "../../../modules/pub_sub/pub_sub_topic"

  topic_name                  = var.topic_name
  project_id                  = module.secure-staging-project.project_id
  allowed_persistence_regions = var.allowed_persistence_regions
  kms_key_name                = var.kms_key_name
  topic_labels                = var.topic_labels
}

#----------------------------------------------------------------------------
# PUB/SUB SUBSCRIPTION MODULE
#----------------------------------------------------------------------------

module "pub_sub_subscription" {
  source = "../../../modules/pub_sub/pub_sub_subscription"
  subscription_name       = var.subscription_name
  project_id              = module.secure-staging-project.project_id
  subscription_topic_name = module.pub_sub_topic.topic_name
  ack_deadline_seconds       = var.ack_deadline_seconds
  dead_letter_topic          = var.dead_letter_topic
  enable_message_ordering    = var.enable_message_ordering
  expiration_policy_ttl      = var.expiration_policy_ttl
  filter                     = var.filter
  maximum_backoff            = var.maximum_backoff
  minimum_backoff            = var.minimum_backoff
  max_delivery_attempts      = var.max_delivery_attempts
  message_retention_duration = var.message_retention_duration
  retain_acked_messages      = var.retain_acked_messages
  subscription_labels        = var.subscription_labels

  // PUSH CONFIGURATION - OPTIONAL

  audience              = var.audience
  push_endpoint         = var.push_endpoint
  push_attributes       = var.push_attributes
  service_account_email = var.service_account_email
}

// USED TO SET THE DEFINED IAM ROLE TO A PROJECT'S GCS SERVICE ACCOUNT AT THE PUB/SUB TOPIC LEVEL
// ENABLES PUBLISHING GCS NOTIFICATIONS TO A PUB/SUB TOPIC
// LOCAL.STAGING_PROJECT_ID LOCATED IN MAIN.TF OF THIS DIRECTORY

#----------------------------------------------------------------------------
# PUB/SUB TOPIC IAM MEMBER MODULE
#----------------------------------------------------------------------------

module "pub_sub_topic_iam_binding" {
  source = "../../../modules/pub_sub/pub_sub_topic/pub_sub_topic_iam_member"

  project_id = module.secure-staging-project.project_id
  topic_name = module.pub_sub_topic.topic_name
  iam_member = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
  role       = var.role
}



#----------------------------------------------------------------------------
# STAGING PROJECT IAM CUSTOM ROLE MODULE
#----------------------------------------------------------------------------

module "staging_project_iam_custom_role" {
  source = "../../../modules/iam/project_iam_custom_role"

  project_iam_custom_role_project_id  = module.secure-staging-project.project_id
  project_iam_custom_role_description = var.project_iam_custom_role_description
  project_iam_custom_role_id          = var.project_iam_custom_role_id
  project_iam_custom_role_title       = var.project_iam_custom_role_title
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

#   folder_id     = local.srde_folder_id
#   iam_role_list = var.dlp_service_agent_iam_role_list
#   folder_member = "serviceAccount:service-${module.secure-staging-project.project_number}@dlp-api.iam.gserviceaccount.com"
# }

resource "google_project_iam_member" "dlp_service_account_iam" {
  for_each = toset(var.dlp_service_agent_iam_role_list)
  project  = module.secure-staging-project.project_id
  role     = each.value
  member   = "serviceAccount:service-${module.secure-staging-project.project_number}@dlp-api.iam.gserviceaccount.com"
}