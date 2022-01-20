// DATA BLOCK


data "terraform_remote_state" "cloudbuild_sde" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = "foundation/cloudbuild-sde"
  }
}

#------------------
# IMPORT CONSTANTS
#------------------

module "constants" {
  source = "../constants"
}


locals {
  automation_project_id     = module.constants.value.automation_project_id
  folders_apply_trigger     = data.terraform_remote_state.cloudbuild_sde.outputs.folders_apply_trigger_dev
  packer_project_apply_trigger    = data.terraform_remote_state.cloudbuild_sde.outputs.packer_project_apply_trigger_dev
  staging_project_apply_trigger   = data.terraform_remote_state.cloudbuild_sde.outputs.staging_project_apply_trigger_dev
  data_lake_project_apply_trigger = data.terraform_remote_state.cloudbuild_sde.outputs.data_lake_project_apply_trigger_dev

}


resource "google_service_account" "workflow_account" {
  account_id   = "sde-workflow"
  display_name = "SDE Workflow"
  project      = local.automation_project_id
}

resource "google_project_iam_member" "workflow_account_cloudbuild_role" {
  project = local.automation_project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = format("serviceAccount:%s",google_service_account.workflow_account.email)
}

resource "google_workflows_workflow" "sde_build_workflow" {
  name            = "sde-foundation-build-workflow"
  region          = "us-central1"
  description     = "SDE Build Workflow"
  service_account = google_service_account.workflow_account.id
  project         = local.automation_project_id
  source_contents = <<-EOF

    main:
        steps:
            - init:
                assign:
                - projectId: $${sys.get_env("GOOGLE_CLOUD_PROJECT_ID")}
                - foldersTrigger: ${local.folders_apply_trigger}
                - packerProjectTrigger:  ${local.packer_project_apply_trigger}
                - stagingProjectTrigger:  ${local.staging_project_apply_trigger}
                - dataLakeProjectTrigger:  ${local.data_lake_project_apply_trigger}
                - branch: main
            - folders_create:
                call: googleapis.cloudbuild.v1.projects.triggers.run
                args:
                    projectId: $${projectId}
                    triggerId: $${foldersTrigger}
                    body:
                        branchName: $${branch}
                result: foldersResponse
            - log_folders_create:
                call: sys.log
                args:
                    data: $${foldersResponse}
            - packer_project_create:
                call: googleapis.cloudbuild.v1.projects.triggers.run
                args:
                    projectId: $${projectId}
                    triggerId: $${packerProjectTrigger}
                    body:
                        branchName: $${branch}
                result: packerProjectResponse
            - log_packer_project_create:
                call: sys.log
                args:
                    data: $${packerProjectResponse}
            - staging_project_create:
                call: googleapis.cloudbuild.v1.projects.triggers.run
                args:
                    projectId: $${projectId}
                    triggerId: $${stagingProjectTrigger}
                    body: 
                        branchName: $${branch}
                result: stagingProjectResponse
            - log_staging_project_create:
                call: sys.log
                args:
                    data: $${stagingProjectResponse}
            - data_lake_project_create:
                call: googleapis.cloudbuild.v1.projects.triggers.run
                args:
                    projectId: $${projectId}
                    triggerId: $${stagingProjectTrigger}
                    body:
                        branchName: $${branch}
                result: dataLakeProjectResponse
            - log_data_lake_project_create:
                call: sys.log
                args:
                    data: $${dataLakeProjectResponse}
            - the_end:
                return: "SUCCESS"
    # [END cloudbuild_tf_workflow]
    EOF
}