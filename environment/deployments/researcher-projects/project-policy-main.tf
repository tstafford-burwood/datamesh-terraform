#---------------------------------------------------------------
# RESEARCHER BASTION VPC - RESTRICT VPC PEERING TO WORKSPACE VPC
#---------------------------------------------------------------

module "researcher_bastion_vpc_restrict_vpc_peering_to_workspace_vpc" {
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 3.0.2"
  constraint        = "constraints/compute.restrictVpcPeering"
  policy_type       = "list"
  policy_for        = "project"
  project_id        = module.researcher-bastion-access-project.project_id
  enforce           = null
  allow             = ["projects/${module.researcher-workspace-project.project_id}/global/networks/${module.workspace_vpc.network_name}"]
  allow_list_length = 1
  depends_on        = [module.researcher_bastion_to_workspace_vpc_peer, module.researcher_workspace_to_bastion_vpc_peer]
}

#---------------------------------------------------------------
# RESEARCHER WORKSPACE VPC - RESTRICT VPC PEERING TO BASTION VPC
#---------------------------------------------------------------

module "researcher_workspace_vpc_restrict_vpc_peering_to_bastion_vpc" {
  source            = "terraform-google-modules/org-policy/google"
  version           = "~> 3.0.2"
  constraint        = "constraints/compute.restrictVpcPeering"
  policy_type       = "list"
  policy_for        = "project"
  project_id        = module.researcher-workspace-project.project_id
  enforce           = null
  allow             = ["projects/${module.researcher-bastion-access-project.project_id}/global/networks/${module.bastion_project_vpc.network_name}"]
  allow_list_length = 1
  depends_on        = [module.researcher_bastion_to_workspace_vpc_peer, module.researcher_workspace_to_bastion_vpc_peer]
}

// THE BELOW POLICIES ARE LISTED HERE TO DISABLE THEN RE-ENABLE DURING CLOUD BUILD PIPELINE RUNS
// THESE POLICIES ARE ALSO APPLIED AT THE SRDE FOLDER LEVEL IN THE `../srde-folder-policies` DIRECTORY

#----------------------------------------------
# RESEARCHER WORKSPACE SERVICE ACCOUNT CREATION
#----------------------------------------------

module "researcher_workspace_disable_sa_creation" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 3.0.2"
  constraint  = "constraints/iam.disableServiceAccountCreation"
  policy_type = "boolean"
  policy_for  = "project"
  project_id  = module.researcher-workspace-project.project_id
  enforce     = var.enforce_researcher_workspace_disable_sa_creation
}

#-----------------------------------------
# BASTION PROJECT SERVICE ACCOUNT CREATION
#-----------------------------------------

module "bastion_project_disable_sa_creation" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 3.0.2"
  constraint  = "constraints/iam.disableServiceAccountCreation"
  policy_type = "boolean"
  policy_for  = "project"
  project_id  = module.researcher-bastion-access-project.project_id
  enforce     = var.enforce_bastion_project_disable_sa_creation
}