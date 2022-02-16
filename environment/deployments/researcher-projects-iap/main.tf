#----------------------------------------------------------------------------------------------
# IMPORT CONSTANTS
#----------------------------------------------------------------------------------------------

module "constants" {
  source = "../../foundation/constants"
}

#----------------------------------------------------------------------------------------------
# TERRAFORM STATE IMPORTS
# Retrieve Staging project state
#----------------------------------------------------------------------------------------------

#data "terraform_remote_state" "data_ops_project" {
#  backend = "gcs"
#  config = {
#    bucket = module.constants.value.terraform_state_bucket
#    prefix = format("%s/%s", var.terraform_foundation_state_prefix, "data-ops-project")
#  }
#}

data "terraform_remote_state" "folders" {
  backend = "gcs"
  config = {
    bucket = module.constants.value.terraform_state_bucket
    prefix = format("%s/%s", var.terraform_foundation_state_prefix, "folders")
  }
}

#----------------------------------------------------------------------------------------------
# SET CONSTANT MODULE VALUES AS LOCALS
#----------------------------------------------------------------------------------------------

locals {
  data_ops_project_id       = ""
  data_ops_project_number   = ""
  data_ops_default_region   = ""
  org_id                    = module.constants.value.org_id
  billing_account_id        = module.constants.value.billing_account_id
  sde_folder_id             = data.terraform_remote_state.folders.outputs.ids[var.researcher_workspace_name]
  workspace_default_region  = var.workspace_default_region
  researcher_workspace_name = var.researcher_workspace_name
}

#----------------------------------------------------------------------------------------------
# WORKSPACE - PROJECT
# Create the Workspace Project
#----------------------------------------------------------------------------------------------

module "workspace_project" {
  source = "../../../modules/project_factory"

  // REQUIRED FIELDS
  project_name       = format("%s-%s", local.researcher_workspace_name, "workspace")
  org_id             = local.org_id
  billing_account_id = local.billing_account_id
  folder_id          = local.sde_folder_id

  // OPTIONAL FIELDS
  activate_apis               = var.activate_apis
  auto_create_network         = false
  random_project_id           = true
  lien                        = false
  create_project_sa           = false
  default_service_account     = var.workspace_default_service_account
  disable_dependent_services  = true
  disable_services_on_destroy = true
  project_labels = {
    "researcher-workspace" : "${local.researcher_workspace_name}-workspace-project"
  }
}

resource "google_compute_project_metadata" "researcher_workspace_project" {
  project = module.workspace_project.project_id
  metadata = {
    enable-osconfig = "TRUE",
    enable-oslogin  = "TRUE"
  }
}

#----------------------------------------------------------------------------------------------
# WORKSPACE - IAM MEMBER BINDING
#----------------------------------------------------------------------------------------------

module "workspace_project_iam_member" {
  source = "../../../modules/iam/project_iam"

  project_id            = module.workspace_project.project_id
  project_member        = var.workspace_project_member
  project_iam_role_list = var.workspace_project_iam_role_list
}


# Uncomment if defining custom role
#----------------------------------------------------------------------------------------------
# WORKSPACE - PROJECT IAM CUSTOM ROLE MODULE
#----------------------------------------------------------------------------------------------

#module "workspace_project_iam_custom_role" {
#  source = "../../../modules/iam/project_iam_custom_role"
#
#  project_iam_custom_role_project_id  = module.workspace_project.project_id
#  project_iam_custom_role_description = var.workspace_project_iam_custom_role_description
#  project_iam_custom_role_id          = var.workspace_project_iam_custom_role_id
#  project_iam_custom_role_title       = var.workspace_project_iam_custom_role_title
#  project_iam_custom_role_permissions = var.workspace_project_iam_custom_role_permissions
#  project_iam_custom_role_stage       = var.workspace_project_iam_custom_role_stage
#}



#----------------------------------------------------------------------------------------------
# WORKSPACE - VPC
# Create the VPC in the Workspace Project
#----------------------------------------------------------------------------------------------

module "workspace_vpc" {
  source = "../../../modules/vpc"

  project_id                             = module.workspace_project.project_id
  vpc_network_name                       = format("%s-%s", local.researcher_workspace_name, "workspace-vpc")
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = var.workspace_vpc_delete_default_internet_gateway_routes
  firewall_rules                         = var.workspace_vpc_firewall_rules
  routing_mode                           = var.workspace_vpc_routing_mode
  vpc_description                        = var.workspace_vpc_description
  shared_vpc_host                        = var.workspace_vpc_shared_vpc_host
  mtu                                    = var.workspace_vpc_mtu

  subnets = [
    {
      subnet_name               = "${local.researcher_workspace_name}-${local.workspace_default_region}-workspace-subnet"
      subnet_ip                 = "10.0.0.0/16"
      subnet_region             = local.workspace_default_region
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_private_access     = "true"
    }
  ]
  secondary_ranges = var.workspace_vpc_secondary_ranges
  routes           = var.workspace_vpc_routes
}

#----------------------------------------------------------------------------------------------
# WORKSPACE FIREWALL
#----------------------------------------------------------------------------------------------

module "workspace_vpc_firewall" {
  source = "../../../modules/firewall"

  custom_rules = var.workspace_firewall_custom_rules
  network      = module.workspace_vpc.network_name
  project_id   = module.workspace_project.project_id
}

#----------------------------------------------------------------------------------------------
# WORKSPACE RESTRICTED GOOGLE API CLOUD DNS MODULE
#----------------------------------------------------------------------------------------------

module "researcher_workspace_restricted_api_cloud_dns" {
  source = "../../../modules/cloud_dns"

  // REQUIRED
  cloud_dns_domain     = "googleapis.com."
  cloud_dns_name       = "google-apis-private-zone"
  cloud_dns_project_id = module.workspace_project.project_id

  // OPTIONAL
  cloud_dns_description              = "Private DNS Zone for mapping calls for private.googleapis.com to Virtual IP addresses in the SDE."
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = var.workspace_restricted_api_cloud_dns_recordsets
  cloud_dns_zone_type                = "private"
}

#----------------------------------------------------------------------------------------------
# WORKSPACE NOTEBOOKS CLOUD GOOGLE COM CLOUD DNS ZONE MODULE
# THIS PRIVATE ZONE IS USED TO ACCESS NOTEBOOKS API
#----------------------------------------------------------------------------------------------

module "researcher_workspace_notebooks_google_cloud_dns" {
  source = "../../../modules/cloud_dns"

  // REQUIRED
  cloud_dns_domain     = "notebooks.cloud.google.com."
  cloud_dns_name       = "notebooks-cloud-google-com"
  cloud_dns_project_id = module.workspace_project.project_id

  // OPTIONAL
  cloud_dns_description              = "Private DNS Zone for notebooks.google.com"
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = var.workspace_notebooks_google_cloud_dns_recordsets
  cloud_dns_zone_type                = "private"
}

#----------------------------------------------------------------------------------------------
# WORKSPACE NOTEBOOKS GOOGLE USER CONTENT CLOUD DNS ZONE MODULE
# THIS PRIVATE ZONE IS USED TO ACCESS NOTEBOOKS API
#----------------------------------------------------------------------------------------------

module "researcher_workspace_notebooks_googleusercontent_cloud_dns" {
  source = "../../../modules/cloud_dns"

  // REQUIRED
  cloud_dns_domain     = "notebooks.googleusercontent.com."
  cloud_dns_name       = "notebooks-googleusercontent-com"
  cloud_dns_project_id = module.workspace_project.project_id

  // OPTIONAL
  cloud_dns_description              = "Private DNS Zone for notebooks.googleusercontent.com"
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = var.workspace_notebooks_googleusercontent_dns_recordsets
  cloud_dns_zone_type                = "private"
}


#----------------------------------------------------------------------------------------------
# WORKSPACE IAP TUNNEL CLOUD DNS ZONE MODULE
# THIS PRIVATE ZONE FOR IAP IS NEEDED TO ESTABLISH IAP TUNNEL CONNECTIVITY FROM WITHIN A GCP VM TO ANOTHER GCP VM
# https://cloud.google.com/iap/docs/securing-tcp-with-vpc-sc#configure-dns
#----------------------------------------------------------------------------------------------

module "researcher_workspace_iap_tunnel_cloud_dns" {
  source = "../../../modules/cloud_dns"

  // REQUIRED
  cloud_dns_domain     = "tunnel.cloudproxy.app."
  cloud_dns_name       = "iap-private-zone"
  cloud_dns_project_id = module.workspace_project.project_id

  // OPTIONAL
  cloud_dns_description              = "Private DNS Zone that enables IAP connections to be established from inside of a GCP VM so that an SSH connection to another VM can be made."
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = var.workspace_iap_tunnel_cloud_dns_recordsets
  cloud_dns_zone_type                = "private"
}

#----------------------------------------------------------------------------------------------
# WORKSPACE ARTIFACT REGISTRY CLOUD DNS ZONE MODULE
# THIS PRIVATE ZONE IS USED TO ACCESS THE ARTIFACT REGISTRY
#----------------------------------------------------------------------------------------------

module "researcher_workspace_artifact_registry_cloud_dns" {
  source = "../../../modules/cloud_dns"

  // REQUIRED
  cloud_dns_domain     = "pkg.dev."
  cloud_dns_name       = "artifact-registry-private-zone"
  cloud_dns_project_id = module.workspace_project.project_id

  // OPTIONAL
  cloud_dns_description              = "Private DNS Zone that enables access to Artifact Registry domain."
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = var.workspace_artifact_registry_cloud_dns_recordsets
  cloud_dns_zone_type                = "private"
}

#----------------------------------------------------------------------------------------------
# WORKSPACE - REGIONAL EXTERNAL STATIC IP MODULE
#----------------------------------------------------------------------------------------------

// FUNCTIONALITY IN THIS MODULE IS ONLY FOR A REGIONAL EXTERNAL STATIC IP

module "researcher_workspace_regional_external_static_ip" {
  source = "../../../modules/regional_external_static_ip"

  // REQUIRED
  regional_external_static_ip_name = format("%s-%s", local.researcher_workspace_name, "workspace-external-ip-nat")

  // OPTIONAL
  regional_external_static_ip_project_id   = module.workspace_project.project_id
  regional_external_static_ip_address_type = var.researcher_workspace_regional_external_static_ip_address_type
  regional_external_static_ip_description  = var.researcher_workspace_regional_external_static_ip_description
  regional_external_static_ip_network_tier = var.researcher_workspace_regional_external_static_ip_network_tier
  regional_external_static_ip_region       = local.workspace_default_region
}

#----------------------------------------------------------------------------------------------
# WORKSPACE - CLOUD NAT
#----------------------------------------------------------------------------------------------

module "researcher_workspace_cloud_nat" {
  source = "../../../modules/cloud_nat"

  create_router     = var.researcher_workspace_create_router
  project_id        = module.workspace_project.project_id
  cloud_nat_name    = format("%s-%s", local.researcher_workspace_name, "workspace-cloud-nat")
  cloud_nat_network = module.workspace_vpc.network_name
  region            = local.workspace_default_region
  router_name       = format("%s-%s", local.researcher_workspace_name, "workspace-clout-router")
  router_asn        = var.researcher_workspace_router_asn
  cloud_nat_subnetworks = [
    {
      name                     = module.workspace_vpc.subnets_names[0],
      source_ip_ranges_to_nat  = ["PRIMARY_IP_RANGE"],
      secondary_ip_range_names = []
    }
  ]
  enable_endpoint_independent_mapping = var.researcher_workspace_enable_endpoint_independent_mapping
  icmp_idle_timeout_sec               = var.researcher_workspace_icmp_idle_timeout_sec
  log_config_enable                   = var.researcher_workspace_log_config_enable
  log_config_filter                   = var.researcher_workspace_log_config_filter
  min_ports_per_vm                    = var.researcher_workspace_min_ports_per_vm
  nat_ip_allocate_option              = var.researcher_workspace_nat_ip_allocate_option
  nat_ips                             = [module.researcher_workspace_regional_external_static_ip.regional_external_static_ip_self_link]
  source_subnetwork_ip_ranges_to_nat  = var.researcher_workspace_source_subnetwork_ip_ranges_to_nat
  tcp_established_idle_timeout_sec    = var.researcher_workspace_tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = var.researcher_workspace_tcp_transitory_idle_timeout_sec
  udp_idle_timeout_sec                = var.researcher_workspace_udp_idle_timeout_sec
}


#----------------------------------------------
# RESEARCHER WORKSPACE SERVICE ACCOUNT CREATION
#----------------------------------------------

module "researcher_workspace_disable_sa_creation" {
  source      = "terraform-google-modules/org-policy/google"
  version     = "~> 3.0.2"
  constraint  = "constraints/iam.disableServiceAccountCreation"
  policy_type = "boolean"
  policy_for  = "project"
  project_id  = module.workspace_project.project_id
  enforce     = var.enforce_researcher_workspace_disable_sa_creation
}

