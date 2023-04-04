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

data "terraform_remote_state" "folders" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/folders"
  }
}

locals {
  environment               = module.constants.value.environment
  org_id                    = module.constants.value.org_id
  billing_account_id        = var.billing_account
  researcher_workspace_name = lower(var.researcher_workspace_name)
  srde_folder_id            = data.terraform_remote_state.folders.outputs.ids[var.researcher_workspace_name]
  staging_project_id        = data.terraform_remote_state.staging_project.outputs.staging_project_id
  staging_project_number    = data.terraform_remote_state.staging_project.outputs.staging_project_number
  vpc_connector             = data.terraform_remote_state.staging_project.outputs.vpc_access_connector_id[0]
  pubsub_appint_results     = data.terraform_remote_state.staging_project.outputs.pubsub_trigger_appint_results
  data_ops_bucket           = data.terraform_remote_state.staging_project.outputs.research_to_bucket
  composer_sa               = try(data.terraform_remote_state.cloud_composer.outputs.email, "")
  composer_ariflow_uri      = try(data.terraform_remote_state.cloud_composer.outputs.airflow_uri, "")
  dag_bucket                = try(data.terraform_remote_state.cloud_composer.outputs.dag_bucket_name, "")
  policy_for                = "project"
  composer_version          = "composer-2.1.8-airflow-2.4.3"

  # Read the list of folders and create a dag per researcher initiative
  wrkspc_folders  = data.terraform_remote_state.folders.outputs.ids
  research_wrkspc = [for k, v in local.wrkspc_folders : lower(k)]
}