#------------------------------------------------------------------------
# IMPORT CONSTANTS
#------------------------------------------------------------------------

module "constants" {
  source = "../constants"
}

#------------------------------------------------------------------------
# RETRIEVE COMPOSER TF STATE
#------------------------------------------------------------------------

data "terraform_remote_state" "cloud_composer" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = format("%s/%s", var.terraform_state_prefix, "cloud-composer")
  }
}

#------------------------------------------------------------------------
# SET LOCALS
#------------------------------------------------------------------------

locals {
  srde_folder_id             = module.constants.value.srde_folder_id
  cloudbuild_service_account = module.constants.value.cloudbuild_service_account
  automation_project_id      = module.constants.value.automation_project_id
  packer_default_region      = module.constants.value.packer_default_region
  # Check if the composer state file is present, if so format the output else an empty string
  composer_gcs_bucket = try(trimsuffix(trimprefix(data.terraform_remote_state.cloud_composer.outputs.gcs_bucket, "gs://"), "/dags"), "")
}


#------------------------------------------------------------------------
# PACKER PROJECT PLAN TRIGGER
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "packer_project_plan" {

  project = local.automation_project_id
  name    =  format("%s-plan-sde", var.packer_project_trigger_name)

  description    = format("Pipeline for SDE-%s created with Terraform", var.packer_project_trigger_name)
  tags           = var.srde_plan_trigger_tags
  disabled       = var.srde_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan.yaml", var.packer_project_trigger_name)
  included_files = formatlist("environment/foundation/%s/env/terraform.tfvars", var.packer_project_trigger_name)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_plan_trigger_invert_regex
      branch       = var.srde_plan_branch_name
    }
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = ""
  }
}

#------------------------------------------------------------------------
# PACKER PROJECT APPLY TRIGGER
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "packer_project_apply" {

  project = local.automation_project_id
  name    =  format("%s-apply-sde", var.packer_project_trigger_name)

  description    = format("Pipeline for SDE-%s created with Terraform", var.packer_project_trigger_name)
  tags           = var.srde_plan_trigger_tags
  disabled       = var.srde_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply.yaml", var.packer_project_trigger_name)
  included_files = formatlist("environment/foundation/%s/env/terraform.tfvars", var.packer_project_trigger_name)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_plan_trigger_invert_regex
      branch       = var.srde_plan_branch_name
    }
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = ""
  }
}


#------------------------------------------------------------------------
# STAGING PROJECT PLAN TRIGGER
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "staging_project_plan" {

  project = local.automation_project_id
  name    =  format("%s-plan-sde", var.staging_project_trigger_name)

  description    = format("Pipeline for SDE-%s created with Terraform", var.staging_project_trigger_name)
  tags           = var.srde_plan_trigger_tags
  disabled       = var.srde_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan.yaml", var.staging_project_trigger_name)
  included_files = formatlist("environment/foundation/%s/env/terraform.tfvars", var.staging_project_trigger_name)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_plan_trigger_invert_regex
      branch       = var.srde_plan_branch_name
    }
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = ""
  }
}

#------------------------------------------------------------------------
# STAGING PROJECT APPLY TRIGGER
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "staging_project_apply" {

  project = local.automation_project_id
  name    =  format("%s-apply-sde", var.staging_project_trigger_name)

  description    = format("Pipeline for SDE-%s created with Terraform", var.staging_project_trigger_name)
  tags           = var.srde_plan_trigger_tags
  disabled       = var.srde_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply.yaml", var.staging_project_trigger_name)
  included_files = formatlist("environment/foundation/%s/env/terraform.tfvars", var.staging_project_trigger_name)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_plan_trigger_invert_regex
      branch       = var.srde_plan_branch_name
    }
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = ""
  }
}


#------------------------------------------------------------------------
# DATA LAKE PROJECT PLAN TRIGGER
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "data_lake_project_plan" {

  project = local.automation_project_id
  name    =  format("%s-plan-sde", var.data_lake_project_trigger_name)

  description    = format("Pipeline for SDE-%s created with Terraform", var.data_lake_project_trigger_name)
  tags           = var.srde_plan_trigger_tags
  disabled       = var.srde_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan.yaml", var.data_lake_project_trigger_name)
  included_files = formatlist("environment/foundation/%s/env/terraform.tfvars", var.data_lake_project_trigger_name)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_plan_trigger_invert_regex
      branch       = var.srde_plan_branch_name
    }
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = ""
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket
  }
}

#------------------------------------------------------------------------
# DATA LAKE PROJECT APPLY TRIGGER
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "data_lake_project_apply" {

  project = local.automation_project_id
  name    =  format("%s-apply-sde", var.data_lake_project_trigger_name)

  description    = format("Pipeline for SDE-%s created with Terraform", var.data_lake_project_trigger_name)
  tags           = var.srde_plan_trigger_tags
  disabled       = var.srde_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply.yaml", var.data_lake_project_trigger_name)
  included_files = formatlist("environment/foundation/%s/env/terraform.tfvars", var.data_lake_project_trigger_name)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_plan_trigger_invert_regex
      branch       = var.srde_plan_branch_name
    }
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = ""
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket
  }
}


#------------------------------------------------------------------------
# RESEARCHER WORKSPACE PROJECT PLAN TRIGGER
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "researcher_workspace_project_plan" {

  project = local.automation_project_id
  name    =  format("%s-plan-sde", var.researcher_workspace_project_trigger_name)

  description    = format("Pipeline for SDE-%s created with Terraform", var.researcher_workspace_project_trigger_name)
  tags           = var.srde_plan_trigger_tags
  disabled       = var.srde_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan.yaml", var.researcher_workspace_project_trigger_name)
  included_files = formatlist("environment/foundation/%s/env/terraform.tfvars", var.researcher_workspace_project_trigger_name)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_plan_trigger_invert_regex
      branch       = var.srde_plan_branch_name
    }
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = ""
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket
  }
}

#------------------------------------------------------------------------
# RESEARCHER WORKSPACE PROJECT APPLY TRIGGER
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "researcher_workspace_project_apply" {

  project = local.automation_project_id
  name    =  format("%s-apply-sde", var.researcher_workspace_project_trigger_name)

  description    = format("Pipeline for SDE-%s created with Terraform", var.researcher_workspace_project_trigger_name)
  tags           = var.srde_plan_trigger_tags
  disabled       = var.srde_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply.yaml", var.researcher_workspace_project_trigger_name)
  included_files = formatlist("environment/foundation/%s/env/terraform.tfvars", var.researcher_workspace_project_trigger_name)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_plan_trigger_invert_regex
      branch       = var.srde_plan_branch_name
    }
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = ""
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER PLAN
# THIS WILL PROVISION A PIPELINE FOR CLOUD COMPOSER LOCATED IN environment/deployments/srde/staging-project/cloud-composer
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "composer_plan_trigger" {

  project = local.automation_project_id
  name    = "composer-plan-sde"

  description    = "Pipeline for SRDE-Composer created with Terraform"
  tags           = var.composer_plan_trigger_tags
  disabled       = var.composer_plan_trigger_disabled
  filename       = "cloudbuild/deployments/composer-plan.yaml"
  included_files = ["environment/deployments/staging-project/cloud-composer/env/terraform.tfvars"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }
*/

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_plan_trigger_invert_regex
      branch       = var.srde_plan_branch_name
    }
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_state_prefix
    _TAG                 = var.terraform_container_version
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket
    _TFVARS_FILE         = ""
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER APPLY
# THIS WILL PROVISION A PIPELINE FOR CLOUD COMPOSER LOCATED IN environment/deployments/srde/staging-project/cloud-composer
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "composer_apply_trigger" {

  project = local.automation_project_id
  name    = "composer-apply-sde"

  description    = "Pipeline for SRDE-Composer created with Terraform"
  tags           = var.srde_composer_apply_trigger_tags
  disabled       = var.srde_composer_apply_trigger_disabled
  filename       = "cloudbuild/deployments/composer-apply.yaml"
  included_files = ["environment/deployments/staging-project/cloud-composer/env/terraform.tfvars"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_apply_trigger_invert_regex
      branch       = var.srde_apply_branch_name
    }
  }

  substitutions = {
    _BUCKET              = var.terraform_state_bucket
    _PREFIX              = var.terraform_state_prefix
    _TAG                 = var.terraform_container_version
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket
    _TFVARS_FILE         = ""
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - CLOUDBUILD SERVICE ACCOUNT ACCESS LEVEL PLAN\
# THIS WILL PROVISION A PIPELINE FOR THE VPC SERVICE CONTROL ACCESS LEVELS LOCATED IN environment/foundation/vpc-service-controls/
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "srde_cloudbuild_sa_access_level_plan" {

  project = local.automation_project_id
  name    = "access-level-plan-sde"

  description    = "Pipeline for SRDE Cloudbuild Access Level created with Terraform"
  tags           = var.srde_cloudbuild_sa_access_level_plan_trigger_tags
  disabled       = var.srde_cloudbuild_sa_access_level_plan_trigger_disabled
  filename       = "cloudbuild/foundation/access-levels-plan.yaml"
  included_files = ["environment/foundation/vpc-service-controls/cloudbuild-access-levels/env/terraform.tfvars"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_plan_trigger_invert_regex
      branch       = var.srde_plan_branch_name
    }
  }

  substitutions = {
    _BUCKET      = var.terraform_state_bucket
    _PREFIX      = var.terraform_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = ""
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - CLOUDBUILD SERVICE ACCOUNT ACCESS LEVEL APPLY
# THIS WILL PROVISION A PIPELINE FOR THE VPC SERVICE CONTROL ACCESS LEVELS LOCATED IN environment/foundation/vpc-service-controls/
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "srde_cloudbuild_sa_access_level_apply" {

  project = local.automation_project_id
  name    = "access-level-apply-sde"

  description    = "Pipeline for SRDE Cloudbuild Access Level created with Terraform"
  tags           = var.srde_cloudbuild_sa_access_level_apply_trigger_tags
  disabled       = var.srde_cloudbuild_sa_access_level_apply_trigger_disabled
  filename       = "cloudbuild/foundation/access-levels-apply.yaml"
  included_files = ["environment/foundation/vpc-service-controls/cloudbuild-access-levels/env/terraform.tfvars"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_apply_trigger_invert_regex
      branch       = var.srde_apply_branch_name
    }
  }

  substitutions = {
    _BUCKET      = var.terraform_state_bucket
    _PREFIX      = var.terraform_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = ""
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - SRDE ADMIN ACCESS LEVEL PLAN
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "srde_admin_access_level_plan" {

  project = local.automation_project_id
  name    = "admin-access-level-plan-sde"

  description    = "Pipeline for SRDE Admin Access Level created with Terraform"
  tags           = var.srde_admin_access_level_plan_trigger_tags
  disabled       = var.srde_admin_access_level_plan_trigger_disabled
  filename       = "cloudbuild/foundation/admin-access-levels-plan.yaml"
  included_files = ["environment/foundation/vpc-service-controls/srde-admin-access-levels/env/terraform.tfvars"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_plan_trigger_repo_name
    invert_regex = var.srde_plan_trigger_invert_regex
    branch_name  = var.srde_plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_plan_trigger_invert_regex
      branch       = var.srde_plan_branch_name
    }
  }

  substitutions = {
    _BUCKET      = var.terraform_state_bucket
    _PREFIX      = var.terraform_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = ""
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - SRDE ADMIN ACCESS LEVEL APPLY
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "srde_admin_access_level_apply" {

  project = local.automation_project_id
  name    = "admin-access-level-apply-sde"

  description    = "Pipeline for SRDE Admin Access Level created with Terraform"
  tags           = var.srde_admin_access_level_apply_trigger_tags
  disabled       = var.srde_admin_access_level_apply_trigger_disabled
  filename       = "cloudbuild/foundation/admin-access-levels-apply.yaml"
  included_files = ["environment/foundation/vpc-service-controls/srde-admin-access-levels/env/terraform.tfvars"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_apply_trigger_invert_regex
      branch       = var.srde_apply_branch_name
    }
  }

  substitutions = {
    _BUCKET      = var.terraform_state_bucket
    _PREFIX      = var.terraform_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = ""
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - DEEP LEARNING VM IMAGE BUILD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "deep_learning_vm_image_build" {

  project = local.automation_project_id
  name    = "deep-learning-vm-image-build-sde"

  description    = "Pipeline for Deep Learning VM Image build created with Terraform"
  tags           = var.srde_deep_learning_vm_image_build_trigger_tags
  disabled       = var.srde_deep_learning_vm_image_build_trigger_disabled
  filename       = "cloudbuild/foundation/packer-deep-learning-image.yaml"
  included_files = ["environment/foundation/packer-project/researcher-vm-image-build/deep-learning-startup-image-script.sh"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_apply_trigger_invert_regex
      branch       = var.srde_apply_branch_name
    }
  }

  substitutions = {
    _PACKER_PROJECT_ID = var.srde_packer_project_id
    _PACKER_IMAGE_TAG  = var.srde_packer_image_tag
    _REGION            = local.packer_default_region
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - RHEL CIS IMAGE BUILD 
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "rhel_cis_image_build" {

  project = local.automation_project_id
  name    = "rhel-cis-image-build-sde"

  description    = "Pipeline for RHEL CIS Image Build created with Terraform"
  tags           = var.srde_rhel_cis_image_build_trigger_tags
  disabled       = var.srde_rhel_cis_image_build_trigger_disabled
  filename       = "cloudbuild/deployments/cloudbuild-packer-rhel-cis-image.yaml"
  included_files = ["environment/deployments/wcm-srde/packer-project/researcher-vm-image-build/rhel-startup-image-script.sh"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
   invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_apply_trigger_invert_regex
      branch       = var.srde_apply_branch_name
    }
  }

  substitutions = {
    _PACKER_PROJECT_ID = var.srde_packer_project_id
    _PACKER_IMAGE_TAG  = var.srde_packer_image_tag
    _REGION            = local.packer_default_region
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - PACKER CONTAINER IMAGE
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "packer_container_image" {

  project = local.automation_project_id
  name    = "packer-container-image-sde"

  description    = "Pipeline for Packer container image created with Terraform"
  tags           = var.srde_packer_container_image_build_trigger_tags
  disabled       = var.srde_packer_container_image_build_trigger_disabled
  filename       = "cloudbuild/foundation/packer-container.yaml"
  included_files = ["environment/foundation/packer-project/packer-container/Dockerfile"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.srde_apply_trigger_repo_name
    invert_regex = var.srde_apply_trigger_invert_regex
    branch_name  = var.srde_apply_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.srde_apply_trigger_invert_regex
      branch       = var.srde_apply_branch_name
    }
  }

  substitutions = {
    _PACKER_PROJECT_ID = var.srde_packer_project_id
    _REGION            = local.packer_default_region
  }
}

# TODO: Add Cloud Build pipelines for: 1) cloudbuild-packer-deep-learning-image.yaml; 2) cloudbuild-packer-rhel-cis-image.yaml; 3) cloudbuild-pathml-container.yaml; and 4) cloudbuild-packer-container.yaml

# TODO: Create a new Cloud Build pipeline to apply this TF, which will provision all of the other pipelines.

#------------------------------------------------------------------------
# FOLDER IAM MEMBER MODULE
#------------------------------------------------------------------------

module "folder_iam_member" {
  source = "../../../modules/iam/folder_iam"

  folder_id     = local.srde_folder_id
  iam_role_list = var.iam_role_list
  folder_member = "serviceAccount:${local.cloudbuild_service_account}"
}