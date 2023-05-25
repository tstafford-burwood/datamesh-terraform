module "egress_project" {
  source = "./egress"

  environment               = var.environment
  billing_account           = var.billing_account
  org_id                    = var.org_id
  folder_id                 = var.folder_id
  researcher_workspace_name = var.researcher_workspace_name
  region                    = var.region
  data_ops_project_id       = var.data_ops_project_id
  data_ops_project_number   = var.data_ops_project_number
  vpc_connector             = var.vpc_connector
  data_ops_bucket           = var.data_ops_bucket
  cloud_composer_email      = var.cloud_composer_email
  composer_ariflow_uri      = var.composer_ariflow_uri
  composer_dag_bucket       = var.composer_dag_bucket
  prefix                    = var.prefix
  wrkspc_folders            = var.wrkspc_folders
  tf_state_bucket           = var.tf_state_bucket
  enforce                   = var.enforce
  project_admins            = var.project_admins
  data_stewards             = var.data_stewards
  external_users_vpc        = var.external_users_vpc
  lbl_department            = var.lbl_department
}

module "workspace_project" {
  source = "./workspace"

  environment                       = var.environment
  billing_account                   = var.billing_account
  org_id                            = var.org_id
  folder_id                         = var.folder_id
  researcher_workspace_name         = var.researcher_workspace_name
  region                            = var.region
  tf_state_bucket                   = var.tf_state_bucket
  cloudbuild_service_account        = var.cloudbuild_service_account
  research_to_bucket                = var.research_to_bucket
  csv_names_list                    = var.csv_names_list
  imaging_project_id                = var.imaging_project_id
  apt_repo_name                     = var.apt_repo_name
  egress_project_number             = module.egress_project.project_id
  data_ingress_project_id           = var.data_ingress_project_id
  data_ingress_project_number       = var.data_ingress_project_number
  data_ingress_bucket_names         = var.data_ingress_bucket_names
  imaging_bucket_name               = var.imaging_bucket_name
  data_lake_project_id              = var.data_lake_project_id
  data_lake_project_number          = var.data_lake_project_number
  data_lake_research_to_bucket      = var.data_lake_research_to_bucket
  access_policy_id                  = var.access_policy_id
  serviceaccount_access_level_name  = var.serviceaccount_access_level_name
  notebook_sa_email                 = var.notebook_sa_email
  data_ops_project_id               = var.data_ops_project_id
  data_ops_project_number           = var.data_ops_project_number
  composer_dag_bucket               = var.composer_dag_bucket
  project_admins                    = var.project_admins
  instance_name                     = var.instance_name
  researchers                       = var.researchers
  data_stewards                     = var.data_stewards
  lbl_department                    = var.lbl_department
  data_lake_bucket_list_custom_role = var.data_lake_bucket_list_custom_role
  set_vm_os_login                   = var.set_vm_os_login

  depends_on = [
    module.egress_project
  ]
}

# module "vpc_perimeter" {
#   source = "./vpc-sc"

#   researcher_workspace_name = var.researcher_workspace_name
#   external_users_vpc        = var.external_users_vpc

#   depends_on = [ 
#     module.egress_project,
#     module.workspace
#    ]
# }