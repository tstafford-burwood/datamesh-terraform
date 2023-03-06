#------------------------------------------------------------------------
# IMPORT CONSTANTS
#------------------------------------------------------------------------

module "constants" {
  source = "../../../foundation/constants"
}

#------------------------------------------------------------------------
# RETRIEVE TF STATE
#------------------------------------------------------------------------

data "terraform_remote_state" "notebook_sa" {
  # Get the Notebook Service Account from TFSTATE
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-ops"
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

data "terraform_remote_state" "data_ingress" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/data-ingress"
  }
}

data "terraform_remote_state" "image_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/image"
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

data "terraform_remote_state" "vpc_sc" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/${terraform.workspace}/vpc-sc"
  }
}

data "terraform_remote_state" "egress_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "deployments/${terraform.workspace}/researcher-projects/${var.researcher_workspace_name}/egress"
  }
}

data "terraform_remote_state" "workspace_project" {
  backend   = "gcs"
  workspace = terraform.workspace
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "deployments/${terraform.workspace}/researcher-projects/${var.researcher_workspace_name}/workspace"
  }
}

#------------------------------------------------------------------------
# SET LOCAL VALUES
#------------------------------------------------------------------------

locals {
  environment = module.constants.value.environment

  # Get VPC Service Control Access Context Manager for Admins, Stewards and Service Accounts
  parent_access_policy_id = try(data.terraform_remote_state.vpc_sc.outputs.parent_access_policy_id, "")
  fdn_admins              = try(data.terraform_remote_state.vpc_sc.outputs.admin_access_level_name, "")
  fdn_sa                  = try(data.terraform_remote_state.vpc_sc.outputs.serviceaccount_access_level_name, "")
  fnd_stewards            = try(data.terraform_remote_state.vpc_sc.outputs.stewards_access_level_name, "")

  cloudbuild_service_account = module.constants.value.cloudbuild_service_account
  notebook_sa                = try(data.terraform_remote_state.notebook_sa.outputs.notebook_sa_email, "")
  image_project              = try(data.terraform_remote_state.image_project.outputs.project_number, "")
  data_ingress               = try(data.terraform_remote_state.data_ingress.outputs.project_number, "")
  data_ops                   = try(data.terraform_remote_state.staging_project.outputs.staging_project_number, "")
  data_lake                  = try(data.terraform_remote_state.datalake_project.outputs.data_lake_project_number, "")
  workspace                  = try(data.terraform_remote_state.workspace_project.outputs.workspace_project_number, "")
  egress                     = try(data.terraform_remote_state.egress_project.outputs.project_number, "")
}