#-------------------------------------
# RESEARCHER WORKSPACE PROJECT OUTPUTS
#-------------------------------------

output "workspace_enabled_apis" {
  description = "Enabled APIs in the project"
  value       = module.researcher-workspace-project.enabled_apis
}

output "workspace_project_id" {
  value = module.researcher-workspace-project.project_id
}

output "workspace_project_name" {
  value = module.researcher-workspace-project.project_name
}

output "workspace_project_number" {
  value = module.researcher-workspace-project.project_number
}

#----------------------------------------
# RESEARCHER WORKSPACE VPC MODULE OUTPUTS
#----------------------------------------

output "workspace_network_name" {
  description = "The name of the VPC being created"
  value       = module.workspace_vpc.network_name
}

output "workspace_network_self_link" {
  description = "The URI of the VPC being created"
  value       = module.workspace_vpc.network_self_link
}

output "workspace_subnets_names" {
  description = "The names of the subnets being created"
  value       = module.workspace_vpc.subnets_names
}

output "workspace_subnets_self_links" {
  description = "The self-links of subnets being created"
  value       = module.workspace_vpc.subnets_self_links
}

output "workspace_vpc_route_names" {
  description = "The routes created in this VPC."
  value       = module.workspace_vpc.route_names
}

#-------------------------------------------------------------
# RESEARCHER WORKSPACE RESTRICTED API CLOUD DNS MODULE OUTPUTS
#-------------------------------------------------------------

output "workspace_restricted_api_dns_type" {
  description = "The DNS zone type."
  value       = module.researcher_workspace_restricted_api_cloud_dns.type
}

output "workspace_restricted_api_dns_name" {
  description = "The DNS zone name."
  value       = module.researcher_workspace_restricted_api_cloud_dns.name
}

output "workspace_restricted_api_dns_domain" {
  description = "The DNS zone domain."
  value       = module.researcher_workspace_restricted_api_cloud_dns.domain
}

output "workspace_restricted_api_dns_name_servers" {
  description = "The DNS zone name servers."
  value       = module.researcher_workspace_restricted_api_cloud_dns.name_servers
}

#---------------------------------------------------------
# RESEARCHER WORKSPACE IAP TUNNEL CLOUD DNS MODULE OUTPUTS
#---------------------------------------------------------

output "workspace_iap_tunnel_dns_type" {
  description = "The DNS zone type."
  value       = module.researcher_workspace_iap_tunnel_cloud_dns.type
}

output "workspace_iap_tunnel_dns_name" {
  description = "The DNS zone name."
  value       = module.researcher_workspace_iap_tunnel_cloud_dns.name
}

output "workspace_iap_tunnel_dns_domain" {
  description = "The DNS zone domain."
  value       = module.researcher_workspace_iap_tunnel_cloud_dns.domain
}

output "workspace_iap_tunnel_dns_name_servers" {
  description = "The DNS zone name servers."
  value       = module.researcher_workspace_iap_tunnel_cloud_dns.name_servers
}

#----------------------------------------------------------------
# RESEARCHER WORKSPACE ARTIFACT REGISTRY CLOUD DNS MODULE OUTPUTS
#----------------------------------------------------------------

output "workspace_artifact_registry_dns_type" {
  description = "The DNS zone type."
  value       = module.researcher_workspace_artifact_registry_cloud_dns.type
}

output "workspace_artifact_registry_dns_name" {
  description = "The DNS zone name."
  value       = module.researcher_workspace_artifact_registry_cloud_dns.name
}

output "workspace_artifact_registry_dns_domain" {
  description = "The DNS zone domain."
  value       = module.researcher_workspace_artifact_registry_cloud_dns.domain
}

output "workspace_artifact_registry_dns_name_servers" {
  description = "The DNS zone name servers."
  value       = module.researcher_workspace_artifact_registry_cloud_dns.name_servers
}

#----------------------------------------------------
# RESEARCHER WORKSPACE TO BASTION VPC PEERING OUTPUTS
#----------------------------------------------------

output "researcher_workspace_to_bastion_vpc_peer_id" {
  description = "An identifier for the resource with format {{network}}/{{name}}"
  value       = module.researcher_workspace_to_bastion_vpc_peer.id
}

output "researcher_workspace_to_bastion_vpc_peer_state" {
  description = "State for the peering, either ACTIVE or INACTIVE. The peering is ACTIVE when there's a matching configuration in the peer network."
  value       = module.researcher_workspace_to_bastion_vpc_peer.state
}

output "researcher_workspace_to_bastion_vpc_peer_state_details" {
  description = "Details about the current state of the peering."
  value       = module.researcher_workspace_to_bastion_vpc_peer.state_details
}

#--------------------------------------------------------------
# RESEARCHER WORKSPACE DEEP LEARNING VM SERVICE ACCOUNT OUTPUTS 
#--------------------------------------------------------------

output "workspace_deeplearning_vm_sa_email" {
  description = "The service account email."
  value       = module.workspace_deeplearning_vm_service_account.email
}

output "workspace_deeplearning_vm_sa_iam_email" {
  description = "The service account IAM-format email."
  value       = module.workspace_deeplearning_vm_service_account.iam_email
}

output "workspace_deeplearning_vm_service_account" {
  description = "Service account resource (for single use)."
  value       = module.workspace_deeplearning_vm_service_account.service_account
}

#--------------------------------------------------------
# RESEARCHER WORKSPACE PATH ML VM SERVICE ACCOUNT OUTPUTS 
#--------------------------------------------------------

# output "workspace_path_ml_vm_sa_email" {
#   description = "The service account email."
#   value       = module.workspace_path_ml_vm_service_account.email
# }

# output "workspace_path_ml_vm_sa_iam_email" {
#   description = "The service account IAM-format email."
#   value       = module.workspace_path_ml_vm_service_account.iam_email
# }

# output "workspace_path_ml_vm_service_account" {
#   description = "Service account resource (for single use)."
#   value       = module.workspace_path_ml_vm_service_account.service_account
# }

#-----------------------------------------------------
# RESEARCHER WORKSPACE PROJECT IAM CUSTOM ROLE OUTPUTS
#-----------------------------------------------------

output "workspace_project_custom_role_name" {
  description = "The name of the role in the format projects/{{project}}/roles/{{role_id}}. Like id, this field can be used as a reference in other resources such as IAM role bindings."
  value       = module.workspace_project_iam_custom_role.name
}

output "workspace_project_custom_role_id" {
  description = "The role_id name."
  value       = module.workspace_project_iam_custom_role.role_id
}

#----------------------------------------------------------
# RESEARCHER WORKSPACE DEEPLEARNING VM - PRIVATE IP OUTPUTS
#----------------------------------------------------------

output "workspace_deeplearning_vm_instance_id" {
  description = "The server-assigned unique identifier of this instance."
  value       = module.researcher_workspace_deeplearning_vm_private_ip.instance_id
}

output "workspace_deeplearning_vm_self_link" {
  description = "The URI of the instance that was created."
  value       = module.researcher_workspace_deeplearning_vm_private_ip.self_link
}

output "workspace_deeplearning_vm_tags" {
  description = "The tags applied to the VM instance."
  value       = module.researcher_workspace_deeplearning_vm_private_ip.tags
}

#-----------------------------------------------------
# RESEARCHER WORKSPACE PATH ML VM - PRIVATE IP OUTPUTS
#-----------------------------------------------------

# output "workspace_path_ml_vm_instance_id" {
#   description = "The server-assigned unique identifier of this instance."
#   value       = module.researcher_workspace_path_ml_vm_private_ip.instance_id
# }

# output "workspace_path_ml_vm_self_link" {
#   description = "The URI of the instance that was created."
#   value       = module.researcher_workspace_path_ml_vm_private_ip.self_link
# }

# output "workspace_path_ml_vm_tags" {
#   description = "The tags applied to the VM instance."
#   value       = module.researcher_workspace_path_ml_vm_private_ip.tags
# }

#-----------------------------------------------------------
# RESEARCHER WORKSPACE - REGIONAL EXTERNAL STATIC IP OUTPUTS
#-----------------------------------------------------------

output "researcher_workspace_regional_external_static_ip_self_link" {
  description = "Self link to the URI of the created resource."
  value       = module.researcher_workspace_regional_external_static_ip.regional_external_static_ip_self_link
}

#-----------------------------------
# RESEARCHER BASTION PROJECT OUTPUTS
#-----------------------------------

output "bastion_project_enabled_apis" {
  description = "Enabled APIs in the project"
  value       = module.researcher-bastion-access-project.enabled_apis
}

output "bastion_project_project_id" {
  value = module.researcher-bastion-access-project.project_id
}

output "bastion_project_project_name" {
  value = module.researcher-bastion-access-project.project_name
}

output "bastion_project_project_number" {
  value = module.researcher-bastion-access-project.project_number
}

#---------------------------------------------------
# RESEARCHER BASTION PROJECT IAM CUSTOM ROLE OUTPUTS
#---------------------------------------------------

output "bastion_project_custom_role_name" {
  description = "The name of the role in the format projects/{{project}}/roles/{{role_id}}. Like id, this field can be used as a reference in other resources such as IAM role bindings."
  value       = module.bastion_project_iam_custom_role.name
}

output "bastion_project_custom_role_id" {
  description = "The role_id name."
  value       = module.bastion_project_iam_custom_role.role_id
}

#----------------------------------------------
# RESEARCHER BASTION PROJECT VPC MODULE OUTPUTS
#----------------------------------------------

output "bastion_project_network_name" {
  description = "The name of the VPC being created"
  value       = module.bastion_project_vpc.network_name
}

output "bastion_project_network_self_link" {
  description = "The URI of the VPC being created"
  value       = module.bastion_project_vpc.network_self_link
}

output "bastion_project_subnets_names" {
  description = "The names of the subnets being created"
  value       = module.bastion_project_vpc.subnets_names
}

output "bastion_project_subnets_self_links" {
  description = "The self-links of subnets being created"
  value       = module.bastion_project_vpc.subnets_self_links
}

#----------------------------------------------------
# RESEARCHER BASTION TO WORKSPACE VPC PEERING OUTPUTS
#----------------------------------------------------

output "researcher_bastion_to_workspace_vpc_peer_id" {
  description = "An identifier for the resource with format {{network}}/{{name}}"
  value       = module.researcher_bastion_to_workspace_vpc_peer.id
}

output "researcher_bastion_to_workspace_vpc_peer_state" {
  description = "State for the peering, either ACTIVE or INACTIVE. The peering is ACTIVE when there's a matching configuration in the peer network."
  value       = module.researcher_bastion_to_workspace_vpc_peer.state
}

output "researcher_bastion_to_workspace_vpc_peer_state_details" {
  description = "Details about the current state of the peering."
  value       = module.researcher_bastion_to_workspace_vpc_peer.state_details
}

#---------------------------------------------------
# RESEARCHER BASTION PROJECT SERVICE ACCOUNT OUTPUTS 
#---------------------------------------------------

output "bastion_project_sa_email" {
  description = "The service account email."
  value       = module.bastion_project_service_account.email
}

output "bastion_project_sa_iam_email" {
  description = "The service account IAM-format email."
  value       = module.bastion_project_service_account.iam_email
}

output "bastion_project_service_account" {
  description = "Service account resource (for single use)."
  value       = module.bastion_project_service_account.service_account
}

output "bastion_project_service_accounts" {
  description = "Service account resources as list."
  value       = module.bastion_project_service_account.service_accounts
}

#-------------------------------------------
# RESEARCHER BASTION VM - PRIVATE IP OUTPUTS
#-------------------------------------------

output "bastion_instance_id" {
  description = "The server-assigned unique identifier of this instance."
  value       = module.researcher_bastion_vm_private_ip.instance_id
}

output "bastion_self_link" {
  description = "The URI of the instance that was created."
  value       = module.researcher_bastion_vm_private_ip.self_link
}

output "bastion_tags" {
  description = "The tags applied to the VM instance."
  value       = module.researcher_bastion_vm_private_ip.tags
}

#-----------------------------------------------------------
# RESEARCHER WORKSPACE - REGIONAL EXTERNAL STATIC IP OUTPUTS
#-----------------------------------------------------------

output "bastion_project_regional_external_static_ip_self_link" {
  description = "Self link to the URI of the created resource."
  value       = module.bastion_project_regional_external_static_ip.regional_external_static_ip_self_link
}

#---------------------------------------
# RESEARCHER DATA EGRESS PROJECT OUTPUTS
#---------------------------------------

output "data_egress_enabled_apis" {
  description = "Enabled APIs in the project"
  value       = module.researcher-data-egress-project.enabled_apis
}

output "external_data_egress_project_id" {
  value = module.researcher-data-egress-project.project_id
}

output "data_egress_project_name" {
  value = module.researcher-data-egress-project.project_name
}

output "data_egress_project_number" {
  value = module.researcher-data-egress-project.project_number
}

#-------------------
# GCS BUCKET OUTPUTS
#-------------------

output "staging_gcs_ingress_bucket" {
  description = "Name of ingress bucket in staging project."
  value       = module.gcs_bucket_staging_ingress.bucket_name
}

output "staging_gcs_egress_bucket" {
  description = "Name of egress bucket in staging project."
  value       = module.gcs_bucket_staging_egress.bucket_name
}

output "workspace_gcs_ingress_bucket" {
  description = "Name of ingress bucket in researcher workspace project."
  value       = module.gcs_bucket_researcher_workspace_ingress.bucket_name
}

output "workspace_gcs_egress_bucket" {
  description = "Name of egress bucket in researcher workspace project."
  value       = module.gcs_bucket_researcher_workspace_egress.bucket_name
}

output "external_gcs_egress_bucket" {
  description = "Name of egress bucket in researcher data egress project."
  value       = module.gcs_bucket_researcher_data_egress.bucket_name
}

output "workspace_gcs_vm_access_bucket" {
  description = "Name of egress bucket in researcher workspace project."
  value       = module.gcs_bucket_researcher_workspace_vm_access.bucket_name
}

#--------------------------------------------------------------
# RESEARCHER WORKSPACE VPC SC REGULAR SERVICE PERIMETER OUTPUTS
#--------------------------------------------------------------

/*
output "workspace_regular_service_perimeter_resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  value       = module.researcher_workspace_regular_service_perimeter.regular_service_perimeter_resources
}

output "workspace_regular_service_perimeter_name" {
  description = "The perimeter's name."
  value       = module.researcher_workspace_regular_service_perimeter.regular_service_perimeter_name
}

output "workspace_vpc_accessible_services" {
  description = "The API services accessible from a network within the VPC SC perimeter."
  value       = module.researcher_workspace_regular_service_perimeter.vpc_accessible_services
}
*/

#--------------------------------------------------------------------
# RESEARCHER BASTION PROJECT VPC SC REGULAR SERVICE PERIMETER OUTPUTS
#--------------------------------------------------------------------

/*
output "bastion_project_regular_service_perimeter_resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  value       = module.researcher_bastion_project_regular_service_perimeter.regular_service_perimeter_resources
}

output "bastion_project_regular_service_perimeter_name" {
  description = "The perimeter's name."
  value       = module.researcher_bastion_project_regular_service_perimeter.regular_service_perimeter_name
}

output "bastion_project_vpc_accessible_services" {
  description = "The API services accessible from a network within the VPC SC perimeter."
  value       = module.researcher_bastion_project_regular_service_perimeter.vpc_accessible_services
}
*/

#----------------------------------------------------------
# BIGQUERY DATASET - RESEARCHER DLP RESULTS STAGING PROJECT
#----------------------------------------------------------

output "researcher_dlp_result_bq_dataset" {
  description = "Bigquery dataset resource."
  value       = module.bigquery_researcher_dlp.bigquery_dataset
}

#----------------------------------------
# BIGQUERY DATASET - RESEARCHER WORKSPACE
#----------------------------------------

output "researcher_workspace_bq_dataset" {
  description = "Bigquery dataset resource."
  value       = module.bigquery_researcher_workspace.bigquery_dataset
}

#-----------------------------------------------------
# VPC SC RESEARCHER GROUP MEMBER ACCESS LEVELS OUTPUTS
#-----------------------------------------------------

/*
output "vpc_sc_researcher_group_member_access_level_name" {
  description = "Description of the AccessLevel and its use. Does not affect behavior."
  value       = module.researcher_group_member_access_level.name
}

output "vpc_sc_researcher_group_member_access_level_name_id" {
  description = "The fully-qualified name of the Access Level. Format: accessPolicies/{policy_id}/accessLevels/{name}"
  value       = module.researcher_group_member_access_level.name_id
}
*/