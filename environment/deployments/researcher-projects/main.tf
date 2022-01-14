#------------------
# IMPORT CONSTANTS
#------------------

module "constants" {
  source = "../../foundation/constants"
}

// DATA BLOCK
// RETRIEVE STAGING PROJECT NUMBER (I.E. 1234567890)

data "google_project" "staging_project_number" {
  project_id = local.staging_project_id
}

data "terraform_remote_state" "staging_project" {
  backend = "gcs"
  config = {
    bucket = "terraform-state-sde-1292"
    prefix = "cloudbuild-sde/staging-project"
    #prefix = "staging_project_id"
    staging_project_id = ""
  }
}


// NULL RESOURCE TIMER
// USED FOR DISABLING ORG POLICIES AT THE PROJECT LEVEL
// NEED TIME DELAY TO ALLOW POLICY CHANGE TO PROPAGATE

#resource "null_resource" "previous" {}

#resource "time_sleep" "wait_130_seconds" {
#
#  create_duration = "130s"
#  depends_on      = [null_resource.previous]
#}


// SET CONSTANT MODULE VALUES AS LOCALS

locals {
  #staging_project_id       = module.constants.value.staging_project_id
  staging_project_id       = ${data.terraform_remote_state.staging_project.staging_project_id}
  staging_project_number   = data.google_project.staging_project_number.number
  org_id                   = module.constants.value.org_id
  billing_account_id       = module.constants.value.billing_account_id
  srde_folder_id           = module.constants.value.srde_folder_id
  workspace_default_region = module.constants.value.workspace_default_region
  bastion_default_region   = module.constants.value.bastion_default_region
  staging_default_region   = module.constants.value.staging_default_region
}

#--------------------------------
# RESEARCHER WORKSPACE - PROJECT
#--------------------------------

module "researcher-workspace-project" {
  source = "../../../modules/project_factory"

  // REQUIRED FIELDS
  project_name       = format("%v-%v", var.workspace_project_name, "workspace")
  org_id             = local.org_id
  billing_account_id = local.billing_account_id
  folder_id          = local.srde_folder_id

  // OPTIONAL FIELDS
  activate_apis               = var.workspace_activate_apis
  auto_create_network         = var.workspace_auto_create_network
  create_project_sa           = var.workspace_create_project_sa
  default_service_account     = var.workspace_default_service_account
  disable_dependent_services  = var.workspace_disable_dependent_services
  disable_services_on_destroy = var.workspace_disable_services_on_destroy
  group_name                  = var.workspace_group_name
  group_role                  = var.workspace_group_role
  project_labels              = var.workspace_project_labels
  lien                        = var.workspace_lien
  random_project_id           = var.workspace_random_project_id
}

resource "google_compute_project_metadata" "researcher_workspace_project" {
  project = module.researcher-workspace-project.project_id
  metadata = {
    enable-osconfig = "TRUE",
    enable-oslogin  = "TRUE"
  }
}

#--------------------------------------
# GOOGLE CLOUD SOURCE REPOSITORY MODULE
#--------------------------------------

# module "workspace_cloud_source_repository" {
#   source = "../../../modules/source_repository"

#   cloud_source_repo_name       = var.workspace_cloud_source_repo_name
#   cloud_source_repo_project_id = module.researcher-workspace-project.project_id
# }

#------------------------------------------------
# RESEARCHER WORKSPACE PROJECT IAM MEMBER BINDING
#------------------------------------------------

module "workspace_project_iam_member" {
  source = "../../../modules/iam/project_iam"

  project_id            = module.researcher-workspace-project.project_id
  project_member        = var.workspace_project_member
  project_iam_role_list = var.workspace_project_iam_role_list
}

#---------------------------
# RESEARCHER WORKSPACE - VPC
#---------------------------

module "workspace_vpc" {
  source = "../../../modules/vpc"

  project_id                             = module.researcher-workspace-project.project_id
  vpc_network_name                       = var.workspace_vpc_network_name
  auto_create_subnetworks                = var.workspace_vpc_auto_create_subnetworks
  delete_default_internet_gateway_routes = var.workspace_vpc_delete_default_internet_gateway_routes
  firewall_rules                         = var.workspace_vpc_firewall_rules
  routing_mode                           = var.workspace_vpc_routing_mode
  vpc_description                        = var.workspace_vpc_description
  shared_vpc_host                        = var.workspace_vpc_shared_vpc_host
  mtu                                    = var.workspace_vpc_mtu
  subnets = [
    {
      subnet_name               = "workspace-${local.workspace_default_region}-subnet"
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

#------------------------------------------------------------
# RESEARCHER WORKSPACE RESTRICTED GOOGLE API CLOUD DNS MODULE
#------------------------------------------------------------

module "researcher_workspace_restricted_api_cloud_dns" {
  source = "../../../modules/cloud_dns"

  // REQUIRED
  cloud_dns_domain     = var.workspace_restricted_api_cloud_dns_domain
  cloud_dns_name       = var.workspace_restricted_api_cloud_dns_name
  cloud_dns_project_id = module.researcher-workspace-project.project_id

  // OPTIONAL
  default_key_specs_key              = var.workspace_restricted_api_default_key_specs_key
  default_key_specs_zone             = var.workspace_restricted_api_default_key_specs_zone
  cloud_dns_description              = var.workspace_restricted_api_cloud_dns_description
  dnssec_config                      = var.workspace_restricted_api_dnssec_config
  cloud_dns_labels                   = var.workspace_restricted_api_cloud_dns_labels
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = var.workspace_restricted_api_cloud_dns_recordsets
  target_name_server_addresses       = var.workspace_restricted_api_target_name_server_addresses
  cloud_dns_target_network           = var.workspace_restricted_api_cloud_dns_target_network
  cloud_dns_zone_type                = var.workspace_restricted_api_cloud_dns_zone_type
}

// THIS PRIVATE ZONE FOR IAP IS NEEDED TO ESTABLISH IAP TUNNEL CONNECTIVITY FROM WITHIN A GCP VM TO ANOTHER GCP VM
// https://cloud.google.com/iap/docs/securing-tcp-with-vpc-sc#configure-dns

#------------------------------------------------------
# RESEARCHER WORKSPACE IAP TUNNEL CLOUD DNS ZONE MODULE
#------------------------------------------------------

module "researcher_workspace_iap_tunnel_cloud_dns" {
  source = "../../../modules/cloud_dns"

  // REQUIRED
  cloud_dns_domain     = var.workspace_iap_tunnel_cloud_dns_domain
  cloud_dns_name       = var.workspace_iap_tunnel_cloud_dns_name
  cloud_dns_project_id = module.researcher-workspace-project.project_id

  // OPTIONAL
  default_key_specs_key              = var.workspace_iap_tunnel_default_key_specs_key
  default_key_specs_zone             = var.workspace_iap_tunnel_default_key_specs_zone
  cloud_dns_description              = var.workspace_iap_tunnel_cloud_dns_description
  dnssec_config                      = var.workspace_iap_tunnel_dnssec_config
  cloud_dns_labels                   = var.workspace_iap_tunnel_cloud_dns_labels
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = var.workspace_iap_tunnel_cloud_dns_recordsets
  target_name_server_addresses       = var.workspace_iap_tunnel_target_name_server_addresses
  cloud_dns_target_network           = var.workspace_iap_tunnel_cloud_dns_target_network
  cloud_dns_zone_type                = var.workspace_iap_tunnel_cloud_dns_zone_type
}

// THIS PRIVATE ZONE IS USED TO ACCESS THE ARTIFACT REGISTRY

#-------------------------------------------------------------
# RESEARCHER WORKSPACE ARTIFACT REGISTRY CLOUD DNS ZONE MODULE
#-------------------------------------------------------------

module "researcher_workspace_artifact_registry_cloud_dns" {
  source = "../../../modules/cloud_dns"

  // REQUIRED
  cloud_dns_domain     = var.workspace_artifact_registry_cloud_dns_domain
  cloud_dns_name       = var.workspace_artifact_registry_cloud_dns_name
  cloud_dns_project_id = module.researcher-workspace-project.project_id

  // OPTIONAL
  default_key_specs_key              = var.workspace_artifact_registry_default_key_specs_key
  default_key_specs_zone             = var.workspace_artifact_registry_default_key_specs_zone
  cloud_dns_description              = var.workspace_artifact_registry_cloud_dns_description
  dnssec_config                      = var.workspace_artifact_registry_dnssec_config
  cloud_dns_labels                   = var.workspace_artifact_registry_cloud_dns_labels
  private_visibility_config_networks = [module.workspace_vpc.network_self_link]
  cloud_dns_recordsets               = var.workspace_artifact_registry_cloud_dns_recordsets
  target_name_server_addresses       = var.workspace_artifact_registry_target_name_server_addresses
  cloud_dns_target_network           = var.workspace_artifact_registry_cloud_dns_target_network
  cloud_dns_zone_type                = var.workspace_artifact_registry_cloud_dns_zone_type
}

#----------------------------------------
# RESEARCHER WORKSPACE VPC CLOUD FIREWALL
#----------------------------------------

module "researcher_workspace_vpc_firewall" {

  source = "../../../modules/firewall"

  custom_rules = var.workspace_firewall_custom_rules
  network      = module.workspace_vpc.network_name
  project_id   = module.researcher-workspace-project.project_id
}

#-------------------------------------------------------
# RESEARCHER WORKSPACE TO RESEARCHER BASTION VPC PEERING
#-------------------------------------------------------

module "researcher_workspace_to_bastion_vpc_peer" {

  source = "../../../modules/vpc_peering"

  vpc_peering_name                    = var.researcher_workspace_to_bastion_vpc_peering_name
  vpc_network_name                    = module.workspace_vpc.network_self_link
  peer_network_name                   = module.bastion_project_vpc.network_self_link
  export_custom_routes                = var.researcher_workspace_to_bastion_export_custom_routes
  import_custom_routes                = var.researcher_workspace_to_bastion_import_custom_routes
  export_subnet_routes_with_public_ip = var.researcher_workspace_to_bastion_export_subnet_routes_with_public_ip
  import_subnet_routes_with_public_ip = var.researcher_workspace_to_bastion_import_subnet_routes_with_public_ip
}

#-------------------------------------------------------
# RESEARCHER WORKSPACE - DEEPLEARNING VM SERVICE ACCOUNT
#-------------------------------------------------------

module "workspace_deeplearning_vm_service_account" {

  source = "../../../modules/service_account"

  // REQUIRED

  project_id = module.researcher-workspace-project.project_id

  // OPTIONAL

  billing_account_id    = local.billing_account_id
  description           = var.workspace_deeplearning_vm_sa_description
  display_name          = var.workspace_deeplearning_vm_sa_display_name
  generate_keys         = var.workspace_deeplearning_vm_sa_generate_keys
  grant_billing_role    = var.workspace_deeplearning_vm_sa_grant_billing_role
  grant_xpn_roles       = var.workspace_deeplearning_vm_sa_grant_xpn_roles
  service_account_names = var.workspace_deeplearning_vm_sa_service_account_names
  org_id                = local.org_id
  prefix                = var.workspace_deeplearning_vm_sa_prefix
  #depends_on            = [time_sleep.wait_130_seconds]
}

#--------------------------------------------------
# RESEARCHER WORKSPACE - PATH ML VM SERVICE ACCOUNT
#--------------------------------------------------

# module "workspace_path_ml_vm_service_account" {

#   source = "../../../modules/service_account"

#   // REQUIRED

#   project_id = module.researcher-workspace-project.project_id

#   // OPTIONAL

#   billing_account_id    = local.billing_account_id
#   description           = var.workspace_path_ml_vm_sa_description
#   display_name          = var.workspace_path_ml_vm_sa_display_name
#   generate_keys         = var.workspace_path_ml_vm_sa_generate_keys
#   grant_billing_role    = var.workspace_path_ml_vm_sa_grant_billing_role
#   grant_xpn_roles       = var.workspace_path_ml_vm_sa_grant_xpn_roles
#   service_account_names = var.workspace_path_ml_vm_sa_service_account_names
#   org_id                = local.org_id
#   prefix                = var.workspace_path_ml_vm_sa_prefix
#   depends_on            = [time_sleep.wait_130_seconds]
# }

#----------------------------------------------------
# RESEARCHER WORKSPACE PROJECT IAM CUSTOM ROLE MODULE
#----------------------------------------------------

module "workspace_project_iam_custom_role" {
  source = "../../../modules/iam/project_iam_custom_role"

  project_iam_custom_role_project_id  = module.researcher-workspace-project.project_id
  project_iam_custom_role_description = var.workspace_project_iam_custom_role_description
  project_iam_custom_role_id          = var.workspace_project_iam_custom_role_id
  project_iam_custom_role_title       = var.workspace_project_iam_custom_role_title
  project_iam_custom_role_permissions = var.workspace_project_iam_custom_role_permissions
  project_iam_custom_role_stage       = var.workspace_project_iam_custom_role_stage
  depends_on                          = [module.researcher-workspace-project]
}

#------------------------------------------------------------------------------
# RESEARCHER WORKSPACE VM SERVICE ACCOUNT - PROJECT IAM MEMBER CUSTOM SRDE ROLE
#------------------------------------------------------------------------------

resource "google_project_iam_member" "researcher_workspace_project_custom_srde_role" {

  project    = module.researcher-workspace-project.project_id
  role       = module.workspace_project_iam_custom_role.name
  member     = var.workspace_project_member // CURRENTLY SET TO USERS/GROUPS DEFINED IN TFVARS
  depends_on = [module.workspace_project_iam_custom_role]
}

#---------------------------------------------------------
# RESEARCHER WORKSPACE DEEPLEARNING VM - PRIVATE IP MODULE
#---------------------------------------------------------

module "researcher_workspace_deeplearning_vm_private_ip" {
  source = "../../../modules/compute_vm_instance/private_ip_instance"

  // REQUIRED FIELDS
  project_id = module.researcher-workspace-project.project_id

  // OPTIONAL FIELDS
  allow_stopping_for_update = var.workspace_deeplearning_vm_allow_stopping_for_update
  vm_description            = var.workspace_deeplearning_vm_description
  desired_status            = var.workspace_deeplearning_vm_desired_status
  deletion_protection       = var.workspace_deeplearning_vm_deletion_protection
  labels                    = var.workspace_deeplearning_vm_labels
  metadata                  = var.workspace_deeplearning_vm_metadata
  machine_type              = var.workspace_deeplearning_vm_machine_type
  vm_name                   = var.workspace_deeplearning_vm_name
  tags                      = var.workspace_deeplearning_vm_tags
  #zone                      = var.workspace_deeplearning_vm_zone
  zone = "${local.workspace_default_region}-b"

  // BOOT DISK

  initialize_params = [
    {
      vm_disk_size  = 100
      vm_disk_type  = "pd-standard"
      vm_disk_image = "${module.constants.value.packer_project_id}/${module.constants.value.packer_base_image_id_deeplearning}"
    }
  ]
  auto_delete_disk = var.workspace_deeplearning_vm_auto_delete_disk

  // NETWORK INTERFACE

  subnetwork = module.workspace_vpc.subnets_self_links[0]
  network_ip = var.workspace_deeplearning_vm_network_ip // KEEP AS AN EMPTY STRING FOR AN AUTOMATICALLY ASSIGNED PRIVATE IP

  // SERVICE ACCOUNT

  service_account_email  = module.workspace_deeplearning_vm_service_account.email
  service_account_scopes = var.workspace_deeplearning_vm_service_account_scopes

  // SHIELDED INSTANCE CONFIG

  enable_secure_boot          = var.workspace_deeplearning_vm_enable_secure_boot
  enable_vtpm                 = var.workspace_deeplearning_vm_enable_vtpm
  enable_integrity_monitoring = var.workspace_deeplearning_vm_enable_integrity_monitoring

  // DEPENDS ON
  #depends_on = [module.workspace_vpc, module.researcher-workspace-project]
}

#----------------------------------------------------
# RESEARCHER WORKSPACE PATH ML VM - PRIVATE IP MODULE
#----------------------------------------------------

# module "researcher_workspace_path_ml_vm_private_ip" {
#   source = "../../../modules/compute_vm_instance/private_ip_instance"

#   // REQUIRED FIELDS
#   project_id = module.researcher-workspace-project.project_id

#   // OPTIONAL FIELDS
#   allow_stopping_for_update = var.workspace_path_ml_vm_allow_stopping_for_update
#   vm_description            = var.workspace_path_ml_vm_description
#   desired_status            = var.workspace_path_ml_vm_desired_status
#   deletion_protection       = var.workspace_path_ml_vm_deletion_protection
#   labels                    = var.workspace_path_ml_vm_labels
#   metadata                  = var.workspace_path_ml_vm_metadata
#   machine_type              = var.workspace_path_ml_vm_machine_type
#   vm_name                   = var.workspace_path_ml_vm_name
#   tags                      = var.workspace_path_ml_vm_tags
#   #zone                      = var.workspace_path_ml_vm_zone
#   zone = "${local.workspace_default_region}-b"

#   // BOOT DISK

#   initialize_params = [
#     {
#       vm_disk_size  = 100
#       vm_disk_type  = "pd-standard"
#       vm_disk_image = "${module.constants.value.packer_project_id}/${module.constants.value.packer_base_image_id_deeplearning}"
#     }
#   ]
#   auto_delete_disk        = var.workspace_path_ml_vm_auto_delete_disk
#   metadata_startup_script = file(var.workspace_path_ml_vm_metadata_startup_script)

#   // NETWORK INTERFACE

#   subnetwork = module.workspace_vpc.subnets_self_links[0]
#   network_ip = var.workspace_path_ml_vm_network_ip // KEEP AS AN EMPTY STRING FOR AN AUTOMATICALLY ASSIGNED PRIVATE IP

#   // SERVICE ACCOUNT

#   service_account_email  = module.workspace_path_ml_vm_service_account.email
#   service_account_scopes = var.workspace_path_ml_vm_service_account_scopes

#   // SHIELDED INSTANCE CONFIG

#   enable_secure_boot          = var.workspace_path_ml_vm_enable_secure_boot
#   enable_vtpm                 = var.workspace_path_ml_vm_enable_vtpm
#   enable_integrity_monitoring = var.workspace_path_ml_vm_enable_integrity_monitoring

#   // DEPENDS ON
#   depends_on = [module.workspace_vpc, module.researcher-workspace-project]
# }

#----------------------------------------------------------
# RESEARCHER WORKSPACE - REGIONAL EXTERNAL STATIC IP MODULE
#----------------------------------------------------------

// FUNCTIONALITY IN THIS MODULE IS ONLY FOR A REGIONAL EXTERNAL STATIC IP

module "researcher_workspace_regional_external_static_ip" {
  source = "../../../modules/regional_external_static_ip"

  // REQUIRED
  regional_external_static_ip_name = var.researcher_workspace_regional_external_static_ip_name

  // OPTIONAL
  regional_external_static_ip_project_id   = module.researcher-workspace-project.project_id
  regional_external_static_ip_address_type = var.researcher_workspace_regional_external_static_ip_address_type
  regional_external_static_ip_description  = var.researcher_workspace_regional_external_static_ip_description
  regional_external_static_ip_network_tier = var.researcher_workspace_regional_external_static_ip_network_tier
  #regional_external_static_ip_region       = var.researcher_workspace_regional_external_static_ip_region
  regional_external_static_ip_region = local.workspace_default_region
}

#----------------------------------------
# RESEARCHER WORKSPACE - CLOUD NAT MODULE
#----------------------------------------

module "researcher_workspace_cloud_nat" {
  source = "../../../modules/cloud_nat"

  create_router     = var.researcher_workspace_create_router
  project_id        = module.researcher-workspace-project.project_id
  cloud_nat_name    = var.researcher_workspace_cloud_nat_name
  cloud_nat_network = module.workspace_vpc.network_name
  #region            = var.researcher_workspace_region
  region      = local.workspace_default_region
  router_name = var.researcher_workspace_router_name
  router_asn  = var.researcher_workspace_router_asn
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

#----------------------------------
# RESEARCHER BASTION ACCESS PROJECT
#----------------------------------

module "researcher-bastion-access-project" {
  source = "../../../modules/project_factory"

  // REQUIRED FIELDS
  project_name       = format("%v-%v", var.bastion_project_name, "bastion")
  org_id             = local.org_id
  billing_account_id = local.billing_account_id
  folder_id          = local.srde_folder_id

  // OPTIONAL FIELDS
  activate_apis               = var.bastion_project_activate_apis
  auto_create_network         = var.bastion_project_auto_create_network
  create_project_sa           = var.bastion_project_create_project_sa
  default_service_account     = var.bastion_project_default_service_account
  disable_dependent_services  = var.bastion_project_disable_dependent_services
  disable_services_on_destroy = var.bastion_project_disable_services_on_destroy
  group_name                  = var.bastion_project_group_name
  group_role                  = var.bastion_project_group_role
  project_labels              = var.bastion_project_labels
  lien                        = var.bastion_project_lien
  random_project_id           = var.bastion_project_random_project_id
}

resource "google_compute_project_metadata" "researcher_bastion_project" {
  project = module.researcher-bastion-access-project.project_id
  metadata = {
    enable-osconfig = "TRUE",
    enable-oslogin  = "TRUE"
  }
}

//
// BIND IAM MEMBERS & ROLES AT THE PROJECT LEVEL
// CAN BE DONE WITH GROUPS HERE
// USE SYNTAX `group:<GOOGLE_GROUP_NAME>`
//

#----------------------------------------------
# RESEARCHER BASTION PROJECT IAM MEMBER BINDING
#----------------------------------------------

module "bastion_project_iam_member" {
  source = "../../../modules/iam/project_iam"

  project_id            = module.researcher-bastion-access-project.project_id
  project_member        = var.bastion_project_member
  project_iam_role_list = var.bastion_project_iam_role_list
}

#--------------------------------------------------
# RESEARCHER BASTION PROJECT IAM CUSTOM ROLE MODULE
#--------------------------------------------------

module "bastion_project_iam_custom_role" {
  source = "../../../modules/iam/project_iam_custom_role"

  project_iam_custom_role_project_id  = module.researcher-bastion-access-project.project_id
  project_iam_custom_role_description = var.bastion_project_iam_custom_role_description
  project_iam_custom_role_id          = var.bastion_project_iam_custom_role_id
  project_iam_custom_role_title       = var.bastion_project_iam_custom_role_title
  project_iam_custom_role_permissions = var.bastion_project_iam_custom_role_permissions
  project_iam_custom_role_stage       = var.bastion_project_iam_custom_role_stage
  #depends_on                          = [module.researcher-bastion-access-project]
}

// USED SPECIFICALLY TO BIND CUSTOM IAM ROLE IN BASTION PROJECT TO RESEARCH USER OR GROUP

#-------------------------------------------------------
# RESEARCHER BASTION PROJECT IAM MEMBER CUSTOM SRDE ROLE
#-------------------------------------------------------

resource "google_project_iam_member" "researcher_bastion_project_custom_srde_role" {

  project    = module.researcher-bastion-access-project.project_id
  role       = module.bastion_project_iam_custom_role.name
  member     = var.bastion_project_member // CURRENTLY SET TO USERS/GROUPS DEFINED IN TFVARS
  depends_on = [module.bastion_project_iam_custom_role]
}

#---------------------------------
# RESEARCHER BASTION PROJECT - VPC
#---------------------------------

module "bastion_project_vpc" {
  source = "../../../modules/vpc"

  project_id                             = module.researcher-bastion-access-project.project_id
  vpc_network_name                       = var.bastion_project_vpc_network_name
  auto_create_subnetworks                = var.bastion_project_vpc_auto_create_subnetworks
  delete_default_internet_gateway_routes = var.bastion_project_vpc_delete_default_internet_gateway_routes
  firewall_rules                         = var.bastion_project_vpc_firewall_rules
  routing_mode                           = var.bastion_project_vpc_routing_mode
  vpc_description                        = var.bastion_project_vpc_description
  shared_vpc_host                        = var.bastion_project_vpc_shared_vpc_host
  mtu                                    = var.bastion_project_vpc_mtu
  # subnets                                = var.bastion_project_vpc_subnets
  subnets = [
    {
      subnet_name               = "bastion-vpc-subnet"
      subnet_ip                 = "11.0.0.0/16"
      subnet_region             = local.bastion_default_region
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_private_access     = "true"
    }
  ]
  secondary_ranges = var.bastion_project_vpc_secondary_ranges
  routes           = var.bastion_project_vpc_routes
}

#----------------------------------------------
# RESEARCHER BASTION PROJECT VPC CLOUD FIREWALL
#----------------------------------------------

module "researcher_bastion_project_vpc_firewall" {

  source = "../../../modules/firewall"

  custom_rules = var.bastion_project_firewall_custom_rules
  network      = module.bastion_project_vpc.network_name
  project_id   = module.researcher-bastion-access-project.project_id
}

#-------------------------------------------------------
# RESEARCHER BASTION TO RESEARCHER WORKSPACE VPC PEERING
#-------------------------------------------------------

module "researcher_bastion_to_workspace_vpc_peer" {

  source = "../../../modules/vpc_peering"

  vpc_peering_name                    = var.researcher_bastion_to_workspace_vpc_peering_name
  vpc_network_name                    = module.bastion_project_vpc.network_self_link
  peer_network_name                   = module.workspace_vpc.network_self_link
  export_custom_routes                = var.researcher_bastion_to_workspace_export_custom_routes
  import_custom_routes                = var.researcher_bastion_to_workspace_import_custom_routes
  export_subnet_routes_with_public_ip = var.researcher_bastion_to_workspace_export_subnet_routes_with_public_ip
  import_subnet_routes_with_public_ip = var.researcher_bastion_to_workspace_import_subnet_routes_with_public_ip
  depends_on                          = [module.researcher_workspace_to_bastion_vpc_peer]
}

#------------------------------------------------
# RESEARCHER BASTION PROJECT - VM SERVICE ACCOUNT
#------------------------------------------------

module "bastion_project_service_account" {

  source = "../../../modules/service_account"

  // REQUIRED

  project_id = module.researcher-bastion-access-project.project_id

  // OPTIONAL

  billing_account_id    = local.billing_account_id
  description           = var.bastion_project_sa_description
  display_name          = var.bastion_project_sa_display_name
  generate_keys         = var.bastion_project_sa_generate_keys
  grant_billing_role    = var.bastion_project_sa_grant_billing_role
  grant_xpn_roles       = var.bastion_project_sa_grant_xpn_roles
  service_account_names = var.bastion_project_sa_service_account_names
  org_id                = local.org_id
  prefix                = var.bastion_project_sa_prefix
  #depends_on            = [time_sleep.wait_130_seconds]
}

#------------------------------------------------------------------
# RESEARCHER BASTION VM SERVICE ACCOUNT - PROJECT IAM MEMBER MODULE
#------------------------------------------------------------------

module "bastion_vm_sa_project_iam_member" {
  source = "../../../modules/iam/project_iam"

  project_id            = module.researcher-bastion-access-project.project_id
  project_member        = module.bastion_project_service_account.iam_email
  project_iam_role_list = var.bastion_vm_sa_project_iam_role_list
}

// VALUE SET IN `TAGS` FIELD BELOW IS USED IN IAP MODULE FOR FIREWALL FILTERING

#------------------------------------------
# RESEARCHER BASTION VM - PRIVATE IP MODULE
#------------------------------------------

module "researcher_bastion_vm_private_ip" {
  source = "../../../modules/compute_vm_instance/private_ip_instance"

  // REQUIRED FIELDS
  project_id = module.researcher-bastion-access-project.project_id

  // OPTIONAL FIELDS
  allow_stopping_for_update = var.bastion_vm_allow_stopping_for_update
  vm_description            = var.bastion_vm_description
  desired_status            = var.bastion_vm_desired_status
  deletion_protection       = var.bastion_vm_deletion_protection
  labels                    = var.bastion_vm_labels
  metadata                  = var.bastion_vm_metadata
  metadata_startup_script   = file("./sde-bastion-vm.sh")
  machine_type              = var.bastion_vm_machine_type
  vm_name                   = var.bastion_vm_name
  tags                      = var.bastion_vm_tags
  #zone         = var.bastion_vm_zone
  zone = "${local.bastion_default_region}-b"

  // BOOT DISK

  initialize_params = [
    {
      vm_disk_size  = 100
      vm_disk_type  = "pd-standard"
      vm_disk_image = "${module.constants.value.packer_project_id}/${module.constants.value.packer_base_image_id_bastion}"
    }
  ]
  auto_delete_disk = var.bastion_vm_auto_delete_disk

  // NETWORK INTERFACE

  subnetwork = module.bastion_project_vpc.subnets_self_links[0]
  network_ip = var.bastion_vm_network_ip // KEEP AS AN EMPTY STRING FOR AN AUTOMATICALLY ASSIGNED PRIVATE IP

  // SERVICE ACCOUNT

  service_account_email  = module.bastion_project_service_account.email
  service_account_scopes = var.bastion_vm_service_account_scopes

  // SHIELDED INSTANCE CONFIG

  enable_secure_boot          = var.bastion_vm_enable_secure_boot
  enable_vtpm                 = var.bastion_vm_enable_vtpm
  enable_integrity_monitoring = var.bastion_vm_enable_integrity_monitoring

  // DEPENDS ON
  #depends_on = [module.bastion_project_vpc, module.researcher-bastion-access-project]
}

#-----------------------------------------------------
# BASTION PROJECT - REGIONAL EXTERNAL STATIC IP MODULE
#-----------------------------------------------------

// FUNCTIONALITY IN THIS MODULE IS ONLY FOR A REGIONAL EXTERNAL STATIC IP

module "bastion_project_regional_external_static_ip" {
  source = "../../../modules/regional_external_static_ip"

  // REQUIRED
  regional_external_static_ip_name = var.bastion_project_regional_external_static_ip_name

  // OPTIONAL
  regional_external_static_ip_project_id   = module.researcher-bastion-access-project.project_id
  regional_external_static_ip_address_type = var.bastion_project_regional_external_static_ip_address_type
  regional_external_static_ip_description  = var.bastion_project_regional_external_static_ip_description
  regional_external_static_ip_network_tier = var.bastion_project_regional_external_static_ip_network_tier
  #regional_external_static_ip_region       = var.bastion_project_regional_external_static_ip_region
  regional_external_static_ip_region = local.bastion_default_region
}

#-----------------------------------
# BASTION PROJECT - CLOUD NAT MODULE
#-----------------------------------

module "bastion_project_cloud_nat" {
  source = "../../../modules/cloud_nat"

  create_router     = var.bastion_project_create_router
  project_id        = module.researcher-bastion-access-project.project_id
  cloud_nat_name    = var.bastion_project_cloud_nat_name
  cloud_nat_network = module.bastion_project_vpc.network_name
  #region            = var.bastion_project_region
  region      = local.bastion_default_region
  router_name = var.bastion_project_router_name
  router_asn  = var.bastion_project_router_asn
  cloud_nat_subnetworks = [
    {
      name                     = module.bastion_project_vpc.subnets_names[0],
      source_ip_ranges_to_nat  = ["PRIMARY_IP_RANGE"],
      secondary_ip_range_names = []
    }
  ]
  enable_endpoint_independent_mapping = var.bastion_project_enable_endpoint_independent_mapping
  icmp_idle_timeout_sec               = var.bastion_project_icmp_idle_timeout_sec
  log_config_enable                   = var.bastion_project_log_config_enable
  log_config_filter                   = var.bastion_project_log_config_filter
  min_ports_per_vm                    = var.bastion_project_min_ports_per_vm
  nat_ip_allocate_option              = var.bastion_project_nat_ip_allocate_option
  nat_ips                             = [module.bastion_project_regional_external_static_ip.regional_external_static_ip_self_link]
  source_subnetwork_ip_ranges_to_nat  = var.bastion_project_source_subnetwork_ip_ranges_to_nat
  tcp_established_idle_timeout_sec    = var.bastion_project_tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = var.bastion_project_tcp_transitory_idle_timeout_sec
  udp_idle_timeout_sec                = var.bastion_project_udp_idle_timeout_sec
}

// SETUP IDENTITY AWARE PROXY FOR A VM INSTANCE
// MEMBERS WILL HAVE IAP-Secured Tunnel User (roles/iap.tunnelResourceAccessor) APPLIED AT THE VM LEVEL

#------------
# IAP MODULE
#------------

module "iap_tunneling" {
  source = "../../../modules/iap"

  // REQUIRED
  project           = module.researcher-bastion-access-project.project_id
  instances         = var.instances
  iap_members       = var.iap_members
  network_self_link = module.bastion_project_vpc.network_self_link

  // OPTIONAL
  additional_ports           = var.additional_ports
  create_firewall_rule       = var.create_firewall_rule
  fw_name_allow_ssh_from_iap = var.fw_name_allow_ssh_from_iap
  host_project               = var.host_project
  network_tags               = module.researcher_bastion_vm_private_ip.tags
  #depends_on                 = [module.researcher_bastion_vm_private_ip]
}

#--------------------------------------
# RESEARCHER DATA EGRESS PROJECT MODULE
#--------------------------------------

module "researcher-data-egress-project" {
  source = "../../../modules/project_factory"

  // REQUIRED FIELDS
  project_name       = format("%v-%v", var.data_egress_project_name, "data-egress")
  org_id             = local.org_id
  billing_account_id = local.billing_account_id
  folder_id          = local.srde_folder_id

  // OPTIONAL FIELDS
  activate_apis               = var.egress_activate_apis
  auto_create_network         = var.egress_auto_create_network
  create_project_sa           = var.egress_create_project_sa
  default_service_account     = var.egress_default_service_account
  disable_dependent_services  = var.egress_disable_dependent_services
  disable_services_on_destroy = var.egress_disable_services_on_destroy
  group_name                  = var.egress_group_name
  group_role                  = var.egress_group_role
  project_labels              = var.egress_project_labels
  lien                        = var.egress_lien
  random_project_id           = var.egress_random_project_id
}

resource "google_compute_project_metadata" "researcher_egress_project" {
  project = module.researcher-data-egress-project.project_id
  metadata = {
    enable-osconfig = "TRUE",
    enable-oslogin  = "TRUE"
  }
}