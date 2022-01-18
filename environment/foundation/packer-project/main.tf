#----------------------------------------------------------------------------
# SETUP LOCALS
#----------------------------------------------------------------------------



// NULL RESOURCE TIMER
// USED FOR DISABLING ORG POLICIES AT THE PROJECT LEVEL
// NEED TIME DELAY TO ALLOW POLICY CHANGE TO PROPAGATE

# 1-12-22: Commenting out because module.packer_project_disable_sa_creation is also commented out

# resource "time_sleep" "wait_120_seconds" {

#   create_duration = "120s"
#   depends_on      = [module.packer_project_disable_sa_creation]
# }

data "terraform_remote_state" "folders" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = format("%s/%s", var.terraform_state_prefix, "folders")
  }
}

#----------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------

module "constants" {
  source = "../constants"
}


locals {
  org_id                = module.constants.value.org_id
  billing_account_id    = module.constants.value.billing_account_id
  folder_id             = data.terraform_remote_state.folders.outputs.foundation_folder_id
  packer_default_region = module.constants.value.packer_default_region
}


#----------------------------------------------------------------------------
# PACKER PROJECT MODULE
#----------------------------------------------------------------------------

module "packer-project" {
  source = "../../../modules/project_factory"

  // REQUIRED FIELDS
  project_name       = var.project_name
  org_id             = local.org_id
  billing_account_id = local.billing_account_id

  // OPTIONAL FIELDS
  activate_apis               = var.activate_apis
  auto_create_network         = var.auto_create_network
  create_project_sa           = var.create_project_sa
  default_service_account     = "keep"
  disable_dependent_services  = var.disable_dependent_services
  disable_services_on_destroy = var.disable_services_on_destroy
  folder_id                   = local.folder_id
  group_name                  = var.group_name
  group_role                  = var.group_role
  project_labels              = var.project_labels
  lien                        = var.lien
  random_project_id           = var.random_project_id
}

#----------------------------------------------------------------------------
# IAM BINDING FOR COMPUTE SA
#----------------------------------------------------------------------------

# resource "google_project_iam_member" "compute_sa" {

#   project = module.packer-project.project_id
#   role    = "roles/editor"
#   member  = "serviceAccount:${module.packer-project.project_number}-compute@developer.gserviceaccount.com"
#   depends_on = [
#     google_project_service.enable_packer_project_apis
#   ]
# }

#----------------------------------------------------------------------------
# CLOUDBUILD GCS BUCKET MODULE
# Provision GCS Bucket used for Cloudbuild container/artifact registry
#----------------------------------------------------------------------------

resource "google_storage_bucket" "cloudbuild_gcs_bucket" {

  project                     = module.packer-project.project_id
  name                        = "${module.packer-project.project_id}_cloudbuild"
  force_destroy               = var.bucket_force_destroy
  labels                      = var.storage_bucket_labels
  location                    = var.bucket_location
  storage_class               = var.bucket_storage_class
  uniform_bucket_level_access = var.uniform_bucket_level_access
  depends_on                  = []
}

// ENABLE COMPUTE API SEPARATELY TO PROVISION DEFAULT COMPUTE ENGINE SERVICE ACCOUNT
// DEFAULT COMPUTE ENGINE SA IS NEEDED FOR DEPLOYMENT MANAGER TO FUNCTION PROPERLY

# resource "google_project_service" "enable_packer_project_apis" {

#   project                    = module.packer-project.project_id
#   service                    = "compute.googleapis.com"
#   disable_dependent_services = false
#   disable_on_destroy         = false
#   #depends_on                 = [time_sleep.wait_120_seconds] # Commented out the timer
# }

#----------------------------------------------------------------------------
# PACKER PROJECT VPC MODULE
#----------------------------------------------------------------------------

module "packer_vpc" {
  source = "../../../modules/vpc"

  project_id                             = module.packer-project.project_id
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

// PROVISION ARTIFACT REGISTRY REPOSITORY IN PACKER PROJECT FOR PACKER CONTAINER IMAGE

#----------------------------------------------------------------------------
# PACKER CONTAINER ARTIFACT REGISTRY REPOSITORY
#----------------------------------------------------------------------------

module "packer_container_artifact_registry_repository" {
  source = "../../../modules/artifact_registry"

  artifact_repository_project_id  = module.packer-project.project_id
  artifact_repository_name        = var.packer_container_artifact_repository_name
  artifact_repository_format      = var.packer_container_artifact_repository_format
  artifact_repository_location    = local.packer_default_region
  artifact_repository_description = var.packer_container_artifact_repository_description
  artifact_repository_labels      = var.packer_container_artifact_repository_labels
}
// PROVISION ARTIFACT REGISTRY REPOSITORY IN PACKER PROJECT FOR terraform-validator CONTAINER IMAGE

#----------------------------------------------------------------------------
# terraform-validator CONTAINER ARTIFACT REGISTRY REPOSITORY
#----------------------------------------------------------------------------

module "terraform_validator_container_artifact_registry_repository" {
  source = "../../../modules/artifact_registry"

  artifact_repository_project_id  = module.packer-project.project_id
  artifact_repository_name        = var.terraform_validator_container_artifact_repository_name
  artifact_repository_format      = var.terraform_validator_container_artifact_repository_format
  artifact_repository_location    = local.packer_default_region
  artifact_repository_description = var.terraform_validator_container_artifact_repository_description
  artifact_repository_labels      = var.terraform_validator_container_artifact_repository_labels
}

// THE BELOW POLICIES ARE LISTED HERE TO DISABLE THEN RE-ENABLE DURING CLOUD BUILD PIPELINE RUNS
// THESE POLICIES ARE ALSO APPLIED AT THE SRDE FOLDER LEVEL IN THE `../srde-folder-policies` DIRECTORY

#----------------------------------------------------------------------------
# PACKER PROJECT SERVICE ACCOUNT CREATION
#----------------------------------------------------------------------------

# 1-12-22: Commenting out

# module "packer_project_disable_sa_creation" {
#   source      = "terraform-google-modules/org-policy/google"
#   version     = "~> 3.0.2"
#   constraint  = "constraints/iam.disableServiceAccountCreation"
#   policy_type = "boolean"
#   policy_for  = "project"
#   project_id  = module.packer-project.project_id
#   enforce     = var.enforce_packer_project_disable_sa_creation
# }

#----------------------------------------------------------------------------
# MARKETPLACE IAM PERMISSIONS
# To create the RHEL CIS image, the operator
# will need additional permissions
#----------------------------------------------------------------------------

module "project_iam_marketplace_role" {
  source = "../../../modules/iam/project_iam"

  project_id            = module.packer-project.project_id
  project_member        = var.deploymentmanager_editor
  project_iam_role_list = var.packer_project_iam_roles
}