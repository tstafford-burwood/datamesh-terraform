#------------------
# IMPORT CONSTANTS
#------------------

module "constants" {
  source = "../constants"
}

// SET LOCAL VALUES

locals {
  srde_folder_id             = module.constants.value.srde_folder_id
  cloudbuild_service_account = module.constants.value.cloudbuild_service_account
  automation_project_id      = module.constants.value.automation_project_id
  packer_default_region      = module.constants.value.packer_default_region
}

// THIS WILL PROVISION PIPELINES THAT ARE DEFINED IN var.srde_plan_trigger_name
// THIS DOES NOT INCLUDE PIPELINE PROVISIONING FOR COMPOSER OR VPC SERVICE CONTROLS IN environment/foundation
// ADDITIONAL PIPELINES ARE PROVISIONED FURTHER BELOW IN THIS FILE

#---------------------------
# CLOUDBUILD TRIGGERS - PLAN
#---------------------------

resource "google_cloudbuild_trigger" "srde_plan_triggers" {

  for_each = toset(var.srde_plan_trigger_name)

  project = local.automation_project_id
  name    = format("sde-%s-plan", each.value)

  description    = format("Pipeline for SDE-%s created with Terraform", each.value)
  tags           = var.srde_plan_trigger_tags
  disabled       = var.srde_plan_trigger_disabled
  filename       = format("cloudbuild/deployments/-%s-plan.yaml", each.value)
  included_files = formatlist("environment/deployments/%s/terraform.tfvars", each.value)

  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_state_prefix
    _TAG                 = var.terraform_container_version
    _COMPOSER_DAG_BUCKET = var.srde_composer_dag_bucket
  }
}

// THIS WILL PROVISION PIPELINES THAT ARE DEFINED IN var.srde_plan_trigger_name
// THIS DOES NOT INCLUDE PIPELINE PROVISIONING FOR COMPOSER OR VPC SERVICE CONTROLS IN environment/foundation

#----------------------------
# CLOUDBUILD TRIGGERS - APPLY
#----------------------------

resource "google_cloudbuild_trigger" "srde_apply_triggers" {

  for_each = toset(var.srde_apply_trigger_name)

  project = local.automation_project_id
  name    = format("sde-%s-apply", each.value)

  description    = format("Pipeline for %s created with Terraform", each.value)
  tags           = var.srde_plan_trigger_tags
  disabled       = var.srde_plan_trigger_disabled
  filename       = format("cloudbuild/deployments/%s-apply.yaml", each.value)
  included_files = formatlist("environment/deployments/%s/terraform.tfvars", each.value)

  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_state_prefix
    _TAG                 = var.terraform_container_version
    _COMPOSER_DAG_BUCKET = var.srde_composer_dag_bucket
  }
}

// THIS WILL PROVISION A PIPELINE FOR CLOUD COMPOSER LOCATED IN environment/deployments/srde/staging-project/cloud-composer

#------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER PLAN
#------------------------------------

resource "google_cloudbuild_trigger" "composer_plan_trigger" {

  project = local.automation_project_id
  name    = "cloudbuild-composer-plan"

  description    = "Pipeline for SRDE-Composer created with Terraform"
  tags           = var.composer_plan_trigger_tags
  disabled       = var.composer_plan_trigger_disabled
  filename       = "cloudbuild/deployments/composer-plan.yaml"
  included_files = ["environment/deployments/staging-project/cloud-composer/terraform.tfvars"]

  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_state_prefix
    _TAG                 = var.terraform_container_version
    _COMPOSER_DAG_BUCKET = var.srde_composer_dag_bucket
  }
}

// THIS WILL PROVISION A PIPELINE FOR CLOUD COMPOSER LOCATED IN environment/deployments/srde/staging-project/cloud-composer

#-------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER APPLY
#-------------------------------------

resource "google_cloudbuild_trigger" "composer_apply_trigger" {

  project = local.automation_project_id
  name    = "srde-cloudbuild-composer-apply"

  description    = "Pipeline for SRDE-Composer created with Terraform"
  tags           = var.srde_composer_apply_trigger_tags
  disabled       = var.srde_composer_apply_trigger_disabled
  filename       = "cloudbuild/deployments/cloudbuild-composer-apply.yaml"
  included_files = ["environment/deployments/wcm-srde/staging-project/cloud-composer/terraform.tfvars"]

  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_state_prefix
    _TAG                 = var.terraform_container_version
    _COMPOSER_DAG_BUCKET = var.srde_composer_dag_bucket
  }
}

// THIS WILL PROVISION A PIPELINE FOR THE VPC SERVICE CONTROL ACCESS LEVELS LOCATED IN environment/foundation/vpc-service-controls/

#-------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - CLOUDBUILD SERVICE ACCOUNT ACCESS LEVEL PLAN
#-------------------------------------------------------------------

resource "google_cloudbuild_trigger" "srde_cloudbuild_sa_access_level_plan" {

  project = local.automation_project_id
  name    = "srde-cloudbuild-access-level-plan"

  description    = "Pipeline for SRDE Cloudbuild Access Level created with Terraform"
  tags           = var.srde_cloudbuild_sa_access_level_plan_trigger_tags
  disabled       = var.srde_cloudbuild_sa_access_level_plan_trigger_disabled
  filename       = "cloudbuild/foundation/cloudbuild-access-levels-plan.yaml"
  included_files = ["environment/foundation/vpc-service-controls/cloudbuild-access-levels/terraform.tfvars"]

  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }

  substitutions = {
    _BUCKET = var.terraform_state_bucket
    _PREFIX = var.terraform_state_prefix
    _TAG    = var.terraform_container_version
  }
}

// THIS WILL PROVISION A PIPELINE FOR THE VPC SERVICE CONTROL ACCESS LEVELS LOCATED IN environment/foundation/vpc-service-controls/

#--------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - CLOUDBUILD SERVICE ACCOUNT ACCESS LEVEL APPLY
#--------------------------------------------------------------------

resource "google_cloudbuild_trigger" "srde_cloudbuild_sa_access_level_apply" {

  project = local.automation_project_id
  name    = "srde-cloudbuild-access-level-apply"

  description    = "Pipeline for SRDE Cloudbuild Access Level created with Terraform"
  tags           = var.srde_cloudbuild_sa_access_level_apply_trigger_tags
  disabled       = var.srde_cloudbuild_sa_access_level_apply_trigger_disabled
  filename       = "cloudbuild/foundation/cloudbuild-access-levels-apply.yaml"
  included_files = ["environment/foundation/vpc-service-controls/cloudbuild-access-levels/terraform.tfvars"]

  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }

  substitutions = {
    _BUCKET = var.terraform_state_bucket
    _PREFIX = var.terraform_state_prefix
    _TAG    = var.terraform_container_version
  }
}

#---------------------------------------------------
# CLOUDBUILD TRIGGERS - SRDE ADMIN ACCESS LEVEL PLAN
#---------------------------------------------------

resource "google_cloudbuild_trigger" "srde_admin_access_level_plan" {

  project = local.automation_project_id
  name    = "srde-cloudbuild-srde-admin-access-level-plan"

  description    = "Pipeline for SRDE Admin Access Level created with Terraform"
  tags           = var.srde_admin_access_level_plan_trigger_tags
  disabled       = var.srde_admin_access_level_plan_trigger_disabled
  filename       = "cloudbuild/foundation/cloudbuild-srde-admin-access-levels-plan.yaml"
  included_files = ["environment/foundation/vpc-service-controls/srde-admin-access-levels/terraform.tfvars"]

  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }

  substitutions = {
    _BUCKET = var.terraform_state_bucket
    _PREFIX = var.terraform_state_prefix
    _TAG    = var.terraform_container_version
  }
}

#----------------------------------------------------
# CLOUDBUILD TRIGGERS - SRDE ADMIN ACCESS LEVEL APPLY
#----------------------------------------------------

resource "google_cloudbuild_trigger" "srde_admin_access_level_apply" {

  project = local.automation_project_id
  name    = "srde-cloudbuild-srde-admin-access-level-apply"

  description    = "Pipeline for SRDE Admin Access Level created with Terraform"
  tags           = var.srde_admin_access_level_apply_trigger_tags
  disabled       = var.srde_admin_access_level_apply_trigger_disabled
  filename       = "cloudbuild/foundation/cloudbuild-srde-admin-access-levels-apply.yaml"
  included_files = ["environment/foundation/vpc-service-controls/srde-admin-access-levels/terraform.tfvars"]

  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }

  substitutions = {
    _BUCKET = var.terraform_state_bucket
    _PREFIX = var.terraform_state_prefix
    _TAG    = var.terraform_container_version
  }
}

#---------------------------------------------------
# CLOUDBUILD TRIGGERS - DEEP LEARNING VM IMAGE BUILD
#---------------------------------------------------

resource "google_cloudbuild_trigger" "deep_learning_vm_image_build" {

  project = local.automation_project_id
  name    = "srde-cloudbuild-deep-learning-vm-image-build"

  description    = "Pipeline for Deep Learning VM Image build created with Terraform"
  tags           = var.srde_deep_learning_vm_image_build_trigger_tags
  disabled       = var.srde_deep_learning_vm_image_build_trigger_disabled
  filename       = "cloudbuild/deployments/cloudbuild-packer-deep-learning-image.yaml"
  included_files = ["environment/deployments/wcm-srde/packer-project/researcher-vm-image-build/deep-learning-startup-image-script.sh"]

  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }

  substitutions = {
    _PACKER_PROJECT_ID = var.srde_packer_project_id
    _PACKER_IMAGE_TAG  = var.srde_packer_image_tag
    _REGION            = local.packer_default_region
  }
}

#-------------------------------------------
# CLOUDBUILD TRIGGERS - RHEL CIS IMAGE BUILD 
#-------------------------------------------

resource "google_cloudbuild_trigger" "rhel_cis_image_build" {

  project = local.automation_project_id
  name    = "srde-cloudbuild-rhel-cis-image-build"

  description    = "Pipeline for RHEL CIS Image Build created with Terraform"
  tags           = var.srde_rhel_cis_image_build_trigger_tags
  disabled       = var.srde_rhel_cis_image_build_trigger_disabled
  filename       = "cloudbuild/deployments/cloudbuild-packer-rhel-cis-image.yaml"
  included_files = ["environment/deployments/wcm-srde/packer-project/researcher-vm-image-build/rhel-startup-image-script.sh"]

  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }

  substitutions = {
    _PACKER_PROJECT_ID = var.srde_packer_project_id
    _PACKER_IMAGE_TAG  = var.srde_packer_image_tag
    _REGION            = local.packer_default_region
  }
}

#---------------------------------------------
# CLOUDBUILD TRIGGERS - PACKER CONTAINER IMAGE
#---------------------------------------------

resource "google_cloudbuild_trigger" "packer_container_image" {

  project = local.automation_project_id
  name    = "srde-cloudbuild-packer-container-image"

  description    = "Pipeline for Packer container image created with Terraform"
  tags           = var.srde_packer_container_image_build_trigger_tags
  disabled       = var.srde_packer_container_image_build_trigger_disabled
  filename       = "cloudbuild/deployments/cloudbuild-packer-container.yaml"
  included_files = ["environment/deployments/wcm-srde/packer-project/packer-container/Dockerfile"]

  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }

  substitutions = {
    _PACKER_PROJECT_ID = var.srde_packer_project_id
    _REGION            = local.packer_default_region
  }
}

#----------------------------------------------
# CLOUDBUILD TRIGGERS - PATH ML CONTAINER IMAGE
#----------------------------------------------

resource "google_cloudbuild_trigger" "path_ml_container_image" {

  project = local.automation_project_id
  name    = "srde-cloudbuild-path-ml-container-image"

  description    = "Pipeline for Path ML container image created with Terraform"
  tags           = var.srde_path_ml_container_image_build_trigger_tags
  disabled       = var.srde_path_ml_container_image_build_trigger_disabled
  filename       = "cloudbuild/deployments/cloudbuild-pathml-container.yaml"
  included_files = ["environment/deployments/wcm-srde/packer-project/pathml-container/Dockerfile"]

  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }

  substitutions = {
    _PACKER_PROJECT_ID = var.srde_packer_project_id
    _REGION            = local.packer_default_region
  }
}

#----------------------------------------------------------
# CLOUDBUILD TRIGGERS - terraform-validator CONTAINER IMAGE
#----------------------------------------------------------

resource "google_cloudbuild_trigger" "terraform_validator_container_image" {

  project = local.automation_project_id
  name    = "srde-cloudbuild-terraform-validator-container-image"

  description    = "Pipeline for terraform-validator container image created with Terraform"
  tags           = var.srde_terraform_validator_container_image_build_trigger_tags
  disabled       = var.srde_terraform_validator_container_image_build_trigger_disabled
  filename       = "cloudbuild/deployments/cloudbuild-terraform-validator-container.yaml"
  included_files = ["environment/deployments/wcm-srde/packer-project/terraform-validator-container/Dockerfile"]

  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }

  substitutions = {
    _PACKER_PROJECT_ID = var.srde_packer_project_id
    _REGION            = local.packer_default_region
  }
}

# TODO: Add Cloud Build pipelines for: 1) cloudbuild-packer-deep-learning-image.yaml; 2) cloudbuild-packer-rhel-cis-image.yaml; 3) cloudbuild-pathml-container.yaml; and 4) cloudbuild-packer-container.yaml

# TODO: Create a new Cloud Build pipeline to apply this TF, which will provision all of the other pipelines.

#--------------------------
# FOLDER IAM MEMBER MODULE
#--------------------------

module "folder_iam_member" {
  source = "../../../../modules/iam/folder_iam"

  folder_id     = local.srde_folder_id
  iam_role_list = var.iam_role_list
  folder_member = "serviceAccount:${local.cloudbuild_service_account}"
}