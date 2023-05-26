module "workspace_1" {
  source = "../modules/"

  access_policy_id        = local.parent_access_policy_id
  admin_access_level_name = local.fdn_admins
  billing_account         = local.billing_account_id
  environment             = local.environment

  org_id         = local.org_id
  folder_id      = local.srde_folder_id
  region         = local.region
  wrkspc_folders = local.wrkspc_folders

  cloud_composer_email              = local.composer_sa
  cloudbuild_service_account        = local.cloudbuild_service_account
  composer_ariflow_uri              = local.composer_ariflow_uri
  composer_dag_bucket               = local.dag_bucket
  csv_names_list                    = local.cordon_bucket
  data_ingress_bucket_names         = local.data_ingress_bucket
  data_ingress_project_id           = local.data_ingress_id
  data_ingress_project_number       = local.data_ingress
  data_lake_bucket_list_custom_role = local.data_lake_custom_role
  data_lake_project_id              = local.data_lake_id
  data_lake_project_number          = local.data_lake
  data_lake_research_to_bucket      = local.data_lake_bucket
  data_ops_bucket                   = local.data_ops_bucket
  data_ops_project_id               = local.staging_project_id
  data_ops_project_number           = local.staging_project_number
  enforce                           = true

  force_destroy        = true
  golden_image_version = ""
  imaging_bucket_name  = local.imaging_bucket
  imaging_project_id   = local.imaging_project_id
  notebook_sa_email    = ""
  num_instances        = 0

  research_to_bucket        = local.data_lake_bucket
  researcher_workspace_name = local.researcher_workspace_name

  serviceaccount_access_level_name = local.fdn_sa
  set_disable_sa_create            = var.set_disable_sa_create
  set_vm_os_login                  = var.set_vm_os_login
  stewards_access_level_name       = local.fnd_stewards
  vpc_connector                    = local.vpc_connector


  // IAM
  data_stewards      = var.data_stewards
  external_users_vpc = var.external_users_vpc
  project_admins     = var.project_admins
  researchers        = var.researchers

  // VPC Perimeter
  access_context_manager_policy_id = local.parent_access_policy_id
  common_name                      = replace(local.researcher_workspace_name, "-", "_")
  additional_access_levels         = ["ac_dwh_data_enclave_446c2d89", "ac_dwh_image_prj_446c2d89"]
  members                          = distinct(flatten([var.data_stewards, var.external_users_vpc, var.project_admins, var.researchers]))
  access_level_ip_subnetworks      = []
  restricted_services              = ["bigquery.googleapis.com", "storage.googleapis.com"]

  bridge1_resources = [local.staging_project_number, local.data_lake]
  bridge2_resources = [local.imaging_project_number]


  #egress_project_number             = ""
  #pubsub_appint_results            = "application-integration-trigger-results"
  #prefix                           = "test"
  #instance_name                    = "deep-learning-vm"
  #lbl_department                   = "pii"

}