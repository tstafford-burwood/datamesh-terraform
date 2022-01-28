#----------------------------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------------------------

module "constants" {
  source = "../../foundation/constants"
}

#----------------------------------------------------------------------------------------------
# TERRAFORM STATE IMPORTS
# Retrieve Staging project state
#----------------------------------------------------------------------------------------------

data "terraform_remote_state" "imaging_project" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = format("%s/%s", var.terraform_foundation_state_prefix, "imaging-project")
  }
}

data "terraform_remote_state" "staging_project" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = format("%s/%s", var.terraform_foundation_state_prefix, "staging-project")
  }
}

data "terraform_remote_state" "folders" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = format("%s/%s", var.terraform_foundation_state_prefix, "folders")
  }
}

#----------------------------------------------------------------------------------------------
# SET CONSTANT MODULE VALUES AS LOCALS
#----------------------------------------------------------------------------------------------

locals {
  staging_project_id        = data.terraform_remote_state.staging_project.outputs.staging_project_id
  staging_project_number    = data.terraform_remote_state.staging_project.outputs.staging_project_number
  staging_default_region    = data.terraform_remote_state.staging_project.outputs.subnets_regions[0]
  imaging_project_id        = data.terraform_remote_state.imaging-project.outputs.project_id
  org_id                    = module.constants.value.org_id
  billing_account_id        = module.constants.value.billing_account_id
  srde_folder_id            = data.terraform_remote_state.folders.outputs.ids[var.researcher_workspace_name]
  bastion_default_region    = var.bastion_default_region
  workspace_default_region  = var.workspace_default_region
  researcher_workspace_name = var.researcher_workspace_name

  # Packer Images
  #packer_base_image_id_bastion = module.constants.value.packer_base_image_id_bastion
  #packer_base_image_id_deeplearning = module.constants.value.packer_base_image_id_deeplearning
  #workspace_default_region  = module.constants.value.workspace_default_region
  #bastion_default_region    = module.constants.value.bastion_default_region
}

#----------------------------------------------------------------------------------------------
# CONFIGURE VPC-PEERING BETWEEN WORKSPACE PROJECT AND BASTION PROJECT
#----------------------------------------------------------------------------------------------

module "researcher_workspace_to_bastion_vpc_peer" {
  # WORKSAPCE TO RESEARCHER BASTION VPC PEERING
  source = "../../../modules/vpc_peering"

  vpc_peering_name                    = "${local.researcher_workspace_name}-workspace-project-to-bastion-project"
  vpc_network_name                    = module.workspace_vpc.network_self_link
  peer_network_name                   = module.bastion_project_vpc.network_self_link
  export_custom_routes                = var.researcher_workspace_to_bastion_export_custom_routes
  import_custom_routes                = var.researcher_workspace_to_bastion_import_custom_routes
  export_subnet_routes_with_public_ip = var.researcher_workspace_to_bastion_export_subnet_routes_with_public_ip
  import_subnet_routes_with_public_ip = var.researcher_workspace_to_bastion_import_subnet_routes_with_public_ip
}

module "researcher_bastion_to_workspace_vpc_peer" {
  # BASTION TO WORKSAPCE VPC PEERING
  source = "../../../modules/vpc_peering"

  vpc_peering_name                    = "${local.researcher_workspace_name}-bastion-project-to-workspace-project"
  vpc_network_name                    = module.bastion_project_vpc.network_self_link
  peer_network_name                   = module.workspace_vpc.network_self_link
  export_custom_routes                = var.researcher_bastion_to_workspace_export_custom_routes
  import_custom_routes                = var.researcher_bastion_to_workspace_import_custom_routes
  export_subnet_routes_with_public_ip = var.researcher_bastion_to_workspace_export_subnet_routes_with_public_ip
  import_subnet_routes_with_public_ip = var.researcher_bastion_to_workspace_import_subnet_routes_with_public_ip
}