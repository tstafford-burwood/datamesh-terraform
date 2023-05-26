module "workspace_1" {
  source = "../modules/"

  access_policy_id                  = local.parent_access_policy_id
  admin_access_level_name           = local.fdn_admins
  billing_account                   = local.billing_account_id
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
  data_stewards                     = []
  enforce                           = true
  environment                       = local.environment
  external_users_vpc                = []
  folder_id                         = local.srde_folder_id
  force_destroy                     = true
  golden_image_version              = ""
  imaging_bucket_name               = local.imaging_bucket
  imaging_project_id                = local.imaging_project_id
  notebook_sa_email                 = ""
  num_instances                     = 0
  org_id                            = local.org_id
  project_admins                    = []
  region                            = local.region
  research_to_bucket                = local.data_lake_bucket
  researcher_workspace_name         = local.researcher_workspace_name
  researchers                       = []
  serviceaccount_access_level_name  = local.fdn_sa
  set_disable_sa_create             = var.set_disable_sa_create
  set_vm_os_login                   = var.set_vm_os_login
  stewards_access_level_name        = local.fnd_stewards
  vpc_connector                     = local.vpc_connector
  wrkspc_folders                    = local.wrkspc_folders

  // VPC Perimeter
  access_context_manager_policy_id = "428294780283"
  common_name                      = local.researcher_workspace_name
  members                          = []
  access_level_ip_subnetworks      = ["66.226.105.145/32"]
  restricted_services              = ["bigquery.googleapis.com", "storage.googleapis.com"]

  #egress_project_number             = ""
  #pubsub_appint_results            = "application-integration-trigger-results"
  #prefix                           = "test"
  #instance_name                    = "deep-learning-vm"
  #lbl_department                   = "pii"

}