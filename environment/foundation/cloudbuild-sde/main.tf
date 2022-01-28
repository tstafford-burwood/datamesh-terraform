#------------------------------------------------------------------------
# IMPORT CONSTANTS
#------------------------------------------------------------------------

module "constants" {
  source = "../constants"
}

#------------------------------------------------------------------------
# RETRIEVE TF STATE
#------------------------------------------------------------------------

data "terraform_remote_state" "cloud_composer_prod" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = format("%s/%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod, "cloud-composer")
  }
}

data "terraform_remote_state" "cloud_composer_dev" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = format("%s/%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev, "cloud-composer")
  }
}




data "terraform_remote_state" "image_project_prod" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = format("%s/%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod, "image-project")
  }
}

data "terraform_remote_state" "image_project_dev" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = format("%s/%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev, "image-project")
  }
}

#------------------------------------------------------------------------
# SET LOCALS
#------------------------------------------------------------------------

locals {
  folder_id                  = module.constants.value.sde_folder_id
  cloudbuild_service_account = module.constants.value.cloudbuild_service_account
  automation_project_id      = module.constants.value.automation_project_id
  terraform_state_bucket     = module.constants.value.terraform_state_bucket

  # Check what region the image project vpc is using, if not deployed defalt to empty string
  image_default_region_dev       = try(data.terraform_remote_state.image_project_dev.outputs.subnets_regions[0], "")
  image_default_region_prod      = try(data.terraform_remote_state.image_project_prod.outputs.subnets_regions[0], "")

  # Check if the image project has been deployed, if not default to empty string
  image_project_id_dev  = try(data.terraform_remote_state.image_project_dev.outputs.project_id, "")
  image_project_id_prod = try(data.terraform_remote_state.image_project_prod.outputs.project_id, "")

  # Check if the composer state file is present, if so format the output else an empty string
  composer_gcs_bucket_dev  = try(trimsuffix(trimprefix(data.terraform_remote_state.cloud_composer_dev.outputs.gcs_bucket, "gs://"), "/dags"), "")
  composer_gcs_bucket_prod = try(trimsuffix(trimprefix(data.terraform_remote_state.cloud_composer_prod.outputs.gcs_bucket, "gs://"), "/dags"), "")
}


#------------------------------------------------------------------------
# FOLDERS PLAN TRIGGER - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "folders_plan_dev" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.folders_trigger_name, var.env_name_dev)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_prod
  }
}


#------------------------------------------------------------------------
# IMAGE PROJECT PLAN TRIGGER - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "image_project_plan_dev" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.image_project_trigger_name, var.env_name_dev)

  description    = format("Pipeline for SDE-%s %s created with Terraform", var.image_project_trigger_name, var.env_name_dev)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.image_project_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.image_project_trigger_name, var.env_name_dev)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# IMAGE PROJECT PLAN TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "image_project_plan_prod" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.image_project_trigger_name, var.env_name_prod)

  description    = format("Pipeline for SDE-%s %s created with Terraform", var.image_project_trigger_name, var.env_name_prod)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.image_project_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.image_project_trigger_name, var.env_name_prod)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_prod
  }
}

#------------------------------------------------------------------------
# IMAGE PROJECT APPLY TRIGGER - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "image_project_apply_dev" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.image_project_trigger_name, var.env_name_dev)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.image_project_trigger_name, var.env_name_dev)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.image_project_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.image_project_trigger_name, var.env_name_dev)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# IMAGE PROJECT APPLY TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "image_project_apply_prod" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.image_project_trigger_name, var.env_name_prod)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.image_project_trigger_name, var.env_name_prod)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.image_project_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.image_project_trigger_name, var.env_name_prod)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_prod
  }
}

#------------------------------------------------------------------------
# DATA OPS PROJECT PLAN TRIGGER - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "data_ops_project_plan_dev" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.data_ops_project_trigger_name, var.env_name_dev)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.data_ops_project_trigger_name, var.env_name_dev)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.data_ops_project_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.data_ops_project_trigger_name, var.env_name_dev)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# DATA OPS PROJECT PLAN TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "data_ops_project_plan_prod" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.data_ops_project_trigger_name, var.env_name_prod)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.data_ops_project_trigger_name, var.env_name_prod)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.data_ops_project_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.data_ops_project_trigger_name, var.env_name_prod)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_prod
  }
}

#------------------------------------------------------------------------
# DATA OPS PROJECT APPLY TRIGGER - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "data_ops_project_apply_dev" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.data_ops_project_trigger_name, var.env_name_dev)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.data_ops_project_trigger_name, var.env_name_dev)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.data_ops_project_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.data_ops_project_trigger_name, var.env_name_dev)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}


#------------------------------------------------------------------------
# DATA OPS PROJECT APPLY TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "data_ops_project_apply_prod" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.data_ops_project_trigger_name, var.env_name_prod)

  description    = format("Dev pipeline for SDE-%s %s created with Terraform", var.data_ops_project_trigger_name, var.env_name_prod)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.data_ops_project_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/%s/env/%s.tfvars", var.data_ops_project_trigger_name, var.env_name_prod)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
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
    _PREFIX              = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = var.env_name_dev
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket_dev
  }
}


#------------------------------------------------------------------------
# DATA LAKE PROJECT PLAN TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "data_lake_project_plan_prod" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.data_lake_project_trigger_name, var.env_name_prod)

  description    = format("Pipeline for SDE-%s %s created with Terraform", var.data_lake_project_trigger_name, var.env_name_prod)
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
    _PREFIX              = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = var.env_name_prod
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket_prod
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
    _PREFIX              = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = var.env_name_dev
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket_dev
  }
}

#------------------------------------------------------------------------
# DATA LAKE PROJECT APPLY TRIGGER - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "data_lake_project_apply_prod" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.data_lake_project_trigger_name, var.env_name_prod)

  description    = format("Pipeline for SDE-%s %s created with Terraform", var.data_lake_project_trigger_name, var.env_name_prod)
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
    _PREFIX              = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = var.env_name_prod
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket_prod
  }
}


#------------------------------------------------------------------------
# RESEARCHER WORKSPACE PROJECT PLAN TRIGGER
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "researcher_workspace_project_plan_dev" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.researcher_workspace_project_trigger_name, var.env_name_dev)

  description    = format("Pipeline for SDE-%s created with Terraform", var.researcher_workspace_project_trigger_name)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/deployments/%s-plan.yaml", var.researcher_workspace_project_trigger_name)
  included_files = formatlist("environment/deployments/%s/env/terraform.tfvars", var.researcher_workspace_project_trigger_name)

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
    _PREFIX              = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = ""
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket_dev
  }
}

resource "google_cloudbuild_trigger" "researcher_workspace_project_plan_prod" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.researcher_workspace_project_trigger_name, var.env_name_prod)

  description    = format("Pipeline for SDE-%s created with Terraform", var.researcher_workspace_project_trigger_name)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/deployments/%s-plan.yaml", var.researcher_workspace_project_trigger_name)
  included_files = formatlist("environment/deployments/%s/env/terraform.tfvars", var.researcher_workspace_project_trigger_name)

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
    _PREFIX              = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = ""
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket_prod
  }
}

#------------------------------------------------------------------------
# RESEARCHER WORKSPACE PROJECT APPLY TRIGGER
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "researcher_workspace_project_apply_dev" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.researcher_workspace_project_trigger_name, var.env_name_dev)

  description    = format("Pipeline for SDE-%s created with Terraform", var.researcher_workspace_project_trigger_name)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/deployments/%s-apply.yaml", var.researcher_workspace_project_trigger_name)
  included_files = formatlist("environment/deployments/%s/env/terraform.tfvars", var.researcher_workspace_project_trigger_name)

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
    _PREFIX              = format("%s/%s", var.terraform_deployments_state_prefix, var.env_name_dev)
    _PREFIX_FOUNDATION   = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = ""
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket_dev
  }
}

resource "google_cloudbuild_trigger" "researcher_workspace_project_apply_prod" {

  project = local.automation_project_id
  name    = format("%s-apply-%s", var.researcher_workspace_project_trigger_name, var.env_name_prod)

  description    = format("Pipeline for SDE-%s created with Terraform", var.researcher_workspace_project_trigger_name)
  tags           = var.plan_trigger_tags
  disabled       = var.plan_trigger_disabled
  filename       = format("cloudbuild/deployments/%s-apply.yaml", var.researcher_workspace_project_trigger_name)
  included_files = formatlist("environment/deployments/%s/env/terraform.tfvars", var.researcher_workspace_project_trigger_name)

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
    _PREFIX              = format("%s/%s", var.terraform_deployments_state_prefix, var.env_name_prod)
    _PREFIX_FOUNDATION   = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG                 = var.terraform_container_version
    _TFVARS_FILE         = ""
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket_prod
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER PLAN - DEV
# THIS WILL PROVISION A PIPELINE FOR CLOUD COMPOSER LOCATED IN environment/foundation/data-ops-project/cloud-composer
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "composer_plan_dev_trigger" {

  project = local.automation_project_id
  name    = "composer-plan-dev"

  description    = "Pipeline for SDE-Composer created with Terraform"
  tags           = var.composer_plan_trigger_tags
  disabled       = var.composer_plan_trigger_disabled
  filename       = "cloudbuild/foundation/composer-plan.yaml"
  included_files = ["environment/foundation/data-ops-project/cloud-composer/env/${var.env_name_dev}.tfvars"]

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
    _PREFIX              = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG                 = var.terraform_container_version
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket_dev
    _TFVARS_FILE         = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER APPLY - DEV
# THIS WILL PROVISION A PIPELINE FOR CLOUD COMPOSER LOCATED IN environment/deployments/srde/data-ops-project/cloud-composer
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "composer_apply_dev_trigger" {

  project = local.automation_project_id
  name    = "composer-apply-dev"

  description    = "Pipeline for SRDE-Composer created with Terraform"
  tags           = var.composer_apply_trigger_tags
  disabled       = var.composer_apply_trigger_disabled
  filename       = "cloudbuild/foundation/composer-apply.yaml"
  included_files = ["environment/foundation/data-ops-project/cloud-composer/env/${var.env_name_dev}.tfvars"]

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
    _PREFIX              = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG                 = var.terraform_container_version
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket_dev
    _TFVARS_FILE         = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER PLAN - PROD
# THIS WILL PROVISION A PIPELINE FOR CLOUD COMPOSER LOCATED IN environment/deployments/srde/data-ops-project/cloud-composer
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "composer_plan_prod_trigger" {

  project = local.automation_project_id
  name    = "composer-plan-${var.env_name_prod}"

  description    = "${var.env_name_prod} Pipeline for SDE-Composer created with Terraform"
  tags           = var.composer_plan_trigger_tags
  disabled       = var.composer_plan_trigger_disabled
  filename       = "cloudbuild/foundation/composer-plan.yaml"
  included_files = ["environment/foundation/data-ops-project/cloud-composer/env/${var.env_name_prod}.tfvars"]

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
    _PREFIX              = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG                 = var.terraform_container_version
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket_prod
    _TFVARS_FILE         = var.env_name_prod
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - COMPOSER APPLY - PROD
# THIS WILL PROVISION A PIPELINE FOR CLOUD COMPOSER LOCATED IN environment/deployments/srde/data-ops-project/cloud-composer
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "composer_apply_prod_trigger" {

  project = local.automation_project_id
  name    = "composer-apply-${var.env_name_prod}"

  description    = "${var.env_name_prod} Pipeline for SRDE-Composer created with Terraform"
  tags           = var.composer_apply_trigger_tags
  disabled       = var.composer_apply_trigger_disabled
  filename       = "cloudbuild/foundation/composer-apply.yaml"
  included_files = ["environment/foundation/data-ops-project/cloud-composer/env/${var.env_name_prod}.tfvars"]

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
    _PREFIX              = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG                 = var.terraform_container_version
    _COMPOSER_DAG_BUCKET = local.composer_gcs_bucket_prod
    _TFVARS_FILE         = var.env_name_prod
  }
}

#------------------------------------------------------------------------
# ACCESS LEVEL CLOUDBUILD PLAN - DEV
# THIS WILL PROVISION A PIPELINE FOR THE VPC SERVICE CONTROL ACCESS LEVELS LOCATED IN environment/foundation/vpc-service-controls/
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "access_level_cloudbuild_plan_dev" {

  project = local.automation_project_id
  name    = format("%s-plan-sde-%s", var.access_level_cloudbuild_trigger_name, var.env_name_dev)

  description    = "Pipeline for SRDE Cloudbuild Access Level created with Terraform"
  tags           = var.access_level_cloudbuild_plan_trigger_tags
  disabled       = var.access_level_cloudbuild_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.access_level_cloudbuild_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/vpc-service-controls/%s/env/%s.tfvars", var.access_level_cloudbuild_trigger_name, var.env_name_dev)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# ACCESS LEVEL CLOUDBUILD PLAN - PROD
# THIS WILL PROVISION A PIPELINE FOR THE VPC SERVICE CONTROL ACCESS LEVELS LOCATED IN environment/foundation/vpc-service-controls/
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "access_level_cloudbuild_plan_prod" {

  project = local.automation_project_id
  name    = format("%s-plan-sde-%s", var.access_level_cloudbuild_trigger_name, var.env_name_prod)

  description    = "Pipeline for SRDE Cloudbuild Access Level created with Terraform"
  tags           = var.access_level_cloudbuild_plan_trigger_tags
  disabled       = var.access_level_cloudbuild_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.access_level_cloudbuild_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/vpc-service-controls/%s/env/%s.tfvars", var.access_level_cloudbuild_trigger_name, var.env_name_prod)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_prod
  }
}

#------------------------------------------------------------------------
# ACCESS LEVEL CLOUDBUILD APPLY - DEV
# THIS WILL PROVISION A PIPELINE FOR THE VPC SERVICE CONTROL ACCESS LEVELS LOCATED IN environment/foundation/vpc-service-controls/
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "access_level_cloudbuild_apply_dev" {

  project = local.automation_project_id
  name    = format("%s-apply-sde-%s", var.access_level_cloudbuild_trigger_name, var.env_name_dev)

  description    = format("Pipeline for SDE-%s %s created with Terraform", var.access_level_cloudbuild_trigger_name, var.env_name_dev)
  tags           = var.access_level_cloudbuild_apply_trigger_tags
  disabled       = var.access_level_cloudbuild_apply_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.access_level_cloudbuild_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/vpc-service-controls/%s/env/%s.tfvars", var.folders_trigger_name, var.env_name_dev)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# ACCESS LEVEL CLOUDBUILD APPLY - PROD
# THIS WILL PROVISION A PIPELINE FOR THE VPC SERVICE CONTROL ACCESS LEVELS LOCATED IN environment/foundation/vpc-service-controls/
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "access_level_cloudbuild_apply_prod" {

  project = local.automation_project_id
  name    = format("%s-apply-sde-%s", var.access_level_cloudbuild_trigger_name, var.env_name_prod)

  description    = format("Pipeline for SDE-%s %s created with Terraform", var.access_level_cloudbuild_trigger_name, var.env_name_prod)
  tags           = var.access_level_cloudbuild_apply_trigger_tags
  disabled       = var.access_level_cloudbuild_apply_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.access_level_cloudbuild_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/vpc-service-controls/%s/env/%s.tfvars", var.folders_trigger_name, var.env_name_prod)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_prod
  }
}

#------------------------------------------------------------------------
# ACCESS LEVEL ADMIN PLAN - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "access_level_admin_plan_dev" {

  project = local.automation_project_id
  name    = format("%s-plan-sde-%s", var.access_level_admin_trigger_name, var.env_name_dev)

  description    = format("Pipeline for SDE %s %s created with Terraform", var.access_level_admin_trigger_name, var.env_name_dev)
  tags           = var.access_level_admin_plan_trigger_tags
  disabled       = var.access_level_admin_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.access_level_admin_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/vpc-service-controls/%s/env/%s.tfvars", var.access_level_admin_trigger_name, var.env_name_dev)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# ACCESS LEVEL ADMIN PLAN - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "access_level_admin_plan_prod" {

  project = local.automation_project_id
  name    = format("%s-plan-sde-%s", var.access_level_admin_trigger_name, var.env_name_prod)

  description    = format("Pipeline for SDE %s %s created with Terraform", var.access_level_admin_trigger_name, var.env_name_prod)
  tags           = var.access_level_admin_plan_trigger_tags
  disabled       = var.access_level_admin_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.access_level_admin_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/vpc-service-controls/%s/env/%s.tfvars", var.access_level_admin_trigger_name, var.env_name_prod)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# ACCESS LEVEL ADMIN APPLY - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "admin_access_level_apply_dev" {

  project = local.automation_project_id
  name    = format("%s-apply-sde-%s", var.access_level_admin_trigger_name, var.env_name_dev)

  description    = format("Pipeline for SDE %s %s created with Terraform", var.access_level_admin_trigger_name, var.env_name_dev)
  tags           = var.access_level_admin_apply_trigger_tags
  disabled       = var.access_level_admin_apply_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.access_level_admin_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/vpc-service-controls/%s/env/%s.tfvars", var.access_level_admin_trigger_name, var.env_name_dev)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# ACCESS LEVEL ADMIN APPLY - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "admin_access_level_apply_prod" {

  project = local.automation_project_id
  name    = format("%s-apply-sde-%s", var.access_level_admin_trigger_name, var.env_name_prod)

  description    = format("Pipeline for SDE %s %s created with Terraform", var.access_level_admin_trigger_name, var.env_name_prod)
  tags           = var.access_level_admin_apply_trigger_tags
  disabled       = var.access_level_admin_apply_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-apply-%s.yaml", var.access_level_admin_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/vpc-service-controls/%s/env/%s.tfvars", var.access_level_admin_trigger_name, var.env_name_prod)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}


#------------------------------------------------------------------------
# SERVICE PERIMETER CLOUDBUILD PLAN - DEV
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "service_perimeter_dev" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.service_perimeter_trigger_name, var.env_name_dev)

  description    = "Pipeline for SRDE Cloudbuild Access Level created with Terraform"
  tags           = var.service_perimeter_plan_trigger_tags
  disabled       = var.service_perimeter_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.service_perimeter_trigger_name, var.env_name_dev)
  included_files = formatlist("environment/foundation/vpc-service-controls/%s/env/%s.tfvars", var.service_perimeter_trigger_name, var.env_name_dev)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_dev)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_dev
  }
}

#------------------------------------------------------------------------
# SERVICE PERIMETER CLOUDBUILD PLAN - PROD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "service_perimeter_prod" {

  project = local.automation_project_id
  name    = format("%s-plan-%s", var.service_perimeter_trigger_name, var.env_name_prod)

  description    = "Pipeline for SRDE Cloudbuild Access Level created with Terraform"
  tags           = var.service_perimeter_plan_trigger_tags
  disabled       = var.service_perimeter_plan_trigger_disabled
  filename       = format("cloudbuild/foundation/%s-plan-%s.yaml", var.service_perimeter_trigger_name, var.env_name_prod)
  included_files = formatlist("environment/foundation/vpc-service-controls/%s/env/%s.tfvars", var.service_perimeter_trigger_name, var.env_name_prod)

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
    _PREFIX      = format("%s/%s", var.terraform_foundation_state_prefix, var.env_name_prod)
    _TAG         = var.terraform_container_version
    _TFVARS_FILE = var.env_name_prod
  }
}


#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - DEEP LEARNING VM IMAGE BUILD
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "deep_learning_vm_image_build_prod" {

  project = local.automation_project_id
  name    = "deep-learning-vm-image-build-${var.env_name_prod}"

  description    = "Pipeline for Deep Learning VM Image build created with Terraform"
  tags           = var.deep_learning_vm_image_build_trigger_tags
  disabled       = var.deep_learning_vm_image_build_trigger_disabled
  filename       = "cloudbuild/foundation/image-deep-learning-image.yaml"
  included_files = ["environment/foundation/image-project/researcher-vm-image-build/deep-learning-startup-image-script.sh"]

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
    _IMAGE_PROJECT_ID = local.image_project_id_prod
    _IMAGE_TAG        = var.packer_image_tag
    _REGION           = local.image_default_region_prod
    _IMAGE_ZONE       = "${local.image_default_region_prod}-b"
  }
}

resource "google_cloudbuild_trigger" "deep_learning_vm_image_build_dev" {

  project = local.automation_project_id
  name    = "deep-learning-vm-image-build-${var.env_name_dev}"

  description    = "Pipeline for Deep Learning VM Image build created with Terraform"
  tags           = var.deep_learning_vm_image_build_trigger_tags
  disabled       = var.deep_learning_vm_image_build_trigger_disabled
  filename       = "cloudbuild/foundation/image-deep-learning-image.yaml"
  included_files = ["environment/foundation/image-project/researcher-vm-image-build/deep-learning-startup-image-script.sh"]

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
    _IMAGE_PROJECT_ID = local.image_project_id_dev
    _IMAGE_TAG        = var.packer_image_tag
    _REGION           = local.image_default_region_dev
    _IMAGE_ZONE       = "${local.image_default_region_dev}-b"
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - BASTION IMAGE BUILD 
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "bastion_cis_image_build_prod" {

  project = local.automation_project_id
  name    = "bastion-vm-image-${var.env_name_prod}"

  description    = "${var.env_name_prod} Pipeline for bastion CIS Image Build created with Terraform"
  tags           = var.bastion_cis_image_build_trigger_tags
  disabled       = var.bastion_cis_image_build_trigger_disabled
  filename       = "cloudbuild/foundation/image-bastion-image.yaml"
  included_files = ["cloudbuild/foundation/image-bastion-image.yaml"]

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
    _IMAGE_PROJECT_ID = local.image_project_id_prod
    _IMAGE_TAG        = var.packer_image_tag
    _REGION           = local.image_default_region_prod
    _IMAGE_FAMILY     = "ubuntu-1804-lts"
    _IMAGE_ZONE       = "${local.image_default_region_prod}-b"
  }
}

resource "google_cloudbuild_trigger" "bastion_cis_image_build_dev" {

  project = local.automation_project_id
  name    = "bastion-vm-image-${var.env_name_dev}"

  description    = "${var.env_name_dev} Pipeline for bastion CIS Image Build created with Terraform"
  tags           = var.bastion_cis_image_build_trigger_tags
  disabled       = var.bastion_cis_image_build_trigger_disabled
  filename       = "cloudbuild/foundation/image-bastion-image.yaml"
  included_files = ["cloudbuild/foundation/image-bastion-image.yaml"]

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
    _IMAGE_PROJECT_ID = local.image_project_id_dev
    _IMAGE_TAG        = var.packer_image_tag
    _REGION           = local.image_default_region_dev
    _IMAGE_FAMILY     = "ubuntu-1804-lts"
    _IMAGE_ZONE       = "${local.image_default_region_dev}-b"
  }
}

#------------------------------------------------------------------------
# CLOUDBUILD TRIGGERS - PACKER CONTAINER IMAGE
#------------------------------------------------------------------------

resource "google_cloudbuild_trigger" "packer_container_image_dev" {

  project = local.automation_project_id
  name    = "packer-container-image-${var.env_name_dev}"

  description    = "Pipeline for Packer container image created with Terraform"
  tags           = var.packer_container_image_build_trigger_tags
  disabled       = var.packer_container_image_build_trigger_disabled
  filename       = "cloudbuild/foundation/image-container.yaml"
  included_files = ["environment/foundation/image-project/packer-container/Dockerfile"]

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
    _IMAGE_PROJECT_ID = var.image_project_id
    _REGION           = local.image_default_region_dev
  }
}

resource "google_cloudbuild_trigger" "packer_container_image_prod" {

  project = local.automation_project_id
  name    = "packer-container-image-${var.env_name_prod}"

  description    = "Pipeline for Packer container image created with Terraform"
  tags           = var.packer_container_image_build_trigger_tags
  disabled       = var.packer_container_image_build_trigger_disabled
  filename       = "cloudbuild/foundation/image-container.yaml"
  included_files = ["environment/foundation/image-project/packer-container/Dockerfile"]

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
    _IMAGE_PROJECT_ID = var.image_project_id
    _REGION           = local.image_default_region_prod
  }
}

#------------------------------------------------------------------------
# FOLDER IAM MEMBER MODULE
#------------------------------------------------------------------------

module "folder_iam_member" {
  source = "../../../modules/iam/folder_iam"

  folder_id     = local.folder_id
  iam_role_list = var.iam_role_list
  folder_member = "serviceAccount:${local.cloudbuild_service_account}"
}