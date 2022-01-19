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
  folder_id                  = module.constants.value.sde_folder_id
  cloudbuild_service_account = module.constants.value.cloudbuild_service_account
  automation_project_id      = module.constants.value.automation_project_id
  packer_default_region      = module.constants.value.packer_default_region
  terraform_state_bucket     = module.constants.value.terraform_state_bucket
  # Check if the composer state file is present, if so format the output else an empty string
  composer_gcs_bucket = try(trimsuffix(trimprefix(data.terraform_remote_state.cloud_composer.outputs.gcs_bucket, "gs://"), "/dags"), "")
}


#------------------------------------------------------------------------
# FOLDERS PLAN TRIGGER - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "folders_plan_dev" {

  project = local.automation_project_id
  name    = format("%s-plan-sde-%s", var.folders_trigger_name, var.env_name_dev)

  description    = format("Pipeline for SDE-%s %s created with Terraform", var.folders_trigger_name, var.env_name_dev)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.folders_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.folders_trigger_name, var.env_name_dev)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.plan_trigger_invert_regex
      branch       = var.plan_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}


#------------------------------------------------------------------------
# FOLDERS PLAN TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "folders_plan_prod" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.folders_trigger_name, var.env_name_prod)

  description    = format("Pipeline for SDE-%s %s created with Terraform", var.folders_trigger_name, var.env_name_prod)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.folders_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.folders_trigger_name, var.env_name_prod)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.plan_trigger_invert_regex
      branch       = var.plan_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_prod
  }
}


#------------------------------------------------------------------------
# FOLDERS APPLY TRIGGER - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "folders_apply_dev" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.folders_trigger_name, var.env_name_dev)

  description    = format("Dev Pipeline for SDE-%s %s created with Terraform", var.folders_trigger_name, var.env_name_dev)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.folders_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.folders_trigger_name, var.env_name_dev)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}


#------------------------------------------------------------------------
# FOLDERS APPLY TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "folders_apply_prod" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.folders_trigger_name, var.env_name_prod)

  description    = format("Dev Pipeline for SDE-%s %s created with Terraform", var.folders_trigger_name, var.env_name_prod)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.folders_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.folders_trigger_name, var.env_name_prod)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_prod
  }
}


#------------------------------------------------------------------------
# PACKER PROJECT PLAN TRIGGER - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "packer_project_plan_dev" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.packer_project_trigger_name, var.env_name_dev)

  description    = format("Pipeline for SDE-%s %s created with Terraform", var.packer_project_trigger_name, var.env_name_dev)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.packer_project_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.packer_project_trigger_name, var.env_name_dev)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.plan_trigger_invert_regex
      branch       = var.plan_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# PACKER PROJECT PLAN TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "packer_project_plan_prod" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.packer_project_trigger_name, var.env_name_prod)

  description    = format("Pipeline for SDE-%s %s created with Terraform", var.packer_project_trigger_name, var.env_name_prod)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.packer_project_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.packer_project_trigger_name, var.env_name_prod)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.plan_trigger_invert_regex
      branch       = var.plan_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_prod
  }
}

#------------------------------------------------------------------------
# PACKER PROJECT APPLY TRIGGER - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "packer_project_apply_dev" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.packer_project_trigger_name, var.env_name_dev)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.packer_project_trigger_name, var.env_name_dev)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.packer_project_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.packer_project_trigger_name, var.env_name_dev)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# PACKER PROJECT APPLY TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "packer_project_apply_prod" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.packer_project_trigger_name, var.env_name_prod)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.packer_project_trigger_name, var.env_name_prod)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.packer_project_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.packer_project_trigger_name, var.env_name_prod)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_prod
  }
}

#------------------------------------------------------------------------
# STAGING PROJECT PLAN TRIGGER - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "staging_project_plan_dev" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.staging_project_trigger_name, var.env_name_dev)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.staging_project_trigger_name, var.env_name_dev)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.staging_project_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.staging_project_trigger_name, var.env_name_dev)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.plan_trigger_invert_regex
      branch       = var.plan_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# STAGING PROJECT PLAN TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "staging_project_plan_prod" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.staging_project_trigger_name, var.env_name_prod)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.staging_project_trigger_name, var.env_name_prod)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.staging_project_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.staging_project_trigger_name, var.env_name_prod)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.plan_trigger_invert_regex
      branch       = var.plan_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_prod
  }
}

#------------------------------------------------------------------------
# STAGING PROJECT APPLY TRIGGER - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "staging_project_apply_dev" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.staging_project_trigger_name, var.env_name_dev)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.staging_project_trigger_name, var.env_name_dev)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.staging_project_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.staging_project_trigger_name, var.env_name_dev)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}


#------------------------------------------------------------------------
# STAGING PROJECT APPLY TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "staging_project_apply_prod" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.staging_project_trigger_name, var.env_name_prod)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.staging_project_trigger_name, var.env_name_prod)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.staging_project_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.staging_project_trigger_name, var.env_name_prod)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_prod
  }
}

#------------------------------------------------------------------------
# DATA LAKE PROJECT PLAN TRIGGER - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "data_lake_project_plan_dev" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.data_lake_project_trigger_name, var.env_name_dev)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.data_lake_project_trigger_name, var.env_name_dev)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.data_lake_project_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.data_lake_project_trigger_name, var.env_name_dev)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.plan_trigger_invert_regex
      branch       = var.plan_branch_name
    }
  }

  substitutions = {
    _BUCKET              = local.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = var.env_name_dev
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket
  }
}


#------------------------------------------------------------------------
# DATA LAKE PROJECT PLAN TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "data_lake_project_plan_prod" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.data_lake_project_trigger_name, var.env_name_prod)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.data_lake_project_trigger_name, var.env_name_prod)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.data_lake_project_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.data_lake_project_trigger_name, var.env_name_prod)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.plan_trigger_invert_regex
      branch       = var.plan_branch_name
    }
  }

  substitutions = {
    _BUCKET              = local.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = var.env_name_prod
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket
  }
}

#------------------------------------------------------------------------
# DATA LAKE PROJECT APPLY TRIGGER - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "data_lake_project_apply_dev" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.data_lake_project_trigger_name, var.env_name_dev)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.data_lake_project_trigger_name, var.env_name_dev)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.data_lake_project_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.data_lake_project_trigger_name, var.env_name_dev)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _BUCKET              = local.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = var.env_name_dev
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket
  }
}

#------------------------------------------------------------------------
# DATA LAKE PROJECT APPLY TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "data_lake_project_apply_prod" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.data_lake_project_trigger_name, var.env_name_prod)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.data_lake_project_trigger_name, var.env_name_prod)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.data_lake_project_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.data_lake_project_trigger_name, var.env_name_prod)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _BUCKET              = local.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = var.env_name_prod
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket
  }
}


#------------------------------------------------------------------------
# RESEARCHER WORKSPACE PROJECT PLAN TRIGGER
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "researcher_workspace_project_plan" {

  project = local.automation_project_id
  name    = format("%s-plan-sde", var.researcher_workspace_project_trigger_name)

  description    = format("Pipeline for SDE-%s created with Terraform", var.researcher_workspace_project_trigger_name)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan.yaml", var.researcher_workspace_project_trigger_name)
  included_files = formatlist("environment/foundation/%s/env/terraform.tfvars", var.researcher_workspace_project_trigger_name)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.plan_trigger_invert_regex
      branch       = var.plan_branch_name
    }
  }

  substitutions = {
    _BUCKET              = local.terraform_state_bucket
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
  name    = format("%s-apply-sde", var.researcher_workspace_project_trigger_name)

  description    = format("Pipeline for SDE-%s created with Terraform", var.researcher_workspace_project_trigger_name)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply.yaml", var.researcher_workspace_project_trigger_name)
  included_files = formatlist("environment/foundation/%s/env/terraform.tfvars", var.researcher_workspace_project_trigger_name)

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _BUCKET              = local.terraform_state_bucket
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

  description    = "Pipeline for SDE-Composer created with Terraform"
  tags           = var.composer_plan_trigger_tags
  disabled       = var.composer_plan_trigger_disabled
  filename       = "cloudbuild/foundation/composer-plan.yaml"
  included_files = ["environment/foundation/staging-project/cloud-composer/env/terraform.tfvars"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
*/

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.plan_trigger_invert_regex
      branch       = var.plan_branch_name
    }
  }

  substitutions = {
    _BUCKET              = local.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
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
  tags           = var.composer_apply_trigger_tags
  disabled       = var.composer_apply_trigger_disabled
  filename       = "cloudbuild/foundation/composer-apply.yaml"
  included_files = ["environment/foundation/staging-project/cloud-composer/env/terraform.tfvars"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.apply_trigger_repo_name
    invert_regex = var.apply_trigger_invert_regex
    branch_name  = var.apply_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _BUCKET              = local.terraform_state_bucket
    _PREFIX              = var.terraform_foundation_state_prefix
    _TAG                 = var.terraform_container_version
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket
    _TFVARS_FILE         = ""
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - CLOUDBUILD SERVICE ACCOUNT ACCESS LEVEL PLAN\
# THIS WILL PROVISION A PIPELINE FOR THE VPC SERVICE CONTROL ACCESS LEVELS LOCATED IN environment/foundation/vpc-service-controls/
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "cloudbuild_sa_access_level_plan" {

  project = local.automation_project_id
  name    = "access-level-plan-sde"

  description    = "Pipeline for SRDE Cloudbuild Access Level created with Terraform"
  tags           = var.cloudbuild_sa_access_level_plan_trigger_tags
  disabled       = var.cloudbuild_sa_access_level_plan_trigger_disabled
  filename       = "cloudbuild/foundation/access-levels-plan.yaml"
  included_files = ["environment/foundation/vpc-service-controls/cloudbuild-access-levels/env/terraform.tfvars"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.plan_trigger_invert_regex
      branch       = var.plan_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = ""
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - CLOUDBUILD SERVICE ACCOUNT ACCESS LEVEL APPLY
# THIS WILL PROVISION A PIPELINE FOR THE VPC SERVICE CONTROL ACCESS LEVELS LOCATED IN environment/foundation/vpc-service-controls/
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "cloudbuild_sa_access_level_apply" {

  project = local.automation_project_id
  name    = "access-level-apply-sde"

  description    = "Pipeline for SRDE Cloudbuild Access Level created with Terraform"
  tags           = var.cloudbuild_sa_access_level_apply_trigger_tags
  disabled       = var.cloudbuild_sa_access_level_apply_trigger_disabled
  filename       = "cloudbuild/foundation/access-levels-apply.yaml"
  included_files = ["environment/foundation/vpc-service-controls/cloudbuild-access-levels/env/terraform.tfvars"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.apply_trigger_repo_name
    invert_regex = var.apply_trigger_invert_regex
    branch_name  = var.apply_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = ""
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - SRDE ADMIN ACCESS LEVEL PLAN
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "admin_access_level_plan" {

  project = local.automation_project_id
  name    = "admin-access-level-plan-sde"

  description    = "Pipeline for SRDE Admin Access Level created with Terraform"
  tags           = var.admin_access_level_plan_trigger_tags
  disabled       = var.admin_access_level_plan_trigger_disabled
  filename       = "cloudbuild/foundation/admin-access-levels-plan.yaml"
  included_files = ["environment/foundation/vpc-service-controls/srde-admin-access-levels/env/terraform.tfvars"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.plan_trigger_repo_name
    invert_regex = var.plan_trigger_invert_regex
    branch_name  = var.plan_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.plan_trigger_invert_regex
      branch       = var.plan_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = ""
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - SRDE ADMIN ACCESS LEVEL APPLY
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "admin_access_level_apply" {

  project = local.automation_project_id
  name    = "admin-access-level-apply-sde"

  description    = "Pipeline for SRDE Admin Access Level created with Terraform"
  tags           = var.admin_access_level_apply_trigger_tags
  disabled       = var.admin_access_level_apply_trigger_disabled
  filename       = "cloudbuild/foundation/admin-access-levels-apply.yaml"
  included_files = ["environment/foundation/vpc-service-controls/srde-admin-access-levels/env/terraform.tfvars"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.apply_trigger_repo_name
    invert_regex = var.apply_trigger_invert_regex
    branch_name  = var.apply_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _BUCKET      = local.terraform_state_bucket
    _PREFIX      = var.terraform_foundation_state_prefix
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
  tags           = var.deep_learning_vm_image_build_trigger_tags
  disabled       = var.deep_learning_vm_image_build_trigger_disabled
  filename       = "cloudbuild/foundation/packer-deep-learning-image.yaml"
  included_files = ["environment/foundation/packer-project/researcher-vm-image-build/deep-learning-startup-image-script.sh"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.apply_trigger_repo_name
    invert_regex = var.apply_trigger_invert_regex
    branch_name  = var.apply_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _PACKER_PROJECT_ID = var.packer_project_id
    _PACKER_IMAGE_TAG  = var.packer_image_tag
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
  tags           = var.rhel_cis_image_build_trigger_tags
  disabled       = var.rhel_cis_image_build_trigger_disabled
  filename       = "cloudbuild/deployments/cloudbuild-packer-rhel-cis-image.yaml"
  included_files = ["environment/deployments/wcm-srde/packer-project/researcher-vm-image-build/rhel-startup-image-script.sh"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.apply_trigger_repo_name
   invert_regex = var.apply_trigger_invert_regex
    branch_name  = var.apply_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _PACKER_PROJECT_ID = var.packer_project_id
    _PACKER_IMAGE_TAG  = var.packer_image_tag
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
  tags           = var.packer_container_image_build_trigger_tags
  disabled       = var.packer_container_image_build_trigger_disabled
  filename       = "cloudbuild/foundation/packer-container.yaml"
  included_files = ["environment/foundation/packer-project/packer-container/Dockerfile"]

  /*
  trigger_template {
    project_id   = local.automation_project_id
    repo_name    = var.apply_trigger_repo_name
    invert_regex = var.apply_trigger_invert_regex
    branch_name  = var.apply_branch_name
  }
  */

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      invert_regex = var.apply_trigger_invert_regex
      branch       = var.apply_branch_name
    }
  }

  substitutions = {
    _PACKER_PROJECT_ID = var.packer_project_id
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

  folder_id     = local.folder_id
  iam_role_list = var.iam_role_list
  folder_member = "serviceAccount:${local.cloudbuild_service_account}"
}