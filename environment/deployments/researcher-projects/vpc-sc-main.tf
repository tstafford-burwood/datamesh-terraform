// DATA BLOCK
// RETRIEVE DATA LAKE PROJECT NUMBER (I.E. 1234567890)

data "google_project" "data_lake_project_number" {
  project_id = local.data_lake_project_id
}

data "google_project" "packer_project_number" {
  project_id = local.packer_project_id
}

// CONSTANTS MODULE IMPORTED IN MAIN.TF OF THIS WORKING DIRECTORY

locals {
  parent_access_policy_id          = module.constants.value.parent_access_policy_id
  cloudbuild_access_level_name     = module.constants.value.cloudbuild_access_level_name
  cloud_composer_access_level_name = module.constants.value.cloud_composer_access_level_name
  srde_admin_access_level_name     = module.constants.value.srde_admin_access_level_name
  vpc_sc_all_restricted_apis       = module.constants.value.vpc_sc_all_restricted_apis
  cloudbuild_service_account       = module.constants.value.cloudbuild_service_account
  packer_project_id                = module.constants.value.packer_project_id
  packer_project_number            = data.google_project.packer_project_number.number
  data_lake_project_id             = module.constants.value.data_lake_project_id
  data_lake_project_number         = data.google_project.data_lake_project_number.number
}

#--------------------------------------------
# VPC SC RESEARCHER GROUP MEMBER ACCESS LEVEL
#--------------------------------------------

module "researcher_group_member_access_level" {
  source = "../../../../modules/vpc_service_controls/access_levels"

  // REQUIRED
  access_level_name  = var.access_level_name
  parent_policy_name = local.parent_access_policy_id

  // OPTIONAL - NON PREMIUM
  combining_function       = var.combining_function
  access_level_description = var.access_level_description
  ip_subnetworks           = var.ip_subnetworks
  access_level_members     = var.access_level_members
  negate                   = var.negate
  regions                  = var.regions
  required_access_levels   = var.required_access_levels

  // OPTIONAL - DEVICE POLICY (PREMIUM FEATURE)
  allowed_device_management_levels = var.allowed_device_management_levels
  allowed_encryption_statuses      = var.allowed_encryption_statuses
  minimum_version                  = var.minimum_version
  os_type                          = var.os_type
  require_corp_owned               = var.require_corp_owned
  require_screen_lock              = var.require_screen_lock
}

// PERIMETER AROUND RESEARCHER WORKSPACE PROJECT
// LOCAL.PARENT_ACCESS_POLICY_NAME SET IN MAIN.TF OF THIS DIRECTORY

#-----------------------------------------------------------
# RESEARCHER WORKSPACE VPC SERVICE CONTROL REGULAR PERIMETER
#-----------------------------------------------------------

# TODO: Consider implementing ingress/egress rules instead of using bridges (determine whether or not this is requires too much maintenance.)

module "researcher_workspace_regular_service_perimeter" {
  source = "../../../../modules/vpc_service_controls/regular_service_perimeter"

  // REQUIRED
  regular_service_perimeter_description = var.researcher_workspace_regular_service_perimeter_description
  regular_service_perimeter_name        = var.researcher_workspace_regular_service_perimeter_name
  parent_policy_id                      = local.parent_access_policy_id

  // OPTIONAL

  access_level_names = [
    local.cloudbuild_access_level_name,
    local.cloud_composer_access_level_name,
    module.researcher_group_member_access_level.name
    # local.srde_admin_access_level_name // BREAK GLASS USAGE
  ]

  project_to_add_perimeter = [module.researcher-workspace-project.project_number]
  restricted_services      = local.vpc_sc_all_restricted_apis
  enable_restriction       = var.researcher_workspace_regular_service_perimeter_enable_restriction
  allowed_services         = var.researcher_workspace_regular_service_perimeter_allowed_services
  #egress_policies          = var.researcher_workspace_regular_service_perimeter_egress_policies
  egress_policies = [ // Allows the workspace project to pull the Path ML container in the Packer project. Note that the identity is set to the user instead of the VM's service account.
  {
    "from" = {
      "identity_type" = ""
      "identities"    = var.researcher_workspace_regular_service_perimeter_egress_policies_identities // RESEARCH GROUP USER // TODO: Consider changing this to the service account of the VM that will be running the Path ML container
    },
    "to" = {
      "resources" = ["${local.packer_project_number}"] // PACKER PROJECT NUMBER
      "operations" = {
        "artifactregistry.googleapis.com" = {
          "methods" = [
            "artifactregistry.googleapis.com/DockerRead"
          ]
        }
      }
    }
  },
  { // Allows the Cloud Build service account in the workspace project to retrieve the Deep Learning VM image from the Packer project
    "from" = {
      "identity_type" = ""
      "identities"    = ["serviceAccount:${local.cloudbuild_service_account}"] // CLOUDBUILD SERVICE ACCOUNT
    },
    "to" = {
      "resources" = ["${local.packer_project_number}"] // PACKER PROJECT NUMBER
      "operations" = {
        "compute.googleapis.com" = {
          "methods" = [
            "InstancesService.Insert"
          ]
        }
      }
    }
  }
]

  depends_on = [module.researcher-workspace-project]
}

// BRIDGE PERIMETER BETWEEN STAGING PROJECT AND RESEARCHER WORKSPACE PROJECT
// LOCAL.STAGING_PROJECT_NUMBER SET IN MAIN.TF OF THIS DIRECTORY
// LOCAL.PARENT_ACCESS_POLICY_NAME SET IN MAIN.TF OF THIS DIRECTORY

#---------------------------------------------------------------
# RESEARCHER WORKSPACE & STAGING PROJECT VPC SC BRIDGE PERIMETER
#---------------------------------------------------------------

module "researcher_workspace_and_staging_project_bridge_perimeter" {
  source = "../../../../modules/vpc_service_controls/bridge_service_perimeter"

  // REQUIRED

  bridge_service_perimeter_name = var.workspace_and_staging_bridge_service_perimeter_name
  parent_policy_name            = local.parent_access_policy_id

  bridge_service_perimeter_resources = [
    local.staging_project_number,
    module.researcher-workspace-project.project_number
  ]

  // OPTIONAL

  bridge_service_perimeter_description = var.workspace_and_staging_bridge_service_perimeter_description

  depends_on = [module.researcher_workspace_regular_service_perimeter]
}

// DATA LAKE PROJECT NUMBER IS OBTAINED AFTER THE DATA LAKE PROJECT IS PROVISONED

#-----------------------------------------------------------------
# RESEARCHER WORKSPACE & DATA LAKE PROJECT VPC SC BRIDGE PERIMETER
#-----------------------------------------------------------------

module "researcher_workspace_and_data_lake_project_bridge_perimeter" {
  source = "../../../../modules/vpc_service_controls/bridge_service_perimeter"

  // REQUIRED

  bridge_service_perimeter_name = var.workspace_and_data_lake_bridge_service_perimeter_name
  parent_policy_name            = local.parent_access_policy_id

  bridge_service_perimeter_resources = [
    local.data_lake_project_number,
    module.researcher-workspace-project.project_number
  ]

  // OPTIONAL

  bridge_service_perimeter_description = var.workspace_and_data_lake_bridge_service_perimeter_description

  depends_on = [module.researcher_workspace_regular_service_perimeter]
}

// PERIMETER AROUND RESEARCHER BASTION PROJECT
// LOCAL.PARENT_ACCESS_POLICY_NAME SET IN MAIN.TF OF THIS DIRECTORY

#-----------------------------------------------------------------
# RESEARCHER BASTION PROJECT VPC SERVICE CONTROL REGULAR PERIMETER
#-----------------------------------------------------------------

# TODO: Probably don't need this, since all communication is SSH over peered VPC.

module "researcher_bastion_project_regular_service_perimeter" {
  // This policy allows access to retrieve the bastion VM image from the Packer project
  source = "../../../../modules/vpc_service_controls/regular_service_perimeter"

  // REQUIRED
  regular_service_perimeter_description = var.researcher_bastion_project_regular_service_perimeter_description
  regular_service_perimeter_name        = var.researcher_bastion_project_regular_service_perimeter_name
  parent_policy_id                      = local.parent_access_policy_id

  // OPTIONAL

  access_level_names = [
    local.cloudbuild_access_level_name,
    local.cloud_composer_access_level_name,
    module.researcher_group_member_access_level.name
    # local.srde_admin_access_level_name // BREAK GLASS USAGE
  ]

  project_to_add_perimeter = [module.researcher-bastion-access-project.project_number]
  restricted_services      = local.vpc_sc_all_restricted_apis
  enable_restriction       = var.researcher_bastion_project_regular_service_perimeter_enable_restriction
  allowed_services         = var.researcher_bastion_project_regular_service_perimeter_allowed_services
  
  #egress_policies          = var.researcher_bastion_project_regular_service_perimeter_egress_policies
  egress_policies = [ // This policy allows access to retrieve the bastion VM image from the Packer project
  {
    "from" = {
      "identity_type" = ""
      "identities"    = ["serviceAccount:${local.cloudbuild_service_account}"] // CLOUDBUILD SERVICE ACCOUNT
    },
    "to" = {
      "resources" = ["${local.packer_project_number}"] // PACKER PROJECT NUMBER
      "operations" = {
        "compute.googleapis.com" = {
          "methods" = [
            "InstancesService.Insert"
          ]
        }
      }
    }
  }
]
  depends_on               = [module.researcher-bastion-access-project]
}

// PERIMETER AROUND RESEARCHER EXTERNAL DATA EGRESS PROJECT
// NEEDED WITH BRIDGE PERIMETER FOR CLOUD COMPOSER TO MOVE POST-INSPECTION DATA TO EXTERNAL DATA EGRESS PROJECT

#-------------------------------------------------------------------------
# RESEARCHER EXTERNAL DATA EGRESS PROJECT VPC SC REGULAR SERVICE PERIMETER
#-------------------------------------------------------------------------

# TODO: Consider implementing ingress/egress rules instead of using bridges (determine whether or not this is requires too much maintenance.)

module "researcher_data_egress_regular_service_perimeter" {
  source = "../../../../modules/vpc_service_controls/regular_service_perimeter"

  // REQUIRED
  regular_service_perimeter_description = var.researcher_data_egress_regular_service_perimeter_description
  regular_service_perimeter_name        = var.researcher_data_egress_regular_service_perimeter_name
  parent_policy_id                      = local.parent_access_policy_id

  // OPTIONAL
  access_level_names       = var.researcher_data_egress_regular_service_perimeter_access_levels
  project_to_add_perimeter = [module.researcher-data-egress-project.project_number]
  restricted_services      = var.researcher_data_egress_regular_service_perimeter_restricted_services
  enable_restriction       = var.researcher_data_egress_regular_service_perimeter_enable_restriction
  allowed_services         = var.researcher_data_egress_regular_service_perimeter_allowed_services
  depends_on               = [module.researcher-data-egress-project]
}

// BRIDGE PERIMETER BETWEEN STAGING PROJECT AND RESEARCHER EXTERNAL DATA EGRESS PROJECT
// NEEDED FOR CLOUD COMPOSER TO MOVE APPROVED/INSPECTED DATA

// LOCAL.STAGING_PROJECT_NUMBER SET IN MAIN.TF OF THIS DIRECTORY
// LOCAL.PARENT_ACCESS_POLICY_NAME SET IN MAIN.TF OF THIS DIRECTORY

#--------------------------------------------------------------------------
# RESEARCHER EXTERNAL DATA EGRESS & STAGING PROJECT VPC SC BRIDGE PERIMETER
#--------------------------------------------------------------------------

module "researcher_external_data_egress_and_staging_project_bridge_perimeter" {
  source = "../../../../modules/vpc_service_controls/bridge_service_perimeter"

  // REQUIRED

  bridge_service_perimeter_name = var.external_egress_and_staging_bridge_service_perimeter_name
  parent_policy_name            = local.parent_access_policy_id

  bridge_service_perimeter_resources = [
    local.staging_project_number,
    module.researcher-data-egress-project.project_number
  ]

  // OPTIONAL

  bridge_service_perimeter_description = var.external_egress_and_staging_bridge_service_perimeter_description

  depends_on = [module.researcher_data_egress_regular_service_perimeter]
}
