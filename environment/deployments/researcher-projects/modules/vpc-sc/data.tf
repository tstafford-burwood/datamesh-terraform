#------------------------------------------------------------------------
# IMPORT CONSTANTS
#------------------------------------------------------------------------

# module "constants" {
#   source = "../../../foundation/constants"
# }

#------------------------------------------------------------------------
# RETRIEVE TF STATE
#------------------------------------------------------------------------

# data "terraform_remote_state" "notebook_sa" {
#   # Get the Notebook Service Account from TFSTATE
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket = module.constants.value.terraform_state_bucket
#     prefix = "foundation/${terraform.workspace}/data-ops"
#   }
# }

# data "terraform_remote_state" "staging_project" {
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket = module.constants.value.terraform_state_bucket
#     prefix = "foundation/${terraform.workspace}/data-ops"
#   }
# }

# data "terraform_remote_state" "data_ingress" {
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket = module.constants.value.terraform_state_bucket
#     prefix = "foundation/${terraform.workspace}/data-ingress"
#   }
# }

# data "terraform_remote_state" "image_project" {
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket = module.constants.value.terraform_state_bucket
#     prefix = "foundation/${terraform.workspace}/image"
#   }
# }

# data "terraform_remote_state" "datalake_project" {
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket = module.constants.value.terraform_state_bucket
#     prefix = "foundation/${terraform.workspace}/data-lake"
#   }
# }

# data "terraform_remote_state" "vpc_sc" {
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket = module.constants.value.terraform_state_bucket
#     prefix = "foundation/${terraform.workspace}/vpc-sc"
#   }
# }

# data "terraform_remote_state" "egress_project" {
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket = module.constants.value.terraform_state_bucket
#     prefix = "deployments/${terraform.workspace}/researcher-projects/${var.researcher_workspace_name}/egress"
#   }
# }

# data "terraform_remote_state" "workspace_project" {
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket = module.constants.value.terraform_state_bucket
#     prefix = "deployments/${terraform.workspace}/researcher-projects/${var.researcher_workspace_name}/workspace"
#   }
# }

#------------------------------------------------------------------------
# SET LOCAL VALUES
#------------------------------------------------------------------------

locals {
  environment = var.environment

  # Get VPC Service Control Access Context Manager for Admins, Stewards and Service Accounts
  parent_access_policy_id = var.access_policy_id
  fdn_admins              = var.admin_access_level_name
  fdn_sa                  = var.serviceaccount_access_level_name
  fnd_stewards            = var.stewards_access_level_name

  cloudbuild_service_account = var.cloudbuild_service_account
  notebook_sa                = var.notebook_sa_email
  image_project              = var.imaging_project_number
  data_ingress               = var.data_ingress_project_number
  data_ops                   = var.data_ingress_project_number
  data_lake                  = var.data_lake_project_number
  workspace                  = var.workspace_project_number
  egress                     = var.egress_project_number
}