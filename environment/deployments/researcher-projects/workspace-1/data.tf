#----------------------------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------------------------

module "constants" {
  source = "../../../foundation/constants"
}

#----------------------------------------------------------------------------------------------
# TERRAFORM STATE IMPORTS
# Retrieve Terraform state
#----------------------------------------------------------------------------------------------

data "terraform_remote_state" "image_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/image"
  }
}

data "terraform_remote_state" "staging_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-ops"
  }
}

data "terraform_remote_state" "cloud_composer" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/cloud-composer"
  }
}

data "terraform_remote_state" "notebook_sa" {
  # Get the Notebook Service Account from TFSTATE
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-ops"
  }
}

data "terraform_remote_state" "data_ingress" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-ingress"
  }
}

data "terraform_remote_state" "datalake_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-lake"
  }
}

data "terraform_remote_state" "folders" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/folders"
  }
}

data "terraform_remote_state" "vpc_sc" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/vpc-sc"
  }
}

# data "terraform_remote_state" "egress_project" {
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket = module.constants.value.terraform_state_bucket
#     prefix = "deployments/${terraform.workspace}/researcher-projects/${var.researcher_workspace_name}/egress"
#   }
# }

# data "google_compute_image" "deep_learning_image" {
#   # If family is specified, will return latest image that is part of image family
#   count   = var.num_instances
#   project = local.imaging_project_id
#   family  = "packer-data-science"
# }

locals {
  environment                = module.constants.value.environment
  org_id                     = module.constants.value.org_id
  cloudbuild_service_account = module.constants.value.cloudbuild_service_account
  billing_account_id         = var.billing_account == "" ? module.constants.value.billing_account_id : var.billing_account
  region                     = var.region == "" ? module.constants.value.default_region : var.region

  composer_sa            = data.terraform_remote_state.cloud_composer.outputs.email
  srde_folder_id         = data.terraform_remote_state.folders.outputs.ids[var.researcher_workspace_name]
  staging_project_id     = data.terraform_remote_state.staging_project.outputs.staging_project_id
  staging_project_number = data.terraform_remote_state.staging_project.outputs.staging_project_number
  data_ops_bucket        = data.terraform_remote_state.staging_project.outputs.research_to_bucket
  cordon_bucket          = data.terraform_remote_state.staging_project.outputs.csv_names_list[0]
  pubsub_appint_approval = data.terraform_remote_state.staging_project.outputs.pubsub_trigger_appint_approval
  pubsub_appint_results  = data.terraform_remote_state.staging_project.outputs.pubsub_trigger_appint_results
  data_ingress           = try(data.terraform_remote_state.data_ingress.outputs.project_number, "")
  data_ingress_id        = try(data.terraform_remote_state.data_ingress.outputs.project_id, "")
  data_ingress_bucket    = data.terraform_remote_state.data_ingress.outputs.bucket_names
  data_lake              = try(data.terraform_remote_state.datalake_project.outputs.data_lake_project_number, "")
  data_lake_id           = try(data.terraform_remote_state.datalake_project.outputs.data_lake_project_id, "")
  data_lake_bucket       = data.terraform_remote_state.datalake_project.outputs.research_to_bucket
  data_lake_custom_role  = data.terraform_remote_state.datalake_project.outputs.bucket_list_custom_role_name
  #composer_sa               = try(data.terraform_remote_state.staging_project.outputs.email, "")
  dag_bucket = data.terraform_remote_state.cloud_composer.outputs.dag_bucket_name
  #workspace_project_id      = module.workspace_project.project_id
  researcher_workspace_name = lower(var.researcher_workspace_name)

  imaging_project_id     = data.terraform_remote_state.image_project.outputs.project_id
  imaging_project_number = data.terraform_remote_state.image_project.outputs.project_number
  apt_repo_name          = data.terraform_remote_state.image_project.outputs.apt_repo_name
  notebook_sa            = try(data.terraform_remote_state.notebook_sa.outputs.notebook_sa_email, "")
  #egress                    = try(data.terraform_remote_state.egress_project.outputs.project_number, "")
  imaging_bucket       = data.terraform_remote_state.image_project.outputs.research_to_bucket
  vpc_connector        = data.terraform_remote_state.staging_project.outputs.vpc_access_connector_id[0]
  composer_ariflow_uri = try(data.terraform_remote_state.cloud_composer.outputs.airflow_uri, "")
  policy_for           = "project"
  composer_version     = "composer-2.1.8-airflow-2.4.3"

  # Get VPC Service Control Access Context Manager for Admins, Stewards and Service Accounts
  parent_access_policy_id = try(data.terraform_remote_state.vpc_sc.outputs.parent_access_policy_id, "")
  fdn_admins              = try(data.terraform_remote_state.vpc_sc.outputs.admin_access_level_name, "")
  fdn_sa                  = try(data.terraform_remote_state.vpc_sc.outputs.serviceaccount_access_level_name, "")
  fnd_stewards            = try(data.terraform_remote_state.vpc_sc.outputs.stewards_access_level_name, "")

  # Read the list of folders and create a dag per researcher initiative
  wrkspc_folders  = data.terraform_remote_state.folders.outputs.ids
  research_wrkspc = [for k, v in local.wrkspc_folders : lower(k)]

}