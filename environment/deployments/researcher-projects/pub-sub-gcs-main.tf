// THIS TF FILE CREATES NOTIFICATIONS FROM GCS BUCKETS AND SEND THEM TO A PUB/SUB TOPIC

// LOCAL.RESEARCHER_BUCKET_NAMES SET IN BUCKET-MAIN.TF OF THIS DIRECTORY

// LOCAL.STAGING_PROJECT_ID SET IN MAIN.TF OF THIS DIRECTORY

#--------------------------------
# PUB/SUB GCS NOTIFICATION MODULE
#--------------------------------

locals {
  staging_pub_sub_topic_name = data.terraform_remote_state.staging_project.outputs.topic_name
}

module "gcs_pub_sub_notification" {
  source = "../../../modules/pub_sub/pub_sub_gcs_notification"

  for_each = local.researcher_bucket_names

  // REQUIRED
  bucket_name    = each.value
  payload_format = var.payload_format
  pub_sub_topic  = "projects/${local.staging_project_id}/topics/${local.staging_pub_sub_topic_name}" // TOPIC SHOULD BE PROVISIONED PRIOR TO USING THIS MODULE

  // OPTIONAL
  custom_attributes  = var.custom_attributes
  event_types        = var.event_types
  object_name_prefix = var.object_name_prefix

  depends_on = [module.pub_sub_topic_iam_binding]
}


// USED TO APPLY THE DEFINED IAM ROLE TO A PROJECT'S GCS SERVICE ACCOUNT
// BIND ROLE TO SERVICE ACCOUNT AND THEN TO PUB/SUB TOPIC

// ENABLES PUBLISHING GCS NOTIFICATIONS TO A PUB/SUB TOPIC
// LOCAL.STAGING_PROJECT_ID LOCATED IN MAIN.TF OF THIS DIRECTORY

// DATA BLOCK TO RETRIEVE WORKSPACE PROJECT'S GCS SERVICE ACCOUNT

data "google_storage_project_service_account" "workspace_gcs_account" {
  project = module.workspace_project.project_id
}

// DATA BLOCK TO RETRIEVE RESEARCHER EXTERNAL DATA EGRESS PROJECT'S GCS SERVICE ACCOUNT

data "google_storage_project_service_account" "researcher_egress_project_gcs_account" {
  project = module.researcher-data-egress-project.project_id
}

// LOCALS VALUE USED TO ITERATE OVER IN PUB/SUB TOPIC IAM MEMBER MODULE

locals {
  researcher_projects_buckets_gcs_service_accounts = {
    workspace_gcs_account                 = data.google_storage_project_service_account.workspace_gcs_account.email_address,
    researcher_egress_project_gcs_account = data.google_storage_project_service_account.researcher_egress_project_gcs_account.email_address
  }
}

#--------------------------------
# PUB/SUB TOPIC IAM MEMBER MODULE
#--------------------------------

module "pub_sub_topic_iam_binding" {
  source = "../../../modules/pub_sub/pub_sub_topic/pub_sub_topic_iam_member"

  for_each = local.researcher_projects_buckets_gcs_service_accounts

  // REQUIRED

  project_id = local.staging_project_id
  #topic_name = var.topic_name
  topic_name = local.staging_pub_sub_topic_name
  iam_member = "serviceAccount:${each.value}"
  role       = var.role
}